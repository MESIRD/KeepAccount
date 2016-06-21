//
//  Constants.h
//  Accounting
//
//  Created by mesird on 10/13/15.
//  Copyright © 2015 mesird. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static NSString * const kUpdatePocketName           = @"updatePocketName";
static NSString * const kShowCreateNewRecord        = @"showCreateNewRecord";
static NSString * const kRefreshHomeTableData       = @"refreshHomeTableData";
static NSString * const kClearUserAccountFlows      = @"clearUserAccountFlows";
static NSString * const kHomeDataEmpty              = @"homeDataEmpty";
static NSString * const kHomeDataNotEmpty           = @"homeDataNotEmpty";

static NSString * const kCreateCategorySuccess      = @"createCategorySuccess";
static NSString * const kCategoryCollectionDeleted  = @"categoryCollectionDeleted";
static NSString * const kUpdateCategorySuccess      = @"updateCategorySuccess";

static NSString * const kCategoryCollectionChangeRightButton    = @"categoryCollectionChangeRightButton";


static CGFloat const defaultAnimationDuration = 0.5f;
static CGFloat const quickAnimationDuration = 0.2f;

typedef NS_ENUM(NSInteger, BudgetType) {
    BudgetTypeInit = -1,
    BudgetTypeIncome = 0,
    BudgetTypeExpenditure = 1,
};

typedef NS_ENUM(NSInteger, ImageSource) {
    ImageSourceBundle = 0,
    ImageSourceDocument = 1,
};

typedef NS_ENUM(NSInteger, EditableState) {
    EditableStateNO = 0,
    EditableStateYES = 1,
};

@interface Constants : NSObject

@end
