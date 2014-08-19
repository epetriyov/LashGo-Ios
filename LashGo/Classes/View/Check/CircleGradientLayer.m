//
//  CircleGradientLayer.m
//  LashGo
//
//  Created by Vitaliy Pykhtin on 19.07.14.
//  Copyright (c) 2014 Vitaliy Pykhtin. All rights reserved.
//

#import "CircleGradientLayer.h"

@implementation CircleGradientLayer

//- (id) init {
//	if (self = [super init]) {
//		self.contentsScale = [UIScreen mainScreen].scale;
//	}
//	return self;
//}

typedef void (^voidBlock)(void);
typedef float (^floatfloatBlock)(float);
typedef UIColor * (^floatColorBlock)(float);

-(CGPoint) pointForTrapezoidWithAngle:(float)a andRadius:(float)r  forCenter:(CGPoint)p{
    return CGPointMake(p.x + r*cos(a), p.y + r*sin(a));
}

-(void)drawGradientInContext:(CGContextRef)ctx  startingAngle:(float)a endingAngle:(float)b intRadius:(floatfloatBlock)intRadiusBlock outRadius:(floatfloatBlock)outRadiusBlock withGradientBlock:(floatColorBlock)colorBlock withSubdiv:(int)subdivCount withCenter:(CGPoint)center withScale:(float)scale
{
    float angleDelta = (b-a)/subdivCount;
    float fractionDelta = 1.0/subdivCount;
	
    CGPoint p0,p1,p2,p3, p4,p5;
    float currentAngle=a;
    p4=p0 = [self pointForTrapezoidWithAngle:currentAngle andRadius:intRadiusBlock(0) forCenter:center];
    p5=p3 = [self pointForTrapezoidWithAngle:currentAngle andRadius:outRadiusBlock(0) forCenter:center];
//    CGMutablePathRef innerEnveloppe=CGPathCreateMutable(),
//    outerEnveloppe=CGPathCreateMutable();
//	
//    CGPathMoveToPoint(outerEnveloppe, 0, p3.x, p3.y);
//    CGPathMoveToPoint(innerEnveloppe, 0, p0.x, p0.y);
    CGContextSaveGState(ctx);
	
    CGContextSetLineWidth(ctx, 1);
	
    for (int i=0;i<subdivCount;i++)
    {
        float fraction = (float)i/subdivCount;
        currentAngle=a+fraction*(b-a);
        CGMutablePathRef trapezoid = CGPathCreateMutable();
		
        p1 = [self pointForTrapezoidWithAngle:currentAngle+angleDelta andRadius:intRadiusBlock(fraction+fractionDelta) forCenter:center];
        p2 = [self pointForTrapezoidWithAngle:currentAngle+angleDelta andRadius:outRadiusBlock(fraction+fractionDelta) forCenter:center];
		
        CGPathMoveToPoint(trapezoid, 0, p0.x, p0.y);
        CGPathAddLineToPoint(trapezoid, 0, p1.x, p1.y);
        CGPathAddLineToPoint(trapezoid, 0, p2.x, p2.y);
        CGPathAddLineToPoint(trapezoid, 0, p3.x, p3.y);
        CGPathCloseSubpath(trapezoid);
		
        CGPoint centerofTrapezoid = CGPointMake((p0.x+p1.x+p2.x+p3.x)/4, (p0.y+p1.y+p2.y+p3.y)/4);
		
        CGAffineTransform t = CGAffineTransformMakeTranslation(-centerofTrapezoid.x, -centerofTrapezoid.y);
        CGAffineTransform s = CGAffineTransformMakeScale(scale, scale);
        CGAffineTransform concat = CGAffineTransformConcat(t, CGAffineTransformConcat(s, CGAffineTransformInvert(t)));
        CGPathRef scaledPath = CGPathCreateCopyByTransformingPath(trapezoid, &concat);
		
        CGContextAddPath(ctx, scaledPath);
		CFRelease(scaledPath);
        CGContextSetFillColorWithColor(ctx,colorBlock(fraction).CGColor);
        CGContextSetStrokeColorWithColor(ctx, colorBlock(fraction).CGColor);
        CGContextSetMiterLimit(ctx, 0);
		
        CGContextDrawPath(ctx, kCGPathFillStroke);
		
        CGPathRelease(trapezoid);
        p0=p1;
        p3=p2;
		
//        CGPathAddLineToPoint(outerEnveloppe, 0, p3.x, p3.y);
//        CGPathAddLineToPoint(innerEnveloppe, 0, p0.x, p0.y);
    }
//    CGContextSetLineWidth(ctx, 0);
//    CGContextSetLineJoin(ctx, kCGLineJoinRound);
//    CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
//    CGContextAddPath(ctx, outerEnveloppe);
//    CGContextAddPath(ctx, innerEnveloppe);
//    CGContextMoveToPoint(ctx, p0.x, p0.y);
//    CGContextAddLineToPoint(ctx, p3.x, p3.y);
//    CGContextMoveToPoint(ctx, p4.x, p4.y);
//    CGContextAddLineToPoint(ctx, p5.x, p5.y);
//    CGContextStrokePath(ctx);
}

- (void) drawInContext:(CGContextRef)ctx {
    float radius=MIN(self.frame.size.width, self.frame.size.height) / 2;// / [UIScreen mainScreen].scale;
	
    [self drawGradientInContext:ctx  startingAngle: -M_PI_2 endingAngle: 3*M_PI_2 intRadius:^float(float f) {
        return 0;
    } outRadius:^float(float f) {
        return radius;
    } withGradientBlock:^UIColor *(float f) {
		
		//        return [UIColor colorWithHue:f saturation:1 brightness:1 alpha:1];
        float sr=246, sg=188, sb=87;
		float mr=237, mg=37, mb=73;
        float er=255, eg=60, eb=189;
		
		float k; //Gradient increment koefficient
		
		if (f > 0.5) {
			k = f * 2 - 1;
			return [UIColor colorWithRed:(k*er+(1-k)*mr)/255. green:(k*eg+(1-k)*mg)/255. blue:(k*eb+(1-k)*mb)/255. alpha:1];
		} else {
			k = f * 2;
			return [UIColor colorWithRed:(k*mr+(1-k)*sr)/255. green:(k*mg+(1-k)*sg)/255. blue:(k*mb+(1-k)*sb)/255. alpha:1];
		}
		
    } withSubdiv:64 withCenter:CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds)) withScale: 1];
}

//- (void) drawInContext:(CGContextRef)ctx {
//	CGContextRef context = ctx;//UIGraphicsGetCurrentContext();
////    [[UIColor whiteColor] set]; //[[NSColor whiteColor]set];
////    UIRectFill([self bounds]);
//    float dim = MIN(self.bounds.size.width, self.bounds.size.height);
//    int subdiv=10;
//    float r=dim/4;
//    float R=dim/2;
//	
//    float halfinteriorPerim = M_PI*r;
//    float halfexteriorPerim = M_PI*R;
//    float smallBase= halfinteriorPerim/subdiv;
//    float largeBase= halfexteriorPerim/subdiv;
//	
//	CGMutablePathRef path = CGPathCreateMutable();
//	
//    UIBezierPath * cell = [UIBezierPath bezierPath];
//	
//	CGPathMoveToPoint(path, 0, - smallBase/2, r);
////    [cell moveToPoint:CGPointMake(- smallBase/2, r)];
//	
//	CGPathAddLineToPoint(path, 0, + smallBase/2, r);
////    [cell addLineToPoint:CGPointMake(+ smallBase/2, r)];
//	
//	CGPathAddLineToPoint(<#CGMutablePathRef path#>, <#const CGAffineTransform *m#>, <#CGFloat x#>, <#CGFloat y#>)
//    [cell addLineToPoint:CGPointMake( largeBase /2 , R)];
//    [cell addLineToPoint:CGPointMake(-largeBase /2,  R)];
//    [cell closePath];
//	
//    float incr = M_PI / subdiv;
//    //CGContextRef ctx = [[NSGraphicsContext currentContext] graphicsPort];
//    CGContextTranslateCTM(context, +self.bounds.size.width/2, +self.bounds.size.height/2);
//	
//    CGContextScaleCTM(context, 0.9, 0.9);
//    CGContextRotateCTM(context, M_PI/2);
//    CGContextRotateCTM(context,-incr/2);
//	
//    for (int i=0;i<subdiv;i++) {
//        // replace this color with a color extracted from your gradient object
//		UIGraphicsPushContext(context);
//        [[UIColor colorWithHue:(float)i/subdiv saturation:1 brightness:1 alpha:1] set];
//        [cell fill];
//        [cell stroke];
//		UIGraphicsPopContext();
//        CGContextRotateCTM(context, -incr);
//    }
////	UIGraphicsPopContext();
//}

@end
