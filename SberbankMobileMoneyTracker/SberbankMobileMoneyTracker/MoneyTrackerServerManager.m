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

- (void)sendNewExpense:(NSDictionary *)expenseDictionary
           withSuccess:(void (^)())success
               failure:(void (^)(NSError *error))failure{
    NSDictionary *params = @{@"category": expenseDictionary[@"category"],
                             @"description": expenseDictionary[@"description"],
                             @"cost": expenseDictionary[@"value"],
                             @"datetime": [NSNumber numberWithLongLong:(long long)[(NSDate *)expenseDictionary[@"date"] timeIntervalSince1970]]};
    
    [[MoneyTrackerClient sharedClient] POST:@"addexpense"
                                 parameters:params
                                    success:^(NSURLSessionDataTask *task, id responseObject) {
                                        NSLog(@"New expense successfully sended");
                                        success();
                                    }
                                    failure:^(NSURLSessionDataTask *task, NSError *error) {
                                        NSLog(@"Error while sending new expense: %@", error);
                                        failure(error);
                                    }];
}

- (void)fetchStatisticInIntervalFrom:(NSDate *)fromDate
                                  to:(NSDate *)toDate
                         withSuccess:(void(^)(NSArray *resultStatistic))success
                             failure:(void (^)(NSError *error))failure{
    fromDate = [NSDate dateWithFirstMinuteOfDay:fromDate];
    toDate = [NSDate dateWithLastMinuteOfDay:toDate];
    
    NSDictionary *params = @{@"from": [NSNumber numberWithLongLong:(long long)[fromDate timeIntervalSince1970]],
                             @"to": [NSNumber numberWithLongLong:(long long)[toDate timeIntervalSince1970]]};
    
    [[MoneyTrackerClient sharedClient] GET:@"getexpenseslist"
                                parameters:params
                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                       NSLog(@"%@", responseObject);
                                       if(responseObject){
                                           //clear store and resave statistic
                                           [[CoreDataManager sharedInstance] clearStore];
                                           
                                           for(NSDictionary *expenseDictionary in responseObject[@"expenses"]){
                                               double expenseValue = [expenseDictionary[@"cost"] doubleValue];
                                               NSString *categoryName = expenseDictionary[@"category"];
                                               NSString *description = expenseDictionary[@"description"] ? expenseDictionary[@"description"] : @"No description";
                                               NSInteger timestamp = [[expenseDictionary objectForKey:@"datetime"] integerValue];
                                               NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
                                               if(expenseValue && categoryName && date){
                                                   [[CoreDataManager sharedInstance] addExpense:expenseValue toCategory:categoryName withDescription:description atDate:date];
                                               }
                                           }
                                       }
                                       
                                       [[CoreDataManager sharedInstance] fetchExpensesStatistic];
                                       success([CoreDataManager sharedInstance].expenses);
                                       
                                   }
                                   failure:^(NSURLSessionDataTask *task, NSError *error) {
                                       NSLog(@"Error while fetching statistic: %@", error);
                                       failure(error);
                                   }];
}

- (void)fetchStatisticForDay:(NSDate *)date
                 withSuccess:(void(^)(NSArray *resultStatistic))success
                     failure:(void (^)(NSError *error))failure{
    [self fetchStatisticInIntervalFrom:date to:date withSuccess:success failure:failure];
}

- (void)fetchAllStatisticWithSuccess:(void(^)(NSArray *resultStatistic))success
                             failure:(void (^)(NSError *error))failure{
    [self fetchStatisticInIntervalFrom:[NSDate dateWithTimeIntervalSince1970:50000000] to:[NSDate date] withSuccess:success failure:failure];
}

@end
