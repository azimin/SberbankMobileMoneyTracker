//
//  MainViewNavigation.h
//  SberbankMobileMoneyTracker
//
//  Created by Alex Zimin on 26/07/14.
//  Copyright (c) 2014 Empatika. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MainViewNavigationDelegat;

@interface MainViewNavigation : UIView

@property (nonatomic, assign) id <MainViewNavigationDelegat> delegate;
@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic) NSArray *titles;

- (instancetype)initWithTitles: (NSArray*)titles
                 selectedIndex: (NSInteger)index
                    andDelegat: (id <MainViewNavigationDelegat>)delegat;

@end

@protocol MainViewNavigationDelegat <NSObject>

- (void)mainNavigation:(MainViewNavigation *)mainNavigation
         scrollToIndex:(NSInteger)index;

@end
