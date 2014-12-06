//
//  SubscriptionViewController.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 29.11.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "SubscriptionViewController.h"

#import "Common.h"
#import "Kernel.h"
#import "SubscriptionTableViewCell.h"
#import "ViewFactory.h"

#import "LGSubscription.h"
#import "UIImageView+LGImagesExtension.h"

static NSString *const kObservationKeyPath = @"subscriptions";

@interface SubscriptionViewController () <UITableViewDataSource, UITableViewDelegate, SubscriptionTableViewCellDelegate> {
	UITableView __weak *_tableView;
}

@end

@implementation SubscriptionViewController

- (void) loadView {
	[super loadView];
	
	//Reconfigure titleBar
	_titleBarView.titleLabel.text = @"SubscriptionViewControllerTitle".commonLocalizedString;
	
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
	tableView.rowHeight = [SubscriptionTableViewCell height];
//	tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	[self.view addSubview: tableView];
	
	_tableView = tableView;
	
	[kernel.storage addObserver: self forKeyPath: kObservationKeyPath options: 0 context: nil];
	switch (self.mode) {
		case SubscriptionViewControllerModeCheckUsers:
			[kernel.checksManager getUsersForCheck: self.check];
			break;
		case SubscriptionViewControllerModeUserSubscribers:
			[kernel.userManager getSubscribersForUser: self.user];
			break;
		case SubscriptionViewControllerModeUserSubscribtions:
			[kernel.userManager getSubscribtionsForUser: self.user];
			break;
		default:
			break;
	}
	
}

- (void) dealloc {
	[kernel.storage removeObserver: self forKeyPath: kObservationKeyPath];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
						 change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqualToString: kObservationKeyPath] == YES && [object isKindOfClass: [Storage class]] == YES) {
		[kernel stopWaiting: self];
		[_tableView reloadData];
	}
}

#pragma mark - UITableViewDelegate implementation

//- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
//	LGSubscription *item = kernel.storage.subscriptions[indexPath.row];
//	[kernel.userManager subscribeTo: item];
//}

#pragma mark -
#pragma mark Table view data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	short count = 1;
    return count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	short numberOfRows = [kernel.storage.subscriptions count];
    return numberOfRows;
}


- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
	
	LGSubscription *item = kernel.storage.subscriptions[indexPath.row];
	
	SubscriptionTableViewCell *cell = [theTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[SubscriptionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
												reuseIdentifier:CellIdentifier];
		cell.delegate = self;
	}
	
	cell.textLabel.text = item.user.fio;
	[cell.imageView loadWebImageWithSizeThatFitsName: item.user.avatar
										 placeholder: [ViewFactory sharedFactory].titleBarAvatarPlaceholder];
	cell.isSubscribed = item.isSubscribed;
	
	return cell;
}

#pragma mark - SubscriptionTableViewCellDelegate implementation

- (void) subscriptionActionFor: (SubscriptionTableViewCell *) cell {
	NSIndexPath *indexPath = [_tableView indexPathForCell: cell];
	LGSubscription *item = kernel.storage.subscriptions[indexPath.row];
	[kernel.userManager subscribeTo: item];
}

@end
