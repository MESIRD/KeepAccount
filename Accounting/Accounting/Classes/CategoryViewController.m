//
//  CategoryViewController.m
//  Accounting
//
//  Created by mesird on 11/8/15.
//  Copyright © 2015 mesird. All rights reserved.
//

#import "CategoryViewController.h"
#import "SettingsCategoryCollectionView.h"
#import "SVProgressHUD.h"
#import "FontUtil.h"

@interface CategoryViewController ()

@property (nonatomic, strong) SettingsCategoryCollectionView *collectionView;

@end

@implementation CategoryViewController


- (instancetype)initWithBudgetType:(BudgetType)type andFrame:(CGRect)frame {
    self = [super init];
    if ( self) {
        
        if ( type == BudgetTypeIncome) {
            self.title = @"收入类目";
        } else {
            self.title = @"支出类目";
        }
        self.view.frame = frame;
        
        //init collection view
        CGSize itemSize = CGSizeMake(80, 100);
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = itemSize;
        layout.minimumLineSpacing = 30;
        layout.minimumInteritemSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(10, 50, 10, 50);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[SettingsCategoryCollectionView alloc] initWithBudgetType:type frame:frame andLayout:layout];
        [_collectionView setNestedViewController:self];
        [self.view addSubview:_collectionView];
        
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editingMode)];
        [editButton setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[FontUtil defaultFontWithSize:20]} forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = editButton;
        [self.navigationItem.backBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[FontUtil defaultFontWithSize:20]} forState:UIControlStateNormal];
        
        //register notification
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRightItemButton:) name:kCategoryCollectionChangeRightButton object:nil];
    }
    return self;
}

- (void)viewWillLayoutSubviews {
    
}

- (void)viewDidLayoutSubviews {
    
}

- (void)editingMode {
    [_collectionView editingMode];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
    [cancelButton setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[FontUtil defaultFontWithSize:20]} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = cancelButton;
}

- (void)cancelAction {
    [_collectionView cancelAction];
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editingMode)];
    [editButton setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[FontUtil defaultFontWithSize:20]} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = editButton;
}

- (void)deleteAction {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"删除选中的类目?" message:@"(同时会删除类目对应的账目记录)" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([_collectionView deleteAction]) {
            [SVProgressHUD showSuccessWithStatus:@"删除类目成功!"];
        }
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editingMode)];
        [editButton setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = editButton;
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:sureAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)changeRightItemButton:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    RightButtonType rightButtonType = [[userInfo objectForKey:@"RightButtonType"] integerValue];
    if ( rightButtonType == RightButtonTypeEdit) {
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editingMode)];
        [editButton setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = editButton;
    } else if ( rightButtonType == RightButtonTypeCancel) {
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
        [cancelButton setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = cancelButton;
    } else if ( rightButtonType == RightButtonTypeDelete) {
        UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(deleteAction)];
        [deleteButton setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = deleteButton;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
