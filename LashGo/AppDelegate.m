//
//  AppDelegate.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 19.04.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate


// The native facebook application transitions back to an authenticating application when the user
// chooses to either log in, or cancel. The url passed to this method contains the token in the
// case of a successful login. By passing the url to the handleOpenURL method of FBAppCall the provided
// session object can parse the URL, and capture the token for use by the rest of the authenticating
// application; the return value of handleOpenURL indicates whether or not the URL was handled by the
// session object, and does not reflect whether or not the login was successful; the session object's
// state, as well as its arguments passed to the state completion handler indicate whether the login
// was successful; note that if the session is nil or closed when handleOpenURL is called, the expression
// will be boolean NO, meaning the URL was not handled by the authenticating application
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [[AuthorizationManager sharedManager].account handleOpenURL: url
													 sourceApplication: sourceApplication];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	kernel = [[Kernel alloc] init];
	
	[kernel.pushNotificationManager registerRemoteNotifications];
	
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
	self.window.rootViewController = kernel.viewControllersManager.rootNavigationController;
    [self.window makeKeyAndVisible];
	
	[kernel performOnColdWakeActions];
	
	NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
//	userInfo = @{@"aps":@{@"alert":@{@"loc-key": @"CHECK_STARTED",
//									 @"loc-args": @[@"Назв"]}},
//				 @"check_id":@"125"};
	
	if (userInfo != nil) {
		//Notification actions
		[kernel.pushNotificationManager didReceiveRemoteNotificationBeforeStart:userInfo];
	}
	
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[[AuthorizationManager sharedManager].account handleApplicationDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	[[AuthorizationManager sharedManager].account handleApplicationWillTerminate];
}

#pragma mark - Methods

- (void)setNetworkActivityIndicatorVisible:(BOOL) value {
	static short requestsCount = 0;
	if (value == YES) {
        requestsCount++;
	} else {
        requestsCount--;
	}
	
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: (requestsCount > 0)];
}

#pragma mark -
#pragma mark Push notification delegate

#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
	[kernel.pushNotificationManager didRegisterUserNotificationSettings: notificationSettings];
}
#endif

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken {
	[kernel.pushNotificationManager didRegisterForRemoteNotificationsWithDeviceToken:devToken];
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
	[kernel.pushNotificationManager didFailToRegisterForRemoteNotificationsWithError:err];
}

//- (void)application:(UIApplication *)app didReceiveLocalNotification:(UILocalNotification *)notif {
//	NSDictionary *dic = notif.userInfo;
//    NSString *itemName = [notif.userInfo objectForKey:@"ToDoItemKey"];
////    [viewController displayItem:itemName];  // custom method
////    application.applicationIconBadgeNumber = notification.applicationIconBadgeNumber-1;
//}

- (void)application:(UIApplication *)app didReceiveRemoteNotification:(NSDictionary *)userInfo {
	[kernel.pushNotificationManager didReceiveRemoteNotificationWhileRunning:userInfo];
}

@end
