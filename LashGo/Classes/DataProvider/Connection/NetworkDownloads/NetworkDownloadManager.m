//
//  NetworkDownloadManager.m
//  DevLib
//
//  Created by Vitaliy Pykhtin on 27.02.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "NetworkDownloadManager.h"

@implementation NetworkDownloadManager

+ (NetworkDownloadManager *) sharedManager {
	static NetworkDownloadManager *networkDownloadManager = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		networkDownloadManager = [[self alloc] init];
	});
	return networkDownloadManager;
}

- (id) init {
	if (self = [super init]) {
		delegatesforContentItem = [[NSMutableDictionary alloc] init];
		_downloadingQueue = [[NSOperationQueue alloc] init];
		_downloadingQueue.name = @"NetworkDownloadManager queue";
	}
	return self;
}

- (void) downloadFilesForObjectInBackground: (id<DownloadableContentProtocol>) objectWithContent {
	NetworkDownloader *downloader = [[NetworkDownloader alloc] initWithDelegate: self
															   objectWithContent: objectWithContent];
	[_downloadingQueue addOperation: downloader];
}

- (void) setDelegate: (id<NetworkDownloadManagerDelegate>) delegate
		   forObject: (id<DownloadableContentProtocol>) objectWithContent {
	delegatesforContentItem[objectWithContent.uid] = delegate;
}

- (void) removeDelegate: (id<NetworkDownloadManagerDelegate>) delegate {
	NSArray *keysToRemove = [delegatesforContentItem allKeysForObject: delegate];
	[delegatesforContentItem removeObjectsForKeys: keysToRemove];
}

#pragma mark - NetworkDownloaderDelegate implementation

- (void) networkDownloaderProcessedForItem: (DownloadedItemInfo *) itemInfo {
	id<NetworkDownloadManagerDelegate> delegate = delegatesforContentItem[itemInfo.downloader.objectWithContent.uid];
	if (delegate != nil && [delegate respondsToSelector: @selector(didDownloadContentForItem:inObject:)] == YES) {
		[delegate didDownloadContentForItem: itemInfo.item inObject: itemInfo.downloader.objectWithContent];
	}
}

- (void) networkDownloaderFinished: (NetworkDownloader *) downloader {
	id<NetworkDownloadManagerDelegate> delegate = delegatesforContentItem[downloader.objectWithContent.uid];
	if (delegate != nil && [delegate respondsToSelector: @selector(didDownloadContentForAllItemsInObject:)] == YES) {
		[delegate didDownloadContentForAllItemsInObject: downloader.objectWithContent];
	}
}

@end
