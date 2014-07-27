//
//  CoreDataManager.h
//  SberbankMobileMoneyTracker
//
//  Created by Ivan Oschepkov on 26.07.14.
//  Copyright (c) 2014 Empatika. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreDataManager : NSObject

@property (nonatomic) NSArray *expenses;
@property (nonatomic) NSDictionary *expensesWithDayMove;

+ (instancetype)sharedInstance;

- (void)addExpense:(double)sum toCategory:(NSString *)categoryName withDescription:(NSString *)description atDate:(NSDate *)date;
- (void)fetchExpensesStatistic;

- (void)clearStore;

- (NSArray*)sortDictsByNameWithDefaultKeys:(NSArray*)arrOfDics;

@end
