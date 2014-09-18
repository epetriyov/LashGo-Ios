//
//  UIImageView+LGImagesExtension.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 18.09.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "UIImageView+LGImagesExtension.h"
#import "Common.h"

@implementation UIImageView (LGImagesExtension)

- (void) loadLocalImageWithName: (NSString *) ImageName {
	UIImageView __weak *wself = self;
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
		NSString *pathForResource = [[NSBundle mainBundle] pathForResource: @"DemoImage" ofType: @"jpg"];
		
		UIImage *image = [[UIImage alloc] initWithContentsOfFile: pathForResource];
		UIImage __weak *result = [Common generateThumbnailForImage: image withSize: CGSizeMake(168, 168) ];
		
		dispatch_sync(dispatch_get_main_queue(), ^{
			wself.image = result;
			[wself setNeedsDisplay];
		});
	});
}

@end
