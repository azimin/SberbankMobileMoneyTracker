//
//  UIView+Tag.m
//  SberbankMobileMoneyTracker
//
//  Created by Alex Zimin on 26/07/14.
//  Copyright (c) 2014 Empatika. All rights reserved.
//

#import "UIView+Tag.h"
#import <objc/runtime.h>

@implementation UIView (Tag)

static char key;
static char key2;

- (NSInteger)tagPlus
{
    return [objc_getAssociatedObject(self, &key) intValue];
}

- (void)setTagPlus:(NSInteger)tagPlus
{
    objc_setAssociatedObject(self, &key, @(tagPlus), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray *)dates
{
     return objc_getAssociatedObject(self, &key2);
}

- (void)setDates:(NSArray *)dates
{
    objc_setAssociatedObject(self, &key2, dates, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
