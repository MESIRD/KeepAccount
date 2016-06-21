//
//  ImageUtil.m
//  Accounting
//
//  Created by mesird on 11/8/15.
//  Copyright © 2015 mesird. All rights reserved.
//

#import "ImageUtil.h"

@implementation ImageUtil

+ (NSData *)compressImage:(UIImage *)image withRate:(CGFloat)compressRate {
    return UIImageJPEGRepresentation(image, compressRate);
}

@end
