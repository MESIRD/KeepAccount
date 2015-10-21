//
//  UIImage+Color.m
//  Accounting
//
//  Created by mesird on 10/7/15.
//  Copyright © 2015 mesird. All rights reserved.
//

#import "UIImage+Color.h"

@implementation UIImage (Color)

+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [color setFill];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
