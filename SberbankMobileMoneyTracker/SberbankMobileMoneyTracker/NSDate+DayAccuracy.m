//
//  NSDate+DayAccuracy.m
//  SberbankMobileMoneyTracker
//
//  Created by Ivan Oschepkov on 27.07.14.
//  Copyright (c) 2014 Empatika. All rights reserved.
//

#import "NSDate+DayAccuracy.h"

@implementation NSDate (DayAccuracy)

+ (NSDate *)dateWithFirstMinuteOfDay:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    return [calendar dateFromComponents:components];
}

+ (NSDate *)dateWithLastMinuteOfDay:(NSDate *)date{
    date = [date dateByAddingTimeInterval:86400];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    return [calendar dateFromComponents:components];
}

@end
