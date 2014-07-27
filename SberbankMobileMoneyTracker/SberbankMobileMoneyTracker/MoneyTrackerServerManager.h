//
//  SearchManager.h
//  SberbankMobileMoneyTracker
//
//  Created by Ivan Oschepkov on 27.07.14.
//  Copyright (c) 2014 Empatika. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MoneyTrackerServerManager;
@protocol MoneyTrackerServerDelegate <NSObject>

@optional
- (void)MoneyTrackerServerManagerSendNewExpenseWithSuccess:(MoneyTrackerServerManager *)manager;
- (void)MoneyTrackerServerManager:(MoneyTrackerServerManager *)manager newExpenseSendingDidFailWithError:(NSError *)error;

- (void)MoneyTrackerServerManager:(MoneyTrackerServerManager *)manager fetchingStatisticDidFailWithError:(NSError *)error;

@required
- (void)MoneyTrackerServerManager:(MoneyTrackerServerManager *)manager DidFetchStatisticWithResult:(NSArray *)resultDictionary;

@end


@interface MoneyTrackerServerManager : NSObject

@property (weak, nonatomic) id<MoneyTrackerServerDelegate> delegate;

+ (instancetype)sharedInstance;

- (void)sendNewExpense:(NSDictionary *)expenseDictionary;
- (void)fetchStatisticInIntervalFrom:(NSDate *)fromDate to:(NSDate *)toDate;
- (void)fetchStatisticForDay:(NSDate *)date;
- (void)fetchAllStatistic;

@end
