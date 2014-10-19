//
//  UIImageView+LGImagesExtension.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 18.09.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import <SDWebImage/UIImageView+WebCache.h>

@interface UIImageView (LGImagesExtension)

- (void) loadLocalImageWithName: (NSString *) ImageName;

- (void) loadWebImageWithName: (NSString *) imageName;
- (void) loadWebImageWithName: (NSString *) imageName
			 placeholderImage: (UIImage *)placeholder completed:(SDWebImageCompletionBlock)completedBlock;
- (void) loadWebImageWithSizeThatFitsName: (NSString *) imageName placeholder: (UIImage *) placeholder;

- (void) cancelWebImageLoad;

@end
