//
//  FMNTConstant.h
//  VendorMate
//
//  Created by gyuyoung Hwang on 2017. 6. 7..
//  Copyright © 2017년 gyuyoung Hwang. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXTERN NSString *const FMNTVendorRequestErrorDomain;

typedef NS_ENUM(NSInteger, FMNTErrorCode) {
    FMNTVendorRequestProductFailed = -10,
    FMNTVendorRequestProductNoValidResult = -11,
};

@interface FMNTConstant : NSObject

@end
