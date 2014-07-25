//
//  URLSecurity.h
//  SmartKeeper
//
//  Created by Vitaliy Pykhtin on 27.05.14.
//  Copyright (c) 2014 Soft-logic LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(short, SSLValidationMode) {
	SSLValidationModeNone = 0,
	SSLValidationModeCertificate
};

@interface URLSecurity : NSObject

///By default, 'SSLValidationModeNone'
@property (nonatomic, assign) SSLValidationMode sslValidationMode;
///By default, 'NO'
@property (nonatomic, assign) BOOL allowInvalidCertificates;
///By default, 'YES'
@property (nonatomic, assign) BOOL validateFullCertificateChain;
///Certificates in NSData representation
@property (nonatomic, strong) NSArray *allowedCertificates;

/**
 Get all .cer files from current NSBundle directory
 @return Certificates in NSData representation
 */
+ (NSArray *) defaultCertificates;
+ (void) storeCertificatesForServerTrust: (SecTrustRef) serverTrust
								   atPath: (NSString *) path;

- (BOOL) validateServerTrust: (SecTrustRef) serverTrust
					 forHost: (NSString *) host;

@end
