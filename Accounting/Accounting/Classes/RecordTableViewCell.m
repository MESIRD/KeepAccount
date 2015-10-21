//
//  RecordTableViewCell.m
//  Accounting
//
//  Created by mesird on 10/4/15.
//  Copyright © 2015 mesird. All rights reserved.
//

#import "RecordTableViewCell.h"
#import "NumberUtil.h"

@implementation RecordTableViewCell

- (void)setAmount:(NSInteger)amount {
    _amount = amount;
    _amountLabel.text = [NumberUtil centToYuan:amount];
}

- (void)setCategory:(NSString *)category {
    _category = category;
    _categoryLabel.text = category;
}

- (void)awakeFromNib {
    // Initialization code
    
    self.categoryView.layer.cornerRadius = self.categoryView.layer.bounds.size.height/2;
    self.categoryView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
