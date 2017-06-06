//
//  FMNTVendorProduct.m
//  VendorMate
//
//  Created by gyuyoung Hwang on 2017. 6. 6..
//  Copyright © 2017년 gyuyoung Hwang. All rights reserved.
//

#import "FMNTVendorProduct.h"
#import "FMNTConstant.h"
#import <StoreKit/SKProductsRequest.h>

@interface FMNTVendorProduct () <SKProductsRequestDelegate>

@property (nonatomic, copy) FMNTRequestProductCompletionHandler productCompletionHandler;

@end

@implementation FMNTVendorProduct

- (void)productsWithProductIds:(NSArray *)productIds completionHandler:(FMNTRequestProductCompletionHandler)completionHandler
{
    self.productCompletionHandler = completionHandler;
    
    NSSet *idsSet = [NSSet setWithArray:productIds];
    SKProductsRequest *productRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:idsSet];
    productRequest.delegate = self;
    
    NSLog(@"[AppStore] Attempt to request products");
    [productRequest start];
}

#pragma mark - SKProduct request delegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSLog(@"[AppStore] Did receive response for request products");
    NSLog(@"[AppStore] %tu valid products", [response.products count]);
    NSLog(@"[AppStore] %tu invalid products", [response.invalidProductIdentifiers count]);
    
    NSError *error = nil;
    if (!response ||
        !response.products ||
        ![response.products count]) {
        error = [NSError errorWithDomain:FMNTVendorRequestErrorDomain
                                    code:FMNTVendorRequestProductNoValidResult
                                userInfo:@{NSLocalizedDescriptionKey:@"Product ids are not valid. Check product ids"}];
    }
    
    if (self.productCompletionHandler) {
        self.productCompletionHandler([response.products copy], error);
        self.productCompletionHandler = nil;
    }
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"[AppStore] Failed to request products: %@", error.localizedDescription);
    
    if (self.productCompletionHandler) {
        NSError *theError = [NSError errorWithDomain:FMNTVendorRequestErrorDomain
                                                code:FMNTVendorRequestProductFailed
                                            userInfo:@{NSLocalizedDescriptionKey:error.localizedDescription,
                                                       NSUnderlyingErrorKey:error}];
        self.productCompletionHandler(nil, theError);
        self.productCompletionHandler = nil;
    }
}


@end
