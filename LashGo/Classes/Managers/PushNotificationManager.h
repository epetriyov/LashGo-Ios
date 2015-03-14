
@class DataProvider;

@interface PushNotificationPayload : NSObject

@property (nonatomic, strong) NSString *message;
@property (nonatomic, assign) int64_t checkUID;

@end

@interface PushNotificationManager : NSObject

@property (nonatomic, readonly) BOOL didReceivedNotificationBeforeStart;
@property (nonatomic, readonly) PushNotificationPayload *lastPayload;

- (instancetype) initWithDataProvider: (DataProvider *) dataProvider;

- (void) registerRemoteNotifications;
#ifdef __IPHONE_8_0
- (void) didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings;
#endif
- (void) didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
- (void) didFailToRegisterForRemoteNotificationsWithError:(NSError *) error;

- (void) didReceiveRemoteNotificationBeforeStart:(NSDictionary *)userInfo;
- (void) didReceiveRemoteNotificationWhileRunning:(NSDictionary *)userInfo;
- (void) didReceiveLocalNotification:(UILocalNotification *)notif;

@end
