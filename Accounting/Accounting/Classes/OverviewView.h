//
//  OverviewView.h
//  Accounting
//
//  Created by mesird on 10/4/15.
//  Copyright © 2015 mesird. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OverviewView : UIView

@property (strong, nonatomic) IBOutlet UILabel *curMonthIncomeLabel;
@property (strong, nonatomic) IBOutlet UILabel *curMonthExpenditureLabel;
@property (strong, nonatomic) IBOutlet UILabel *balanceLabel;
@property (strong, nonatomic) IBOutlet UILabel *curMonthIncomeSign;
@property (strong, nonatomic) IBOutlet UILabel *curMonthExpenditureSign;
@property (strong, nonatomic) IBOutlet UILabel *moneySign;
@property (strong, nonatomic) IBOutlet UILabel *balanceSign;
@property (strong, nonatomic) IBOutlet UIView  *totalBalanceView;

@end
