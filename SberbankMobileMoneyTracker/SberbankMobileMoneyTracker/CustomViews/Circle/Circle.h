//
//  Circle.h
//  SberbankMobileMoneyTracker
//
//  Created by Alex Zimin on 26/07/14.
//  Copyright (c) 2014 Empatika. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Circle : UIView <NSCopying>

- (instancetype)initWithRadius: (CGFloat)radius
           andCenter: (CGPoint)center;

@property (nonatomic) CGFloat radius;
@property (nonatomic) UIColor *color;
@property (nonatomic, getter = isHovering) BOOL hovering;
@property (nonatomic) NSArray *expenses;

- (void)bounceAppearWithDuration: (CGFloat)duration;
- (void)changeRadius: (CGFloat)radius
        withDuration: (CGFloat)duration
           andBounce: (BOOL)isBounce;

- (void)addTarget:(id)target action:(SEL)action;

- (void)removeText;

@end