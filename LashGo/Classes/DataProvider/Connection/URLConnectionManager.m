#import "URLConnectionManager.h"


@implementation URLConnectionManager

@synthesize prepareToRemoveConnectionSelector;

- (id) init {
	if (self = [super init]) {
		targetsForURLConnections = [ [NSMutableDictionary alloc] init];
		didFinishSelectorsForURLConnections = [ [NSMutableDictionary alloc] init];
		didFailSelectorsForURLConnections = [ [NSMutableDictionary alloc] init];
	}
	return self;
}

- (void) dealloc {
	[targetsForURLConnections release];
	[didFinishSelectorsForURLConnections release];
	[didFailSelectorsForURLConnections release];
	
	[super dealloc];
}

- (URLConnection *) connectionWithHost: (NSString *) host
								  path: (NSString *) path
						   queryParams: (NSDictionary *) queryParams
						  headerParams: (NSDictionary *) headerParams
								  body: (NSDictionary *) bodyJSON
								  type: (URLConnectionType) theType
								target: (id) target finishSelector: (SEL) finishSelector failSelector: (SEL) failSelector {
	URLConnection *connection = [URLConnection connectionWithHost: host
															 path: path
															 type: theType
													  queryParams: queryParams
													 headerParams: headerParams
															 body: bodyJSON
														 delegate: self];
	if (connection != nil && target != nil) {
		[targetsForURLConnections setObject: target forKey: connection.uid];
		[didFinishSelectorsForURLConnections setObject: NSStringFromSelector(finishSelector) forKey: connection.uid];
		[didFailSelectorsForURLConnections setObject: NSStringFromSelector(failSelector) forKey: connection.uid];
	}
	return connection;
}

- (void) removeConnection: (URLConnection *) connection {
	[targetsForURLConnections removeObjectForKey: connection.uid];
	[didFinishSelectorsForURLConnections removeObjectForKey: connection.uid];
	[didFailSelectorsForURLConnections removeObjectForKey: connection.uid];
}

#pragma mark URLConnectionDelegate methods

- (void) connectionDidFinish: (URLConnection *) connection {
	id target = [targetsForURLConnections objectForKey: connection.uid];
	SEL selector = NSSelectorFromString([didFinishSelectorsForURLConnections objectForKey: connection.uid]);
	if ([target respondsToSelector: selector]) {
		[target performSelector: selector withObject: connection];
	}
	if ([target respondsToSelector: prepareToRemoveConnectionSelector]) {
		[target performSelector: prepareToRemoveConnectionSelector withObject: connection];
	}

	[self removeConnection: connection];
}

- (void) connectionDidFail: (URLConnection *) connection withError: (NSError *) error {
	id target = [targetsForURLConnections objectForKey: connection.uid];
	SEL selector = NSSelectorFromString([didFailSelectorsForURLConnections objectForKey: connection.uid]);
	if ([target respondsToSelector: selector]) {
		[target performSelector: selector withObject: connection];
	}
	if ([target respondsToSelector: prepareToRemoveConnectionSelector]) {
		[target performSelector: prepareToRemoveConnectionSelector withObject: connection];
	}

	[self removeConnection: connection];
}

@end
