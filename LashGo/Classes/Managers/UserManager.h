//
//  UserManager.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 13.09.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

@class Kernel;
@class DataProvider;
@class ViewControllersManager;

@class LGUser;

@interface UserManager : NSObject

- (instancetype) initWithKernel: (Kernel *) kernel
				   dataProvider: (DataProvider *) dataProvider
					  vcManager: (ViewControllersManager *) vcManager;

- (void) getUserPhotosForUser: (LGUser *) user;
- (void) stopWaitingUserPhotos;

- (void) recoverPasswordWithEmail: (NSString *) email;
- (void) socialSignIn;

- (void) openLoginViewController;
- (void) openRecoverViewController;

- (void) openProfileEditViewControllerWith: (LGUser *) user;
- (void) openProfileWelcomeViewControllerWith: (LGUser *) user;
- (void) openProfileViewController;
- (void) openProfileViewControllerWith: (LGUser *) user;

@end
