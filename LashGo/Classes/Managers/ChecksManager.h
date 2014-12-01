//
//  ChecksManager.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 11.08.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

@class Kernel;
@class DataProvider;
@class ViewControllersManager;

@class LGCheck;
@class LGPhoto;
@class LGVoteAction;

@interface ChecksManager : NSObject

- (instancetype) initWithKernel: (Kernel *) kernel
				   dataProvider: (DataProvider *) dataProvider
					  vcManager: (ViewControllersManager *) vcManager;

- (void) addPhotoForCheck: (LGCheck *) check;

- (void) getPhotosForCheck: (LGCheck *) check;
- (void) getUsersForCheck: (LGCheck *) check;
- (void) getVotePhotosForCheck: (LGCheck *) check;
- (void) stopWaitingVotePhotos;

- (void) stopWaiting: (UIViewController *) viewController;

- (void) voteWith: (LGVoteAction *) voteAction;

- (void) openCheckCardViewController;
- (void) openCheckCardViewControllerFor: (LGCheck *) check;
- (void) openCheckCardViewControllerForCheckUID: (int64_t) checkUID;
- (void) openCheckListViewController;

- (void) openCheckDetailViewControllerAdminFor: (LGCheck *) check;
- (void) openCheckDetailViewControllerUserFor: (LGCheck *) check;
- (void) openCheckDetailViewControllerWinnerFor: (LGCheck *) check;
- (void) openViewControllerFor: (LGPhoto *) photo;

- (void) openCheckPhotosViewControllerForCheck: (LGCheck *) check;
- (void) openCheckUsersViewControllerForCheck: (LGCheck *) check;
- (void) openVoteViewControllerForCheck: (LGCheck *) check;

@end
