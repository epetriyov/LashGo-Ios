//
//  DownloadableItem.h
//  DevLib
//
//  Created by Vitaliy Pykhtin on 27.02.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadableItem : NSObject {
	NSString *url;
	NSString *hash;
	NSString *pathToFile;
}

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *hash;
@property (nonatomic, strong) NSString *pathToFile;

- (NSData *) getStoredData;

@end
