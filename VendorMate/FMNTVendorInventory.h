//
//  FMNTVendorInventory.h
//  VendorMate
//
//  Created by gyuyoung Hwang on 2017. 6. 4..
//  Copyright © 2017년 gyuyoung Hwang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SKPaymentTransaction;

@interface FMNTVendorInventory : NSObject

+ (instancetype)sharedInstance;
- (NSArray <SKPaymentTransaction *> *)purchasedTransactions;

@end
