//
//  NumberUtil.h
//  Accounting
//
//  Created by mesird on 10/5/15.
//  Copyright © 2015 mesird. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NumberUtil : NSObject

+ (NumberUtil *)sharedNumberUtil;
+ (NSString *)centToYuan:(NSInteger)cent;

@end
