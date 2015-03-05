#import "PushNotificationManager.h"

#import "AlertViewManager.h"
#import "Common.h"
#import "DataProvider.h"
#import "CryptoUtils.h"

@implementation PushNotificationPayload

@end

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

- (PushNotificationPayload *) parsePushNotificationPayloadInfo: (NSDictionary *) info {
	PushNotificationPayload *payload = [[PushNotificationPayload alloc] init];
	NSDictionary *rawAlert = info[@"aps"][@"alert"];
	
	NSString *messageFormat =	((NSString *)rawAlert[@"loc-key"]).commonLocalizedString;
	NSArray *messageArgs =		rawAlert[@"loc-args"];
	
	payload.message =			[NSString stringWithFormat: messageFormat, [messageArgs firstObject]];
	payload.checkUID =			[info[@"check_id"] longLongValue];
	
	return payload;
}

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
	NSString *deviceTokenString = [deviceToken hexString];
	
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
	
	PushNotificationPayload *payload = [self parsePushNotificationPayloadInfo:userInfo];
	
	[[AlertViewManager sharedManager] showAlertCheckActivityViewConfirmWithMessage: payload.message
																		   context: payload];
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
