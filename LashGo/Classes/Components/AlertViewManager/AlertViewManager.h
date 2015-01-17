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
- (void) showAlertEmptyFields;

- (void) showAlertComplainConfirmWithContext: (id) context;
- (void) showAlertLogoutConfirm;

@end

@protocol AlertViewManagerDelegate <NSObject>

@optional
- (void) alertViewManagerDidConfirmComplain: (AlertViewManager *) manager withContext: (id) context;
- (void) alertViewManagerDidConfirmLogout: (AlertViewManager *) manager;

@end
