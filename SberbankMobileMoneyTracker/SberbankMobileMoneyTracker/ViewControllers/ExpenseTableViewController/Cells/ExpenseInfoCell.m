//
//  ExpenseInfoCell.m
//  SberbankMobileMoneyTracker
//
//  Created by Alex Zimin on 27/07/14.
//  Copyright (c) 2014 Empatika. All rights reserved.
//

#import "ExpenseInfoCell.h"

@implementation ExpenseInfoCell

- (void)awakeFromNib {
    UIView *seperator = [[UIView alloc] initWithFrame:CGRectMake(0, 89, 320, 1)];
    seperator.backgroundColor = [UIColor mainGreyColor];
    [self addSubview:seperator];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
