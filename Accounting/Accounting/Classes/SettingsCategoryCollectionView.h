//
//  SettingsCategoryCollectionView.h
//  Accounting
//
//  Created by mesird on 11/7/15.
//  Copyright © 2015 mesird. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

typedef NS_ENUM(NSInteger, RightButtonType) {
    RightButtonTypeEdit = 0,
    RightButtonTypeCancel = 1,
    RightButtonTypeDelete = 2,
};

@interface SettingsCategoryCollectionView : UICollectionView <UICollectionViewDelegate, UICollectionViewDataSource>

- (instancetype)initWithBudgetType:(BudgetType)type frame:(CGRect)frame andLayout:(UICollectionViewLayout *)layout;

- (void)setNestedViewController:(UIViewController *)nestedViewController;

- (void)editingMode;
- (void)cancelAction;
- (BOOL)deleteAction;

@end

