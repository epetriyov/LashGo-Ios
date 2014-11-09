//
//  FacebookAppAccount.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 12.06.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

//LashGo app id 417722991695914

#import "FacebookAppAccount.h"

#import "Common.h"

@implementation FacebookAppAccount

#pragma mark - Properties

- (NSString *) accountSocialName {
	return @"facebook";
}

- (AppAccountType) accountType {
	return AppAccountTypeFacebook;
}

- (NSString *) accessToken {
	return _session.accessTokenData.accessToken;
}

#pragma mark - Standard overrides

- (id) init {
	if (self = [super init]) {
		// create a fresh session object
        _session = [[FBSession alloc] init];
		
        // if we don't have a cached token, a call to open here would cause UX for login to
        // occur; we don't want that to happen unless the user clicks the login button, and so
        // we check here to make sure we have a token before calling open
        if (_session.state == FBSessionStateCreatedTokenLoaded) {
            // even though we had a cached token, we need to login to make the session usable
            [_session openWithBehavior: FBSessionLoginBehaviorUseSystemAccountIfPresent
					 completionHandler:^(FBSession *session,
										 FBSessionState status,
										 NSError *error) {
				[self sessionStateChanged:session state:status error:error];
            }];
        }
	}
	
	return self;
}

- (void) dealloc {
	[_session close];
}

// FBSample logic
// It is possible for the user to switch back to your application, from the native Facebook application,
// when the user is part-way through a login; You can check for the FBSessionStateCreatedOpenening
// state in applicationDidBecomeActive, to identify this situation and close the session; a more sophisticated
// application may choose to notify the user that they switched away from the Facebook application without
// completely logging in
- (void) handleApplicationDidBecomeActive {
    [FBAppEvents activateApp];
	
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
	
    // FBSample logic
    // We need to properly handle activation of the application with regards to SSO
    //  (e.g., returning from iOS 6.0 authorization dialog or from fast app switching).
    [FBAppCall handleDidBecomeActiveWithSession: _session];
}

// FBSample logic
// Whether it is in applicationWillTerminate, in applicationDidEnterBackground, or in some other part
// of your application, it is important that you close an active session when it is no longer useful
// to your application; if a session is not properly closed, a retain cycle may occur between the block
// and an object that holds a reference to the session object; close releases the handler, breaking any
// inadvertant retain cycles
- (void) handleApplicationWillTerminate {
    // FBSample logic
    // if the app is going away, we close the session if it is open
    // this is a good idea because things may be hanging off the session, that need
    // releasing (completion block, etc.) and other components in the app may be awaiting
    // close notification in order to do cleanup
    [_session close];
}

// FBSample logic
// The native facebook application transitions back to an authenticating application when the user
// chooses to either log in, or cancel. The url passed to this method contains the token in the
// case of a successful login. By passing the url to the handleOpenURL method of FBAppCall the provided
// session object can parse the URL, and capture the token for use by the rest of the authenticating
// application; the return value of handleOpenURL indicates whether or not the URL was handled by the
// session object, and does not reflect whether or not the login was successful; the session object's
// state, as well as its arguments passed to the state completion handler indicate whether the login
// was successful; note that if the session is nil or closed when handleOpenURL is called, the expression
// will be boolean NO, meaning the URL was not handled by the authenticating application
- (BOOL) handleOpenURL:(NSURL *)url
	 sourceApplication:(NSString *)sourceApplication {
    // attempt to extract a token from the url
    return [FBAppCall handleOpenURL: url
                  sourceApplication: sourceApplication
                        withSession: _session];
}

#pragma mark - Methods

- (void) loginLashGo {
	if ([Common isEmptyString: self.sessionID] == YES) {
		LGSocialInfo *socialInfo = [[LGSocialInfo alloc] init];
		socialInfo.accessToken = self.accessToken;
		socialInfo.socialName = self.accountSocialName;
		[_dataProvider userSocialSignIn: socialInfo];
	} else {
		[self.delegate authDidFinish: YES forAccount: self];
	}
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error {
	if(FB_ISSESSIONOPENWITHSTATE(state)){
		NSAssert(error == nil, @"ShareKit: Facebook sessionStateChanged open session, but errors?!?!");
//		if(requestingPermisSHKFacebook == self){
//			// in this case, we basically want to ignore the state change because the
//			// completion handler for the permission request handles the post.
//			// this happens when the permissions just get extended
//		}else{
			[self loginLashGo];
//			[self.delegate authDidFinish: YES forAccount: self];
//		}
	}else if (FB_ISSESSIONSTATETERMINAL(state)){
//		if (authingSHKFacebook == self) {	// the state can change for a lot of reasons that are out of the login loop
		[self.delegate authDidFinish: NO forAccount: self];
//		}else{
//			// seems that if you expire the tolken that it thinks is valid it will close the session without reporting
//			// errors super awesome. So look for the errors in the FBRequestHandlerCallback
//		}
	}
	
    if (error && error.fberrorShouldNotifyUser) {
		[FBSession.activeSession closeAndClearTokenInformation];
        
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.fberrorUserMessage
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (void) login {
	if (_session.state != FBSessionStateCreated) {
		// Create a new, logged out session.
		_session = [[FBSession alloc] init];
	}
	
	// if the session isn't open, let's open it now and present the login UX to the user
	[_session openWithBehavior: FBSessionLoginBehaviorUseSystemAccountIfPresent
			 completionHandler:^(FBSession *session,
								 FBSessionState status,
								 NSError *error) {
		// and here we make sure to update our UX according to the new session state
		[self sessionStateChanged: session state: status error: error];
	}];
}

- (void) logout {
	// if a user logs out explicitly, we delete any cached token information, and next
	// time they run the applicaiton they will be presented with log in UX again; most
	// users will simply close the app or switch away, without logging out; this will
	// cause the implicit cached-token login to occur on next launch of the application
	[_session closeAndClearTokenInformation];
}

@end
