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

static NSString *const kObservationKeyPath = @"isSubscribed";

@interface SubscriptionViewController () <UITableViewDataSource, UITableViewDelegate, SubscriptionTableViewCellDelegate> {
	UITableView __weak *_tableView;
	UILabel __weak *_emptyListLabel;
	NSMutableSet *_currentObservationSet;
}

@end

@implementation SubscriptionViewController

- (void) setSubscriptions:(NSArray *)subscriptions {
	_subscriptions = subscriptions;
	
	[kernel stopWaiting: self];
	[_tableView reloadData];
	self.waitViewHidden = YES;
	_emptyListLabel.alpha = [self.subscriptions count] <= 0 ? 1 : 0;
}

- (instancetype) initWithKernel:(Kernel *)theKernel {
	if (self = [super initWithKernel: theKernel]) {
		_currentObservationSet = [[NSMutableSet alloc] initWithCapacity: 1];
	}
	return self;
}

- (void) loadView {
	[super loadView];
	
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
	
	NSString *emptyLabelText = nil;
	switch (self.mode) {
		case SubscriptionViewControllerModeCheckUsers:
			emptyLabelText = @"CheckUsersEmptyLabel".commonLocalizedString;
			_titleBarView.titleLabel.text = @"SubscriptionViewControllerCheckUsersTitle".commonLocalizedString;
			[kernel.checksManager getUsersForCheck: self.context];
			break;
		case SubscriptionViewControllerModeUserSubscribers:
			emptyLabelText = @"SubscribersEmptyLabel".commonLocalizedString;
			_titleBarView.titleLabel.text = @"SubscriptionViewControllerUserSubscribersTitle".commonLocalizedString;
			[kernel.userManager getSubscribersForUser: self.context];
			break;
		case SubscriptionViewControllerModeUserSubscribtions:
			emptyLabelText = @"SubscribtionsEmptyLabel".commonLocalizedString;
			_titleBarView.titleLabel.text = @"SubscriptionViewControllerUserSubscribtionsTitle".commonLocalizedString;
			[kernel.userManager getSubscribtionsForUser: self.context];
			break;
		case SubscriptionViewControllerModePhotoVotes:
			emptyLabelText = @"VotesEmptyLabel".commonLocalizedString;
			_titleBarView.titleLabel.text = @"SubscriptionViewControllerPhotoVotesTitle".commonLocalizedString;
			[kernel.checksManager getPhotoVotesForPhoto: self.context];
			break;
		default:
			break;
	}
	self.waitViewHidden = NO;
	
	UILabel *emptyListLabel = [[ViewFactory sharedFactory] emptyListLabelWithFrame: contentFrame
																		   andText: emptyLabelText];
	[self.view addSubview:emptyListLabel];
	_emptyListLabel = emptyListLabel;
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
						 change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqualToString: kObservationKeyPath] == YES && [object isKindOfClass: [LGSubscription class]] == YES) {
		NSUInteger index = [self.subscriptions indexOfObject: object];
		
		if (index != NSNotFound) {
			[_tableView beginUpdates];
			[_tableView reloadRowsAtIndexPaths: @[[NSIndexPath indexPathForRow: index inSection: 0]]
							  withRowAnimation: UITableViewRowAnimationNone];
			[_tableView endUpdates];
		}
	}
}

- (void) dealloc {
	for (id item in _currentObservationSet) {
		[item removeObserver: self forKeyPath: kObservationKeyPath context: nil];
	}
}

#pragma mark - UITableViewDelegate implementation

//- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
//	LGSubscription *item = kernel.storage.subscriptions[indexPath.row];
//	[kernel.userManager subscribeTo: item];
//}

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[theTableView deselectRowAtIndexPath: indexPath animated: YES];
	
	LGSubscription *item = self.subscriptions[indexPath.row];
	
	[kernel.userManager openProfileViewControllerWith: item.user];
}

#pragma mark -
#pragma mark Table view data source methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	short count = 1;
    return count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	short numberOfRows = [self.subscriptions count];
    return numberOfRows;
}


- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
	
	LGSubscription *item = self.subscriptions[indexPath.row];
	
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
	LGSubscription *item = self.subscriptions[indexPath.row];
	
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
