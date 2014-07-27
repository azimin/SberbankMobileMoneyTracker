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
#import "Expense.h"

#define  STORE_NAME @"SberbankMobileMoneyTrackerModel"

@interface CoreDataManager ()
@property (strong, nonatomic) NSManagedObjectContext *context;
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
        [MagicalRecord setupCoreDataStackWithStoreNamed:STORE_NAME];
        self.context = [NSManagedObjectContext defaultContext];
    }
    return self;
}


- (void)addExpense:(double)sum toCategory:(NSString *)categoryName withDescription:(NSString *)description atDate:(NSDate *)date{
    date = [NSDate dateWithFirstMinuteOfDay:date];
    
    DayInfo *dayInfo = [DayInfo findFirstByAttribute:@"date" withValue:date];
    
    if(dayInfo){
        for(CategoryType *type in dayInfo.categoryTypes){
            if([type.name isEqualToString:categoryName]){
                //update category sum
                type.value = @([type.value doubleValue] + sum);
                
                // add expense to category
                Expense *expence = [Expense createEntity];
                expence.expenceDescription = description;
                expence.value = @(sum);
                [type addExpensesObject:expence];
            }
        }
    } else {
        dayInfo = [DayInfo createEntity];
        dayInfo.date = date;
        
        NSArray *categoryNames = [NSArray categoriesArray];
        for(NSString *cName in categoryNames){
            //add category to dayInfo
            CategoryType *concreteType = [CategoryType createEntity];
            concreteType.name = cName;
            concreteType.value = [cName isEqualToString:categoryName] ? @(sum) : @(0);
            
            if([cName isEqualToString:categoryName]){
                // add expense to category
                Expense *expence = [Expense createEntity];
                expence.expenceDescription = description;
                expence.value = @(sum);
                [concreteType addExpensesObject:expence];
            }
            [dayInfo addCategoryTypesObject:concreteType];
        }
    }
    
    [self.context saveToPersistentStoreAndWait];
}

-(void)fetchExpensesStatistic{
    NSArray *allDays = [DayInfo findAll];
    NSMutableArray *resultStatistic = [[NSMutableArray alloc] init];
    
    for(DayInfo *day in allDays){
        //fetch all categories of DayInfo
        NSMutableArray *categories = [[NSMutableArray alloc] init];
        for(CategoryType *categoryType in day.categoryTypes){
            //fetch all expenses of category
            NSMutableArray *expenses = [[NSMutableArray alloc] init];
            for(Expense *expense in categoryType.expenses){
                NSDictionary *expenseInfo = @{@"description":expense.expenceDescription,
                                              @"value": expense.value,
                                              @"date": expense.categoryType.dayInfo.date};
                [expenses addObject:expenseInfo];
            }
            
            NSDictionary *categoryInfo = @{@"name": categoryType.name,
                                           @"value": categoryType.value,
                                           @"date": categoryType.dayInfo.date,
                                           @"expenses": expenses};
            [categories addObject:categoryInfo];
        }
        
        [resultStatistic addObject:@{@"date": day.date,
                                     @"categories": categories}];
    }
    
    self.expenses = resultStatistic;
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    for (NSDictionary *dic in self.expenses) {
        NSDate *date = [dic objectForKey:@"date"];
        [mDic setObject:[dic objectForKey:@"categories"] forKey:@([self daysToDate:date])];
    }
    
    self.expensesWithDayMove = mDic;
}

- (NSInteger)daysToDate:(NSDate*)date
{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                        fromDate:[NSDate date]
                                                          toDate:date
                                                         options:0];
    return [components day];
}

- (void)clearStore{
    NSURL *storeURL = [NSPersistentStore urlForStoreName:STORE_NAME];
    [MagicalRecord cleanUp];
    
    NSError *error;
    if([[NSFileManager defaultManager] removeItemAtURL:storeURL error:&error]){
        [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:STORE_NAME];
    }
    else{
        NSLog(@"An error has occurred while deleting %@", STORE_NAME);
        NSLog(@"Error description: %@", error.description);
    }
}

@end
