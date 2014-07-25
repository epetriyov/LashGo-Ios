//
//  URLSecurity.m
//  SmartKeeper
//
//  Created by Vitaliy Pykhtin on 27.05.14.
//  Copyright (c) 2014 Soft-logic LLC. All rights reserved.
//

#import "URLSecurity.h"

@implementation URLSecurity

- (instancetype) init {
	if (self = [super init]) {
		_validateFullCertificateChain = YES;
	}
	return self;
}

#pragma mark -

+ (NSArray *) defaultCertificates {
	NSBundle *bundle = [NSBundle bundleForClass: [self class]];
	NSArray *paths = [bundle pathsForResourcesOfType:@"cer" inDirectory:@"."];
	
	NSMutableArray *certificates = [NSMutableArray arrayWithCapacity:[paths count]];
	for (NSString *path in paths) {
		NSData *certificateData = [[NSData alloc] initWithContentsOfFile: path];
		[certificates addObject:certificateData];
	}
	
    return [[NSArray alloc] initWithArray: certificates copyItems: NO];
}

Boolean SecTrustIsValid(SecTrustRef serverTrust) {
    Boolean isValid = FALSE;
    SecTrustResultType result;
	if (SecTrustEvaluate(serverTrust, &result) == errSecSuccess) {
		isValid = (result == kSecTrustResultUnspecified || result == kSecTrustResultProceed);
	}
	
    return isValid;
}

CFMutableArrayRef SecCertificateTrustChainCreateForServerTrust(SecTrustRef serverTrust) {
    CFIndex certificatesCount = SecTrustGetCertificateCount(serverTrust);
	CFMutableArrayRef certificates = CFArrayCreateMutable(kCFAllocatorDefault, certificatesCount, &kCFTypeArrayCallBacks);
	//Copy the certificates from the original trust object
	for (CFIndex i = 0; i < certificatesCount; i++) {
		SecCertificateRef item = SecTrustGetCertificateAtIndex(serverTrust, i);
		CFArrayAppendValue(certificates, item);
	}
	
    return certificates;
}

+ (NSArray*) secCertificatesChainDataForServerTrust: (SecTrustRef) serverTrust {
    CFIndex certificatesCount = SecTrustGetCertificateCount(serverTrust);
	NSMutableArray *certificates = [[NSMutableArray alloc] initWithCapacity: certificatesCount];
	//Copy the certificates from the original trust object
	for (CFIndex i = 0; i < certificatesCount; ++i) {
		SecCertificateRef item = SecTrustGetCertificateAtIndex(serverTrust, i);
		CFDataRef itemData = SecCertificateCopyData(item);
		[certificates addObject: (__bridge NSData*)itemData];
		CFRelease(itemData);
	}
	
    return certificates;
}

SecTrustRef SecTrustGetForHost(SecTrustRef trust, CFStringRef host) {
	SecPolicyRef policy = SecPolicyCreateSSL(true, host);
	
	CFMutableArrayRef policies = CFArrayCreateMutable(kCFAllocatorDefault, 1, &kCFTypeArrayCallBacks);
	CFArrayAppendValue(policies, policy);
	CFRelease(policy);
	
	SecTrustRef resultTrust = NULL;
	
	if (floor(NSFoundationVersionNumber) >= NSFoundationVersionNumber_iOS_6_0) {
		SecTrustSetPolicies(trust, policies);
		resultTrust = trust;
	} else {
		CFMutableArrayRef certificates = SecCertificateTrustChainCreateForServerTrust(trust);
		
		//Create a new trust object
		
		if (SecTrustCreateWithCertificates(certificates, policies, &resultTrust) != errSecSuccess) {
			NSLog(@"Unable to create setificates with SSL policy for host: %@", host);
			
			resultTrust = NULL;
		}
		CFRelease(certificates);
	}
	
	CFRelease(policies);
	
	return resultTrust;
}

+ (void) storeCertificatesForServerTrust: (SecTrustRef) serverTrust
								   atPath: (NSString *) path {
	NSArray *certificates = [URLSecurity secCertificatesChainDataForServerTrust: serverTrust];

	for (NSUInteger i = 0; i < [certificates count]; ++i) {
		NSError *error;
		BOOL result = [certificates[i] writeToFile: [path stringByAppendingPathComponent: [NSString stringWithFormat: @"%ld.cer", (unsigned long)i]]
										   options: NSDataWritingFileProtectionNone error: &error];
		if (result == NO) {
			NSLog(@"Unable to store certificate: %@", error);
		}
	}
}

- (BOOL) validateServerTrust: (SecTrustRef) serverTrust
					 forHost: (NSString *) host {
	SecTrustRef trust = SecTrustGetForHost(serverTrust, (__bridge CFStringRef)host);
	
	BOOL validationResult;
	
    if (SecTrustIsValid(trust) == FALSE && self.allowInvalidCertificates == NO) {
        validationResult = NO;
    } else {
		switch (self.sslValidationMode) {
			case SSLValidationModeNone:
				validationResult = YES;
				break;
			case SSLValidationModeCertificate: {
				//Convert certificates from NSData to SecCertificateRef
				CFMutableArrayRef certificates = CFArrayCreateMutable(kCFAllocatorDefault, [self.allowedCertificates count], &kCFTypeArrayCallBacks);
				for (NSData *certificateData in self.allowedCertificates) {
					CFArrayAppendValue(certificates, SecCertificateCreateWithData(NULL, (__bridge CFDataRef)certificateData));
				}
				SecTrustSetAnchorCertificates(trust, certificates);
				CFRelease(certificates);
				
				if (SecTrustIsValid(trust) == NO) {
					validationResult = NO;
					break;
				}
				if (self.validateFullCertificateChain == NO) {
					validationResult = YES;
					break;
				}
				
				NSArray *serverCertificates = [URLSecurity secCertificatesChainDataForServerTrust: trust];
				
				NSUInteger trustedCertificateCount = 0;
				for (NSData *chainCertificate in serverCertificates) {
					if ([self.allowedCertificates containsObject:chainCertificate]) {
						trustedCertificateCount++;
					}
				}
				
				validationResult = trustedCertificateCount == [serverCertificates count];
				break;
			}
		}
	}
	
	if (floor(NSFoundationVersionNumber) < NSFoundationVersionNumber_iOS_6_0) {
		CFRelease(trust);
	}
    
    return validationResult;
}

@end
