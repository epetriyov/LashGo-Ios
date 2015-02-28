#import "PushNotificationManager.h"
#import "DataProvider.h"

@interface PushNotificationManager () {
	DataProvider __weak *_dataProvider;
}

@end

@implementation PushNotificationManager

- (instancetype) initWithDataProvider: (DataProvider *) dataProvider {
	if (self = [super init]) {
		_dataProvider = dataProvider;
	}
	return self;
}

#pragma mark - Methods for tests

//	aps = {
//		alert = {
//			body = “Message Body Here”
//			"action-loc-key" = "special key for button"
//		},
//		badge = 0,
//	},
//	misc = {
//		type = “:typeofalert”
//		nicode = "show id here"
//	}

- (void) simulatePushNotificationAfterDelay: (float) delay {
//	NSDictionary *userInfo = [self createCustomUserDataForNotification:BBPushNotificationTypeTuneInNow];
//	[self performSelector:@selector(didReceiveRemoteNotification:) withObject:userInfo afterDelay:delay];
}

//- (void) cancelLocalNotification
//{
//	if ([NSClassFromString(@"UILocalNotification") respondsToSelector: @selector(alloc)]) 
//	{
//		[[UIApplication sharedApplication] cancelAllLocalNotifications];
//	}
//}
//
//- (void) scheduleLocalNotification
//{
//	if ([NSClassFromString(@"UILocalNotification") respondsToSelector: @selector(alloc)]) 
//	{
//		UILocalNotification* localNotification = [ [UILocalNotification alloc] init];
//		
//		if (localNotification == nil) 
//			return;
//		
//		NSDate* today = [NSDate date];
//		localNotification.fireDate = today;
//		localNotification.timeZone = [NSTimeZone defaultTimeZone];		
//		localNotification.alertBody = [Commons localString: @"A new notification is available!"];
//		localNotification.alertAction = NSLocalizedString(@"View Details", nil);
//		localNotification.applicationIconBadgeNumber = 1;
//		localNotification.repeatInterval = NSSecondCalendarUnit;
//		
//		[[UIApplication sharedApplication] scheduleLocalNotification: localNotification];
//		
//		[localNotification release];
//	}
//}

#pragma mark -

//- (BBPushNotificationPayload *) parsePushNotificationPayloadInfo: (NSDictionary *) info {
//	BBPushNotificationPayload *payload = [[[BBPushNotificationPayload alloc] init] autorelease];
//	NSDictionary *tmpDict = [info objectForKey:@"aps"];
//	payload.badgeNumber = [[tmpDict valueForKey:@"badge"] intValue];
//	
//	tmpDict =					[tmpDict objectForKey:@"alert"];
//	payload.text =				[tmpDict valueForKey:@"body"];
//	payload.actionButtonText =	[tmpDict valueForKey:@"action-loc-key"];
//	
//	tmpDict =				[info objectForKey:@"misc"];
//	payload.showCode =		[tmpDict valueForKey:@"nicode"];
//	NSString *payloadType = [tmpDict valueForKey:@"type"];
//	
//	if ([payloadType isEqualToString:kBBPushNotificationTypeBreakingNewsKey]) {
//		payload.type = BBPushNotificationTypeBreakingNews;
//	} else if ([payloadType isEqualToString:kBBPushNotificationTypeTuneInNowKey]) {
//		payload.type = BBPushNotificationTypeTuneInNow;
//	} else if ([payloadType isEqualToString:kBBPushNotificationTypePodcastsAlerts]) {
//		payload.type = BBPushNotificationTypePodcastsAlerts;
//	}
//	
//	return payload;
//}

- (void) registerRemoteNotifications {
    //Register for notifications
	if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
		[[UIApplication sharedApplication]
		 registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
											 UIRemoteNotificationTypeSound |
											 UIRemoteNotificationTypeAlert)];
	} else {
		UIUserNotificationSettings *unSettings = [UIUserNotificationSettings settingsForTypes: UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound
																				   categories: nil];
		[[UIApplication sharedApplication] registerUserNotificationSettings: unSettings];
	}
	
	//Local notifications for test
//	[self scheduleLocalNotification];
}

- (void) didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
	if (notificationSettings.types != UIUserNotificationTypeNone) {
		[[UIApplication sharedApplication] registerForRemoteNotifications];
	}
}

#pragma mark -

- (void) didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
	// Reset badge number to 0
	[UIApplication sharedApplication].applicationIconBadgeNumber = 0;
	
    // Get a hex string from the device token with no spaces or < >
	NSString *deviceTokenString = nil;
	
	if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
		deviceTokenString = [deviceToken base64Encoding];
	} else {
		deviceTokenString = [deviceToken base64EncodedStringWithOptions: 0];
	}
 
//    self.deviceToken = [[[[[_deviceToken description]
//						  stringByReplacingOccurrencesOfString: @"<" withString: @""] 
//						 stringByReplacingOccurrencesOfString: @">" withString: @""] 
//						stringByReplacingOccurrencesOfString: @" " withString: @""]
//						stringByReplacingOccurrencesOfString: @"-" withString: @""];
	
	DLog(@"Device Token: %@", deviceTokenString);
	
	if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
		if ([[UIApplication sharedApplication] enabledRemoteNotificationTypes] == UIRemoteNotificationTypeNone) {
			DLog(@"Notifications are disabled for this application. Not registering");
			return;
		}
	}

	[_dataProvider apnsRegisterWithToken: deviceTokenString];
}

- (void) didFailToRegisterForRemoteNotificationsWithError:(NSError *) error {
    DLog(@"Failed to register with error: %@", error);
}

- (void) didReceiveRemoteNotification:(NSDictionary *)userInfo {
    DLog(@"remote notification: %@",[userInfo description]);
	
//	BBPushNotificationPayload *payload = [self parsePushNotificationPayloadInfo:userInfo];
//	
//	self.pushNotificationShowCode = payload.showCode;
//	[UIApplication sharedApplication].applicationIconBadgeNumber = payload.badgeNumber;
//	
//	switch (payload.type) {
//		case BBPushNotificationTypeBreakingNews:
//            if ([Commons stringIsEmpty:payload.showCode] == NO)
//			[[AlertViewManager sharedManager] showPushNotificationBreakingNewsAlertViewWithMessage:payload.showCode
//																				 actionButtonTitle:payload.actionButtonText
//                                                                                       messageText:payload.text];
//            else
//            [[AlertViewManager sharedManager] showPushNotificationBreakingNewsAlertViewWithMessage:payload.text
//                                                                                 actionButtonTitle:payload.actionButtonText 
//                                                                                       messageText:payload.text];
//			break;
//		case BBPushNotificationTypeTuneInNow:
//            if ([Commons stringIsEmpty:payload.showCode] == NO)
//			[[AlertViewManager sharedManager] showPushNotificationTuneInAlertsAlertViewWithMessage:payload.showCode
//																				 actionButtonTitle:payload.actionButtonText
//                                                                                       messageText:payload.text];
//            else
//            [[AlertViewManager sharedManager] showPushNotificationTuneInAlertsAlertViewWithMessage:payload.text
//                                                                                 actionButtonTitle:payload.actionButtonText
//                                                                                       messageText:payload.text];
//			break;
//		case BBPushNotificationTypePodcastsAlerts:
//            if ([Commons stringIsEmpty:payload.showCode] == NO)
//			[[AlertViewManager sharedManager] showPushNotificationFavoritesAlertViewWithMessage:payload.showCode
//																			  actionButtonTitle:payload.actionButtonText
//                                                                                    messageText:payload.text];
//            else
//            [[AlertViewManager sharedManager] showPushNotificationFavoritesAlertViewWithMessage:payload.text
//                                                                              actionButtonTitle:payload.actionButtonText
//                                                                                    messageText:payload.text];
//			break;
//		default:
//			break;
//	}
}

- (void) didReceiveRemoteNotificationBeforeStart:(NSDictionary *)userInfo {
	[self didReceiveRemoteNotification:userInfo];
}

- (void) didReceiveRemoteNotificationWhileRunning:(NSDictionary *)userInfo {
	[self didReceiveRemoteNotification:userInfo];
}

- (void) didReceiveLocalNotification:(UILocalNotification *)notif {
//	NSDictionary *dic = notif.userInfo;
//    NSString *itemName = [notif.userInfo objectForKey:@"ToDoItemKey"];
//    [viewController displayItem:itemName];  // custom method
//    application.applicationIconBadgeNumber = notification.applicationIconBadgeNumber-1;	
}

@end
