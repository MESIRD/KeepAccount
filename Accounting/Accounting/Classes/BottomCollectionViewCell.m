//
//  BottomCollectionViewCell.m
//  Accounting
//
//  Created by mesird on 11/3/15.
//  Copyright © 2015 mesird. All rights reserved.
//

#import "BottomCollectionViewCell.h"

@interface BottomCollectionViewCell()

@end

@implementation BottomCollectionViewCell


//designated initializer
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if ( self) {
        _catImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
        _catImage.layer.cornerRadius  = 5.0f;
        _catImage.layer.masksToBounds = YES;
        [self addSubview:_catImage];
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 78, 80, 20)];
        _label.textColor = [UIColor whiteColor];
        _label.font = [UIFont systemFontOfSize:14];
        _label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_label];
    }
    return self;
}

@end
