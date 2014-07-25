//
//  NetworkDownloader.h
//  DevLib
//
//  Created by Vitaliy Pykhtin on 27.02.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "DownloadableContentProtocol.h"
#import "DownloadableItem.h"

@class NetworkDownloader;

@interface DownloadedItemInfo : NSObject

@property (nonatomic, strong) NetworkDownloader *downloader;
@property (nonatomic, strong) DownloadableItem *item;

@end

@protocol NetworkDownloaderDelegate;

@interface NetworkDownloader : NSOperation

@property (nonatomic, weak) NSObject<NetworkDownloaderDelegate> *delegate;
@property (nonatomic, readonly) NSString *uid;
@property (nonatomic, strong) id<DownloadableContentProtocol> objectWithContent;

- (instancetype) initWithDelegate: (NSObject<NetworkDownloaderDelegate> *) delegate
				objectWithContent: (id<DownloadableContentProtocol>) object;

@end

@protocol NetworkDownloaderDelegate <NSObject>

@required
- (void) networkDownloaderProcessedForItem: (DownloadedItemInfo *) itemInfo;
@optional
- (void) networkDownloaderFinished: (NetworkDownloader *) downloader;

@end
