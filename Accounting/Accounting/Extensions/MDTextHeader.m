//
//  MDTextRefreshHeader.m
//  Accounting
//
//  Created by mesird on 10/30/15.
//  Copyright © 2015 mesird. All rights reserved.
//

#import "MDTextHeader.h"

@interface MDTextHeader()

{
    NSString *idelTitle;
    NSString *pullingTitle;
    NSString *refreshingTitle;
}

@property (nonatomic, strong) UILabel *label;

@end

@implementation MDTextHeader

CGFloat w = 200;        //default width of label
CGFloat h = 40;         //default height of label

- (UILabel *)label {
    if ( !_label) {
        _label = [UILabel label];
        _label.textColor = [UIColor whiteColor];
        [self addSubview:_label];
    }
    return _label;
}

- (void)setIdelTitle:(NSString *)idel pullingTitle:(NSString *)pulling andRefreshingTitle:(NSString *)refreshing {
    idelTitle = [idel copy];
    pullingTitle = [pulling copy];
    refreshingTitle = [refreshing copy];
    self.label.text = idelTitle;
}

- (void)setLabelFont:(UIFont *)font {
    self.label.font = [font copy];
}

#pragma makr - Override
- (void)prepare {
    [super prepare];
}

- (void)placeSubviews {
    [super placeSubviews];
    
    CGFloat W = self.frame.size.width;
    CGFloat H = self.frame.size.height;
    //文字
    self.label.frame = CGRectMake((W-w)/2, (H-h)/2, w, h);
}

- (void)setState:(MJRefreshState)state {
    MJRefreshCheckState
    
    // 根据状态做事情
    if (state == MJRefreshStateIdle) {
        self.label.text = idelTitle;
    } else if (state == MJRefreshStateRefreshing) {
        self.label.text = refreshingTitle;
    } else if ( state == MJRefreshStatePulling) {
        self.label.text = pullingTitle;
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
