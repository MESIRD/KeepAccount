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

@interface SettingsViewController ()

@property (strong, nonatomic) UIBarButtonItem *backButtonItem;

@end

@implementation SettingsViewController

static SettingsViewController *sharedSettingsViewController;

+ (SettingsViewController *)sharedSettingsViewController {
    if ( !sharedSettingsViewController) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Settings" bundle:[NSBundle mainBundle]];
        sharedSettingsViewController = [sb instantiateViewControllerWithIdentifier:@"Settings"];
        sharedSettingsViewController.title = @"设置";
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changePocketName) name:kUpdatePocketName object:nil];
        
        NSString *pocketName = [[UserDefaultsService sharedUserDefaultsService] getPocketName];
        sharedSettingsViewController.backButtonItem = [[UIBarButtonItem alloc] initWithTitle:pocketName style:UIBarButtonItemStyleDone target:self action:@selector(dismissSelf)];
        sharedSettingsViewController.backButtonItem.tintColor = [UIColor whiteColor];
        sharedSettingsViewController.navigationItem.leftBarButtonItem = sharedSettingsViewController.backButtonItem;
    }
    return sharedSettingsViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSString *pocketName = [[UserDefaultsService sharedUserDefaultsService] getPocketName];
    sharedSettingsViewController.backButtonItem.possibleTitles = [NSSet setWithObject:pocketName];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (void)dismissSelf {
    [sharedSettingsViewController dismissViewControllerAnimated:YES completion:nil];
}

+ (void)changePocketName {
    
    NSString *pocketName = [[UserDefaultsService sharedUserDefaultsService] getPocketName];
    sharedSettingsViewController.backButtonItem = [[UIBarButtonItem alloc] initWithTitle:pocketName style:UIBarButtonItemStyleDone target:self action:@selector(dismissSelf)];
    sharedSettingsViewController.backButtonItem.tintColor = [UIColor whiteColor];
    sharedSettingsViewController.navigationItem.leftBarButtonItem = sharedSettingsViewController.backButtonItem;
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
