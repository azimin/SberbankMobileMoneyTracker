//
//  LabelOnCircle.h
//  SberbankMobileMoneyTracker
//
//  Created by Alex Zimin on 26/07/14.
//  Copyright (c) 2014 Empatika. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Circle.h"

@interface LabelOnCircle : UILabel

@property (nonatomic) NSString *categoryName;
@property (nonatomic) NSString *value;

- (instancetype)initWithCategoryName: (NSString*)categoryName
                         valueString: (NSString*)value
                            onCircle: (Circle*)circle;

@end
