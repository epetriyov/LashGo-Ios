//
//  NetworkDownloadManager.h
//  DevLib
//
//  Created by Vitaliy Pykhtin on 27.02.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "NetworkDownloader.h"

@protocol NetworkDownloadManagerDelegate;

@interface NetworkDownloadManager : NSObject <NetworkDownloaderDelegate> {
	NSMutableDictionary *delegatesforContentItem;
}

@property (nonatomic, readonly) NSOperationQueue *downloadingQueue;

+ (NetworkDownloadManager *) sharedManager;

- (void) downloadFilesForObjectInBackground: (id<DownloadableContentProtocol>) objectWithContent;

- (void) setDelegate: (id<NetworkDownloadManagerDelegate>) delegate
		   forObject: (id<DownloadableContentProtocol>) objectWithContent;
- (void) removeDelegate: (id<NetworkDownloadManagerDelegate>) delegate;

@end

@protocol NetworkDownloadManagerDelegate <NSObject>

@optional
- (void) didDownloadContentForItem: (DownloadableItem *) objectItem inObject: (id<DownloadableContentProtocol>) objectWithContent;
- (void) didDownloadContentForAllItemsInObject: (id<DownloadableContentProtocol>) objectWithContent;

@end
