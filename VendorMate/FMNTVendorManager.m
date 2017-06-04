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

#pragma mark - External

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[FMNTVendorManager alloc] init];
    });
    return sharedInstance;
}

- (void)productsWithProductIds:(NSArray *)productIds completionHandler:(void(^)(NSArray <SKProduct *> *products, NSError *error))completionHandler
{
    
}

- (void)purchaseProductWithProductId:(NSString *)productId applicationUsername:(NSString *)username completionHandler:(void(^)(NSString *transactionId, NSString *receipt, NSError *error))completionHandler
{
    
}

- (void)receiptWithCompletionHandler:(void(^)(NSString *receipt, NSError *error))completionHandler
{
    
}

- (void)consumeProductWithTransactionId:(NSString *)transactionId completionHandler:(void(^)(NSError * error))completionHandler
{
    
}

- (void)purchasedTransactionWithCompletionHandler:(void (^)(NSArray<SKPaymentTransaction *> *))completionHandler
{
    NSArray *transactions = [[FMNTVendorInventory sharedInstance] purchasedTransactions];
    
    if (completionHandler) {
        completionHandler(transactions);
    }
}

#pragma mark - Internal

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
