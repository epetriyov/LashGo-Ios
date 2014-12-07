//
//  UIView+CGExtension.m
//  DevLib
//
//  Created by Vitaliy Pykhtin on 13.05.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "UIView+CGExtension.h"

@implementation UIView (CGExtension)

@dynamic centerX, centerY;

- (CGFloat) centerX {
	return self.center.x;
}

- (void) setCenterX:(CGFloat) value {
	CGPoint center = self.center;
	center.x = value;
	self.center = center;
}

- (CGFloat) centerY {
	return self.center.y;
}

- (void) setCenterY: (CGFloat) value {
	CGPoint center = self.center;
    center.y = value;
    self.center = center;
}

@dynamic frameOrigin;
@dynamic frameSize;

- (CGPoint) frameOrigin {
	return self.frame.origin;
}

- (void) setFrameOrigin:(CGPoint)frameOrigin {
	CGRect frame = self.frame;
    frame.origin = frameOrigin;
    self.frame = frame;
}

- (CGSize) frameSize {
	return self.frame.size;
}

- (void) setFrameSize:(CGSize)frameSize {
	CGRect frame = self.frame;
    frame.size = frameSize;
    self.frame = frame;
}

@dynamic frameX, frameY, frameWidth, frameHeight;

- (CGFloat) frameX {
    return self.frame.origin.x;
}

- (void) setFrameX:(CGFloat) value {
    CGRect frame = self.frame;
    frame.origin.x = value;
    self.frame = frame;
}

- (CGFloat) frameY {
    return self.frame.origin.y;
}

- (void) setFrameY:(CGFloat) value {
    CGRect frame = self.frame;
    frame.origin.y = value;
    self.frame = frame;
}

- (CGFloat) frameWidth {
	return self.frame.size.width;
}

- (void) setFrameWidth:(CGFloat) value {
    CGRect frame = self.frame;
    frame.size.width = value;
    self.frame = frame;
}

- (CGFloat) frameHeight {
	return self.frame.size.height;
}

- (void) setFrameHeight:(CGFloat) value {
    CGRect frame = self.frame;
    frame.size.height = value;
    self.frame = frame;
}

@end
