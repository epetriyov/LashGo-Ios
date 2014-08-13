//
//  AlertViewManager.h
//  DevLib
//
//  Created by Vitaliy Pykhtin on 23.04.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

@protocol AlertViewManagerDelegate;

@interface AlertViewManager : NSObject <UIAlertViewDelegate> {
	NSMutableDictionary *alertViews;
}

@property (nonatomic, weak) id<AlertViewManagerDelegate> delegate;

+ (AlertViewManager *) sharedManager;

- (void) showAlertViewWithError: (NSError *) error;
- (void) showAlertViewWithTitle: (NSString *) title andMessage: (NSString *) message;
- (void) showAlertAuthorizationFails;
- (void) showAlertLogoutConfirm;

@end

@protocol AlertViewManagerDelegate <NSObject>

@optional
- (void) alertViewManagerDidConfirmLogout: (AlertViewManager *) manager;

@end
