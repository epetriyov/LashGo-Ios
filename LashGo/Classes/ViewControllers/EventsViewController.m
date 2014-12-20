//
//  EventsViewController.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 09.12.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "EventsViewController.h"

#define kObservationKeyPath @"events"

//@interface EventsViewController () <UITableViewDataSource, UITableViewDelegate> {
//	UITableView __weak *_tableView;
//}
//
//@end

@implementation EventsViewController

//- (void) loadView {
//	[super loadView];
//	
//	CGRect contentFrame = self.contentFrame;
//	
//	//	CGRect tableFrame = self.view.frame;
//	//	tableFrame.origin.y = contentFrame.origin.y;
//	//	tableFrame.size.height -= contentFrame.origin.y;
//	
//	UITableView *tableView = [[UITableView alloc] initWithFrame: contentFrame style: UITableViewStylePlain];
//	//	tableView.backgroundColor = [UIColor colorWithRed: 0.92 green: 0.925 blue: 0.93 alpha: 1.0];
//	//	tableView.contentInset = UIEdgeInsetsMake(0, 0, tableFrame.size.height - contentFrame.size.height, 0);
//	tableView.dataSource = self;
//	tableView.delegate = self;
//	tableView.tableFooterView = [[UIView alloc] init];
//	tableView.rowHeight = 60
//	//	tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//	[self.view addSubview: tableView];
//	
//	_tableView = tableView;
//	
//	switch (self.mode) {
//		case SubscriptionViewControllerModeCheckUsers:
//			_titleBarView.titleLabel.text = @"SubscriptionViewControllerCheckUsersTitle".commonLocalizedString;
//			[kernel.checksManager getUsersForCheck: self.context];
//			break;
//		case SubscriptionViewControllerModeUserSubscribers:
//			_titleBarView.titleLabel.text = @"SubscriptionViewControllerUserSubscribersTitle".commonLocalizedString;
//			[kernel.userManager getSubscribersForUser: self.context];
//			break;
//		case SubscriptionViewControllerModeUserSubscribtions:
//			_titleBarView.titleLabel.text = @"SubscriptionViewControllerUserSubscribtionsTitle".commonLocalizedString;
//			[kernel.userManager getSubscribtionsForUser: self.context];
//			break;
//		default:
//			break;
//	}
//	self.waitViewHidden = NO;
//}
//
//- (void) viewWillAppear:(BOOL)animated {
//	[super viewWillAppear: animated];
//}
//
//- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
//						 change:(NSDictionary *)change context:(void *)context {
//	if ([keyPath isEqualToString: kObservationKeyPath] == YES && [object isKindOfClass: [LGSubscription class]] == YES) {
//		NSUInteger index = [self.subscriptions indexOfObject: object];
//		
//		if (index != NSNotFound) {
//			[_tableView beginUpdates];
//			[_tableView reloadRowsAtIndexPaths: @[[NSIndexPath indexPathForRow: index inSection: 0]]
//							  withRowAnimation: UITableViewRowAnimationNone];
//			[_tableView endUpdates];
//		}
//	}
//}
//
//- (void) dealloc {
//	for (id item in _currentObservationSet) {
//		[item removeObserver: self forKeyPath: kObservationKeyPath context: nil];
//	}
//}
//
//#pragma mark - UITableViewDelegate implementation
//
////- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
////	LGSubscription *item = kernel.storage.subscriptions[indexPath.row];
////	[kernel.userManager subscribeTo: item];
////}
//
//- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//	[theTableView deselectRowAtIndexPath: indexPath animated: YES];
//	
//	LGSubscription *item = self.subscriptions[indexPath.row];
//	
//	[kernel.userManager openProfileViewControllerWith: item.user];
//}
//
//#pragma mark -
//#pragma mark Table view data source methods
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//	short count = 1;
//    return count;
//}
//
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//	short numberOfRows = [self.subscriptions count];
//    return numberOfRows;
//}
//
//
//- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *CellIdentifier = @"Cell";
//	
//	LGSubscription *item = self.subscriptions[indexPath.row];
//	
//	SubscriptionTableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
//	if (cell == nil) {
//		cell = [[SubscriptionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
//												reuseIdentifier:CellIdentifier];
//		cell.delegate = self;
//	}
//	
//	cell.textLabel.text = item.user.fio;
//	[cell.imageView loadWebImageWithSizeThatFitsName: item.user.avatar
//										 placeholder: [ViewFactory sharedFactory].titleBarAvatarPlaceholder];
//	cell.isSubscribed = item.isSubscribed;
//	
//	return cell;
//}

@end
