//
//  SearchManager.h
//  SberbankMobileMoneyTracker
//
//  Created by Ivan Oschepkov on 27.07.14.
//  Copyright (c) 2014 Empatika. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MoneyTrackerServerManager : NSObject

+ (instancetype)sharedInstance;

- (void)sendNewExpense:(NSDictionary *)expenseDictionary
           withSuccess:(void (^)())success
               failure:(void (^)(NSError *error))failure;

- (void)fetchStatisticInIntervalFrom:(NSDate *)fromDate
                                  to:(NSDate *)toDate
                         withSuccess:(void(^)(NSArray *resultStatistic))success
                             failure:(void (^)(NSError *error))failure;

- (void)fetchStatisticForDay:(NSDate *)date
                 withSuccess:(void(^)(NSArray *resultStatistic))success
                     failure:(void (^)(NSError *error))failure;

- (void)fetchAllStatisticWithSuccess:(void(^)(NSArray *resultStatistic))success
                             failure:(void (^)(NSError *error))failure;

@end
