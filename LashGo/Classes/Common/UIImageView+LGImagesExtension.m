//
//  UIImageView+LGImagesExtension.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 18.09.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "UIImageView+LGImagesExtension.h"
#import "Common.h"

//#import "objc/runtime.h"
#import <SDWebImage/UIView+WebCacheOperation.h>

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

- (void) loadSizeThatFits: (UIImage *) image {
	UIImageView __weak *wself = self;
	UIImage __weak *wimage = image;
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
		UIImage __weak *result = [Common generateThumbnailForImage: wimage withSize: self.frame.size];
		
		dispatch_sync(dispatch_get_main_queue(), ^{
			wself.image = result;
//			[wself setNeedsDisplay];
		});
	});
}

- (void) loadWebImageWithName: (NSString *) imageName {
	NSURL *url = [Common imageLoadingURLForName: imageName];
	[self sd_setImageWithURL: url];
}

- (void) loadWebImageWithName: (NSString *) imageName
			 placeholderImage: (UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock {
	NSURL *url = [Common imageLoadingURLForName: imageName];
	[self sd_setImageWithURL: url placeholderImage: placeholder completed: completedBlock];
}

- (void) loadWebImageWithSizeThatFitsName: (NSString *) imageName placeholder: (UIImage *) placeholder {
	[self loadWebImageWithSizeThatFitsName: imageName placeholder: placeholder shaded: NO];
}

- (void) loadWebImageShadedWithSizeThatFitsName: (NSString *) imageName placeholder: (UIImage *) placeholder {
	[self loadWebImageWithSizeThatFitsName: imageName placeholder: placeholder shaded: YES];
}

- (void) loadWebImageWithSizeThatFitsName: (NSString *) imageName placeholder: (UIImage *) placeholder
										 shaded: (BOOL) shaded {
	NSURL *url = nil;
	
	[self sd_cancelCurrentImageLoad];
	//    objc_setAssociatedObject(self, &imageURLKey, url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	
	self.image = placeholder;
	
	if (imageName != nil) {
		url = [Common imageLoadingURLForName: imageName];
	}
	if (url) {
		__weak UIImageView *wself = self;
		id <SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadImageWithURL:url options: 0 progress: nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
			if (!wself) return;
			
			//Hack, some times imageView.frame inside UITableViewCell is empty, try to get placeholer size instead
			CGSize imageDisplaySize;
			if (CGRectIsEmpty(wself.frame) == NO) {
				imageDisplaySize = wself.frame.size;
			} else {
				imageDisplaySize = wself.image.size;
			}
			UIImage __weak *resizedImage = [Common generateThumbnailForImage: image
																	withSize: imageDisplaySize gradient: shaded];
			dispatch_main_sync_safe(^{
				if (!wself) return;
				if (resizedImage) {
					wself.image = resizedImage;
					[wself setNeedsLayout];
				}
			});
		}];
		[self sd_setImageLoadOperation:operation forKey:@"UIImageViewImageLoad"];
	}
}

- (void) cancelWebImageLoad {
	[self sd_cancelCurrentImageLoad];
}

@end
