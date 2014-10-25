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

- (URLConnection *) connectionWithHost: (NSString *) host
								  path: (NSString *) path
								  type: (URLConnectionType) theType
							   request: (NSMutableURLRequest *) request
								target: (id) target finishSelector: (SEL) finishSelector failSelector: (SEL) failSelector {
	URLConnection *connection = [URLConnection connectionWithHost: host
															 path: path
															 type: theType
														  request: request
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

- (void) performARCSelector: (SEL) selector forTarget: (id) target withConnection: (URLConnection *) connection {
	IMP imp = [target methodForSelector:selector];
	void (*func)(id, SEL, URLConnection *) = (void *)imp;
	func(target, selector, connection);
}

- (void) connectionDidFinish: (URLConnection *) connection {
	id target = targetsForURLConnections[connection.uid];
	SEL selector = NSSelectorFromString(didFinishSelectorsForURLConnections[connection.uid]);
	if ([target respondsToSelector: selector]) {
		[self performARCSelector: selector forTarget: target withConnection: connection];
		
//		[target performSelector: selector withObject: connection];
	}
	if ([target respondsToSelector: prepareToRemoveConnectionSelector]) {
		[self performARCSelector: prepareToRemoveConnectionSelector forTarget: target withConnection: connection];
		
//		[target performSelector: prepareToRemoveConnectionSelector withObject: connection];
	}

	[self removeConnection: connection];
}

- (void) connectionDidFail: (URLConnection *) connection withError: (NSError *) error {
	id target = targetsForURLConnections[connection.uid];
	SEL selector = NSSelectorFromString(didFailSelectorsForURLConnections[connection.uid]);
	if ([target respondsToSelector: selector]) {
		[self performARCSelector: selector forTarget: target withConnection: connection];
		
//		[target performSelector: selector withObject: connection];
	}
	if ([target respondsToSelector: prepareToRemoveConnectionSelector]) {
		[self performARCSelector: prepareToRemoveConnectionSelector forTarget: target withConnection: connection];
		
//		[target performSelector: prepareToRemoveConnectionSelector withObject: connection];
	}

	[self removeConnection: connection];
}

@end
