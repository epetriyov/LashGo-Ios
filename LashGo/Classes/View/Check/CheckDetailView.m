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

@dynamic progressValue;

#pragma mark - Properties

- (CGFloat) progressValue {
	return _arcLayer.strokeEnd;
}

- (void) setProgressValue:(CGFloat)progressValue {
	_arcLayer.strokeEnd = progressValue;
	[_arcLayer setNeedsDisplay];
}

#pragma mark - Standard

- (id)initWithFrame:(CGRect)frame
{
    self = [self initWithFrame:frame imageCaps: 18 progressLineWidth: 10];
    return self;
}

- (instancetype) initWithFrame: (CGRect) frame
					 imageCaps: (CGFloat) imageCaps
			 progressLineWidth: (CGFloat) progressLineWidth {
	if (self = [super initWithFrame: frame]) {
		_imageCaps = imageCaps;
		_progressLineWidth = progressLineWidth;
		
		//Configure image
		NSString *pathForResource = [[NSBundle mainBundle] pathForResource: @"DemoImage" ofType: @"jpg"];
		
		UIImage *image = [[UIImage alloc] initWithContentsOfFile: pathForResource];
		_image = [self generateThumbnailForImage: image];
		
		UIImageView *imageView = [[UIImageView alloc] initWithImage: _image];
		
		CALayer *imageLayer = imageView.layer;
        [imageLayer setCornerRadius: imageView.frame.size.width / 2];
//        [imageLayer setBorderWidth:10];
        [imageLayer setMasksToBounds:YES];
		
		imageView.center = CGPointMake(imageView.center.x + self.imageCaps, imageView.center.y + self.imageCaps);
		[self addSubview: imageView];
		
		//Configure shape layer - which user actually see
		
		CGFloat drawingWidth = MIN(frame.size.width, frame.size.height);
		CGRect drawingFrame = CGRectMake(0, 0, drawingWidth, drawingWidth);
		
		UIBezierPath *path = [UIBezierPath bezierPath];
		
		CGFloat startOffset = 0.06;
		
		[path addArcWithCenter: imageView.center radius: drawingFrame.size.width / 2 - self.progressLineWidth / 2
					startAngle: -M_PI_2 + startOffset endAngle:3 * M_PI_2 + startOffset clockwise: YES];
		_arcLayer=[CAShapeLayer layer];
		_arcLayer.path=path.CGPath;
		_arcLayer.fillColor = [UIColor clearColor].CGColor;
		_arcLayer.strokeColor = [UIColor whiteColor].CGColor;
		_arcLayer.strokeEnd = 0;
		_arcLayer.lineWidth = self.progressLineWidth;
		_arcLayer.lineCap = kCALineCapRound;
		_arcLayer.frame = drawingFrame;
		
		//Configure background for layer
		
		_arcBgLayer = [[CircleGradientLayer alloc] init];
		_arcBgLayer.frame = drawingFrame;
		
//		_arcBgLayer.colors = @[(__bridge id)[UIColor redColor].CGColor,(__bridge id)[UIColor yellowColor].CGColor ];
//		_arcBgLayer.startPoint = CGPointMake(0,0.5);
//		_arcBgLayer.endPoint = CGPointMake(1,0.5);
		_arcBgLayer.mask = _arcLayer;
		
		
		[self.layer addSublayer: _arcBgLayer];
		[_arcBgLayer setNeedsDisplay];
		//Using arc as a mask instead of adding it as a sublayer.
		//[self.view.layer addSublayer:arc];
	}
	return self;
}

//- (void) drawRect:(CGRect)rect {
//	self.progressValue += 0.1;
//	_arcLayer.strokeEnd = self.progressValue;
//	
//}

#pragma mark - Methods

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
	CGFloat imageDiameter = MIN(self.frame.size.width, self.frame.size.height) - self.imageCaps * 2;
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
