//
//  Circle.m
//  SberbankMobileMoneyTracker
//
//  Created by Alex Zimin on 26/07/14.
//  Copyright (c) 2014 Empatika. All rights reserved.
//

#import "Circle.h"
@import QuartzCore;

// Scale points
struct ScalePoints {
    CGFloat x;
    CGFloat y;
    CGFloat z;
    CGFloat k;
};
typedef struct ScalePoints ScalePoints;

ScalePoints ScalePointMale(CGFloat x, CGFloat y, CGFloat z, CGFloat k) {
    ScalePoints points;
    
    points.x = x;
    points.y = y;
    points.z = z;
    points.k = k;
    
    return points;
}

@implementation Circle

#pragma mark - Init

- (instancetype)init
{
    self = [super init];
    
    if ( self ) {
        self.radius = 0;
        self.layer.cornerRadius = 0;
        self.layer.masksToBounds = YES;
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    CGFloat minSide = MIN(frame.size.width, frame.size.height);
    frame = CGRectMake(frame.origin.x,
                       frame.origin.y,
                       minSide,
                       minSide);
    self = [super initWithFrame:frame];
    
    if (self) {
        self.radius = minSide / 2;
        self.layer.cornerRadius = minSide / 2;
        self.layer.masksToBounds = YES;
    }
    
    return self;
}

- (instancetype)initWithRadius: (CGFloat)radius
           andCenter: (CGPoint)center
{
    self = [super initWithFrame:CGRectMake(0, 0, radius * 2, radius * 2)];
    
    if ( self ) {
        self.radius = radius;
        self.center = center;
        self.layer.cornerRadius = radius;
        self.layer.masksToBounds = YES;
    }
    
    return self;
}

#pragma mark - Setters

- (void)setRadius:(CGFloat)radius
{
    _radius = radius;
    [self changeRadius:radius withDuration:0.0 andBounce:NO];
}

- (void)setFrame:(CGRect)frame
{
    CGFloat minSide = MIN(frame.size.width, frame.size.height);
    frame = CGRectMake(frame.origin.x,
                       frame.origin.y,
                       minSide,
                       minSide);
    
    [super setFrame:frame];
    
    self.radius = minSide / 2;
    self.layer.cornerRadius = minSide / 2;
}

#pragma mark - Animation

- (void)bounceAppearWithDuration: (CGFloat)duration
{
    [self runBounceAnimationWithScalePoints:ScalePointMale(0.0, 1.2, 0.9, 1.0) withDuration:duration];
}

- (void)changeRadius: (CGFloat)radius
        withDuration: (CGFloat)duration
           andBounce: (BOOL)isBounce
{
    _radius = radius;
    CGFloat scale = radius * 2 / self.frame.size.width;
    
    if ( isBounce ) {
        
        CGFloat scaleDifferent = (scale - 1.0) / 10;
        [self runBounceAnimationWithScalePoints:ScalePointMale(1.0, scale + scaleDifferent, scale - scaleDifferent, scale) withDuration:duration];
        
    } else {
        
        [UIView animateWithDuration:duration animations:^{
            self.transform = CGAffineTransformMakeScale(scale, scale);
        }];
        
    }
}

#pragma mark - Bounce Animation

- (void)runBounceAnimationWithScalePoints: (ScalePoints)points
                             withDuration: (CGFloat)duration
{
    [CATransaction begin];
    [CATransaction setAnimationDuration:duration];
    [CATransaction setAnimationTimingFunction:[[CAMediaTimingFunction alloc] initWithControlPoints:0.4 :0.0 :0.2 :1.0]];
    
    CAKeyframeAnimation *boundsOvershootAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    CATransform3D startingScale = CATransform3DScale (self.layer.transform, points.x, points.x, 0);
    CATransform3D overshootScale = CATransform3DScale (self.layer.transform, points.y, points.y, 1.0);
    CATransform3D undershootScale = CATransform3DScale (self.layer.transform, points.z, points.z, 1.0);
    CATransform3D endingScale = CATransform3DScale (self.layer.transform, points.k, points.k, 1.0);//self.layer.transform;
    
    NSArray *boundsValues = [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:startingScale],
                             [NSValue valueWithCATransform3D:overshootScale],
                             [NSValue valueWithCATransform3D:undershootScale],
                             [NSValue valueWithCATransform3D:endingScale], nil];
    [boundsOvershootAnimation setValues:boundsValues];
    
    NSArray *times = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f],
                      [NSNumber numberWithFloat:0.5f],
                      [NSNumber numberWithFloat:0.9f],
                      [NSNumber numberWithFloat:1.0f], nil];
    [boundsOvershootAnimation setKeyTimes:times];
    
    
    NSArray *timingFunctions = [NSArray arrayWithObjects:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                nil];
    [boundsOvershootAnimation setTimingFunctions:timingFunctions];
    boundsOvershootAnimation.fillMode = kCAFillModeForwards;
    boundsOvershootAnimation.removedOnCompletion = NO;
    
    [self.layer addAnimation:boundsOvershootAnimation forKey:boundsOvershootAnimation.keyPath];
    
    [CATransaction commit];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}


@end
