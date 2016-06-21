//
//  URLUtil.m
//  Accounting
//
//  Created by mesird on 11/6/15.
//  Copyright © 2015 mesird. All rights reserved.
//

#import "URLUtil.h"

static NSString * const imageFolderName = @"catImg";

@implementation URLUtil

+ (NSString *)getCompletePathWithComponent:(NSString *)component {
    
    return [[URLUtil getDocumentDirectory] stringByAppendingPathComponent:component];
}

+ (NSString *)getCompleteImagePathWithComponent:(NSString *)component {
    return [[URLUtil getDocumentDirectory] stringByAppendingPathComponent:[imageFolderName stringByAppendingPathComponent:component]];
}

+ (NSString *)getCompleteImagePath {
    return [[URLUtil getDocumentDirectory] stringByAppendingPathComponent:imageFolderName];
}

+ (NSString *)getRelativeImagePathWithComponent:(NSString *)component {
    return [imageFolderName stringByAppendingString:component];
}

+ (NSString *)getDocumentDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

@end
