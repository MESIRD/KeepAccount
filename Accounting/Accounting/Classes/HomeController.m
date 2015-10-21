//
//  HomeController.m
//  Accounting
//
//  Created by mesird on 10/3/15.
//  Copyright © 2015 mesird. All rights reserved.
//

#import "HomeController.h"
#import "UserDefaultsService.h"
#import "SettingsViewController.h"
#import "UIImage+Color.h"
#import "Constants.h"

@implementation HomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:22]}];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:50.0/255 green:54.0/255 blue:63.0/255 alpha:1] andSize:CGSizeMake(1, 1)] forBarMetrics:UIBarMetricsDefault];
    
//    [self.navigationController.navigationBar setTranslucent:NO];  //off color's resolution
    
    UIBarButtonItem *configButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"config_pic"] style:UIBarButtonItemStylePlain target:self action:@selector(showConfigurationView)];
    configButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = configButtonItem;
    
    UIBarButtonItem *newButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"new_pic"] style:UIBarButtonItemStylePlain target:self action:@selector(showNewRecordView)];
    newButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = newButtonItem;
    
    self.title = [[UserDefaultsService sharedUserDefaultsService] getPocketName];
    
    //register notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changePocketName) name:kUpdatePocketName object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)changePocketName {
    self.title = [[UserDefaultsService sharedUserDefaultsService] getPocketName];
}

- (void)showConfigurationView {
    UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:[SettingsViewController sharedSettingsViewController]];
    //set navigation bar attributes
    [naviController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:50.0/255 green:54.0/255 blue:63.0/255 alpha:1] andSize:CGSizeMake(1, 1)] forBarMetrics:UIBarMetricsDefault];
    [naviController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:22]}];
    [naviController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    [self presentViewController:naviController animated:YES completion:nil];
}

- (void)showNewRecordView {
    
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
