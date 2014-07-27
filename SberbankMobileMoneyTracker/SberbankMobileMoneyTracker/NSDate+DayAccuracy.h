//
//  NSDate+DayAccuracy.h
//  SberbankMobileMoneyTracker
//
//  Created by Ivan Oschepkov on 27.07.14.
//  Copyright (c) 2014 Empatika. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (DayAccuracy)

+ (NSDate *)dateWithFirstMinuteOfDay:(NSDate *)date;
+ (NSDate *)dateWithLastMinuteOfDay:(NSDate *)date;

@end
