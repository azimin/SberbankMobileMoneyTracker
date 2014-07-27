//
//  UIImage+ImageFromColor.m
//  PassMaker
//
//  Created by Alex Zimin on 25.09.13.
//  Copyright (c) 2013 Alex Zimin. All rights reserved.
//

#import "UIImage+ImageFromColor.h"

@implementation UIImage (ImageFromColor)

+(UIImage *)imageWithColor:(UIColor *)color andFrame:(CGRect)rect {
    // Create a 1 by 1 pixel context
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(CGRectMake(0, 0, rect.size.width, rect.size.height));   // Fill it with your color
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

-(UIImage *)imageWithOverlayColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, self.size.width, self.size.height);
    
    if (UIGraphicsBeginImageContextWithOptions) {
        CGFloat imageScale = 2.0f;
        if ([self respondsToSelector:@selector(scale)]) // The scale property is new with iOS4. imageScale = self.scale;
        UIGraphicsBeginImageContextWithOptions(self.size, NO, imageScale);
    }
        
    [self drawInRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext(); CGContextSetBlendMode(context, kCGBlendModeSourceIn);
    
    CGContextSetFillColorWithColor(context, color.CGColor); CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext(); UIGraphicsEndImageContext();
    
    return image;
        
}

@end
