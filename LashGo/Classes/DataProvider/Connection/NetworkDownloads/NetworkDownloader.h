//
//  NetworkDownloader.h
//  DevLib
//
//  Created by Vitaliy Pykhtin on 27.02.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "DownloadableContentProtocol.h"
#import "DownloadableItem.h"

@interface DownloadedItemData : NSObject {
	id<DownloadableContentProtocol> objectWithContent;
	DownloadableItem *item;
}

@property (nonatomic, strong) id<DownloadableContentProtocol> objectWithContent;
@property (nonatomic, strong) DownloadableItem *item;

@end

@protocol NetworkDownloaderDelegate;

@interface NetworkDownloader : NSObject  {
	id<NetworkDownloaderDelegate> __weak delegate;
	NSString *uid;
}

@property (nonatomic, weak) id<NetworkDownloaderDelegate> delegate;
@property (nonatomic, readonly) NSString *uid;

- (void) downloadFilesForObjectInBackground: (id<DownloadableContentProtocol>) objectWithContent;

@end

@protocol NetworkDownloaderDelegate <NSObject>

@optional
- (void) networkDownloader: (NetworkDownloader *) downloader didDownloadContentForItem: (DownloadableItem *) objectItem
				  inObject: (id<DownloadableContentProtocol>) objectWithContent;
- (void) networkDownloader: (NetworkDownloader *) downloader didDownloadContentForAllItemsInObject: (id<DownloadableContentProtocol>) objectWithContent;

@end
