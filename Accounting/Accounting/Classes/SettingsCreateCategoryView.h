//
//  SettingsCreateCategoryView.h
//  Accounting
//
//  Created by mesird on 11/9/15.
//  Copyright © 2015 mesird. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

typedef NS_ENUM(NSInteger, PanelState) {
    PanelStateCreate = 0,
    PanelStateEdit = 1,
};

@class AccountCategory;
@interface SettingsCreateCategoryView : UIView <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

- (void)setNestedViewController:(UIViewController *)nestedViewController;
- (void)setType:(BudgetType)type;
- (void)viewMovingInFromRight;
- (void)viewMovingOutToTop;
- (void)setCategoryData:(AccountCategory *)accountCategory state:(PanelState)state;

@end
