//
//  CalendarCell.h
//  SberbankMobileMoneyTracker
//
//  Created by Alex Zimin on 26/07/14.
//  Copyright (c) 2014 Empatika. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarCell : UIView

@property (nonatomic) NSString *dayString;
@property (nonatomic) NSArray *values;
@property (nonatomic, getter = isSelected) BOOL selected;

- (instancetype)initWithDayString: (NSString*)dayString
                        andValues: (NSArray*)valus;

+ (CGRect)calendarCellFrame;

@end
