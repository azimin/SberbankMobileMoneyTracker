//
//  UIColor+AppColors.m
//  SberbankMobileMoneyTracker
//
//  Created by Alex Zimin on 26/07/14.
//  Copyright (c) 2014 Empatika. All rights reserved.
//

#import "UIColor+AppColors.h"

@implementation UIColor (AppColors)

+ (NSArray*)circleColors
{
    return @[[UIColor colorWithHexString:@"669129"],
             [UIColor colorWithHexString:@"ca4e4e"],
             [UIColor colorWithHexString:@"6e92c9"],
             [UIColor colorWithHexString:@"9bc663"]];
}

+ (UIColor*)mainGreyColor
{
    return [UIColor colorWithHexString:@"d8d9d9"];
}

@end
