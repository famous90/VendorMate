//
//  FMNTVendorManager.h
//  VendorMate
//
//  Created by gyuyoung Hwang on 2017. 6. 4..
//  Copyright © 2017년 gyuyoung Hwang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SKProduct;
@class SKPaymentTransaction;

@interface FMNTVendorManager : NSObject

+ (instancetype)sharedInstance;
- (void)productsWithProductIds:(NSArray *)productIds completionHandler:(void(^)(NSArray <SKProduct *> *products, NSError *error))completionHandler;
- (void)purchaseProductWithProductId:(NSString *)productId applicationUsername:(NSString *)username completionHandler:(void(^)(NSString *transactionId, NSString *receipt, NSError *error))completionHandler;
- (void)receiptWithCompletionHandler:(void(^)(NSString *receipt, NSError *error))completionHandler;
- (void)consumeProductWithTransactionId:(NSString *)transactionId completionHandler:(void(^)(NSError * error))completionHandler;
- (void)purchasedTransactionWithCompletionHandler:(void(^)(NSArray<SKPaymentTransaction *> *transactions))completionHandler;

@end
