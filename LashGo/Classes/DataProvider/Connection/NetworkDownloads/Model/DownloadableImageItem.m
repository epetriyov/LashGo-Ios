//
//  DownloadableImageItem.m
//  DevLib
//
//  Created by Vitaliy Pykhtin on 27.02.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "DownloadableImageItem.h"

@implementation DownloadableImageItem


- (UIImage *) getImage {
	if (image == nil) {
		NSData *storedData = [self getStoredData];
		if (storedData != nil) {
			UIImage *unscaledImage = [[UIImage alloc] initWithData: storedData];
			image = [[UIImage alloc] initWithCGImage: unscaledImage.CGImage scale: [UIScreen mainScreen].scale
										 orientation: UIImageOrientationUp];
		}
	}
	return image;
}

@end
