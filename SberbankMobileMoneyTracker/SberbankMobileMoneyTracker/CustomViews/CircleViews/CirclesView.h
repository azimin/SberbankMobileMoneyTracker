//
//  CirclesView.h
//  SberbankMobileMoneyTracker
//
//  Created by Alex Zimin on 26/07/14.
//  Copyright (c) 2014 Empatika. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CirclesView : UIView

@property (nonatomic) NSArray *values;

- (instancetype)initWithValues: (NSArray*)values
                      andFrame: (CGRect)frame;

@end
