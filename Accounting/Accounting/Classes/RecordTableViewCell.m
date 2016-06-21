//
//  RecordTableViewCell.m
//  Accounting
//
//  Created by mesird on 10/4/15.
//  Copyright © 2015 mesird. All rights reserved.
//

#import "RecordTableViewCell.h"
#import "UIImage+Color.h"
#import "ColorUtil.h"
#import "NumberUtil.h"
#import "FontUtil.h"

@implementation RecordTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)layoutSubviews {
    _amountLabel.font = [FontUtil numberFontWithSize:36];
    _categoryLabel.font = [FontUtil defaultFontWithSize:20];
    _moneySign.font = [FontUtil defaultFontWithSize:17];
    _recordDescription.font = [FontUtil defaultFontWithSize:14];
    _recordDescription.textColor = [UIColor whiteColor];
    _recordDateTime.font = [FontUtil defaultFontWithSize:14];
    _divideLine.image = [UIImage imageWithColor:[ColorUtil grayDivideLineColor] andSize:CGSizeMake(1, 1)];
    self.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
