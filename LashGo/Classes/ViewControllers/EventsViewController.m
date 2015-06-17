//
//  EventsViewController.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 09.12.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "EventsViewController.h"

#import "Common.h"
#import "EventTableViewCell.h"
#import "Kernel.h"

#import "NSDateFormatter+CustomFormats.h"

#import "UIImageView+LGImagesExtension.h"
#import "ViewFactory.h"

#define kObservationKeyPath @"events"

@interface EventsViewController () <UITableViewDataSource, UITableViewDelegate, EventTableViewCellDelegate> {
	UITableView __weak *_tableView;
	UILabel __weak *_emptyListLabel;
}

@end

@implementation EventsViewController

- (instancetype) initWithKernel:(Kernel *)theKernel {
	if (self = [super initWithKernel: theKernel]) {
		[kernel.storage addObserver: self forKeyPath: kObservationKeyPath options: 0 context: nil];
	}
	return self;
}

- (void) loadView {
	[super loadView];
	
	_titleBarView.titleLabel.text = @"EventsViewControllerTitle".commonLocalizedString;
	
	CGRect contentFrame = self.contentFrame;
	
	//	CGRect tableFrame = self.view.frame;
	//	tableFrame.origin.y = contentFrame.origin.y;
	//	tableFrame.size.height -= contentFrame.origin.y;
	
	UITableView *tableView = [[UITableView alloc] initWithFrame: contentFrame style: UITableViewStylePlain];
	//	tableView.backgroundColor = [UIColor colorWithRed: 0.92 green: 0.925 blue: 0.93 alpha: 1.0];
	//	tableView.contentInset = UIEdgeInsetsMake(0, 0, tableFrame.size.height - contentFrame.size.height, 0);
	tableView.dataSource = self;
	tableView.delegate = self;
	tableView.tableFooterView = [[UIView alloc] init];
	tableView.rowHeight = 64;
	tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	[self.view addSubview: tableView];
	
	_tableView = tableView;
	
	UILabel *emptyListLabel = [[ViewFactory sharedFactory] emptyListLabelWithFrame: contentFrame
																		   andText: @"EventsEmptyLabel".commonLocalizedString];
	[self.view addSubview:emptyListLabel];
	_emptyListLabel = emptyListLabel;
}

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear: animated];
	
}

- (void) viewDidAppear:(BOOL)animated {
	[AuthorizationManager sharedManager].account.userInfo.subscriptionsLastViewDate = [NSDate date];
	[[AuthorizationManager sharedManager].account storeDataAsync];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
						 change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqualToString: kObservationKeyPath] == YES && [object isKindOfClass: [Storage class]] == YES) {
		[_tableView beginUpdates];
		[_tableView reloadSections: [NSIndexSet indexSetWithIndex:0] withRowAnimation: UITableViewRowAnimationAutomatic];
		[_tableView endUpdates];
		
		_emptyListLabel.alpha = [kernel.storage.events count] <= 0 ? 1 : 0;
	}
}

- (void) dealloc {
	[kernel.storage removeObserver: self forKeyPath: kObservationKeyPath];
}

#pragma mark - UITableViewDelegate implementation

//- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
//	LGSubscription *item = kernel.storage.subscriptions[indexPath.row];
//	[kernel.userManager subscribeTo: item];
//}

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[theTableView deselectRowAtIndexPath: indexPath animated: YES];
	
	LGEvent *item = kernel.storage.events[indexPath.row];
	
	if (item.user != nil) {
		[kernel.userManager openProfileViewControllerWith: item.user];
	}
}

#pragma mark -
#pragma mark Table view data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	short count = 1;
    return count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	short numberOfRows = [kernel.storage.events count];
    return numberOfRows;
}


- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
	
	LGEvent *item = kernel.storage.events[indexPath.row];
	
	EventTableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[EventTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
										 reuseIdentifier:CellIdentifier];
		cell.delegate = self;
	}
	
	cell.textLabel.text = [[item.user.fio stringByAppendingString: @" "]
						   stringByAppendingString: item.action.commonLocalizedString];
	cell.detailTextLabel.text = [[NSDateFormatter dateFormatterWithDisplayMediumDateFormat]
								 stringFromDate: item.eventDate];
	[cell.imageView loadWebImageWithSizeThatFitsName: item.user.avatar
										 placeholder: [ViewFactory sharedFactory].titleBarAvatarPlaceholder];
	[cell setCheckPhotoUrl: item.check.taskPhotoUrl];
	
	return cell;
}

- (void) eventCheckActionFor: (EventTableViewCell *) cell {
	NSIndexPath *indexPath = [_tableView indexPathForCell: cell];
	LGEvent *item = kernel.storage.events[indexPath.row];
	
	[kernel.checksManager openCheckCardViewControllerForCheckUID: item.check.uid];
}

@end
