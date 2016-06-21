//
//  RecentRecordTableView.m
//  Accounting
//
//  Created by mesird on 10/5/15.
//  Copyright © 2015 mesird. All rights reserved.
//

#import "RecentRecordTableView.h"
#import "OverviewView.h"
#import "Record.h"
#import "RecordTableViewCell.h"
#import "HomeAccountingService.h"
#import "RecordDetailViewController.h"
#import "MJRefresh.h"
#import "Constants.h"
#import "MDTextHeader.h"
#import "NumberUtil.h"
#import "ColorUtil.h"
#import "URLUtil.h"
#import "HomeController.h"
#import "UIImage+Color.h"
#import "FontUtil.h"

@interface RecentRecordTableView()

@property (strong, nonatomic) OverviewView          *overviewView;
@property (strong, nonatomic) NSArray               *recentRecords;
@property (strong, nonatomic) HomeAccountingService *homeAccountingService;

@property (weak, nonatomic)          HomeController *nestedViewController;
@end

@implementation RecentRecordTableView

static NSString * reusableIdentifier = @"Recent Record";

#pragma -mark Parameters Lazy Initialization

- (HomeAccountingService *)homeAccountingService {
    if ( _homeAccountingService == nil) {
        _homeAccountingService = [[HomeAccountingService alloc] init];
    }
    return _homeAccountingService;
}

- (void)setRecentRecords:(NSArray *)recentRecords {
    _recentRecords = recentRecords;
    [self reloadData];
}

- (void)setViewNestedViewController:(UIViewController *)vc {
    _nestedViewController = (HomeController *)vc;
}

- (NSInteger)getRecordCount {
    return _recentRecords.count;
}

#pragma -mark Initialization

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if ( self) {
        [self fetchRecentRecordsFromLocal];
        self.dataSource = self;
        self.delegate = self;
        self.backgroundColor = [UIColor clearColor];
//        self.backgroundColor = [UIColor colorWithRed:50.0/255 green:54.0/255 blue:63.0/255 alpha:1];
        self.tableFooterView = [[UIView alloc] init];
        [self registerNib:[UINib nibWithNibName:@"RecordTableViewCell" bundle:nil] forCellReuseIdentifier:reusableIdentifier];
        _overviewView = [[[NSBundle mainBundle] loadNibNamed:@"Overview" owner:self options:nil] lastObject];
        self.tableHeaderView = _overviewView;
        
        //register notifications
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchRecentRecordsFromLocal) name:kRefreshHomeTableData  object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchRecentRecordsFromLocal) name:kClearUserAccountFlows object:nil];
        
        //set pull down function
        MDTextHeader *header = [MDTextHeader headerWithRefreshingTarget:self refreshingAction:@selector(showNewRecordOptions)];
        [header setLabelFont:[FontUtil defaultFontWithSize:14]];
        [header setIdelTitle:@"下拉创建新账单" pullingTitle:@"释放完成创建" andRefreshingTitle:@"正在创建..."];
        self.header = header;
    }
    return self;
}


#pragma -mark Create new

- (void)showNewRecordOptions {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kShowCreateNewRecord object:nil];
    [self.header endRefreshing];
}

#pragma -mark UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.recentRecords count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusableIdentifier forIndexPath:indexPath];
    //configure cell
    Record *record = (Record *)self.recentRecords[indexPath.row];
    cell.amountLabel.text = [NumberUtil centToYuan:record.amount];
    cell.categoryLabel.text = record.categoryName;
    cell.recordDescription.text = record.recDescription;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"mm:ss"];
    cell.recordDateTime.text = [dateFormatter stringFromDate:record.gmtCreate];
    if ( record.budgetType == BudgetTypeIncome) {
        cell.amountLabel.textColor = [ColorUtil incomeColor];
    } else if (record.budgetType == BudgetTypeExpenditure) {
        cell.amountLabel.textColor = [ColorUtil expenditureColor];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64.5f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Record *record = (Record *)self.recentRecords[indexPath.row];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Home" bundle:[NSBundle mainBundle]];
    RecordDetailViewController *rdvc = [sb instantiateViewControllerWithIdentifier:@"RecordDetailViewController"];
    [rdvc setRecord:record];
    [self.nestedViewController.navigationController pushViewController:rdvc animated:YES];
}

#pragma -mark Data Operation

- (void)fetchRecentRecordsFromLocal {
    
    self.recentRecords = [self.homeAccountingService fetchRecentRecordsFromLocal];
    if ( self.recentRecords.count == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kHomeDataEmpty object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kHomeDataNotEmpty object:nil];
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
