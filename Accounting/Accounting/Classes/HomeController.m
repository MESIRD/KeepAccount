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
#import "DBService.h"
#import "ColorUtil.h"
#import "AccountingView.h"
#import "FontUtil.h"

@interface HomeController() <AccoutingViewDelegate>

@end

@implementation HomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
     self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[FontUtil defaultFontWithSize:22]}];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:50.0/255 green:54.0/255 blue:63.0/255 alpha:1] andSize:CGSizeMake(1, 1)] forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setTranslucent:NO];  //off color's resolution
    
    UIBarButtonItem *configButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"config_pic"] style:UIBarButtonItemStylePlain target:self action:@selector(showConfigurationView)];
    configButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = configButtonItem;
    
    UIBarButtonItem *newButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"new_pic"] style:UIBarButtonItemStylePlain target:self action:@selector(showNewRecordOptions)];
    newButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = newButtonItem;
    
    self.title = [[UserDefaultsService sharedUserDefaultsService] getPocketName];
    self.view.backgroundColor = [ColorUtil backgroundColor];
    
    //register notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changePocketName)     name:kUpdatePocketName    object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNewRecordOptions) name:kShowCreateNewRecord object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(displayEmptyView)     name:kHomeDataEmpty       object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideEmptyView)        name:kHomeDataNotEmpty    object:nil];
    
    //set subview nested view controller
    [self.recentRecordTV setViewNestedViewController:self];
    
    if ([_recentRecordTV getRecordCount] == 0) {
        _showEmptyView.hidden = NO;
    } else {
        _showEmptyView.hidden = YES;
    }
    
    //hide blur view
    self.blurEffectView.layer.opacity = 0.0f;
//    self.blurEffectView.hidden = YES;
    
    //test db
//    [DBService sharedDB];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)changePocketName {
    self.title = [[UserDefaultsService sharedUserDefaultsService] getPocketName];
}

#pragma -mark Navigation

- (void)showConfigurationView {
    UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:[SettingsViewController sharedSettingsViewController]];
    //set navigation bar attributes
    [naviController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:50.0/255 green:54.0/255 blue:63.0/255 alpha:1] andSize:CGSizeMake(1, 1)] forBarMetrics:UIBarMetricsDefault];
    [naviController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:22]}];
    [naviController.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    [self presentViewController:naviController animated:YES completion:nil];
}

- (void)showNewRecordOptions {
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"AccountingView" owner:self options:nil];
    AccountingView *view = [nibs objectAtIndex:0];
    view.delegate = self;
    [view setNestedViewController:self];
    [self.view addSubview:view];
    [view buttonsPopIn];
    [self.navigationController.navigationBar setUserInteractionEnabled:NO];
}

- (void)displayEmptyView {
    _showEmptyView.hidden = NO;
}

- (void)hideEmptyView {
    _showEmptyView.hidden = YES;
}

#pragma -mark AccoutingViewDelegate

- (void)accoutingViewWillShow {
    NSLog(@"accouting view will show");
    [UIView animateWithDuration:quickAnimationDuration animations:^{
        self.blurEffectView.layer.opacity = 1.0f;
    }];
}

- (void)accoutingViewShowed {
    NSLog(@"accouting view showed");
}

- (void)accoutingViewWillHide {
    NSLog(@"accouting view will hide");
    [UIView animateWithDuration:quickAnimationDuration animations:^{
        self.blurEffectView.layer.opacity = 0.0f;
    }];
}

- (void)accoutingViewHidden {
    NSLog(@"accouting view hidden");
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
