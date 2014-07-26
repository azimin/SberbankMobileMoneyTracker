//
//  ServerClient.h
//  SberbankMobileMoneyTracker
//
//  Created by Ivan Oschepkov on 27.07.14.
//  Copyright (c) 2014 Empatika. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface MoneyTrackerClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

@end
