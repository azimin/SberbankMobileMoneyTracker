//
//  CirclesView.h
//  SberbankMobileMoneyTracker
//
//  Created by Alex Zimin on 26/07/14.
//  Copyright (c) 2014 Empatika. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Circle.h"

@protocol CirclesViewDelegat;

@interface CirclesView : UIView

@property (nonatomic) NSArray *values;
@property (nonatomic, assign) id <CirclesViewDelegat> delegate;

- (instancetype)initWithValues: (NSArray*)values
                      andFrame: (CGRect)frame;

@end

@protocol CirclesViewDelegat <NSObject>

- (void)circlesView:(CirclesView*)circlesView didSelectCircle:(Circle*)circle;

@end
