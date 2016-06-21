//
//  SettingsViewController.m
//  Accounting
//
//  Created by mesird on 10/5/15.
//  Copyright © 2015 mesird. All rights reserved.
//

#import "SettingsViewController.h"
#import "UserDefaultsService.h"
#import "Constants.h"
#import "FontUtil.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

static SettingsViewController *sharedSettingsViewController;

+ (SettingsViewController *)sharedSettingsViewController {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Settings" bundle:[NSBundle mainBundle]];
        sharedSettingsViewController = [sb instantiateViewControllerWithIdentifier:@"Settings"];
        sharedSettingsViewController.title = @"设置";
        [sharedSettingsViewController.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[FontUtil defaultFontWithSize:22]}];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changePocketName) name:kUpdatePocketName object:nil];
        
        UIView *backButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
        UIButton *backTitleButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
        [backTitleButton addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
        UILabel *backButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
        backButtonLabel.text = [NSString stringWithFormat:@"<%@", [[UserDefaultsService sharedUserDefaultsService] getPocketName]];
        backButtonLabel.font = [FontUtil defaultFontWithSize:20];
        backButtonLabel.textColor = [UIColor whiteColor];
        [backButtonView addSubview:backButtonLabel];
        [backButtonView addSubview:backTitleButton];
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButtonView];
        sharedSettingsViewController.navigationItem.leftBarButtonItem = backButtonItem;
        
    });
    return sharedSettingsViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (void)dismissSelf {
    [sharedSettingsViewController dismissViewControllerAnimated:YES completion:nil];
}

+ (void)changePocketName {
    
    UIView *backButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
    UIButton *backTitleButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
    [backTitleButton addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
    UILabel *backButtonLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
    backButtonLabel.text = [NSString stringWithFormat:@"<%@", [[UserDefaultsService sharedUserDefaultsService] getPocketName]];
    backButtonLabel.font = [FontUtil defaultFontWithSize:20];
    backButtonLabel.textColor = [UIColor whiteColor];
    [backButtonView addSubview:backButtonLabel];
    [backButtonView addSubview:backTitleButton];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButtonView];
    sharedSettingsViewController.navigationItem.leftBarButtonItem = backButtonItem;
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
