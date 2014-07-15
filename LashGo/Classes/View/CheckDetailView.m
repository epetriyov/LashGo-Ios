//
//  CheckDetailView.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 08.07.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "CheckDetailView.h"
#import "ViewFactory.h"

@implementation CheckDetailView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		NSString *pathForResource = [[NSBundle mainBundle] pathForResource: @"DemoImage" ofType: @"jpg"];
		UIImage *image = [UIImage imageWithContentsOfFile: pathForResource];
		_image = [self generateThumbnailForImage: image];
		
		UIImageView *imageView = [[UIImageView alloc] initWithImage: _image];
		
		CALayer *imageLayer = imageView.layer;
        [imageLayer setCornerRadius: imageView.frame.size.width / 2];
//        [imageLayer setBorderWidth:10];
        [imageLayer setMasksToBounds:YES];
		
		[self addSubview: imageView];
		
		UIBezierPath *path=[UIBezierPath bezierPath];
		
		[path addArcWithCenter: imageView.center radius: imageView.frame.size.width / 2 startAngle: -M_PI_2 endAngle:3 * M_PI_2 clockwise: YES];
		_arcLayer=[CAShapeLayer layer];
		_arcLayer.path=path.CGPath;
		_arcLayer.fillColor = [UIColor clearColor].CGColor;
		_arcLayer.strokeColor=[UIColor colorWithRed: 0.5 green: 0 blue: 0 alpha: 1].CGColor;
		_arcLayer.strokeEnd = 0;
		_arcLayer.lineWidth=15;
		_arcLayer.lineCap = kCALineCapRound;
		_arcLayer.frame = imageView.frame;
//		[self.layer addSublayer: _arcLayer];
		[self performSelector: @selector(drawLineAnimation:) withObject: _arcLayer afterDelay: 3];
//		[self drawLineAnimation: _arcLayer];
    }
    return self;
}

-(void)drawLineAnimation:(CALayer*)layer
{
    CABasicAnimation *bas=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    bas.duration=5;
    bas.delegate=self;
    bas.fromValue=[NSNumber numberWithInteger:0];
    bas.toValue=[NSNumber numberWithInteger:1];
	bas.removedOnCompletion = NO;
	bas.repeatCount = 5;
    [layer addAnimation:bas forKey:@"key"];
	
	CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = layer.frame;
    gradientLayer.colors = @[(__bridge id)[UIColor redColor].CGColor,(__bridge id)[UIColor yellowColor].CGColor ];
    gradientLayer.startPoint = CGPointMake(0,0.5);
    gradientLayer.endPoint = CGPointMake(1,0.5);
	
    [self.layer addSublayer:gradientLayer];
	//Using arc as a mask instead of adding it as a sublayer.
	//[self.view.layer addSublayer:arc];
	gradientLayer.mask = layer;
}

- (UIImage *) squareImageFromImage: (UIImage *) image {
    UIImage *squareImage = nil;
    CGSize imageSize = [image size];
    
    if (imageSize.width == imageSize.height) {
        squareImage = image;
    } else {
        // Compute square crop rect
        CGFloat smallerDimension = MIN(imageSize.width, imageSize.height);
        CGRect cropRect = CGRectMake(0, 0, smallerDimension, smallerDimension);
        
        // Center the crop rect either vertically or horizontally, depending on which dimension is smaller
        if (imageSize.width <= imageSize.height) {
            cropRect.origin = CGPointMake(0, rintf((imageSize.height - smallerDimension) / 2.0));
        } else {
            cropRect.origin = CGPointMake(rintf((imageSize.width - smallerDimension) / 2.0), 0);
        }
        
        CGImageRef croppedImageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
        squareImage = [UIImage imageWithCGImage:croppedImageRef scale: image.scale orientation: UIImageOrientationUp];
        CGImageRelease(croppedImageRef);
    }
    
    return squareImage;
}

- (UIImage *) generateThumbnailForImage: (UIImage *) image {
	CGFloat screenScale = [[UIScreen mainScreen] scale];
	CGFloat imageDiameter = MIN(self.frame.size.width, self.frame.size.height) * screenScale;
	CGRect contextBounds = CGRectZero;
	contextBounds.size = CGSizeMake(imageDiameter, imageDiameter);
	
	UIImage *sourceImage = image;
	UIImage *squareImage = [self squareImageFromImage: sourceImage];
	
	UIGraphicsBeginImageContext(contextBounds.size);
	
	[squareImage drawInRect:contextBounds];
	UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	return scaledImage;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
