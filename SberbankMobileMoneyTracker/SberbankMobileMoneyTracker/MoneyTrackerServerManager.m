//
//  SearchManager.m
//  SberbankMobileMoneyTracker
//
//  Created by Ivan Oschepkov on 27.07.14.
//  Copyright (c) 2014 Empatika. All rights reserved.
//

#import "MoneyTrackerServerManager.h"
#import "MoneyTrackerClient.h"
#import "CoreDataManager.h"

@implementation MoneyTrackerServerManager

+ (instancetype)sharedInstance
{
    static MoneyTrackerServerManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [MoneyTrackerServerManager new];
    });
    return instance;
}

- (instancetype)init
{
    if (self == [super init]){
        
    }
    return self;
}

- (void)sendNewExpense:(NSDictionary *)expenseDictionary{
    NSDictionary *params = @{@"category": expenseDictionary[@"category"],
                             @"description": @"cash",
                             @"cost": expenseDictionary[@"value"],
                             @"datetime": [NSNumber numberWithInt:[(NSDate *)expenseDictionary[@"date"] timeIntervalSince1970]]};
    
    [[MoneyTrackerClient sharedClient] POST:@"addexpense"
                                 parameters:params
                                    success:^(NSURLSessionDataTask *task, id responseObject) {
                                        NSLog(@"New expense successfully sended");
                                        [self.delegate MoneyTrackerServerManagerSendNewExpenseWithSuccess:self];
                                    }
                                    failure:^(NSURLSessionDataTask *task, NSError *error) {
                                        NSLog(@"Error while sending new expense: %@", error);
                                        [self.delegate MoneyTrackerServerManager:self newExpenseSendingDidFailWithError:error];
                                    }];
}

- (void)fetchStatisticInIntervalFrom:(NSDate *)fromDate to:(NSDate *)toDate{
    NSDictionary *params = @{@"from": @([fromDate timeIntervalSince1970]),
                             @"to": @([toDate timeIntervalSince1970])};
    
    [[MoneyTrackerClient sharedClient] GET:@"getexpenseslist"
                                parameters:params
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       
                                       if(responseObject){
                                           for(NSDictionary *expenseDictionary in responseObject[@"expenses"]){
                                               double expenseValue = [expenseDictionary[@"cost"] doubleValue];
                                               NSString *categoryName = expenseDictionary[@"category"];
                                               NSDate *date = [NSDate dateWithTimeIntervalSince1970:[expenseDictionary[@"dateTime"] doubleValue]];
                                               if(expenseValue && categoryName && date){
                                                   [[CoreDataManager sharedInstance] addExpense:expenseValue toCategory:categoryName atDate:date];
                                               }
                                           }
                                       }
                                       [self.delegate MoneyTrackerServerManager:self DidFetchStatisticWithResult:[[CoreDataManager sharedInstance] fetchExpensesStatistic]];
                                       
                                   }
                                   failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       NSLog(@"Error while fetching statistic: %@", error);
                                       [self.delegate MoneyTrackerServerManager:self fetchingStatisticDidFailWithError:error];
                                   }];
}

- (void)fetchStatisticForDate:(NSDate *)date{
    [self fetchStatisticInIntervalFrom:date to:date];
}

- (void)fetchAllStatistic{
    [self fetchStatisticInIntervalFrom:[NSDate dateWithTimeIntervalSince1970:1] to:[NSDate date]];
}

@end
