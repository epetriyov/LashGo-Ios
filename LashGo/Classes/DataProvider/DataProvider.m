//
//  DataProvider.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 24.05.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "DataProvider.h"

#import "AppDelegate.h"
#import "AuthorizationManager.h"
#import "Common.h"
#import "JSONParser.h"
#import "URLConnectionManager.h"

#define kWebServiceURL @"http://90.188.31.70:8080/lashgo-api"

#define kChecksPath			@"/checks" //POST
#define kChecksCurrentPath	@"/checks/current" //GET
#define kChecksCommentsPath	@"/checks/%ld/comments" //GET, POST
#define kChecksPhotosPath	@"/checks/%ld/photos" //GET, POST


#define kUsersLoginPath				@"/users/login" //POST
#define kUsersMainScreenInfoPath	@"/users/main-screen-info" //GET
#define kUsersPhotosPath			@"/users/photos" //GET
#define kUsersProfilePath			@"/users/profile" //GET
#define kUsersRecoverPath			@"/users/recover" //PUT
#define kUsersRegisterPath			@"/users/register" //POST
#define kUsersSocialSignInPath		@"/users/social-sign-in" //POST
#define kUsersSocialSignUpPath		@"/users/social-sign-up" //POST
#define kUsersSubscriptionsPath			@"/users/subscriptions" //GET
#define kUsersSubscriptionsManagePath	@"/users/subscriptions/%d" //DELETE, POST

static NSString *const kRequestClientType =	@"client_type";
static NSString *const kRequestSessionID =	@"session_id";
static NSString *const kRequestUUID =		@"uuid";

@interface DataProvider () {
	URLConnectionManager *_connectionManager;
	NSMutableDictionary *_liveConnections;
	JSONParser *_parser;
}

@end

@implementation DataProvider

#pragma mark - Standard overrides

- (id) init {
	if (self = [super init]) {
		_connectionManager = [[URLConnectionManager alloc] init];
		_connectionManager.prepareToRemoveConnectionSelector = @selector(prepareToRemoveConnection:);
		_liveConnections = [[NSMutableDictionary alloc] init];
		_parser = [[JSONParser alloc] init];
	}
	return self;
}

#pragma mark -

- (NSMutableDictionary *) dictionaryWithHeaderParams {
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:
									   @"IOS",											kRequestClientType,
									   [AuthorizationManager sharedManager].sessionID,	kRequestSessionID,
									   [Common deviceUUID],								kRequestUUID, nil];
	return dictionary;
}

///!!!:Works if no query params
- (void) removeConnectionFromLiveConnections: (URLConnection *) connection {
	NSString *connectionKey = [connection.request.URL.absoluteString stringByAppendingFormat: @"%d", connection.type];
	[_liveConnections removeObjectForKey: connectionKey];
}

- (void) prepareToRemoveConnection: (URLConnection *) connection {
	[((AppDelegate *)[UIApplication sharedApplication].delegate) setNetworkActivityIndicatorVisible: NO];
	[self removeConnectionFromLiveConnections: connection];
}

- (void) startConnectionWithPath: (NSString *) path
							type: (URLConnectionType) theType
							body: (NSDictionary *) bodyJSON
						 context: (id) context
				   allowMultiple: (BOOL) allowMultiple
				  finishSelector: (SEL) finishSelector failSelector: (SEL) failSelector {
	@synchronized (self) {
		NSString *connectionKey = [[kWebServiceURL stringByAppendingString: path] stringByAppendingFormat: @"%d", theType];
		
		if (allowMultiple == NO) {
			URLConnection *liveConnection = _liveConnections[connectionKey];
			if (liveConnection.status == URLConnectionStatusStarted) {
				return;
			}
		}
		NSMutableDictionary *headerParamsDictionary = [self dictionaryWithHeaderParams];
		URLConnection *connection = [_connectionManager connectionWithHost: kWebServiceURL
																	 path: path
															  queryParams: nil
															 headerParams: headerParamsDictionary
																	 body: bodyJSON
																	 type: theType
																   target: self
														   finishSelector: finishSelector
															 failSelector: failSelector];
		connection.context = context;
		
		if (allowMultiple == NO) {
			_liveConnections[connectionKey] = connection;
		}
		
		[((AppDelegate *)[UIApplication sharedApplication].delegate) setNetworkActivityIndicatorVisible: YES];
		[connection startAsync];
	}
}

- (void) didFailGetImportantData: (URLConnection *) connection {
	
}

#pragma mark - Login

- (void) didLogin: (URLConnection *) connection {
	
}

- (void) userLogin: (LGLoginInfo *) inputData {
	[self startConnectionWithPath: kUsersLoginPath type: URLConnectionTypePOST
							 body: inputData.JSONObject
						  context: nil
					allowMultiple: NO
				   finishSelector: @selector(didLogin:) failSelector: @selector(didFailGetImportantData:)];
}

#pragma mark -

- (void) didGetMainScreenInfo: (URLConnection *) connection {
	
}

- (void) userMainScreenInfo {
	[self startConnectionWithPath: kUsersMainScreenInfoPath type: URLConnectionTypeGET
							 body: nil
						  context: nil
					allowMultiple: NO
				   finishSelector: @selector(didGetMainScreenInfo:)
					 failSelector: @selector(didFailGetImportantData:)];
}

#pragma mark -

- (void) didGetPhotos: (URLConnection *) connection {
	
}

- (void) userPhotos {
	[self startConnectionWithPath: kUsersPhotosPath type: URLConnectionTypeGET
							 body: nil
						  context: nil
					allowMultiple: NO
				   finishSelector: @selector(didGetPhotos:)
					 failSelector: @selector(didFailGetImportantData:)];
}

#pragma mark -

- (void) didGetProfile: (URLConnection *) connection {
	
}

- (void) userProfile {
	[self startConnectionWithPath: kUsersProfilePath type: URLConnectionTypeGET
							 body: nil
						  context: nil
					allowMultiple: NO
				   finishSelector: @selector(didGetProfile:) failSelector: @selector(didFailGetImportantData:)];
}

#pragma mark -

- (void) didRecover: (URLConnection *) connection {
	
}

- (void) userRecover: (LGRecoverInfo *) inputData {
	[self startConnectionWithPath: kUsersRecoverPath type: URLConnectionTypePUT
							 body: nil
						  context: nil
					allowMultiple: NO
				   finishSelector: @selector(didRecover:) failSelector: @selector(didFailGetImportantData:)];
}

#pragma mark -

- (void) didRegisterUser: (URLConnection *) connection {
	
}

- (void) userRegister: (LGLoginInfo *) inputData {
	[self startConnectionWithPath: kUsersRegisterPath type: URLConnectionTypePOST
							 body: inputData.JSONObject
						  context: nil
					allowMultiple: NO
				   finishSelector: @selector(didRegisterUser:) failSelector: @selector(didFailGetImportantData:)];
}

#pragma mark -

- (void) didSocialSignIn: (URLConnection *) connection {
	
}

- (void) userSocialSignIn: (LGSocialInfo *) inputData {
	[self startConnectionWithPath: kUsersSocialSignInPath type: URLConnectionTypePOST
							 body: inputData.JSONObject
						  context: nil
					allowMultiple: NO
				   finishSelector: @selector(didSocialSignIn:) failSelector: @selector(didFailGetImportantData:)];
}

#pragma mark -

- (void) didSocialSignUp: (URLConnection *) connection {
	
}

- (void) userSocialSignUp: (LGSocialInfo *) inputData {
	[self startConnectionWithPath: kUsersRegisterPath type: URLConnectionTypePOST
							 body: inputData.JSONObject
						  context: nil
					allowMultiple: NO
				   finishSelector: @selector(didSocialSignUp:) failSelector: @selector(didFailGetImportantData:)];
}

#pragma mark -

- (void) didSubscribe: (URLConnection *) connection {
	
}

- (void) userSubscribeTo: (int32_t) userID {
	[self startConnectionWithPath: [NSString stringWithFormat: kUsersSubscriptionsManagePath, userID]
							 type: URLConnectionTypePOST
							 body: nil
						  context: nil
					allowMultiple: NO
				   finishSelector: @selector(didSubscribe:) failSelector: @selector(didFailGetImportantData:)];
}

#pragma mark -

- (void) didGetSubscriptions: (URLConnection *) connection {
	
}

- (void) userSubscriptions {
	[self startConnectionWithPath: kUsersSubscriptionsPath type: URLConnectionTypeGET
							 body: nil
						  context: nil
					allowMultiple: NO
				   finishSelector: @selector(didGetSubscriptions:) failSelector: @selector(didFailGetImportantData:)];
}

#pragma mark -

- (void) didUnsubscribe: (URLConnection *) connection {
	
}

- (void) userUnsubscribeFrom: (int32_t) userID {
	[self startConnectionWithPath: [NSString stringWithFormat: kUsersSubscriptionsManagePath, userID]
							 type: URLConnectionTypeDELETE
							 body: nil
						  context: nil
					allowMultiple: NO
				   finishSelector: @selector(didGetSubscriptions:) failSelector: @selector(didFailGetImportantData:)];
}

@end
