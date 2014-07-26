//
//  CirclesView.m
//  SberbankMobileMoneyTracker
//
//  Created by Alex Zimin on 26/07/14.
//  Copyright (c) 2014 Empatika. All rights reserved.
//

#import "CirclesView.h"
#import "Circle.h"
#import "LabelOnCircle.h"

@implementation CirclesView 

- (instancetype)init
{
    return [super initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        self.values = @[];
        [self commonInit];
    }
    
    return self;
}

- (instancetype)initWithValues: (NSArray*)values
                      andFrame: (CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.values = values;
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit
{
    NSArray *sortedValues = [self.values sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        CGFloat firstValue = [obj1 floatValue];
        CGFloat secondValuer = [obj2 floatValue];
        
        if (firstValue > secondValuer)
            return NSOrderedAscending;
        else if (firstValue < secondValuer)
            return NSOrderedDescending;
        
        return NSOrderedSame;
    }];
    
    
    
    for (NSInteger index = 0; index < 4; index ++) {
        if ( index >= self.values.count ) {
            return;
        }
        
        NSInteger sizeNumber = [sortedValues indexOfObject:self.values[index]];
        CGFloat radius = [self.circleSizes[sizeNumber] floatValue];
        Circle *circle = [[Circle alloc] initWithRadius:radius andCenter:[self centerAfterNumber: index
                                                                                   andSizeNumber: sizeNumber]];
        circle.color = UIColor.circleColors[index];
        circle.tagPlus = index;
        [circle addTarget:self action:@selector(circleWasPressed:)];
        [circle bounceAppearWithDuration: 0.8 + (float)(arc4random() % 6) / 10];
        
        LabelOnCircle *labelOnCircle = [[LabelOnCircle alloc] initWithCategoryName:[NSArray categoriesArray][index] valueString:[self.values[index] stringValue] onCircle:circle];
        [circle addSubview:labelOnCircle];
        
        [self addSubview:circle];
    }
}

- (void)circleWasPressed:(Circle*)circle
{
    [self.delegate circlesView:self didSelectCircle:circle];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL flag = FALSE;
    for (Circle *circle in self.subviews) {
        if ([circle isKindOfClass:[Circle class]]) {
            if (CGRectContainsPoint(circle.frame, point)) {
                flag = TRUE;
            }
        }
    }
    
    return flag;
}


#pragma mark - Getters

- (CGPoint)centerAfterNumber:(NSInteger)number
               andSizeNumber:(NSInteger)sizeNumber
{
    CGFloat x = 0;
    CGFloat y = 0;
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    if (number % 2 == 0) {
        x = width / 3.4;
        if (number == 0) {
            y = height / 2.95;
        } else {
            y = height / 1.24;
        }
    } else {
        if (number == 1) {
            x = width / 1.42;
            y = height / 3.35;
        } else {
            x = width / 1.52;
            y = height / 1.45;
        }
    }
    
    return CGPointMake(x, y);
}

- (NSArray*)circleSizes
{
    CGFloat minSide = MIN(self.frame.size.width, self.frame.size.height);
    CGFloat maxValue = minSide / 4.6;
    CGFloat minValue = minSide / 7.5;
    CGFloat delta = (maxValue - minValue) / 3;
    
    return @[@(maxValue),
             @(maxValue - delta),
             @(minValue + delta),
             @(minValue)];
}

#pragma mark - Text Label


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
