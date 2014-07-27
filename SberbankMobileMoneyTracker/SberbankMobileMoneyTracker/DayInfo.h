//
//  DayInfo.h
//  SberbankMobileMoneyTracker
//
//  Created by Alex Zimin on 27/07/14.
//  Copyright (c) 2014 Empatika. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CategoryType;

@interface DayInfo : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSSet *categoryTypes;
@end

@interface DayInfo (CoreDataGeneratedAccessors)

- (void)addCategoryTypesObject:(CategoryType *)value;
- (void)removeCategoryTypesObject:(CategoryType *)value;
- (void)addCategoryTypes:(NSSet *)values;
- (void)removeCategoryTypes:(NSSet *)values;

@end
