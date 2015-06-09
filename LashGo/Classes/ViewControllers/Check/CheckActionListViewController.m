//
//  CheckActionListViewController.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 06.06.15.
//  Copyright (c) 2015 Vitaliy Pykhtin. All rights reserved.
//

#import "CheckActionListViewController.h"

#import "Common.h"
#import "FontFactory.h"
#import "Kernel.h"
#import "UIImageView+LGImagesExtension.h"
#import "ViewFactory.h"

#import "CheckListTableViewCell.h"
#import "PullToRefreshControl.h"
#import "SegmentedTextControl.h"

#define kOffsetToActivateDataFetch 50
#define kObservationKeyPath @"checksActions"

@interface CheckActionListViewController () <UITableViewDataSource, UITableViewDelegate> {
	SegmentedTextControl __weak *_segmentedControl;
	
	UITableView __weak *_tableView;
	NSArray *_contentModel;
	
	NSTimer *_progressTimer;
	
	PullToRefreshControl *fullRefreshControl;
}

@end

@implementation CheckActionListViewController

- (instancetype) initWithKernel:(Kernel *)theKernel {
	if (self = [super initWithKernel: theKernel]) {
		[kernel.storage addObserver: self forKeyPath: kObservationKeyPath options: 0 context: nil];
	}
	return self;
}

- (void) loadView {
	[super loadView];
	
	_titleBarView.titleLabel.text = @"ChecksActionTitle".commonLocalizedString;
	
	CGRect contentFrame = self.contentFrame;
	float offsetY = CGRectGetMinY(contentFrame);
	
	SegmentedTextControl *segmentedControl = [[SegmentedTextControl alloc] initWithFrame: CGRectMake(0, offsetY, CGRectGetWidth(self.view.bounds), 45)
																			buttonsTexts: @[@"ChecksActiveHeaderTitle".commonLocalizedString,
																							@"ChecksClosedHeaderTitle".commonLocalizedString]
																				  bgName: nil contentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
	[segmentedControl addTarget: self action: @selector(segmentedControlSelectedIndexChanged:)
			   forControlEvents: UIControlEventValueChanged];
	[self.view addSubview: segmentedControl];
	_segmentedControl = segmentedControl;
	
	offsetY += CGRectGetHeight(segmentedControl.frame);
	contentFrame.origin.y += CGRectGetHeight(segmentedControl.frame);
	contentFrame.size.height -= CGRectGetHeight(segmentedControl.frame);
	
	UILabel *descriptionLabel = [[UILabel alloc] initWithFrame: CGRectMake(0, offsetY,
																		   CGRectGetWidth(contentFrame), 53)];
	descriptionLabel.backgroundColor = _titleBarView.backgroundColor;
	descriptionLabel.font = [FontFactory fontWithType: FontTypeSegmentedTextControl];
	descriptionLabel.textColor = [UIColor whiteColor];
	descriptionLabel.textAlignment = NSTextAlignmentCenter;
	descriptionLabel.text = @"CheckActionsDescription".commonLocalizedString;
	descriptionLabel.numberOfLines = 3;
	[self.view addSubview: descriptionLabel];
	
	offsetY += CGRectGetHeight(descriptionLabel.frame);
	contentFrame.origin.y += CGRectGetHeight(descriptionLabel.frame);
	contentFrame.size.height -= CGRectGetHeight(descriptionLabel.frame);
	
	UITableView *tableView = [[UITableView alloc] initWithFrame: contentFrame style: UITableViewStylePlain];
	tableView.backgroundColor = [UIColor colorWithRed: 0.92 green: 0.925 blue: 0.93 alpha: 1.0];
//	tableView.contentInset = UIEdgeInsetsMake(0, 0, tableFrame.size.height - contentFrame.size.height, 0);
	tableView.dataSource = self;
	tableView.delegate = self;
	tableView.rowHeight = [CheckListTableViewCell height];
	tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	[self.view addSubview: tableView];
	
	_tableView = tableView;
	
	fullRefreshControl = [[PullToRefreshControl alloc] initWithFrame: CGRectMake(0, -kOffsetToActivateDataFetch,
																				 tableView.frame.size.width,
																				 kOffsetToActivateDataFetch)];
	[fullRefreshControl addTarget: self action: @selector(fetchFullData:) forControlEvents: UIControlEventValueChanged];
	[tableView addSubview: fullRefreshControl];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear: animated];
	
	if ([_progressTimer isValid] == NO) {
		_progressTimer = [NSTimer scheduledTimerWithTimeInterval: 1 target: self selector:@selector(refreshVisiblePage)
														userInfo:nil repeats:YES];
	}
}

- (void) viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear: animated];
	[_progressTimer invalidate];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
						 change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqualToString: kObservationKeyPath] == YES && [object isKindOfClass: [Storage class]] == YES) {
		[self refresh];
	}
}

- (void) dealloc {
	[kernel.storage removeObserver: self forKeyPath: kObservationKeyPath];
}

#pragma mark - Methods

- (void) refreshVisiblePage {
	if (_tableView.decelerating == YES) {
		return;
	}
	for (CheckListTableViewCell *cell in _tableView.visibleCells) {
		[cell refresh];
		DLog(@"cell refreshed");
	}
}

- (void) refresh {
	NSTimeInterval nowTime = [NSDate timeIntervalSinceReferenceDate];
	
	_contentModel = [kernel.storage.checksActions filteredArrayUsingPredicate:
					 [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
		LGCheck *checkAction = (LGCheck *)evaluatedObject;
		
		BOOL result;
		
		if (_segmentedControl.selectedIndex > 0) {
			result = nowTime >= checkAction.closeDate;
		} else {
			result = nowTime < checkAction.closeDate;
		}
		return result;
	}]];
	
	[fullRefreshControl setActive: NO forScrollView: _tableView];
	
	[_tableView beginUpdates];
	[_tableView reloadSections: [NSIndexSet indexSetWithIndex:0] withRowAnimation: UITableViewRowAnimationAutomatic];
	[_tableView endUpdates];
	
//		_emptyListLabel.alpha = [kernel.storage.news count] <= 0 ? 1 : 0;
}

- (void) fetchFullData: (PullToRefreshControl *) sender {
	if (sender.isActive == YES) {
		[kernel.checksManager getChecksActions];
	}
}

#pragma mark - SegmentedTextControlDelegate implementation

- (void) segmentedControlSelectedIndexChanged: (SegmentedTextControl *) segmentedControl {
	[self refresh];
}

#pragma mark - Table delegate implementation
//!!!:Hidden for coming soon
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//	CGFloat height = 40;
//	return height;
//}
//
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
	
	LGCheck *item = _contentModel[indexPath.row];
	
	if (item != nil) {
		[kernel.checksManager openCheckActionCardViewControllerWithCheckUID: item.uid];
	}
}

#pragma mark -
#pragma mark Table view data source methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [_contentModel count];
}


- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"Cell";
	
	LGCheck *item = _contentModel[indexPath.row];
	
	CheckListTableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[CheckListTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
											 reuseIdentifier:CellIdentifier];
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
	
	return cell;
}

#pragma mark

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[fullRefreshControl containingScrollViewDidScroll: scrollView];
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
	[fullRefreshControl containingScrollViewWillBeginDecelerating: scrollView];
}

@end
