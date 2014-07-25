//
//  NetworkDownloader.m
//  DevLib
//
//  Created by Vitaliy Pykhtin on 27.02.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "NetworkDownloader.h"
#import "Common.h"
#import "CryptoUtils.h"
#import "FileManager.h"

@implementation DownloadedItemInfo

@end

@implementation NetworkDownloader

- (id) init {
	if (self = [super init]) {
		_uid = [Common generateUniqueString];
	}
	return self;
}

- (instancetype) initWithDelegate: (id<NetworkDownloaderDelegate>) delegate
				objectWithContent: (id<DownloadableContentProtocol>) object {
	if (self = [self init]) {
		self.delegate = delegate;
		self.objectWithContent = object;
	}
	return self;
}

- (void) main {
	@autoreleasepool {
		for (DownloadableItem *item in self.objectWithContent.itemsToDownload) {
			if (self.isCancelled == YES) {
				return;
			}
			
			NSString *cachesDirectory = [FileManager cachesDirectory];
			NSString *path = [cachesDirectory stringByAppendingPathComponent: item.hash];
			
			if ([Common isEmptyString: item.hash] == YES ||
				[FileManager fileExistsAtPath: path] == NO) {
				if ([Common isEmptyString: item.url] == NO) {
					NSURL *url = [NSURL URLWithString: item.url];
					NSData *data = [NSData dataWithContentsOfURL: url];
					
					if (data.length > 0) {
						NSString *fileNameToSave = item.hash;
						if ([Common isEmptyString: fileNameToSave] == YES) {
							fileNameToSave = data.md5;
							item.hash = fileNameToSave;
						}
						NSString *newPath = [cachesDirectory stringByAppendingPathComponent: fileNameToSave];
						DLog(@"File is downloaded: %@\n md5: %@\n fromThread: %@", item.url, item.hash, [NSThread currentThread].name);
						
						// Save image to cache folder
						[FileManager createFileAtPath: newPath withData: data];
						item.pathToFile = newPath;
					}
				}
			} else {
				item.pathToFile = path;
			}
			if ([Common isEmptyString: item.pathToFile] == NO) {
				DownloadedItemInfo *itemInfo = [[DownloadedItemInfo alloc] init];
				itemInfo.downloader = self;
				itemInfo.item = item;
				[self.delegate performSelectorOnMainThread: @selector(networkDownloaderProcessedForItem:)
												withObject: itemInfo waitUntilDone: YES];
			}
		}
		
		if ([self.delegate respondsToSelector: @selector(networkDownloaderFinished:)] == YES) {
			[self.delegate performSelectorOnMainThread: @selector(networkDownloaderFinished:)
											withObject: self waitUntilDone: YES];
		}
	}
}

@end
