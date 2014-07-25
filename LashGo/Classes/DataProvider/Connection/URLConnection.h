
#import "NSMutableURLRequest+ParamsManipulation.h"
#import "URLSecurity.h"

typedef enum {
	URLConnectionStatusInitialized = 0,
	URLConnectionStatusStarted = 1,
	URLConnectionStatusFinished
} URLConnectionStatus;

@protocol URLConnectionDelegate;

@interface URLConnection : NSObject <NSURLConnectionDataDelegate> {
	URLConnectionStatus status;
	
	//Required if async request called from BG thread
	NSOperationQueue *queue;
	
	NSString *uid;
	NSString *urlPath;
	URLConnectionType type;
	NSMutableURLRequest *request;
	NSURLConnection *connection;
	
	NSHTTPURLResponse *response;
	NSError *error;
	
	NSMutableData *downloadedData;
}

@property (nonatomic, weak) id<URLConnectionDelegate> delegate;
@property (nonatomic, readonly) URLConnectionStatus status;
@property (nonatomic, readonly) NSString *uid;
@property (nonatomic, readonly) NSString *urlPath;
@property (nonatomic, readonly) URLConnectionType type;
@property (nonatomic, readonly) NSMutableURLRequest *request;
@property (nonatomic, readonly) NSHTTPURLResponse *response;
@property (nonatomic, readonly) NSError *error;
@property (nonatomic, readonly) NSMutableData *downloadedData;
@property (nonatomic, strong) URLSecurity *security;
@property (nonatomic, strong) id context;

+ (URLConnection *) connectionWithHost: (NSString *) host
								  path: (NSString *) path
								  type: (URLConnectionType) theType
						   queryParams: (NSDictionary *) queryParams
						  headerParams: (NSDictionary *) headerParams
								  body: (NSDictionary *) bodyJSON
							  delegate: (id<URLConnectionDelegate>) theDelegate;
- (void) addValue: (NSString *) value forQueryParameter: (NSString *) name;
- (void) startAsync;
- (void) startSync;

@end

@protocol URLConnectionDelegate <NSObject>

- (void) connectionDidFinish: (URLConnection *) connection;
- (void) connectionDidFail: (URLConnection *) connection withError: (NSError *) error;

@end
