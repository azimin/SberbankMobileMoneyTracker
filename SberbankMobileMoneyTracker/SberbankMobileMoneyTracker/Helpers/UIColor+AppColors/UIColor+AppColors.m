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

+ (UIColor *)selectionColorFromColor:(UIColor*)color
{
    float hue = 0;
    float saturation = 0;
    float brightness = 0;
    float newBrightness = 0;
    float alpha = 1.0;
    
    BOOL b = [color getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    newBrightness = (brightness > 0.55) ? brightness * 0.9 - 0.25 : brightness * 1.1 + 0.25;
    newBrightness = (newBrightness > 0.95) ? 0.9 : newBrightness;
    
    return (b) ? [UIColor colorWithHue:hue saturation:saturation brightness:newBrightness alpha:alpha] : [UIColor lightGrayColor];
}

@end
