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

@implementation DownloadedItemData

@synthesize objectWithContent, item;

- (void) dealloc {
	[objectWithContent release];
	[item release];
	
	[super dealloc];
}

@end

@implementation NetworkDownloader

@synthesize delegate, uid;

- (id) init {
	if (self = [super init]) {
		uid = [[Common generateUniqueString] retain];
	}
	return self;
}

- (void) dealloc {
	[uid release];
	self.delegate = nil;
	
	[super dealloc];
}

- (void) didDownloadContentForItem: (DownloadedItemData *) objectItem {
	if ([self.delegate respondsToSelector: @selector(networkDownloader:didDownloadContentForItem:inObject:)] == YES) {
		[self.delegate networkDownloader: self didDownloadContentForItem: objectItem.item
								inObject: objectItem.objectWithContent];
	}
}

- (void) didDownloadContentForAllItemsInObject: (id<DownloadableContentProtocol>) objectWithContent {
	if ([self.delegate respondsToSelector: @selector(networkDownloader:didDownloadContentForAllItemsInObject:)] == YES) {
		[self.delegate networkDownloader: self didDownloadContentForAllItemsInObject: objectWithContent];
	}
}

- (void) downloadFilesForObject: (id<DownloadableContentProtocol>) objectWithContent {
	@autoreleasepool {
		for (DownloadableItem *item in objectWithContent.itemsToDownload) {
			NSString *cachesDirectory = [FileManager cachesDirectory];
			NSString *path = [cachesDirectory stringByAppendingPathComponent: item.hash];
			
			if ([Common isEmpty: item.hash] == YES ||
				[FileManager fileExistsAtPath: path] == NO) {
				if ([Common isEmpty: item.url] == NO) {
					NSURL *url = [NSURL URLWithString: item.url];
					NSData *data = [NSData dataWithContentsOfURL: url];
					
					if (data.length > 0) {
						NSString *fileNameToSave = item.hash;
						if ([Common isEmpty: fileNameToSave] == YES) {
							fileNameToSave = data.md5;
							item.hash = fileNameToSave;
						}
						NSString *newPath = [cachesDirectory stringByAppendingPathComponent: fileNameToSave];
						DLog(@"File is downloaded: %@\nmd5: %@", item.url, item.hash);
						
						// Save image to cache folder
						[FileManager createFileAtPath: newPath withData: data];
						item.pathToFile = newPath;
					}
				}
			} else {
				item.pathToFile = path;
			}
			if ([Common isEmpty: item.pathToFile] == NO) {
				DownloadedItemData *itemData = [[[DownloadedItemData alloc] init] autorelease];
				itemData.objectWithContent = objectWithContent;
				itemData.item = item;
				[self performSelectorOnMainThread: @selector(didDownloadContentForItem:)
									   withObject: itemData waitUntilDone: YES];
			}
		}
		
		[self performSelectorOnMainThread: @selector(didDownloadContentForAllItemsInObject:)
							   withObject: objectWithContent waitUntilDone: YES];
	}
}

- (void) downloadFilesForObjectInBackground: (id<DownloadableContentProtocol>) objectWithContent {
	[self performSelectorInBackground: @selector(downloadFilesForObject:) withObject: objectWithContent];
}

@end
