//
//  CoreDataManager.m
//  SberbankMobileMoneyTracker
//
//  Created by Ivan Oschepkov on 26.07.14.
//  Copyright (c) 2014 Empatika. All rights reserved.
//

#import "CoreDataManager.h"
#import "DayInfo.h"
#import "CategoryType.h"

@interface CoreDataManager ()

@end

@implementation CoreDataManager

+ (instancetype)sharedInstance
{
    static CoreDataManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [CoreDataManager new];
    });
    return instance;
}

- (instancetype)init
{
    if (self == [super init])
        
    {
        [MagicalRecord setupCoreDataStackWithStoreNamed:@"SberbankMobileMoneyTrackerModel"];
    }
    return self;
}

- (void)addExpenses:(double)sum toCategory:(NSString *)categoryName atDate:(NSDate *)date{
    DayInfo *dayInfo = [DayInfo findFirstByAttribute:@"date" withValue:date];
    
    if(dayInfo){
        for(CategoryType *type in dayInfo.categoryTypes){
            if([type.name isEqualToString:categoryName])
                type.value = @([type.value doubleValue] + sum);
        }
    } else {
        dayInfo = [DayInfo createEntity];
        dayInfo = date;
        
        
        NSMutableSet *dayInfoCategories = [[NSMutableSet alloc] init];
        NSArray *categoryNames = @[@"Home", @"Health", @"Food", @"Fun"];
        for(NSString *cName in categoryNames){
            CategoryType *concreteType = [CategoryType createEntity];
            concreteType.name = cName;
            concreteType.value = [cName isEqualToString:categoryName] ? @(sum) : @(0);
            concreteType.dayInfo = dayInfo;
            
            [dayInfoCategories addObject:concreteType];
        }
        
        dayInfo.categoryTypes = dayInfoCategories;
    }
}

-(NSArray *)fetchExpensesStatistic{
    NSArray *allDays = [DayInfo findAll];
    NSMutableArray *resultStatistic = [[NSMutableArray alloc] init];
    
    for(DayInfo *day in allDays){
        NSMutableArray *categories = [[NSMutableArray alloc] init];
        for(CategoryType *categoryType in day.categoryTypes){
            NSDictionary *categoryInfo = @{@"name": categoryType.name,
                                           @"value": categoryType.value,
                                           @"date": categoryType.dayInfo};
            [categories addObject:categoryInfo];
        }
        
        [resultStatistic addObject:@{@"date": day.date,
                                     @"categories": categories}];
    }
    
    return resultStatistic;
}

@end
