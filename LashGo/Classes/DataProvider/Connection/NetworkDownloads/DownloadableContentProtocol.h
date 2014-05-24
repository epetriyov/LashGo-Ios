//
//  DownloadableContentProtocol.h
//  DevLib
//
//  Created by Vitaliy Pykhtin on 27.02.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DownloadableContentProtocol <NSObject>

@property (nonatomic, readonly) NSString *uid;
@property (nonatomic, readonly) NSArray *itemsToDownload;

@end
