//
//  DownloadableImageItem.h
//  DevLib
//
//  Created by Vitaliy Pykhtin on 27.02.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "DownloadableItem.h"

@interface DownloadableImageItem : DownloadableItem {
	UIImage *image;
}

- (UIImage *) getImage;

@end
