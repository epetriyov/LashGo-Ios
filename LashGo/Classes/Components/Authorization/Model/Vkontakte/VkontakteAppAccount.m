//
//  VkontakteAppAccount.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 16.06.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "VkontakteAppAccount.h"

static NSString *const TOKEN_KEY = @"my_application_access_token";

@implementation VkontakteAppAccount

#pragma mark - Properties

- (NSString *) accessToken {
	return [VKSdk getAccessToken].accessToken;
}

#pragma mark - Standard overrides

- (id) init {
	if (self = [super init]) {
		[VKSdk initializeWithDelegate:self andAppId: @"4435452"];
		if ([VKSdk wakeUpSession]) {
			[self.delegate authDidFinish: YES forAccount: self];
		}
	}
	
	return self;
}

- (void) login {
	[VKSdk authorize: @[VK_PER_STATS] revokeAccess:YES forceOAuth: YES];
}

- (void) logout {
	[VKSdk forceLogout];
}

- (BOOL) handleOpenURL:(NSURL *)url
	 sourceApplication:(NSString *)sourceApplication {
    // attempt to extract a token from the url
    return [VKSdk processOpenURL:url fromApplication:sourceApplication];
}

#pragma mark - Methods

- (void)vkSdkNeedCaptchaEnter:(VKError *)captchaError {
//	VKCaptchaViewController *vc = [VKCaptchaViewController captchaControllerWithError:captchaError];
//	[vc presentIn:self];
}

- (void)vkSdkTokenHasExpired:(VKAccessToken *)expiredToken {
	[self login];
}

- (void)vkSdkReceivedNewToken:(VKAccessToken *)newToken {
    [self.delegate authDidFinish: YES forAccount: self];
}

- (void)vkSdkShouldPresentViewController:(UIViewController *)controller {
//	[self presentViewController:controller animated:YES completion:nil];
}

- (void)vkSdkAcceptedUserToken:(VKAccessToken *)token {
//    [self startWorking];
}
- (void)vkSdkUserDeniedAccess:(VKError *)authorizationError {
	[self.delegate authDidFinish: NO forAccount: self];
	[[[UIAlertView alloc] initWithTitle:nil message:@"Access denied" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
}

@end
