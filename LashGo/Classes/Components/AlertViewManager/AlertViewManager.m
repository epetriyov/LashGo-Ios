//
//  AlertViewManager.m
//  DevLib
//
//  Created by Vitaliy Pykhtin on 23.04.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "AlertViewManager.h"
#import "Common.h"

#define kAlertDefaultSingleButtonText @"OK"
#define kAlertDefaultYesText	@"Да"
#define kAlertDefaultNoText		@"Нет"

#define kLogoutConfirmAlertView @"LogoutConfirmAlertView"

@implementation AlertViewManager

@synthesize delegate;

+ (AlertViewManager *) sharedManager {
	static AlertViewManager *alertViewManager = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		alertViewManager = [ [AlertViewManager alloc] init];
	});
	return alertViewManager;
}

- (id) init {
	if (self = [super init]) {
		alertViews = [ [NSMutableDictionary alloc] init];
		
		return self;
	}
	return nil;
}

#pragma mark - Methods

- (void) showAlertView: (UIAlertView *) alertView withKey: (NSString *) key {
	if (alertViews[key] == nil) {
		alertViews[key] = alertView;
		[alertView show];
	}
}

- (void) closeAlertViewWithKey: (NSString *) key {
	UIAlertView *alertView = alertViews[key];
	if (alertView != nil) {
		DLog(@"Close alert with key: %@", key);
		[alertView dismissWithClickedButtonIndex: 0 animated: YES];
	}
}

#pragma mark -

- (void) showAlertViewWithError: (NSError *) error {
	UIAlertView *alertView = [ [UIAlertView alloc] initWithTitle: @"AlertErrorTitle".commonLocalizedString
														 message: [error localizedDescription]
														delegate: self
											   cancelButtonTitle: kAlertDefaultSingleButtonText.commonLocalizedString
											   otherButtonTitles: nil];
	[alertView show];
}

- (void) showAlertViewWithTitle: (NSString *) title andMessage: (NSString *) message {
	UIAlertView *alertView = [ [UIAlertView alloc] initWithTitle: title
														 message: message
														delegate: nil
											   cancelButtonTitle: kAlertDefaultSingleButtonText.commonLocalizedString
											   otherButtonTitles: nil];
	[alertView show];
}

- (void) showAlertAuthorizationFails {
	UIAlertView *alertView = [ [UIAlertView alloc] initWithTitle: @"AlertAuthErrorTitle".commonLocalizedString
														 message: @"AlertAuthErrorMessage".commonLocalizedString
														delegate: nil
											   cancelButtonTitle: kAlertDefaultSingleButtonText.commonLocalizedString
											   otherButtonTitles: nil];
	[alertView show];
}

- (void) showAlertEmptyFields {
	UIAlertView *alertView = [ [UIAlertView alloc] initWithTitle: @"AlertAuthErrorTitle".commonLocalizedString
														 message: @"AlertEmptyFieldsMessage".commonLocalizedString
														delegate: nil
											   cancelButtonTitle: kAlertDefaultSingleButtonText.commonLocalizedString
											   otherButtonTitles: nil];
	[alertView show];
}

- (void) showAlertLogoutConfirm {
	UIAlertView *alertView = [ [UIAlertView alloc] initWithTitle: @"AlertLogoutTitle".commonLocalizedString
														 message: @"AlertLogoutMessage".commonLocalizedString
														delegate: self
											   cancelButtonTitle: kAlertDefaultNoText.commonLocalizedString
											   otherButtonTitles: kAlertDefaultYesText.commonLocalizedString, nil];
	[self showAlertView: alertView withKey: kLogoutConfirmAlertView];
}

#pragma mark UIAlertViewDelegate methods

- (void) alertView: (UIAlertView *) alertView didDismissWithButtonIndex: (NSInteger) buttonIndex {
	NSArray *keys = [alertViews allKeysForObject: alertView];
	NSString *key = nil;
	if ([keys count] > 0) {
		key = keys[0];
		
		[alertViews removeObjectForKey: key];
	}
	
	if ([key isEqualToString: kLogoutConfirmAlertView] == YES) {
		if (buttonIndex > 0 &&
			[self.delegate respondsToSelector: @selector(alertViewManagerDidConfirmLogout:)] == YES) {
			[self.delegate alertViewManagerDidConfirmLogout: self];
		}
	}
}

@end
