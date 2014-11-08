//
//  VkontakteAppAccount.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 16.06.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "VkontakteAppAccount.h"

#import "DataProvider.h"
#import "Common.h"

static NSString *const TOKEN_KEY = @"my_application_access_token";

@interface VkontakteAppAccount () <DataProviderDelegate> {
	DataProvider *_dataProvider;
}

@end

@implementation VkontakteAppAccount

#pragma mark - Properties

- (NSString *) accountSocialName {
	return @"vk";
}

- (AppAccountType) accountType {
	return AppAccountTypeVkontakte;
}

- (NSString *) accessToken {
	return [VKSdk getAccessToken].accessToken;
}

#pragma mark - Standard overrides

- (id) init {
	if (self = [super init]) {
		_dataProvider = [[DataProvider alloc] init];
		_dataProvider.delegate = self;
		
		[VKSdk initializeWithDelegate:self andAppId: @"4201819"];
		if ([VKSdk wakeUpSession]) {
			[self.delegate authDidFinish: YES forAccount: self];
		}
	}
	
	return self;
}

#pragma mark -

- (void) loginLashGo {
	if ([Common isEmptyString: self.sessionID] == YES) {
		LGSocialInfo *socialInfo = [[LGSocialInfo alloc] init];
		socialInfo.accessToken = self.accessToken;
		socialInfo.accessTokenSecret = [VKSdk getAccessToken].secret;
		socialInfo.socialName = self.accountSocialName;
		[_dataProvider userSocialSignIn: socialInfo];
	} else {
		[self.delegate authDidFinish: YES forAccount: self];
	}
}

- (void) login {
	[VKSdk authorize: @[VK_PER_STATS] revokeAccess:YES forceOAuth: YES inApp: NO];
}

- (void) logout {
	[VKSdk forceLogout];
	[self.delegate authDidFinish: NO forAccount: self];
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
	[self loginLashGo];
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

#pragma mark - DataProviderDelegate implementation

- (void) dataProvider: (DataProvider *) dataProvider didRegisterUser: (LGRegisterInfo *) registerInfo {
	self.sessionID = registerInfo.sessionInfo.uid;
	self.userInfo = registerInfo.user;
	[self.delegate authDidFinish: YES forAccount: self];
}

- (void) dataProvider: (DataProvider *) dataProvider didFailRegisterUserWith: (NSError *) error {
	[self.delegate authDidFinish: NO forAccount: self];
}

@end
