//
//  FMNTVendorProduct.h
//  VendorMate
//
//  Created by gyuyoung Hwang on 2017. 6. 6..
//  Copyright © 2017년 gyuyoung Hwang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SKProduct;

typedef void(^_Nullable FMNTRequestProductCompletionHandler)( NSArray <SKProduct *> * _Nullable products, NSError * _Nullable error);

@interface FMNTVendorProduct : NSObject

- (void)productsWithProductIds:(NSArray * _Nonnull)productIds completionHandler:(FMNTRequestProductCompletionHandler)completionHandler;

@end
