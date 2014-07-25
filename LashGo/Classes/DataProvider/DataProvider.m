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

#define kUsersLoginPath		@"/users/login" //POST
#define kUsersPhotosPath	@"/users/photos" //GET
#define kUsersProfilePath	@"/users/profile" //GET
#define kUsersRecoverPath	@"/users/recover" //PUT
#define kUsersRegisterPath	@"/users/register" //POST
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

@end
