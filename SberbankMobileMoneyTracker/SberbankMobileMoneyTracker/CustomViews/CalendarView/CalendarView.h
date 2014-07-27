//
//  CalendarView.h
//  SberbankMobileMoneyTracker
//
//  Created by Alex Zimin on 26/07/14.
//  Copyright (c) 2014 Empatika. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CirclesView.h"
#import "Circle.h"

@protocol CalendarViewDelegat;

@interface CalendarView : UIView

@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic) NSArray *numbers;
@property (nonatomic) NSArray *arrayOfValues;

- (instancetype)initWithDays: (NSArray*)numbers
            andArrayOfValues: (NSArray*)arrayOfValues;
@property (nonatomic, assign) id <CalendarViewDelegat> delegate;

@end


@protocol CalendarViewDelegat <NSObject>

- (void)changeDownCirclesWithValues:(NSArray*)values andInfos:(NSArray*)infos;

@end

