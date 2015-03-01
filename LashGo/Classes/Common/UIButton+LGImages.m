//
//  UIButton+LGImages.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 20.10.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "UIButton+LGImages.h"
#import "Common.h"

#import <SDWebImage/UIView+WebCacheOperation.h>

@implementation UIButton (LGImages)

- (void) loadWebImageWithSizeThatFitsName: (NSString *) imageName placeholder: (UIImage *) placeholder {
	NSURL *url = nil;
	
	[self sd_cancelBackgroundImageLoadForState: UIControlStateNormal];
	
    [self setBackgroundImage:placeholder forState: UIControlStateNormal];
	
	if (imageName != nil) {
		url = [Common imageLoadingURLForName: imageName];
	}
    if (url) {
        __weak UIButton *wself = self;
        id <SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadImageWithURL:url options: 0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (!wself) return;
			UIImage __weak *resizedImage = [Common generateThumbnailForImage: image withSize: wself.frame.size];
            dispatch_main_sync_safe(^{
                __strong UIButton *sself = wself;
                if (!sself) return;
                if (resizedImage) {
                    [sself setBackgroundImage:resizedImage forState: UIControlStateNormal];
                }
            });
        }];
        [self sd_setImageLoadOperation:operation forKey:[NSString stringWithFormat:@"UIButtonBackgroundImageOperation%@", @(UIControlStateNormal)]];
    }
}

- (void) loadWebImageShadedWithSizeThatFitsName: (NSString *) imageName placeholder: (UIImage *) placeholder {
	NSURL *url = nil;
	
	[self sd_cancelBackgroundImageLoadForState: UIControlStateNormal];
	
    [self setBackgroundImage:placeholder forState: UIControlStateNormal];
	
	if (imageName != nil) {
		url = [Common imageLoadingURLForName: imageName];
	}
    if (url) {
        __weak UIButton *wself = self;
        id <SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadImageWithURL:url options: 0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (!wself) return;
			UIImage __weak *resizedImage = [Common generateThumbnailForImage: image
																	withSize: wself.frame.size gradient: YES];
            dispatch_main_sync_safe(^{
                __strong UIButton *sself = wself;
                if (!sself) return;
                if (resizedImage) {
                    [sself setBackgroundImage:resizedImage forState: UIControlStateNormal];
                }
            });
        }];
        [self sd_setImageLoadOperation:operation forKey:[NSString stringWithFormat:@"UIButtonBackgroundImageOperation%@", @(UIControlStateNormal)]];
    }
}

@end
