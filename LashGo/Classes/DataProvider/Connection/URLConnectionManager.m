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
		targetsForURLConnections[connection.uid] = target;
		didFinishSelectorsForURLConnections[connection.uid] = NSStringFromSelector(finishSelector);
		didFailSelectorsForURLConnections[connection.uid] = NSStringFromSelector(failSelector);
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
	id target = targetsForURLConnections[connection.uid];
	SEL selector = NSSelectorFromString(didFinishSelectorsForURLConnections[connection.uid]);
	if ([target respondsToSelector: selector]) {
		[target performSelector: selector withObject: connection];
	}
	if ([target respondsToSelector: prepareToRemoveConnectionSelector]) {
		[target performSelector: prepareToRemoveConnectionSelector withObject: connection];
	}

	[self removeConnection: connection];
}

- (void) connectionDidFail: (URLConnection *) connection withError: (NSError *) error {
	id target = targetsForURLConnections[connection.uid];
	SEL selector = NSSelectorFromString(didFailSelectorsForURLConnections[connection.uid]);
	if ([target respondsToSelector: selector]) {
		[target performSelector: selector withObject: connection];
	}
	if ([target respondsToSelector: prepareToRemoveConnectionSelector]) {
		[target performSelector: prepareToRemoveConnectionSelector withObject: connection];
	}

	[self removeConnection: connection];
}

@end
