//
//  OverviewView.m
//  Accounting
//
//  Created by mesird on 10/4/15.
//  Copyright © 2015 mesird. All rights reserved.
//

#import "OverviewView.h"
#import "HomeAccountingService.h"
#import "NumberUtil.h"
#import "UserDefaultsService.h"
#import "FontUtil.h"

@interface OverviewView()

@property (nonatomic, strong)   HomeAccountingService *homeAccountingService;

@end

@implementation OverviewView

- (HomeAccountingService *)homeAccountingService {
    if ( !_homeAccountingService) {
        _homeAccountingService = [[HomeAccountingService alloc] init];
    }
    return _homeAccountingService;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if ( self) {
        
    }
    return self;
}

- (void)awakeFromNib {
    //some initialization here
    
    //data initialization
    [self setData];
    
    //register notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresData) name:kRefreshHomeTableData object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresData) name:kClearUserAccountFlows object:nil];
    
}

- (void)layoutSubviews {
    
    self.totalBalanceView.layer.cornerRadius = 5.0;
    self.totalBalanceView.layer.masksToBounds = YES;
    
    _curMonthIncomeLabel.font = [FontUtil numberFontWithSize:16];
    _curMonthExpenditureLabel.font = [FontUtil numberFontWithSize:16];
    _balanceLabel.font = [FontUtil defaultFontWithSize:30];
    _moneySign.font = [FontUtil defaultFontWithSize:34];
    _curMonthIncomeSign.font = [FontUtil defaultFontWithSize:15];
    _curMonthExpenditureSign.font = [FontUtil defaultFontWithSize:15];
    _balanceSign.font = [FontUtil defaultFontWithSize:30];
}

- (void)refresData {
    [self setData];
}

- (void)setData {
    
    NSInteger pocketId = [[UserDefaultsService sharedUserDefaultsService] getPocketId];
    
    NSInteger pocketBalance = [self.homeAccountingService getCurrentPocketBalanceWithPocketId:pocketId];
    NSInteger curMonthIncome = [self.homeAccountingService getCurrentMonthIncomeWithPocketId:pocketId];
    NSInteger curMonthExpenditure = [self.homeAccountingService getCurrentMonthExpenditureWithPocketId:pocketId];
    
    self.curMonthExpenditureLabel.text = [NumberUtil centToYuan:curMonthExpenditure];
    self.curMonthIncomeLabel.text = [NumberUtil centToYuan:curMonthIncome];
    self.balanceLabel.text = [NumberUtil centToYuan:pocketBalance];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
