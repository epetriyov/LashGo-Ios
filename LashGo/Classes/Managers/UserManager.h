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

@class LGSubscription;
@class LGUser;

@interface UserManager : NSObject

- (instancetype) initWithKernel: (Kernel *) kernel
				   dataProvider: (DataProvider *) dataProvider
					  vcManager: (ViewControllersManager *) vcManager;

- (void) getUserCounters;
- (void) getUserProfile;
- (void) getUsersSearch: (NSString *) searchText;
- (void) getUserPhotosForUser: (LGUser *) user;
- (void) stopWaitingUserPhotos;
- (void) getSubscribersForUser: (LGUser *) user;
- (void) getSubscribtionsForUser: (LGUser *) user;

- (void) updateUser: (LGUser *) user;
- (void) updateUserAvatar: (UIImage *) image;

- (void) recoverPasswordWithEmail: (NSString *) email;
- (void) socialSignIn;

- (void) subscribeTo: (LGSubscription *) subscription;
- (void) subscribeToUser: (LGUser *) user;
- (void) unsubscribeFrom: (LGSubscription *) subscription;
- (void) unsubscribeFromUser: (LGUser *) user;

- (void) openEventsViewVontroller;
- (void) openNewsViewController;

- (void) openLoginViewController;
- (void) openRecoverViewController;

- (void) openProfileEditViewControllerWith: (LGUser *) user;
- (void) openProfileWelcomeViewController;
- (void) openProfileViewController;
- (void) openProfileViewControllerWith: (LGUser *) user;

- (void) openSubscribersWith: (LGUser *) user;
- (void) openSubscribtionsWith: (LGUser *) user;

- (void) openEULAViewController;
- (void) openPrivacyPolicyViewController;

@end
