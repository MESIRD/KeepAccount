//
//  OverviewView.m
//  Accounting
//
//  Created by mesird on 10/4/15.
//  Copyright © 2015 mesird. All rights reserved.
//

#import "OverviewView.h"

@implementation OverviewView

- (instancetype)init {
    self = [super init];
    if ( self) {
        self.totalBalanceView.layer.cornerRadius = 5.0;
        self.totalBalanceView.layer.masksToBounds = YES;
        self.curMonthExpenditureLabel.text = @"2608.00";
        self.curMonthIncomeLabel.text = @"5900.00";
        self.balanceLabel.text = @"11111.00";
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if ( self) {
        self.totalBalanceView.layer.cornerRadius = 5.0;
        self.totalBalanceView.layer.masksToBounds = YES;
        self.curMonthExpenditureLabel.text = @"2608.00";
        self.curMonthIncomeLabel.text = @"5900.00";
        self.balanceLabel.text = @"11111.00";
    }
    return self;
}

- (void)awakeFromNib {
    self.totalBalanceView.layer.cornerRadius = 8.0;
    self.totalBalanceView.layer.masksToBounds = YES;
    self.curMonthExpenditureLabel.text = @"2608.00";
    self.curMonthIncomeLabel.text = @"5900.00";
    self.balanceLabel.text = @"11111.00";
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
