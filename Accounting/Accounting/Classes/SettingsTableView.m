//
//  SettingsTableView.m
//  Accounting
//
//  Created by mesird on 10/5/15.
//  Copyright © 2015 mesird. All rights reserved.
//

#import "SettingsTableView.h"
#import "UserDefaultsService.h"
#import "NumberUtil.h"
#import "SettingsService.h"
#import "SettingsFunctionalTableViewCell.h"
#import "SettingsViewController.h"
#import "CategoryViewController.h"
#import "Constants.h"
#import "SVProgressHUD.h"

@interface SettingsTableView()

@property (strong, nonatomic) NSArray           *settingsOptions;
@property (strong, nonatomic) SettingsService   *settingsService;

@end

@implementation SettingsTableView

static NSString *menuReusableIdentifier     = @"Settings Option";
static NSString *functionReusableIdentifier = @"Fuctional Option";
static NSString *menuDisplayNames           = @"SettingsMenuOptionDisplayNames";
static NSString *functionDisplayNames       = @"SettingsFunctionalOptionDisplayNames";

- (SettingsService *)settingsService {
    if ( !_settingsService) {
        _settingsService = [[SettingsService alloc] init];
    }
    return _settingsService;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if ( self) {
        NSString *optionPath = [[NSBundle mainBundle] pathForResource:@"SettingsMenuOption" ofType:@"plist"];
        if ( optionPath) {
            NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:optionPath];
            
            NSMutableArray *menuOptionNames = [data objectForKey:menuDisplayNames];
            NSMutableArray *functionOptionNames = [data objectForKey:functionDisplayNames];
            self.settingsOptions = @[menuOptionNames, functionOptionNames];
        }
        self.delegate        = self;
        self.dataSource      = self;
        self.tableFooterView = [[UIView alloc] init];       //hide superfluous cells
        self.scrollEnabled   = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableData) name:kUpdatePocketName object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableData) name:kCategoryCollectionDeleted object:nil];
    }
    return self;
}

- (void)refreshTableData {
    [self reloadData];
}

#pragma -mark table view delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.settingsOptions[section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.settingsOptions count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [tableView headerViewForSection:section];
    if ( headerView == nil) {
        headerView = [[UIView alloc] init];
    }
    [headerView setBackgroundColor:[UIColor clearColor]];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ( indexPath.section == 0) {
        //normal options
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:menuReusableIdentifier forIndexPath:indexPath];
        if ( !cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:menuReusableIdentifier];
        }
        cell.textLabel.text = self.settingsOptions[indexPath.section][indexPath.row];
        if ( indexPath.row == 0) {
            //pocket name
            NSString *pocketName = [[UserDefaultsService sharedUserDefaultsService] getPocketName];
            cell.detailTextLabel.text = pocketName;
        } else if ( indexPath.row == 1) {
            //income category
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", (long)[self.settingsService countCategory:BudgetTypeIncome]];
        } else if ( indexPath.row == 2) {
            //expenditure category
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld", (long)[self.settingsService countCategory:BudgetTypeExpenditure]];
        } else if ( indexPath.row == 3) {
            //Income Expenditure Charts
            cell.detailTextLabel.text = @"";
        }
        return cell;
    } else if ( indexPath.section == 1) {
        //functional options
        SettingsFunctionalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:functionReusableIdentifier];
        cell.functionNameLabel.text = self.settingsOptions[indexPath.section][indexPath.row];
        if ( indexPath.row == 0) {
            //clear data
            cell.functionNameLabel.textColor = [UIColor whiteColor];
            cell.backgroundColor = [UIColor colorWithRed:255.0/255 green:90.0/255 blue:67.0/255 alpha:1];
        }
        return cell;
    }
    return [[UITableViewCell alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ( indexPath.section == 0) {
        //normal options
        if ( indexPath.row == 0) {
            //pocket name
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Settings" bundle:[NSBundle mainBundle]];
            UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"PocketNameViewController"];
            [[SettingsViewController sharedSettingsViewController].navigationController pushViewController:vc animated:YES];
        } else if ( indexPath.row == 1) {
            //income category
            CGRect frame = self.frame;
            frame.size.height -= [SettingsViewController sharedSettingsViewController].navigationController.navigationBar.frame.size.height;
            frame.size.height -= [[UIApplication sharedApplication] statusBarFrame].size.height;
            
            CategoryViewController *vc = [[CategoryViewController alloc] initWithBudgetType:BudgetTypeIncome andFrame:frame];
            [[SettingsViewController sharedSettingsViewController].navigationController pushViewController:vc animated:YES];
        } else if ( indexPath.row == 2) {
            //expenditure category
            CGRect frame = self.frame;
            frame.size.height -= [SettingsViewController sharedSettingsViewController].navigationController.navigationBar.frame.size.height;
            frame.size.height -= [[UIApplication sharedApplication] statusBarFrame].size.height;
            
            CategoryViewController *vc = [[CategoryViewController alloc] initWithBudgetType:BudgetTypeExpenditure andFrame:frame];
            [[SettingsViewController sharedSettingsViewController].navigationController pushViewController:vc animated:YES];
        } else if ( indexPath.row == 3) {
            //Income Expenditure Charts
            //do nothing
        }
    } else if ( indexPath.section == 1) {
        //functional options
        if ( indexPath.row == 0) {
            //clear data
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示"
                                                                                     message:@"确定要清空数据吗？"
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction  = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.settingsService clearUserData];
                [[NSNotificationCenter defaultCenter] postNotificationName:kClearUserAccountFlows object:nil];
                [SVProgressHUD showSuccessWithStatus:@"数据清空成功!"];
                [[SettingsViewController sharedSettingsViewController] dismissViewControllerAnimated:YES completion:nil];
            }];
            [alertController addAction:cancelAction];
            [alertController addAction:confirmAction];
            [[SettingsViewController sharedSettingsViewController] presentViewController:alertController
                                                                                animated:YES
                                                                              completion:nil];
        }
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
