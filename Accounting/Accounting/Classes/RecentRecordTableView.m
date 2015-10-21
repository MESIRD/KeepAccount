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

@interface RecentRecordTableView()

@property (strong, nonatomic) OverviewView          *overviewView;
@property (strong, nonatomic) NSArray               *recentRecords;
@property (strong, nonatomic) HomeAccountingService *homeAccountingService;

@end

@implementation RecentRecordTableView

static NSString * reusableIdentifier = @"Recent Record";

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

- (void)awakeFromNib {
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if ( self) {
        [self fetchRecentRecordsFromLocal];
        self.dataSource = self;
        self.delegate = self;
        self.backgroundColor = [UIColor colorWithRed:50.0/255 green:54.0/255 blue:63.0/255 alpha:1];
        [self registerNib:[UINib nibWithNibName:@"RecordTableViewCell" bundle:nil] forCellReuseIdentifier:reusableIdentifier];
        _overviewView = [[[NSBundle mainBundle] loadNibNamed:@"Overview" owner:self options:nil] lastObject];
        self.tableHeaderView = _overviewView;
    }
    return self;
}

//UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.recentRecords count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusableIdentifier forIndexPath:indexPath];
    //configure cell
    cell.amount = [self.recentRecords[indexPath.row] amount];
    cell.category = [self.recentRecords[indexPath.row] category];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//

- (void)fetchRecentRecordsFromLocal {
    //mock data at present
    self.recentRecords = [self.homeAccountingService fetchRecentRecordFromLocal];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
