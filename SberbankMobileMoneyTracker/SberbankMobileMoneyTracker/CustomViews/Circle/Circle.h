//
//  Circle.h
//  SberbankMobileMoneyTracker
//
//  Created by Alex Zimin on 26/07/14.
//  Copyright (c) 2014 Empatika. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Circle : UIView

- (id)initWithRadius: (CGFloat)radius
           andCenter: (CGPoint)center;

@property (nonatomic) CGFloat *radius;

@end
