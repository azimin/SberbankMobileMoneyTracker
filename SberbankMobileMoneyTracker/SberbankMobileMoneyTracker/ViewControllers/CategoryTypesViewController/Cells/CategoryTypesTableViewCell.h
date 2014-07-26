//
//  CategoryTypesTableViewCell.h
//  SberbankMobileMoneyTracker
//
//  Created by Ivan Oschepkov on 26.07.14.
//  Copyright (c) 2014 Empatika. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Circle.h"

@interface CategoryTypesTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *categorySmallCircleIcon;
@property (weak, nonatomic) IBOutlet UILabel *categoryNameLabel;

@property (nonatomic) Circle *categoryCircle;

@end
