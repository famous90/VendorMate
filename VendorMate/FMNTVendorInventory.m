//
//  FMNTVendorInventory.m
//  VendorMate
//
//  Created by gyuyoung Hwang on 2017. 6. 4..
//  Copyright © 2017년 gyuyoung Hwang. All rights reserved.
//

#import "FMNTVendorInventory.h"
#import <StoreKit/StoreKit.h>

@interface FMNTVendorInventory () <SKPaymentTransactionObserver>

@property (nonatomic, strong) NSMutableArray *vendorTransactions;

@end

@implementation FMNTVendorInventory

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[FMNTVendorInventory alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _vendorTransactions = [NSMutableArray array];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}

- (void)dealloc
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

- (void)addTransactionWithTransaction:(SKPaymentTransaction *)transaction
{
    
}

- (void)removeTransactionOfTransactionId:(NSString *)transactionId
{
    
}

#pragma mark - SKPayment Transaction Delegate
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions
{
    NSLog(@"[AppStore] %tu txs were updated from vendor", transactions.count);
    for (SKPaymentTransaction *transaction in transactions) {
        
        NSLog(@"[AppStore] will update tx: %@", [self descriptionOfTransaction:transaction]);
        SKPaymentTransactionState transactionState = transaction.transactionState;
        
        // storing transactions
        [self addTransactionToInventory:transaction];
        
        // neccesary state : purchased, failed, restored. not use: purchasing, deferred.
        if (transactionState == SKPaymentTransactionStatePurchased ||
            transactionState == SKPaymentTransactionStateFailed ||
            transactionState == SKPaymentTransactionStateRestored) {
            
            // paying transaction
            if (self.paymentProductId &&
                [transaction.payment.productIdentifier isEqualToString:self.paymentProductId]) {
                if (self.paymentCompletion) {
                    self.paymentCompletion(transaction);
                    self.paymentProductId = nil;
                    self.paymentCompletion = nil;
                }
            }
        }
    }
    [self description];
}

- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray<SKPaymentTransaction *> *)transactions
{
    
}

#pragma mark - SKPayment Transaction
- (NSString *)descriptionOfTransaction:(SKPaymentTransaction *)transaction
{
    // check nil
    if (!transaction) {
        return @"(nil)";
    }

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:(transaction.transactionIdentifier ? : @"(nil)") forKey:@"transaction_id"];
    [dic setValue:@(transaction.transactionState) forKey:@"state"];
    [dic setValue:(transaction.transactionDate ? : @"(nil)") forKey:@"date"];
    [dic setValue:(transaction.error.localizedDescription ? : @"(nil)") forKey:@"error"];
    
    if (!transaction.payment) {
        return [dic description];
    }
    
    [dic setValue:(transaction.payment.productIdentifier ? : @"(nil)") forKey:@"product_id"];
    [dic setValue:@(transaction.payment.quantity) forKey:@"quantity"];
    [dic setValue:(transaction.payment.applicationUsername? : @"(nil)") forKey:@"application_username"];
    
    return [dic description];
}

@end
