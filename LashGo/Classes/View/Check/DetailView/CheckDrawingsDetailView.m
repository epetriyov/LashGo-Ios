//
//  CheckDrawingsDetailView.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 17.09.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "CheckDrawingsDetailView.h"
#import "CircleGradientLayer.h"

#define kAnimationDuration 0.4

@interface CheckDrawingsDetailView () {
	CAShapeLayer *_arcLayer;
	CALayer *_arcBgLayer;
	CAShapeLayer *_arcFillLayer;
	CAShapeLayer *_emptyTimelineLayer;
	
	UIView *_drawingView;
}

@end

@implementation CheckDrawingsDetailView

#pragma mark - Properties

- (void) setDisplayPreview:(BOOL)displayPreview {
	if (_displayPreview != displayPreview) {
		if (displayPreview == YES) {
			[UIView animateWithDuration: kAnimationDuration
							 animations:^{
								 _drawingView.alpha = 0;
							 }];
		} else {
			[UIView animateWithDuration: kAnimationDuration
							 animations:^{
								 _drawingView.alpha = 1;
							 }];
		}
	}
	
	_displayPreview = displayPreview;
}

- (void) setProgressValue:(CGFloat)progressValue {
	_progressValue = progressValue > 1.0 ? 1.0 : progressValue;
	_progressValue = _progressValue < 0.0 ? 0.0 : _progressValue;
	if (self.type == CheckDetailTypeOpen) {
		_arcLayer.strokeEnd = _progressValue;
	} else if (self.type == CheckDetailTypeVote) {
		_arcFillLayer.strokeEnd = _progressValue;
	}
}

//Turned off cell should refresh view manually
//- (void) setType:(CheckDetailType)type {
//	if (_type != type) {
//		_type = type;
//		[self refresh];
//	}
//}

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
		_type = CheckDetailTypeClosed;
		
		//Configure shape layer - which user actually see
		
		CGFloat drawingWidth = MIN(frame.size.width, frame.size.height);
		CGRect drawingFrame = CGRectMake(0, 0, drawingWidth, drawingWidth);
		CGFloat drawingRadius = drawingFrame.size.width / 2 - self.progressLineWidth / 2;
		
		_drawingView = [[UIView alloc] initWithFrame: drawingFrame];
		[self addSubview: _drawingView];
		
		UIBezierPath *emptyTimelinePath = [UIBezierPath bezierPathWithArcCenter: _drawingView.center
																		 radius: drawingRadius
																	 startAngle: -M_PI_2 endAngle: 3 * M_PI_2
																	  clockwise: YES];
		CAShapeLayer *emptyTimelineLayer = [[CAShapeLayer alloc] init];
		emptyTimelineLayer.frame = drawingFrame;
		emptyTimelineLayer.path = emptyTimelinePath.CGPath;
		emptyTimelineLayer.fillColor = [UIColor clearColor].CGColor;
		//		emptyTimelineLayer.strokeColor = [UIColor colorWithWhite: 1.0 alpha: 38.0/255.0].CGColor;
		emptyTimelineLayer.lineWidth = self.progressLineWidth;
		[_drawingView.layer addSublayer: emptyTimelineLayer];
		_emptyTimelineLayer = emptyTimelineLayer;
		
//		//Configure background for layer
//
//		_arcBgLayer = [[CircleGradientLayer alloc] init];
//		_arcBgLayer.frame = drawingFrame;
//
////		_arcBgLayer.colors = @[(__bridge id)[UIColor redColor].CGColor,(__bridge id)[UIColor yellowColor].CGColor ];
////		_arcBgLayer.startPoint = CGPointMake(0,0.5);
////		_arcBgLayer.endPoint = CGPointMake(1,0.5);
//		_arcBgLayer.mask = _arcLayer;
//
//
//		[self.layer addSublayer: _arcBgLayer];
//		[_arcBgLayer setNeedsDisplay];
		
		[self refresh];
	}
	return self;
}

//- (void) drawRect:(CGRect)rect {
//	self.progressValue += 0.1;
//	_arcLayer.strokeEnd = self.progressValue;
//
//}

#pragma mark - Methods

//- (void) animateFadeIn {
//	CABasicAnimation *bas=[CABasicAnimation animationWithKeyPath:@"opacity"];
//	bas.duration = 0.5;
//	bas.delegate=self;
//	bas.fillMode = kCAFillModeForwards;
//	bas.fromValue = [NSNumber numberWithInteger:0];
//	bas.toValue = [NSNumber numberWithInteger:1];
//	bas.removedOnCompletion = NO;
////		bas.additive = YES;
//	[_arcBgLayer addAnimation:bas forKey:@"fadeIn"];
//}
//
//- (void) animateFadeOut {
//	CABasicAnimation *bas=[CABasicAnimation animationWithKeyPath:@"opacity"];
//	bas.duration = 0.5;
//	bas.delegate=self;
//	bas.fillMode = kCAFillModeForwards;
//	bas.fromValue=[NSNumber numberWithInteger:1];
//	bas.toValue=[NSNumber numberWithInteger:0];
//	bas.removedOnCompletion = NO;
////		bas.additive = YES;
//	[_arcBgLayer addAnimation:bas forKey:@"fadeOut"];
//}

- (void) refresh {
	if (self.type == CheckDetailTypeOpen) {
		_emptyTimelineLayer.strokeColor = [UIColor colorWithWhite: 1.0 alpha: 38.0/255.0].CGColor;
		
		if (_arcLayer == nil) {
			CGFloat startOffset = 0.06;
			
			UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter: _drawingView.center
																radius: _drawingView.frame.size.width / 2 - self.progressLineWidth / 2
															startAngle: 3 * M_PI_2 - startOffset
															  endAngle: -M_PI_2 - startOffset clockwise: NO];
			_arcLayer=[CAShapeLayer layer];
			_arcLayer.path=path.CGPath;
			_arcLayer.fillColor = [UIColor clearColor].CGColor;
			_arcLayer.strokeColor = [UIColor whiteColor].CGColor;
			_arcLayer.strokeEnd = self.progressValue;
			_arcLayer.lineWidth = self.progressLineWidth;
			_arcLayer.lineCap = kCALineCapRound;
			_arcLayer.frame = _drawingView.bounds;
		}
		
		//Configure background for layer
		if (_arcBgLayer == nil) {
			_arcBgLayer = [[CircleGradientLayer alloc] init];
			_arcBgLayer.frame = _drawingView.bounds;
			_arcBgLayer.mask = _arcLayer;
			
			[_drawingView.layer addSublayer: _arcBgLayer];
			[_arcBgLayer setNeedsDisplay];
		}
		
		_arcBgLayer.hidden = NO;
		_arcFillLayer.hidden = YES;
	} else if (self.type == CheckDetailTypeVote) {
		//Configure background for layer
		_emptyTimelineLayer.strokeColor = [UIColor colorWithRed: 255.0/255.0
														  green: 94.0/255.0
														   blue: 124.0/255.0 alpha: 1.0].CGColor;
		
		if (_arcFillLayer == nil) {
			CGFloat imageDiameter = MIN(self.frame.size.width, self.frame.size.height) - self.imageCaps * 2;
			
			CGRect drawingFrame = CGRectMake(0, 0, imageDiameter, imageDiameter);
			drawingFrame.origin.x = (_drawingView.frame.size.width - drawingFrame.size.width) / 2;
			drawingFrame.origin.y = (_drawingView.frame.size.height - drawingFrame.size.height) / 2;
			
			UIBezierPath *path = [UIBezierPath bezierPath];
			
			[path moveToPoint: CGPointMake(drawingFrame.size.width / 2, drawingFrame.size.height)];
			[path addLineToPoint: CGPointMake(drawingFrame.size.width / 2, 0)];
			
			_arcFillLayer=[CAShapeLayer layer];
//			_arcFillLayer.backgroundColor = [UIColor colorWithWhite: 0 alpha: 128.0/255.0].CGColor;
			_arcFillLayer.cornerRadius = drawingFrame.size.width / 2;
			_arcFillLayer.masksToBounds = YES;
			_arcFillLayer.path = path.CGPath;
			_arcFillLayer.lineWidth = drawingFrame.size.width;
			_arcFillLayer.strokeColor = [UIColor colorWithRed: 247.0/255.0 green: 43.0/255.0 blue: 146.0/255.0
														alpha: 204.0/255.0].CGColor;
			_arcFillLayer.strokeEnd = self.progressValue;
			_arcFillLayer.frame = drawingFrame;
			[_drawingView.layer addSublayer: _arcFillLayer];
			//			[_arcFillLayer setNeedsDisplay];
		}
		
		_arcBgLayer.hidden = YES;
		_arcFillLayer.hidden = NO;
	} else if (self.type == CheckDetailTypeClosed) {
		_emptyTimelineLayer.strokeColor = [UIColor colorWithWhite: 1.0 alpha: 38.0/255.0].CGColor;
		
		_arcBgLayer.hidden = YES;
		_arcFillLayer.hidden = YES;
	}
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

#pragma mark - UIView implementation

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    BOOL pointInside = NO;
	
	//    if (CGRectContainsPoint(imageView.frame, point) || expanded) pointInside = YES;
	
    return pointInside;
}

@end
