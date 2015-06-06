//
//  ChecksManager.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 11.08.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "ChecksManager.h"

#import "Kernel.h"
#import "DataProvider.h"
#import "ViewControllersManager.h"

#import "LGPhoto.h"

@interface ChecksManager () {
	Kernel __weak *_kernel;
	DataProvider __weak *_dataProvider;
	ViewControllersManager __weak *_viewControllersManager;
}

@end

@implementation ChecksManager

- (instancetype) initWithKernel: (Kernel *) kernel
				   dataProvider: (DataProvider *) dataProvider
					  vcManager: (ViewControllersManager *) vcManager {
	if (self = [super init]) {
		_kernel = kernel;
		_dataProvider = dataProvider;
		_viewControllersManager = vcManager;
	}
	return self;
}

- (void) getChecks {
	[_dataProvider checksWithContext: nil];
}

- (void) getChecksActions {
	[_dataProvider checksActions];
}

- (void) getChecksSearch: (NSString *) searchText {
	[_dataProvider checksSearch: searchText];
}

#pragma mark -

- (void) getCommentsForPhoto: (LGPhoto *) photo {
	[_dataProvider photoCommentsFor: photo];
}

#pragma mark -

- (void) addPhotoForCheck: (LGCheck *) check {
	[_dataProvider checkAddPhoto: check];
}

#pragma mark -

- (void) getPhotosForCheck: (LGCheck *) check {
	[_viewControllersManager.rootNavigationController addWaitViewControllerOfClass: [CheckPhotosViewController class]];
	[_dataProvider checkPhotosFor: check.uid];
}

- (void) getPhotoCountersForPhoto: (LGPhoto *) photo {
	[_dataProvider photoCountersFor: photo];
}

- (void) getPhotoVotesForPhoto: (LGPhoto *) photo {
	[_dataProvider photoVotesFor: photo];
}

- (void) getUsersForCheck: (LGCheck *) check {
	[_dataProvider checkUsersFor: check];
}

- (void) getVotePhotosForCheck: (LGCheck *) check {
	[_viewControllersManager.rootNavigationController addWaitViewControllerOfClass: [VoteViewController class]];
	[_dataProvider checkVotePhotosFor: check.uid];
}

- (void) stopWaitingVotePhotos {
	[_viewControllersManager.rootNavigationController removeWaitViewControllerOfClass: [VoteViewController class]];
}

- (void) sendCommentWith: (LGCommentAction *) commentAction {
	if ([_kernel isUnauthorizedActionAllowed] == NO) {
		return;
	}
	if ([commentAction.context isKindOfClass: [LGPhoto class]] == YES) {
		[_dataProvider photoAddCommentFor: commentAction];
	}
}

- (void) removeCommentWith: (LGCommentAction *) commentAction {
	[_dataProvider commentRemove: commentAction];
}

- (void) voteWith: (LGVoteAction *) voteAction  {
	[_viewControllersManager.rootNavigationController addWaitViewControllerOfClass: [VoteViewController class]];
	[_dataProvider photoVote: voteAction];
}

- (void) openCheckCardViewController {
	[_viewControllersManager openCheckCardViewController];
	if ([_kernel.storage.checks count] <= 0) {
		[_dataProvider checksWithContext: nil];
	}
}

- (void) openCheckCardViewControllerFor: (LGCheck *) check {
	NSUInteger index = [_kernel.storage.checks indexOfObject: check];
	if (index != NSNotFound) {
		NSIndexPath *indexPath = [NSIndexPath indexPathForRow: index inSection: 0];
		_viewControllersManager.checkCardViewController.indexToShowOnAppear = indexPath;
	}
	[_viewControllersManager openCheckCardViewController];
	if ([_kernel.storage.checks count] <= 0) {
		[_dataProvider checksWithContext: nil];
	}
}

- (BOOL) openCheckCardViewControllerForCheckUID: (int64_t) checkUID {
	for (LGCheck *item in _kernel.storage.checks) {
		if (item.uid == checkUID) {
			[self openCheckCardViewControllerFor: item];
			return YES;
		}
	}
	return NO;
}

- (void) openCheckCardViewControllerWithFetchForCheckUID: (int64_t) checkUID {
	if ([self openCheckCardViewControllerForCheckUID: checkUID] == NO) {
		[_dataProvider checksWithContext: @(checkUID)];
	}
}

- (void) openCheckListViewController {
	[_viewControllersManager openCheckListViewController];
	if ([_kernel.storage.checks count] <= 0) {
		[_dataProvider checksWithContext: nil];
	}
}

- (void) openCheckActionListViewController {
	CheckActionListViewController *vc = _viewControllersManager.checkActionListViewController;
	[_viewControllersManager openViewController: vc animated: YES];
	[_dataProvider checksActions];
}

- (void) openCheckDetailViewControllerAdminFor: (LGCheck *) check {
	CheckDetailViewController *vc = _viewControllersManager.checkDetailViewController;
	vc.check = check;
	vc.photo = nil;
	vc.mode = CheckDetailViewModeAdminPhoto;
	[_viewControllersManager openViewController: vc animated: YES];
}

- (void) openCheckDetailViewControllerUserFor: (LGCheck *) check {
	CheckDetailViewController *vc = _viewControllersManager.checkDetailViewController;
	vc.check = check;
	vc.photo = nil;
	vc.mode = CheckDetailViewModeUserPhoto;
	[_viewControllersManager openViewController: vc animated: YES];
}

- (void) openCheckDetailViewControllerWinnerFor: (LGCheck *) check {
	CheckDetailViewController *vc = _viewControllersManager.checkDetailViewController;
	vc.check = check;
	vc.photo = nil;
	vc.mode = CheckDetailViewModeWinnerPhoto;
	[_viewControllersManager openViewController: vc animated: YES];
}

- (void) openViewControllerFor: (LGPhoto *) photo {
	CheckDetailViewController *vc = _viewControllersManager.checkDetailViewController;
	vc.check = nil;
	vc.photo = photo;
	vc.mode = CheckDetailViewModeUserPhoto;
	[_viewControllersManager openViewController: vc animated: YES];
}

- (void) openCheckPhotosViewControllerForCheck: (LGCheck *) check {
	CheckPhotosViewController *vc = _viewControllersManager.checkPhotosViewController;
	vc.check = check;
	[_viewControllersManager openViewController: vc animated: YES];
}

- (void) openCheckUsersViewControllerForCheck: (LGCheck *) check {
	SubscriptionViewController *vc = _viewControllersManager.subscriptionViewController;
	vc.context = check;
    vc.mode = SubscriptionViewControllerModeCheckUsers;
	[_viewControllersManager openViewController: vc animated: YES];
}

- (void) openVoteViewControllerForCheck: (LGCheck *) check {
	if ([_kernel isUnauthorizedActionAllowed] == NO) {
		return;
	}
	VoteViewController *voteViewController = _viewControllersManager.voteViewController;
	voteViewController.check = check;
	[_viewControllersManager openViewController: voteViewController animated: YES];
}

- (void) openPhotoCommentsViewControllerFor: (LGPhoto *) photo {
	CommentsViewController *vc = _viewControllersManager.commentsViewController;
	vc.photo = photo;
	[_viewControllersManager openViewController: vc animated: YES];
}

- (void) openPhotoVotesViewControllerFor: (LGPhoto *) photo {
	SubscriptionViewController *vc = _viewControllersManager.subscriptionViewController;
	vc.context = photo;
    vc.mode = SubscriptionViewControllerModePhotoVotes;
	[_viewControllersManager openViewController: vc animated: YES];
}

@end
