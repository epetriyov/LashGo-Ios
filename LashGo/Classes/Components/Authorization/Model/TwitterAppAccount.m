//
//  TwitterAppAccount.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 13.06.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "TwitterAppAccount.h"

@implementation TwitterAppAccount

- (void) login {
	// Initialize the account store
	_accountStore = [[ACAccountStore alloc] init];
	
	// Get the account type for the access request
	ACAccountType *accountType = [_accountStore
									accountTypeWithAccountTypeIdentifier: ACAccountTypeIdentifierTwitter];
	
	// Request access to the account with the access info
	[_accountStore requestAccessToAccountsWithType: accountType
							 withCompletionHandler:^(BOOL granted, NSError *error) {
											if (granted) {
												// If access granted, then get the account info
												NSArray *accounts = [_accountStore
																	 accountsWithAccountType: accountType];
												_account = [accounts lastObject];
												
												// Get the access token, could be used in other scenarios
												ACAccountCredential *credential = [_account credential];
												NSString *accessToken = [credential oauthToken];
												DLog(@"Twitter Access Token: %@", accessToken);
											} else {
												DLog(@"Access not granted");
											}
										}];
}

- (void) logout {
	
}

@end
