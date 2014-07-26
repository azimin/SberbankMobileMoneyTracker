//
//  InfiniteScrollView.h
//  SberbankMobileMoneyTracker
//
//  Created by Ivan Oschepkov on 26.07.14.
//  Copyright (c) 2014 Empatika. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InfiniteScrollView;
@protocol InfiniteScrollViewDataSource <NSObject>

@required
-(UIView *)infiniteScrollView:(InfiniteScrollView *)scrollView loadNextViewAfterView:(UIView *)currentView;
-(UIView *)infiniteScrollView:(InfiniteScrollView *)scrollView loadPreviousViewAfterView:(UIView *)currentView;

@end

@interface InfiniteScrollView : UIScrollView

-(instancetype)initWithVisibleView:(UIView *)view dataSource:(id<InfiniteScrollViewDataSource>)source;

@end
