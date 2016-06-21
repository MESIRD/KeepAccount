//
//  ColorUtil.m
//  Accounting
//
//  Created by mesird on 11/2/15.
//  Copyright © 2015 mesird. All rights reserved.
//

#import "ColorUtil.h"

@implementation ColorUtil

+ (UIColor *)incomeColor {
    return [UIColor colorWithRed:124.0/255 green:182.0/255 blue:78.0/255 alpha:1];
}

+ (UIColor *)expenditureColor {
    return [UIColor colorWithRed:255.0/255 green:91.0/255 blue:67.0/255 alpha:1];
}

+ (UIColor *)backgroundColor {
    return [UIColor colorWithRed:50.0/255 green:54.0/255 blue:63.0/255 alpha:1];
}

+ (UIColor *)collectionCellColor {
    return [UIColor colorWithRed:35.0/255 green:35.0/255 blue:35.0/255 alpha:1];
}

+ (UIColor *)grayDivideLineColor {
    return [UIColor colorWithRed:85.0/255 green:88.0/255 blue:96.0/255 alpha:1];
}

+ (UIColor *)detailBlockBackgroundColor {
    return [UIColor colorWithRed:58.0/255 green:63.0/255 blue:76.0/255 alpha:1];
}

+ (UIColor *)darkBlueDivideLineColor {
    return [UIColor colorWithRed:48.0/255 green:53.0/255 blue:64.0/255 alpha:1];
}

+ (UIColor *)darkRedDivideLineColor {
    return [UIColor colorWithRed:216.0/255 green:67.0/255 blue:46.0/255 alpha:1];
}

+ (UIColor *)detailBlockTextColor {
    return [UIColor colorWithRed:192.0/255 green:199.0/255 blue:216.0/255 alpha:1];
}




+ (UIColor *)color:(UIColor *)color withTransparency:(CGFloat)transparency {

    CGColorRef cgColor = CGColorCreateCopyWithAlpha(color.CGColor, transparency);
    return [UIColor colorWithCGColor:cgColor];
}



@end
