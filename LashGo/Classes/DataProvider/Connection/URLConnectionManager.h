#import "URLConnection.h"

@interface URLConnectionManager : NSObject <URLConnectionDelegate> {
	NSMutableDictionary *targetsForURLConnections;
	NSMutableDictionary *didFinishSelectorsForURLConnections;
	NSMutableDictionary *didFailSelectorsForURLConnections;
	SEL prepareToRemoveConnectionSelector;
}

@property (nonatomic, assign) SEL prepareToRemoveConnectionSelector;

- (URLConnection *) connectionWithHost: (NSString *) host
								  path: (NSString *) path
						   queryParams: (NSDictionary *) queryParams
						  headerParams: (NSDictionary *) headerParams
								  body: (NSDictionary *) bodyJSON
								  type: (URLConnectionType) theType
								target: (id) target finishSelector: (SEL) finishSelector failSelector: (SEL) failSelector;

@end