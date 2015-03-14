//
//  SearchViewController.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 21.07.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "SearchViewController.h"

#import "CheckListTableViewCell.h"
#import "SubscriptionTableViewCell.h"
#import "SegmentedTextControl.h"

#import "Common.h"
#import "Kernel.h"

#import "UIImageView+LGImagesExtension.h"
#import "ViewFactory.h"

#define kObservationKeyPath @"isSubscribed"
#define kObservationChecksPath @"searchChecks"
#define kObservationUsersPath @"searchUsers"

typedef NS_ENUM(ushort, SearchMode) {
	SearchModeUsers = 0,
	SearchModeChecks
};

@interface SearchViewController () <UITableViewDataSource, UITableViewDelegate, SubscriptionTableViewCellDelegate> {
	SegmentedTextControl __weak *_segmentedControl;
	UITableView __weak *_tableView;
	NSArray __weak *_tableData;
	
	NSMutableSet *_currentObservationSet;
}

@end

@implementation SearchViewController

- (CGRect) waitViewFrame {
	return _tableView.frame;
}

- (instancetype) initWithKernel:(Kernel *)theKernel {
	if (self = [super initWithKernel: theKernel]) {
		_currentObservationSet = [[NSMutableSet alloc] initWithCapacity: 1];
		[kernel.storage addObserver: self forKeyPath: kObservationChecksPath options: 0 context: NULL];
		[kernel.storage addObserver: self forKeyPath: kObservationUsersPath options: 0 context: NULL];
	}
	return self;
}

- (void) loadView {
	[super loadView];
	
	[_titleBarView removeFromSuperview];
	TitleBarView *tbView = [TitleBarView titleBarViewWithRightButtonWithText: @"Отмена".commonLocalizedString
													   searchDelegate: self];
	[tbView.rightButton addTarget: self action: @selector(backAction:)
					   forControlEvents: UIControlEventTouchUpInside];
	[self.view addSubview: tbView];
	_titleBarView = tbView;
	
	float offsetY = self.contentFrame.origin.y;
	
	SegmentedTextControl *segmentedControl = [[SegmentedTextControl alloc] initWithFrame: CGRectMake(0, offsetY, CGRectGetWidth(self.view.bounds), 45)
																			buttonsTexts: @[@"SearchPeople".commonLocalizedString,
																								   @"SearchChecks".commonLocalizedString]
																				  bgName: nil contentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
	[segmentedControl addTarget: self action: @selector(segmentedControlSelectedIndexChanged:)
			   forControlEvents: UIControlEventValueChanged];
	[self.view addSubview: segmentedControl];
	_segmentedControl = segmentedControl;
	
	CGRect contentFrame = self.contentFrame;
	contentFrame.origin.y += segmentedControl.frame.size.height;
	contentFrame.size.height -= segmentedControl.frame.size.height;
	
	UITableView *tableView = [[UITableView alloc] initWithFrame: contentFrame style: UITableViewStylePlain];
	tableView.backgroundColor = [UIColor colorWithRed: 0.92 green: 0.925 blue: 0.93 alpha: 1.0];
	//	tableView.contentInset = UIEdgeInsetsMake(0, 0, tableFrame.size.height - contentFrame.size.height, 0);
	tableView.dataSource = self;
	tableView.delegate = self;
	tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	[self.view addSubview: tableView];
	
	_tableView = tableView;
}

- (void) dealloc {
	[kernel.storage removeObserver: self forKeyPath: kObservationChecksPath];
	[kernel.storage removeObserver: self forKeyPath: kObservationUsersPath];
	for (id item in _currentObservationSet) {
		[item removeObserver: self forKeyPath: kObservationKeyPath];
	}
}

- (void) viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear: animated];
	[_titleBarView endEditing: YES];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if (object == kernel.storage) {
		if ([keyPath isEqualToString: kObservationChecksPath] == YES &&
			_segmentedControl.selectedIndex == SearchModeChecks) {
			[self reloadTableData];
		} else if ([keyPath isEqualToString: kObservationUsersPath] == YES) {
			if (_segmentedControl.selectedIndex == SearchModeUsers) {
				[self reloadTableData];
			}
			//clean up observation for items because they probably released
			for (id item in _currentObservationSet) {
				[item removeObserver: self forKeyPath: kObservationKeyPath];
			}
			[_currentObservationSet removeAllObjects];
		}
	} else if ([keyPath isEqualToString: kObservationKeyPath] == YES &&
			   [object isKindOfClass: [LGSubscription class]] == YES) {
		NSUInteger index = [_tableData indexOfObject: object];
		
		if (index != NSNotFound) {
			[_tableView beginUpdates];
			[_tableView reloadRowsAtIndexPaths: @[[NSIndexPath indexPathForRow: index inSection: 0]]
							  withRowAnimation: UITableViewRowAnimationNone];
			[_tableView endUpdates];
		}
	}
}

#pragma mark - Methods

- (void) reloadTableData {
	[kernel stopWaiting: self];
	if (_segmentedControl.selectedIndex == SearchModeChecks) {
		_tableData = kernel.storage.searchChecks;
	} else {
		_tableData = kernel.storage.searchUsers;
	}
	
	[_tableView beginUpdates];
	[_tableView reloadSections:[NSIndexSet indexSetWithIndex: 0] withRowAnimation: UITableViewRowAnimationAutomatic];
	[_tableView endUpdates];
}

#pragma mark - SegmentedTextControlDelegate implementation

- (void) segmentedControlSelectedIndexChanged: (SegmentedTextControl *) segmentedControl {
	[self reloadTableData];
}

#pragma mark - UISearchBarDelegate implementation

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
	
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	if ([Common isEmptyString: searchBar.text] == NO) {
		[kernel startWaiting: self];
		if (_segmentedControl.selectedIndex == SearchModeChecks) {
			[kernel.checksManager getChecksSearch: searchBar.text];
		} else {
			[kernel.userManager getUsersSearch: searchBar.text];
		}
	}
	
	[searchBar resignFirstResponder];
}

#pragma mark - Table delegate implementation
//!!!:Hidden for coming soon
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	CGFloat height = 44;
	if (_segmentedControl.selectedIndex == SearchModeChecks) {
		height = [CheckListTableViewCell height];
	} else if (_segmentedControl.selectedIndex == SearchModeUsers) {
		height = [SubscriptionTableViewCell height];
	}
	return height;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//	UIView *resultView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, tableView.frame.size.width, 40)];
//	resultView.backgroundColor = tableView.backgroundColor;
//	//Generate section header
//
//	float offsetX = 15;
//
//	UILabel *headerTextLabel = [[UILabel alloc] initWithFrame:
//								CGRectMake(offsetX, resultView.frame.size.height / 2,
//										   resultView.frame.size.width - offsetX * 2,
//										   resultView.frame.size.height / 2)];
//	headerTextLabel.font = [FontFactory fontWithType: FontTypeCheckListHeaderTitle];
//	[headerTextLabel setTextColor: [FontFactory fontColorForType: FontTypeCheckListHeaderTitle]];
//	headerTextLabel.backgroundColor = [UIColor clearColor];
//
//	[resultView addSubview: headerTextLabel];
//
//	if (section == CheckListSectionActive) {
//		headerTextLabel.text = @"ChecksActiveHeaderTitle".commonLocalizedString;
//	} else if (section == CheckListSectionVote) {
//		headerTextLabel.text = @"ChecksVoteHeaderTitle".commonLocalizedString;
//	} else if (section == CheckListSectionClosed) {
//		headerTextLabel.text = @"ChecksClosedHeaderTitle".commonLocalizedString;
//	}
//
//	return resultView;
//}

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[theTableView deselectRowAtIndexPath: indexPath animated: YES];
	
	id item = _tableData[indexPath.row];
	
	if (_segmentedControl.selectedIndex == SearchModeUsers) {
		[kernel.userManager openProfileViewControllerWith: ((LGSubscription *)item).user];
	} else {
		[kernel.checksManager openCheckCardViewControllerForCheckUID: ((LGCheck *)item).uid];
	}
}

#pragma mark -
#pragma mark Table view data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_tableData count];
}


- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CheckCellIdentifier = @"CheckCell";
	static NSString *UserCellIdentifier = @"UserCell";
	
	UITableViewCell *resultCell;
	
	if (_segmentedControl.selectedIndex == SearchModeChecks) {
		LGCheck *item = _tableData[indexPath.row];
		
		CheckListTableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier: CheckCellIdentifier];
		if (cell == nil) {
			cell = [[CheckListTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
												 reuseIdentifier:CheckCellIdentifier];
		}
		
		cell.textLabel.text = item.name;
		cell.detailTextLabel.text = item.descr;
		if (item.winnerPhoto != nil) {
			[cell.checkView.imageView loadWebImageWithSizeThatFitsName: item.winnerPhoto.url placeholder: nil];
		} else {
			[cell.checkView.imageView loadWebImageWithSizeThatFitsName: item.taskPhotoUrl placeholder: nil];
		}
		cell.check = item;
		[cell refresh];
		
		resultCell = cell;
	} else if (_segmentedControl.selectedIndex == SearchModeUsers) {
		LGSubscription *item = _tableData[indexPath.row];
		
		SubscriptionTableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:UserCellIdentifier];
		if (cell == nil) {
			cell = [[SubscriptionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
													reuseIdentifier:UserCellIdentifier];
			cell.delegate = self;
		}
		
		cell.textLabel.text = item.user.fio;
		[cell.imageView loadWebImageWithSizeThatFitsName: item.user.avatar
											 placeholder: [ViewFactory sharedFactory].titleBarAvatarPlaceholder];
		cell.isSubscribed = item.isSubscribed;
		
		resultCell = cell;
	}
	
	return resultCell;
}

#pragma mark - SubscriptionTableViewCellDelegate implementation

- (void) subscriptionActionFor: (SubscriptionTableViewCell *) cell {
	NSIndexPath *indexPath = [_tableView indexPathForCell: cell];
	LGSubscription *item = _tableData[indexPath.row];
	
	if ([_currentObservationSet containsObject: item] == NO) {
		[item addObserver: self forKeyPath: kObservationKeyPath options: 0 context: nil];
		[_currentObservationSet addObject: item];
	}
	
	if (item.isSubscribed == YES) {
		[kernel.userManager unsubscribeFrom: item];
	} else {
		[kernel.userManager subscribeTo: item];
	}
}

@end
