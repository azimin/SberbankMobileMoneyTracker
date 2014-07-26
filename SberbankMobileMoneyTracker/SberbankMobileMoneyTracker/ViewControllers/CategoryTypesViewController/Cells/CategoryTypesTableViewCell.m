//
//  CategoryTypesTableViewCell.m
//  SberbankMobileMoneyTracker
//
//  Created by Ivan Oschepkov on 26.07.14.
//  Copyright (c) 2014 Empatika. All rights reserved.
//

#import "CategoryTypesTableViewCell.h"

@implementation CategoryTypesTableViewCell

- (void)awakeFromNib {
    UIView *seperator = [[UIView alloc] initWithFrame:CGRectMake(0, 89, 320, 1)];
    seperator.backgroundColor = [UIColor mainGreyColor];
    [self addSubview:seperator];
    
    self.backgroundColor = [UIColor clearColor];
    
    self.categoryCircle = [[Circle alloc] initWithRadius:10 andCenter:CGPointMake(31, 45)];
    [self.contentView addSubview:self.categoryCircle];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
