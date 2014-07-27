//
//  CoreDataManager.h
//  SberbankMobileMoneyTracker
//
//  Created by Ivan Oschepkov on 26.07.14.
//  Copyright (c) 2014 Empatika. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreDataManager : NSObject

+ (instancetype)sharedInstance;

- (void)addExpense:(double)sum toCategory:(NSString *)categoryName withDescription:(NSString *)description atDate:(NSDate *)date;
-(NSArray *)fetchExpensesStatistic;

- (void)clearStore;

@end
