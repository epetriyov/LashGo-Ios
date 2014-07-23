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
		
		UIImage *image = [[UIImage alloc] initWithContentsOfFile: pathForResource];
		_image = [self generateThumbnailForImage: image];
		
		UIImageView *imageView = [[UIImageView alloc] initWithImage: _image];
		
		CALayer *imageLayer = imageView.layer;
        [imageLayer setCornerRadius: imageView.frame.size.width / 2];
//        [imageLayer setBorderWidth:10];
        [imageLayer setMasksToBounds:YES];
		
		[self addSubview: imageView];
		
//		UIBezierPath *path=[UIBezierPath bezierPath];
//		
//		[path addArcWithCenter: imageView.center radius: imageView.frame.size.width / 2 startAngle: -M_PI_2 endAngle:3 * M_PI_2 clockwise: YES];
//		_arcLayer=[CAShapeLayer layer];
//		_arcLayer.path=path.CGPath;
//		_arcLayer.fillColor = [UIColor clearColor].CGColor;
//		_arcLayer.strokeColor=[UIColor colorWithRed: 0.5 green: 0 blue: 0 alpha: 1].CGColor;
//		_arcLayer.strokeEnd = 0;
//		_arcLayer.lineWidth=15;
//		_arcLayer.lineCap = kCALineCapRound;
//		_arcLayer.frame = imageView.frame;
//		
//		NSLog(@"%f %f %f %f", _arcLayer.frame.origin.x, _arcLayer.frame.origin.y, _arcLayer.frame.size.width, _arcLayer.frame.size.height);
//		
//		_gradientLayer = [[CircleGradientLayer alloc] init];
//		_gradientLayer.frame = _arcLayer.frame;
//		
//		NSLog(@"%f %f %f %f", _gradientLayer.frame.origin.x, _gradientLayer.frame.origin.y, _gradientLayer.frame.size.width, _gradientLayer.frame.size.height);
////		_gradientLayer.colors = @[(__bridge id)[UIColor redColor].CGColor,(__bridge id)[UIColor yellowColor].CGColor ];
////		_gradientLayer.startPoint = CGPointMake(0,0.5);
////		_gradientLayer.endPoint = CGPointMake(1,0.5);
////		_gradientLayer.mask = _arcLayer;
//		
//		[self.layer addSublayer: _gradientLayer];
//		[_gradientLayer setNeedsDisplay];
//		//Using arc as a mask instead of adding it as a sublayer.
//		//[self.view.layer addSublayer:arc];
//		
//		
//		[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setNeedsDisplay) userInfo:nil repeats:YES];
////		[self performSelector: @selector(setNeedsDisplay) withObject: nil afterDelay: 3];
    }
    return self;
}

- (void) drawRect:(CGRect)rect {
	_arcLayer.strokeEnd += 0.1;
	
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
//	// Create path.
//	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//	NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Image.png"];
//
//	// Save image.
//	[UIImagePNGRepresentation(squareImage) writeToFile:filePath atomically:YES];
//
//	UIImage *storedImage = [UIImage imageWithContentsOfFile: filePath];
    }
    
    return squareImage;
}

- (UIImage *) generateThumbnailForImage: (UIImage *) image {
	CGFloat imageDiameter = MIN(self.frame.size.width, self.frame.size.height);
	CGRect contextBounds = CGRectZero;
	contextBounds.size = CGSizeMake(imageDiameter, imageDiameter);
	
	UIImage *sourceImage = image;
	UIImage *squareImage = [self squareImageFromImage: sourceImage];
	
	UIGraphicsBeginImageContextWithOptions(contextBounds.size, YES, 0.0);
	
	[squareImage drawInRect:contextBounds];
	UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
//	//Should be stored with scale == 1 for correct image dpi settings
//	UIImage *imageToStore = [UIImage imageWithCGImage: scaledImage.CGImage
//												scale: 1
//										  orientation: UIImageOrientationUp];
	
	UIGraphicsEndImageContext();
	
//	// Create path.
//	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//	NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Image@2x.png"];
//	
//	// Save image.
//	[UIImagePNGRepresentation(imageToStore) writeToFile:filePath atomically:YES];
//	
//	UIImage *storedImage = [UIImage imageWithContentsOfFile: filePath];
	
	return scaledImage;
}

@end
