//
//  NumberUtil.m
//  Accounting
//
//  Created by mesird on 10/5/15.
//  Copyright © 2015 mesird. All rights reserved.
//

#import "NumberUtil.h"

@implementation NumberUtil

+ (NumberUtil *)sharedNumberUtil {
    
    static NumberUtil *sharedNumberUtil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ sharedNumberUtil = [[self alloc] init]; });
    return sharedNumberUtil;
}

+ (NSString *)centToYuan:(NSInteger)cent {
    float amount = cent * 1.0 / 100;
    return [NSString stringWithFormat:@"%.2f", amount];
}

+ (NSInteger)yuanToCent:(NSString *)yuan {
    //FIXME
    float amount = [yuan floatValue];
    return amount * 100;
}

+ (BOOL)isZero:(NSString *)amount {
    if ( [amount floatValue] == 0) {
        return YES;
    }
    return NO;
}

+ (BOOL)isNumber:(NSString *)amount {
    NSString *expression = @"^[0-9]+(.[0-9]{1,2})?$";
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", expression];
    BOOL testResult = [numberTest evaluateWithObject:amount];
    return testResult;
}

@end
