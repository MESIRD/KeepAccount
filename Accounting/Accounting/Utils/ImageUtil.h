//
//  ImageUtil.h
//  Accounting
//
//  Created by mesird on 11/8/15.
//  Copyright © 2015 mesird. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageUtil : NSObject

+ (NSData *)compressImage:(UIImage *)image withRate:(CGFloat)compressRate;

@end
