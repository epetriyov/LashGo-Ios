//
//  DownloadableItem.m
//  DevLib
//
//  Created by Vitaliy Pykhtin on 27.02.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "DownloadableItem.h"

@implementation DownloadableItem

@synthesize url, hash, pathToFile;

- (void) dealloc {
	[url release];
	[hash release];
	
	[super dealloc];
}

- (NSData *) getStoredData {
	NSData *data = [NSData dataWithContentsOfFile: self.pathToFile];
	return data;
}

@end
