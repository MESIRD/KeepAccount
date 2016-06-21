//
//  ColorUtil.h
//  Accounting
//
//  Created by mesird on 11/2/15.
//  Copyright © 2015 mesird. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColorUtil : NSObject

+ (UIColor *)incomeColor;
+ (UIColor *)expenditureColor;
+ (UIColor *)backgroundColor;
+ (UIColor *)collectionCellColor;
+ (UIColor *)grayDivideLineColor;
+ (UIColor *)detailBlockBackgroundColor;
+ (UIColor *)darkBlueDivideLineColor;
+ (UIColor *)darkRedDivideLineColor;
+ (UIColor *)detailBlockTextColor;

+ (UIColor *)color:(UIColor *)color withTransparency:(CGFloat)transparency;

@end
