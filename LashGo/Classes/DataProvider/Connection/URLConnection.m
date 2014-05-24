#import "URLConnection.h"
#import "Common.h"

@implementation URLConnection

@synthesize delegate, status, uid, urlPath, type, request, response, error, downloadedData, context;

#pragma mark - Standard overrides

- (id) init {
	if (self = [super init]) {
		queue = nil;
		
		uid = [[Common generateUniqueString] retain];
		
		status = URLConnectionStatusInitialized;
	}
	return self;
}

- (void) dealloc {
	[queue release];
	[uid release];
	[urlPath release];
	[request release];
	[connection release];
	
	[response release];
	[error release];
	
	[downloadedData release];
	
	self.context = nil;
	
	[super dealloc];
}

#pragma mark - Methods

+ (URLConnection *) connectionWithHost: (NSString *) host
								  path: (NSString *) path
								  type: (URLConnectionType) theType
						   queryParams: (NSDictionary *) queryParams
						  headerParams: (NSDictionary *) headerParams
								  body: (NSDictionary *) bodyJSON
							  delegate: (id<URLConnectionDelegate>) theDelegate {
	URLConnection *urlConnection = [[[URLConnection alloc] init] autorelease];
	urlConnection -> urlPath = [path copy];
	urlConnection -> type = theType;
	urlConnection -> request = [[NSMutableURLRequest requestWithURL: [host stringByAppendingString: path]
															   type: theType
														  getParams: queryParams
														 postParams: nil
													   headerParams: headerParams] retain];
	
	if ((theType == URLConnectionTypePOST || theType == URLConnectionTypePUT) &&
		[NSJSONSerialization isValidJSONObject: bodyJSON] == YES) {
		[urlConnection -> request setValue: [NSString stringWithFormat: @"application/json"]
						forHTTPHeaderField: @"Content-Type"];
		[urlConnection -> request setHTTPBody: [NSJSONSerialization dataWithJSONObject: bodyJSON
																			   options: 0 error: nil]];
	}
	urlConnection.delegate = theDelegate;
	
	return urlConnection;
}

- (void) addValue: (NSString *) value forQueryParameter: (NSString *) name {
	[request addValue: value forQueryParameter: name];
}

- (void) startAsync {
	status = URLConnectionStatusStarted;
	connection = [ [NSURLConnection alloc] initWithRequest: request delegate: self startImmediately: NO];
	
	if ([NSThread currentThread].isMainThread == NO) {
		//Only for BG calls, to get main thread callbacks on mainThread
		queue = [[NSOperationQueue alloc] init];
		[connection setDelegateQueue: queue];
	}
	
	[connection performSelectorOnMainThread: @selector(start) withObject: nil waitUntilDone: YES];
	DLog(@"%@\n%@\n%@", request, [request allHTTPHeaderFields], [NSString stringWithData: [request HTTPBody]]);
}

- (void) startSync {
	DLog(@"%@\n%@\n%@", request, [request allHTTPHeaderFields], [NSString stringWithData: [request HTTPBody]]);
	
	[downloadedData release];
	[error release];
	[response release];
	
	status = URLConnectionStatusStarted;
	downloadedData = (NSMutableData *) [NSURLConnection sendSynchronousRequest: request returningResponse: &response error: &error];
	[downloadedData retain];
	[error retain];
	[response retain];
	
	if (error == nil) {
		if ([delegate respondsToSelector: @selector(connectionDidFinish:)]) {
			[delegate performSelector: @selector(connectionDidFinish:) withObject: self];
		}
	} else {
		if ([delegate respondsToSelector: @selector(connectionDidFail:withError:)]) {
			[delegate performSelector: @selector(connectionDidFail:withError:) withObject: self withObject: error];
		}
	}
}

#pragma mark - NSURLConnectionDataDelegate implementations

- (void) connection: (NSURLConnection *) theConnection didReceiveResponse: (NSHTTPURLResponse *) theResponse {
	response = [theResponse retain];
	NSUInteger estimatedDownloadDataSize = (NSUInteger)MIN(NSUIntegerMax, MAX(0, [response expectedContentLength]));
	[downloadedData release];
	downloadedData = [ [NSMutableData alloc] initWithCapacity: estimatedDownloadDataSize];
}

- (void) connection: (NSURLConnection *) theConnection didReceiveData: (NSData *) data {
	[downloadedData appendData: data];
}

- (void) connectionDidFinishLoading: (NSURLConnection *) theConnection {
	status = URLConnectionStatusFinished;
	
	if (response.statusCode == 200) {
		if ([delegate respondsToSelector: @selector(connectionDidFinish:)]) {
			[delegate performSelector: @selector(connectionDidFinish:) withObject: self];
		}
	} else {
		if ([delegate respondsToSelector: @selector(connectionDidFail:withError:)]) {
			[delegate performSelector: @selector(connectionDidFail:withError:) withObject: self withObject: error];
		}
	}
}

- (void)connection:(NSURLConnection *) theConnection didFailWithError:(NSError *) theError {
	status = URLConnectionStatusFinished;
	[error release];
	error = [theError retain];
	if ([delegate respondsToSelector: @selector(connectionDidFail:withError:)]) {
		[delegate performSelector: @selector(connectionDidFail:withError:) withObject: self withObject: error];
	}
}

#pragma mark - Authentication

-(BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
		[challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
	}
    
    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}

@end
