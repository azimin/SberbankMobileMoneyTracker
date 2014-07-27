//
//  UIImage+ImageFromColor.h
//  PassMaker
//
//  Created by Alex Zimin on 25.09.13.
//  Copyright (c) 2013 Alex Zimin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageFromColor)

+ (UIImage *)imageWithColor:(UIColor *)color andFrame:(CGRect)rect;
- (UIImage *)imageWithOverlayColor:(UIColor *)color;

@end
