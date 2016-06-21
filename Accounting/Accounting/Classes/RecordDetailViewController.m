//
//  RecordDetailViewController.m
//  Accounting
//
//  Created by mesird on 12/2/15.
//  Copyright © 2015 mesird. All rights reserved.
//

#import "RecordDetailViewController.h"
#import "Record.h"
#import "Constants.h"
#import "URLUtil.h"
#import "NumberUtil.h"
#import "FontUtil.h"

@interface RecordDetailViewController ()

@property (strong, nonatomic) IBOutlet UILabel      *categoryAverageSign;
@property (strong, nonatomic) IBOutlet UILabel      *categoryOverallSign;
@property (strong, nonatomic) IBOutlet UIView       *categoryAverageView;
@property (strong, nonatomic) IBOutlet UIView       *categoryOverallView;
@property (strong, nonatomic) IBOutlet UILabel      *categoryAverageAmount;
@property (strong, nonatomic) IBOutlet UILabel      *categoryOverallAmount;

@property (strong, nonatomic) IBOutlet UIImageView  *categoryImage;
@property (strong, nonatomic) IBOutlet UILabel      *categoryName;
@property (strong, nonatomic) IBOutlet UILabel      *recordTime;
@property (strong, nonatomic) IBOutlet UILabel      *recordAmount;
@property (strong, nonatomic) IBOutlet UILabel      *recordDescription;
@property (strong, nonatomic) IBOutlet UIView       *recordView;

@property (strong, nonatomic) IBOutlet UILabel      *recordImageSign;
@property (strong, nonatomic) IBOutlet UILabel      *recordImageReminderSign;
@property (strong, nonatomic) IBOutlet UIImageView  *recordImage;
@property (strong, nonatomic) IBOutlet UIView       *recordImageView;

@property (strong, nonatomic) IBOutlet UIView       *reccordTopDivideLineView;
@property (strong, nonatomic) IBOutlet UIView       *recordBottomDivideLineView;



@property (strong, nonatomic) Record *record;

@end

@implementation RecordDetailViewController

- (void)setRecord:(Record *)record {
    _record = record;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImage *catImage;
    if ( _record.catImgSource == ImageSourceBundle) {
        catImage = [UIImage imageNamed:[_record categoryImageUrl]];
    } else if ( _record.catImgSource == ImageSourceDocument) {
        catImage = [[UIImage alloc] initWithContentsOfFile:[URLUtil getCompleteImagePathWithComponent:[_record categoryImageUrl]]];
    }
    
    _categoryImage.image = catImage;
    _categoryName.text = _record.categoryName;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy/MM/dd hh:mm"];
    _recordTime.text = [df stringFromDate:_record.gmtCreate];
    _recordAmount.text = [NumberUtil centToYuan:_record.amount];
    
    UIImage *recImage;
    if ( _record.recImgSource == ImageSourceBundle) {
        recImage = [UIImage imageNamed:[_record imgUrl]];
    } else if ( _record.recImgSource == ImageSourceDocument) {
        recImage = [[UIImage alloc] initWithContentsOfFile:[URLUtil getCompleteImagePathWithComponent:[_record imgUrl]]];
    }
    _recordImage.image = recImage;
    _recordDescription.text = _record.recDescription;
    
    if ( _record.budgetType == BudgetTypeIncome) {
        self.title = @"收入详情";
    } else if ( _record.budgetType == BudgetTypeExpenditure) {
        self.title = @"支出详情";
    }
    
    if ( _record.)
}

- (void)viewDidLayoutSubviews {
    
    _categoryAverageSign.font = [FontUtil defaultFontWithSize:16];
    _categoryOverallSign.font = [FontUtil defaultFontWithSize:16];
    
    _categoryAverageAmount.font = [FontUtil numberFontWithSize:48];
    _categoryOverallAmount.font = [FontUtil numberFontWithSize:48];
    
    _categoryName.font = [FontUtil defaultFontWithSize:18];
    _recordTime.font = [FontUtil defaultFontWithSize:14];
    _recordAmount.font = [FontUtil numberFontWithSize:96];
    _recordDescription.font = [FontUtil defaultFontWithSize:14];
    
    _recordImageSign.font = [FontUtil defaultFontWithSize:16];
    _recordImageReminderSign.font = [FontUtil defaultFontWithSize:16];
    
    [self configView:_recordView];
    [self configView:_recordImageView];
    [self configView:_categoryAverageView];
    [self configView:_categoryOverallView];
    
}

- (void)configView:(UIView *)view {
    view.layer.cornerRadius = 5.0f;
    view.layer.masksToBounds = YES;
}

- (void)awakeFromNib {

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
