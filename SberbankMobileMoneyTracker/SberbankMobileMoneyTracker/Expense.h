//
//  Expense.h
//  SberbankMobileMoneyTracker
//
//  Created by Alex Zimin on 27/07/14.
//  Copyright (c) 2014 Empatika. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CategoryType;

@interface Expense : NSManagedObject

@property (nonatomic, retain) NSString * expenceDescription;
@property (nonatomic, retain) NSNumber * value;
@property (nonatomic, retain) CategoryType *categoryType;

@end
