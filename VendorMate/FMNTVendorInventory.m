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

@property (nonatomic, strong) NSMutableArray<SKPaymentTransaction *> *vendorTransactions;

@end

@implementation FMNTVendorInventory

#pragma mark - External

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[FMNTVendorInventory alloc] init];
    });
    return sharedInstance;
}

- (NSArray <SKPaymentTransaction *> *)purchasedTransactions
{
    NSMutableArray *transactions = [NSMutableArray array];
    for (SKPaymentTransaction *transaction in self.vendorTransactions) {
        if (transaction.transactionState == SKPaymentTransactionStatePurchased) {
            [transactions addObject:transaction];
        }
    }
    return [transactions copy];
}

#pragma mark - Internal

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
    // without transaction id
    // OR no stored transaction
    if (!transaction.transactionIdentifier ||
        ![self.vendorTransactions count]) {
        [self.vendorTransactions addObject:transaction];
        return;
    }
    
    // not to duplicate
    BOOL hasTransaction = NO;
    NSUInteger index = 0;
    for (NSUInteger i = 0; i < [self.vendorTransactions count]; i++) {
        SKPaymentTransaction *theTransaction = [self.vendorTransactions objectAtIndex:i];
        if ([theTransaction.transactionIdentifier isEqualToString:transaction.transactionIdentifier]) {
            index = i;
            hasTransaction = YES;
            break;
        }
    }
    if (hasTransaction) {
        [self.vendorTransactions replaceObjectAtIndex:index withObject:transaction];
        return;
    }
    
    [self.vendorTransactions addObject:transaction];
}

- (void)removeTransactionOfTransaction:(SKPaymentTransaction *)transaction
{
    if (transaction) {
        [self.vendorTransactions removeObject:transaction];
    }
}

- (void)removeTransactionOfTransactionId:(NSString *)transactionId
{
    // search
    SKPaymentTransaction *removedTransaction;
    for (SKPaymentTransaction *transaction in self.vendorTransactions) {
        if ([transaction.payment.productIdentifier isEqualToString:transactionId]) {
            removedTransaction = transaction;
            break;
        }
    }
    
    // remove
    if (removedTransaction) {
        [self.vendorTransactions removeObject:removedTransaction];
    }
}

- (NSString *)description
{
    NSMutableString *description = [[NSMutableString alloc] init];
    [description appendString:@"++++++++++++++++++++++++++++++++++++++++++"];
    [description appendFormat:@"[Inventory] %tu transactions are stored", [self.vendorTransactions count]];
    if (self.vendorTransactions &&
        [self.vendorTransactions count]) {
        for (SKPaymentTransaction *transaction in self.vendorTransactions) {
            [description appendFormat:@"[Inventory] transaction: %@", [self descriptionOfTransaction:transaction]];
        }
    }
    [description appendString:@"++++++++++++++++++++++++++++++++++++++++++"];
    return [description copy];
}

#pragma mark - SKPayment Transaction Delegate
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions
{
    NSLog(@"[AppStore] %tu txs were updated from vendor", [transactions count]);
    for (SKPaymentTransaction *transaction in transactions) {
        
        NSLog(@"[AppStore] will update transaction: %@", [self descriptionOfTransaction:transaction]);
        
        // store
        [self addTransactionWithTransaction:transaction];
    }
    NSLog(@"[AppStore] did finish update transactions \n%@", [self description]);
}

- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray<SKPaymentTransaction *> *)transactions
{
    NSLog(@"[AppStore] %tu transactions were removed from vendor", [transactions count]);
    for (SKPaymentTransaction *transaction in transactions) {
        NSLog(@"[AppStore] will remove transaction, %@", [self descriptionOfTransaction:transaction]);

        // remove
        [self removeTransactionOfTransaction:transaction];
    }
    NSLog(@"[AppStore] did finish remove transactions \n%@", [self description]);
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
