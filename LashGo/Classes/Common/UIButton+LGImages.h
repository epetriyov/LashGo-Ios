//
//  UIButton+LGImages.h
//  LashGo
//
//  Created by Vitaliy Pykhtin on 20.10.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import <SDWebImage/UIButton+WebCache.h>

@interface UIButton (LGImages)

- (void) loadWebImageWithSizeThatFitsName: (NSString *) imageName placeholder: (UIImage *) placeholder;
- (void) loadWebImageShadedWithSizeThatFitsName: (NSString *) imageName placeholder: (UIImage *) placeholder;

@end
