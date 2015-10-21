//
//  NumberUtil.m
//  Accounting
//
//  Created by mesird on 10/5/15.
//  Copyright © 2015 mesird. All rights reserved.
//

#import "NumberUtil.h"

@implementation NumberUtil

static NumberUtil *sharedNumberUtil;

+ (NumberUtil *)sharedNumberUtil {
    if ( !sharedNumberUtil) {
        sharedNumberUtil = [[NumberUtil alloc] init];
    }
    return sharedNumberUtil;
}

+ (NSString *)centToYuan:(NSInteger)cent {
    
    double amount = cent * 1.0 / 100;
    return [NSString stringWithFormat:@"%.2f", amount];
}

@end
