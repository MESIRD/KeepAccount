//
//  URLUtil.h
//  Accounting
//
//  Created by mesird on 11/6/15.
//  Copyright © 2015 mesird. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLUtil : NSObject

+ (NSString *)getCompletePathWithComponent:(NSString *)component;
+ (NSString *)getCompleteImagePathWithComponent:(NSString *)component;

+ (NSString *)getRelativeImagePathWithComponent:(NSString *)component;
+ (NSString *)getCompleteImagePath;


@end
