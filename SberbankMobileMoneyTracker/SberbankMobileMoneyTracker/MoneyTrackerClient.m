//
//  ServerClient.m
//  SberbankMobileMoneyTracker
//
//  Created by Ivan Oschepkov on 27.07.14.
//  Copyright (c) 2014 Empatika. All rights reserved.
//

#import "MoneyTrackerClient.h"

#define BASE_URL @"http://1-dot-sber-hackathon.appspot.com/"

@implementation MoneyTrackerClient

+ (instancetype)sharedClient {
    static MoneyTrackerClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[MoneyTrackerClient alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    });
    
    return _sharedClient;
}

@end
