//
//  FMNTVendorManager.m
//  VendorMate
//
//  Created by gyuyoung Hwang on 2017. 6. 4..
//  Copyright © 2017년 gyuyoung Hwang. All rights reserved.
//

#import "FMNTVendorManager.h"
#import "FMNTVendorInventory.h"

@implementation FMNTVendorManager

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[FMNTVendorManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        // initailize vendor inventory
        [FMNTVendorInventory sharedInstance];
    }
    return self;
}

@end
