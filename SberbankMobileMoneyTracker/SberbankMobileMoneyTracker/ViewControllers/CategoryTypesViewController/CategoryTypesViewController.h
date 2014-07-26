//
//  CategoryTypesTableViewController.h
//  SberbankMobileMoneyTracker
//
//  Created by Ivan Oschepkov on 26.07.14.
//  Copyright (c) 2014 Empatika. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CategoryTypesViewController;

@protocol CategoryTypesViewDelegate <NSObject>
@required
- (void)categoryTypesVC:(CategoryTypesViewController *)categoryTypesVC userDidSelectCategory:(NSString *)categoryName;
@end


@interface CategoryTypesViewController : UIViewController

@property (weak, nonatomic) id<CategoryTypesViewDelegate> categoryDelegate;

@end
