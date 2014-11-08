//
//  TwitterAppAccount.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 13.06.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "TwitterAppAccount.h"
#import "TWAPIManager.h"
#import "Common.h"
#import "DataProvider.h"

//key JjHQisFOu784Ag7HBAcJg
//sec pIkZnc7NJ8CW0WG5sCFLgPD5BOrak2Gtca3hmpy5dg

#define ERROR_TITLE_MSG @"Oops"
#define ERROR_NO_ACCOUNTS @"You must add a Twitter account in Settings.app to use this demo."
#define ERROR_PERM_ACCESS @"We weren't granted access to the user's accounts"
#define ERROR_NO_KEYS @"You need to add your Twitter app keys to Info.plist to use this demo.\nPlease see README.md for more info."
#define ERROR_OK @"OK"

@interface TwitterAppAccount () <DataProviderDelegate> {
	DataProvider *_dataProvider;
	NSString *_accessTokenSecret;
}

@property (nonatomic, strong) ACAccountStore *accountStore;
@property (nonatomic, strong) TWAPIManager *apiManager;
@property (nonatomic, strong) NSArray *accounts;

@end

@implementation TwitterAppAccount

@synthesize accessToken = _accessToken;

#pragma mark - Properties

- (NSString *) accountSocialName {
	return @"twitter";
}

- (AppAccountType) accountType {
	return AppAccountTypeTwitter;
}

#pragma mark - Standard overrides

- (id) init {
	if (self = [super init]) {
		_dataProvider = [[DataProvider alloc] init];
		_dataProvider.delegate = self;
		
		_accountStore = [[ACAccountStore alloc] init];
        _apiManager = [[TWAPIManager alloc] init];
	}
	return self;
}

#pragma mark -

- (void) loginLashGo {
	if ([Common isEmptyString: self.sessionID] == YES) {
		LGSocialInfo *socialInfo = [[LGSocialInfo alloc] init];
		socialInfo.accessToken = self.accessToken;
		socialInfo.accessTokenSecret = _accessTokenSecret;
		socialInfo.socialName = self.accountSocialName;
		[_dataProvider userSocialSignIn: socialInfo];
	} else {
		[self.delegate authDidFinish: YES forAccount: self];
	}
}

- (void) login {
	[self _refreshTwitterAccounts];
}

- (void) logout {
	[self.delegate authDidFinish: NO forAccount: self];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        [_apiManager performReverseAuthForAccount:_accounts[buttonIndex] withHandler:^(NSData *responseData, NSError *error) {
            if (responseData) {
                NSString *responseStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
                
                TWDLog(@"Reverse Auth process returned: %@", responseStr);
				_accessToken = [responseStr stringBetweenString: @"oauth_token=" andString: @"&"];
				_accessTokenSecret = [responseStr stringBetweenString: @"oauth_token_secret=" andString: @"&"];
                
                dispatch_async(dispatch_get_main_queue(), ^{
					[self loginLashGo];
//					[self.delegate authDidFinish: YES forAccount: self];
                });
            }
            else {
                TWALog(@"Reverse Auth process failed. Error returned was: %@\n", [error localizedDescription]);
            }
        }];
    }
}

#pragma mark - Private
- (void)_displayAlertWithMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"AlertErrorTitle".commonLocalizedString
													message:message
												   delegate:nil
										  cancelButtonTitle: @"OK".commonLocalizedString
										  otherButtonTitles:nil];
    [alert show];
}

/**
 *  Checks for the current Twitter configuration on the device / simulator.
 *
 *  First, we check to make sure that we've got keys to work with inside Info.plist (see README)
 *
 *  Then we check to see if the device has accounts available via +[TWAPIManager isLocalTwitterAccountAvailable].
 *
 *  Next, we ask the user for permission to access his/her accounts.
 *
 *  Upon completion, the button to continue will be displayed, or the user will be presented with a status message.
 */
- (void)_refreshTwitterAccounts
{
    TWDLog(@"Refreshing Twitter Accounts \n");
    
    if (![TWAPIManager hasAppKeys]) {
        [self _displayAlertWithMessage:ERROR_NO_KEYS];
    }
    else if (![TWAPIManager isLocalTwitterAccountAvailable]) {
        [self _displayAlertWithMessage: @"ERROR_NO_ACCOUNTS".commonLocalizedString];
    }
    else {
        [self _obtainAccessToAccountsWithBlock:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (granted) {
					[self performReverseAuth];
//                    _reverseAuthBtn.enabled = YES;
                }
                else {
                    [self _displayAlertWithMessage: @"ERROR_PERM_ACCESS".commonLocalizedString];
                    TWALog(@"You were not granted access to the Twitter accounts.");
                }
            });
        }];
    }
}

- (void)_obtainAccessToAccountsWithBlock:(void (^)(BOOL))block
{
    ACAccountType *twitterType = [_accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    ACAccountStoreRequestAccessCompletionHandler handler = ^(BOOL granted, NSError *error) {
        if (granted) {
            self.accounts = [_accountStore accountsWithAccountType:twitterType];
        }
        
        block(granted);
    };
    [_accountStore requestAccessToAccountsWithType:twitterType options:NULL completion:handler];
}

/**
 *  Handles the button press that initiates the token exchange.
 *
 *  We check the current configuration inside -[UIViewController viewDidAppear].
 */
- (void)performReverseAuth {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Choose an Account".commonLocalizedString
													   delegate:self
											  cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    for (ACAccount *acct in _accounts) {
        [sheet addButtonWithTitle:acct.username];
    }
    sheet.cancelButtonIndex = [sheet addButtonWithTitle:@"Cancel".commonLocalizedString];
    [sheet showInView: self.selectAccountParentView];
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
