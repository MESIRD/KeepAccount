//
//  FontUtil.m
//  Accounting
//
//  Created by mesird on 11/27/15.
//  Copyright © 2015 mesird. All rights reserved.
//

#import "FontUtil.h"

@implementation FontUtil

+ (UIFont *)defaultFontWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"RTWS YueRoundedGothic G0v1" size:size];
}

+ (UIFont *)numberFontWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"DINCondensedC" size:size];
}

@end
