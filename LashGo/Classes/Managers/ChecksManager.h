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

@interface ChecksManager : NSObject

- (instancetype) initWithKernel: (Kernel *) kernel
				   dataProvider: (DataProvider *) dataProvider
					  vcManager: (ViewControllersManager *) vcManager;

- (void) addPhotoForCheck: (LGCheck *) check;

- (void) getVotePhotosForCheck: (LGCheck *) check;
- (void) stopWaitingVotePhotos;

- (void) voteForPhoto: (LGPhoto *) photo;

- (void) openCheckCardViewController;
- (void) openCheckCardViewControllerFor: (LGCheck *) check;
- (void) openCheckListViewController;

- (void) openCheckDetailViewControllerAdminFor: (LGCheck *) check;
- (void) openCheckDetailViewControllerUserFor: (LGCheck *) check;
- (void) openCheckDetailViewControllerWinnerFor: (LGCheck *) check;
- (void) openVoteViewControllerForCheck: (LGCheck *) check;

@end
