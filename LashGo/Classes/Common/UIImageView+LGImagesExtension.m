//
//  UIImageView+LGImagesExtension.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 18.09.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "UIImageView+LGImagesExtension.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Common.h"

//#import "objc/runtime.h"
#import <SDWebImage/UIView+WebCacheOperation.h>

#define kWebServiceURLPhotoPath @"http://78.47.39.245:8080/lashgo-api/photos/"

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

- (void) loadWebImageWithName: (NSString *) imageName {
	NSURL *url = [NSURL URLWithString: [kWebServiceURLPhotoPath stringByAppendingString: imageName]];
	[self sd_setImageWithURL: url];
}

- (void) loadWebImageWithSizeThatFitsName: (NSString *) imageName placeholder: (UIImage *) placeholder {
	NSURL *url = nil;
	
	[self sd_cancelCurrentImageLoad];
//    objc_setAssociatedObject(self, &imageURLKey, url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	
    self.image = placeholder;
    
	if (imageName != nil) {
		url = [NSURL URLWithString: [kWebServiceURLPhotoPath stringByAppendingString: imageName]];
	}
    if (url) {
        __weak UIImageView *wself = self;
        id <SDWebImageOperation> operation = [SDWebImageManager.sharedManager downloadImageWithURL:url options: 0 progress: nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (!wself) return;
			UIImage __weak *resizedImage = [Common generateThumbnailForImage: image withSize: self.frame.size];
            dispatch_main_sync_safe(^{
                if (!wself) return;
                if (image) {
                    wself.image = resizedImage;
                    [wself setNeedsLayout];
                }
            });
        }];
        [self sd_setImageLoadOperation:operation forKey:@"UIImageViewImageLoad"];
    }
}

@end
