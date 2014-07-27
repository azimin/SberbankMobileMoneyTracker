//
//  CategoryType.h
//  SberbankMobileMoneyTracker
//
//  Created by Alex Zimin on 27/07/14.
//  Copyright (c) 2014 Empatika. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DayInfo, Expense;

@interface CategoryType : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * value;
@property (nonatomic, retain) DayInfo *dayInfo;
@property (nonatomic, retain) NSSet *expenses;
@end

@interface CategoryType (CoreDataGeneratedAccessors)

- (void)addExpensesObject:(Expense *)value;
- (void)removeExpensesObject:(Expense *)value;
- (void)addExpenses:(NSSet *)values;
- (void)removeExpenses:(NSSet *)values;

@end
