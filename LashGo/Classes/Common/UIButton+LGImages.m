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

#define kWebServiceURLPhotoPath @"http://78.47.39.245:8080/lashgo-api/photos/"

@implementation UIButton (LGImages)

- (void) loadWebImageWithSizeThatFitsName: (NSString *) imageName placeholder: (UIImage *) placeholder {
	NSURL *url = nil;
	
	[self sd_cancelBackgroundImageLoadForState: UIControlStateNormal];
	
    [self setBackgroundImage:placeholder forState: UIControlStateNormal];
	
	if (imageName != nil) {
		url = [NSURL URLWithString: [kWebServiceURLPhotoPath stringByAppendingString: imageName]];
	}
    if (url) {
        __weak UIButton *wself = self;
        id <SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadImageWithURL:url options: 0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (!wself) return;
			UIImage __weak *resizedImage = [Common generateThumbnailForImage: image withSize: self.frame.size];
            dispatch_main_sync_safe(^{
                __strong UIButton *sself = wself;
                if (!sself) return;
                if (image) {
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
		url = [NSURL URLWithString: [kWebServiceURLPhotoPath stringByAppendingString: imageName]];
	}
    if (url) {
        __weak UIButton *wself = self;
        id <SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadImageWithURL:url options: 0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (!wself) return;
			UIImage __weak *resizedImage = [Common generateThumbnailForImage: image
																	withSize: self.frame.size gradient: YES];
            dispatch_main_sync_safe(^{
                __strong UIButton *sself = wself;
                if (!sself) return;
                if (image) {
                    [sself setBackgroundImage:resizedImage forState: UIControlStateNormal];
                }
            });
        }];
        [self sd_setImageLoadOperation:operation forKey:[NSString stringWithFormat:@"UIButtonBackgroundImageOperation%@", @(UIControlStateNormal)]];
    }
}

@end
