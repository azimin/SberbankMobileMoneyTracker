//
//  CalendarCell.h
//  SberbankMobileMoneyTracker
//
//  Created by Alex Zimin on 26/07/14.
//  Copyright (c) 2014 Empatika. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CalendarCellDelegat;

@interface CalendarCell : UIView <NSCopying>

@property (nonatomic) NSString *dayString;
@property (nonatomic) NSArray *values;
@property (nonatomic) NSArray *info;
@property (nonatomic, getter = isSelected) BOOL selected;

@property (nonatomic, assign) id <CalendarCellDelegat> delegate;

- (instancetype)initWithDayString: (NSString*)dayString
                        andValues: (NSArray*)valus;

+ (CGRect)calendarCellFrame;
- (IBAction)selectCell:(id)sender;

@end

@protocol CalendarCellDelegat <NSObject>

- (void)calendarCellDidSelect:(CalendarCell *)calendarCell;

@end