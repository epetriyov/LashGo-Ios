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

@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *hash;
@property (nonatomic, retain) NSString *pathToFile;

- (NSData *) getStoredData;

@end
