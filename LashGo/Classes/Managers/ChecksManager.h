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

@interface ChecksManager : NSObject

- (instancetype) initWithKernel: (Kernel *) kernel
				   dataProvider: (DataProvider *) dataProvider
					  vcManager: (ViewControllersManager *) vcManager;

- (void) getVotePhotos;

- (void) openCheckCardViewController;
- (void) openCheckListViewController;

- (void) openVoteViewControllerForCheck: (LGCheck *) check;

@end
