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

#define kCheckActivityAlertView @"CheckActivityAlertView"
#define kComplainConfirmAlertView @"ComplainConfirmAlertView"
#define kLogoutConfirmAlertView @"LogoutConfirmAlertView"

@interface AlertViewManager () {
	NSMutableDictionary *_alertContext;
}

@end

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
		_alertContext = [[NSMutableDictionary alloc] init];
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

- (void) showAlertView: (UIAlertView *) alertView withKey: (NSString *) key context: (id) context {
	if (context != nil && _alertContext[key] == nil) {
		_alertContext[key] = context;
	}
	[self showAlertView: alertView withKey: key];
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

#pragma mark -

- (void) showAlertCheckActivityViewConfirmWithMessage: (NSString *) message context: (id) context {
	UIAlertView *alertView = [ [UIAlertView alloc] initWithTitle: @"AlertCheckActivityTitle".commonLocalizedString
														 message: message
														delegate: self
											   cancelButtonTitle: @"AlertCheckActivityBtnCancelTitle".commonLocalizedString
											   otherButtonTitles: @"AlertCheckActivityBtnOkTitle".commonLocalizedString, nil];
	[self showAlertView: alertView withKey: kCheckActivityAlertView context: context];
}

- (void) showAlertComplainConfirmWithContext: (id) context {
	UIAlertView *alertView = [ [UIAlertView alloc] initWithTitle: @"AlertComplainTitle".commonLocalizedString
														 message: @"AlertComplainMessage".commonLocalizedString
														delegate: self
											   cancelButtonTitle: kAlertDefaultNoText.commonLocalizedString
											   otherButtonTitles: kAlertDefaultYesText.commonLocalizedString, nil];
	[self showAlertView: alertView withKey: kComplainConfirmAlertView context: context];
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
	NSString *key = nil;
	id context = nil;
	
	NSArray *keys = [alertViews allKeysForObject: alertView];
	if ([keys count] > 0) {
		key = keys[0];
		
		[alertViews removeObjectForKey: key];
		
		context = _alertContext[key];
		if (context != nil) {
			[_alertContext removeObjectForKey: key];
		}
	}
	
	if ([key isEqualToString: kCheckActivityAlertView] == YES) {
		if (buttonIndex > 0 &&
			[self.delegate respondsToSelector: @selector(alertViewManagerDidConfirmCheckActivityView:withContext:)] == YES) {
			[self.delegate alertViewManagerDidConfirmCheckActivityView: self withContext: context];
		}
	} else
	if ([key isEqualToString: kComplainConfirmAlertView] == YES) {
		if (buttonIndex > 0 &&
			[self.delegate respondsToSelector: @selector(alertViewManagerDidConfirmComplain:withContext:)] == YES) {
			[self.delegate alertViewManagerDidConfirmComplain: self withContext: context];
		}
	} else
	if ([key isEqualToString: kLogoutConfirmAlertView] == YES) {
		if (buttonIndex > 0 &&
			[self.delegate respondsToSelector: @selector(alertViewManagerDidConfirmLogout:)] == YES) {
			[self.delegate alertViewManagerDidConfirmLogout: self];
		}
	}
}

@end
