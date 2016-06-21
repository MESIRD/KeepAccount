//
//  SettingsCategoryCollectionView.m
//  Accounting
//
//  Created by mesird on 11/7/15.
//  Copyright © 2015 mesird. All rights reserved.
//

#import "SettingsCategoryCollectionView.h"
#import "BottomCollectionViewCell.h"
#import "SettingsCreateCategoryView.h"
#import "AccountCategory.h"
#import "URLUtil.h"
#import "ColorUtil.h"
#import "SettingsService.h"
#import "SVProgressHUD.h"
#import "BottomOption.h"
#import "Constants.h"

typedef NS_ENUM(NSInteger, CollectionState) {
    CollectionStateNormal,
    CollectionStateEditing,
};

@interface SettingsCategoryCollectionView()

@property (nonatomic, copy)           NSArray *categories;
@property (nonatomic, strong) SettingsService *settingsService;
@property (nonatomic)              BudgetType type;

@property (nonatomic, weak)  UIViewController *nestedViewController;
@property (nonatomic)         CollectionState collectionState;

@end

@implementation SettingsCategoryCollectionView

static NSString * const reuseIdentifier = @"Category Collection Cell";

- (SettingsService *)settingsService {
    if ( !_settingsService) {
        _settingsService = [[SettingsService alloc] init];
    }
    return _settingsService;
}

- (void)setNestedViewController:(UIViewController *)nestedViewController {
    _nestedViewController = nestedViewController;
}

- (instancetype)initWithBudgetType:(BudgetType)type frame:(CGRect)frame andLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if ( self) {
        // Register cell classes
        [self registerClass:[BottomCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
        
        //self configuration
        self.backgroundColor = [ColorUtil backgroundColor];
        self.delegate = self;
        self.dataSource = self;
        self.type = type;
        
        //init data
        [self initCollectionDataWithBudgetType:type];
        
        //register notification
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCollectionData) name:kCreateCategorySuccess object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCollectionData) name:kUpdateCategorySuccess object:nil];
        
        //init default data
        _collectionState = CollectionStateNormal;
    }
    return self;
}

- (void)initCollectionDataWithBudgetType:(BudgetType)type {
    NSMutableArray *options = [[NSMutableArray alloc] initWithArray:[self.settingsService getCategories:type]];
    BottomOption *addOption = [[BottomOption alloc] init];
    addOption.optionId = 0;
    addOption.optionName = @"新增项";
    addOption.imageSource = ImageSourceBundle;
    addOption.imagePath = @"cat_add";
    [options addObject:addOption];
    _categories = [options copy];
    [self reloadData];
}

- (void)refreshCollectionData {
    NSMutableArray *options = [[NSMutableArray alloc] initWithArray:[self.settingsService getCategories:_type]];
    BottomOption *addOption = [[BottomOption alloc] init];
    addOption.optionId = 0;
    addOption.optionName = @"新增项";
    addOption.imageSource = ImageSourceBundle;
    addOption.imagePath = @"cat_add";
    [options addObject:addOption];
    _categories = [options copy];
    [self reloadData];
}

- (void)editingMode {
    _collectionState = CollectionStateEditing;
    
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    for (int i = 0; i < _categories.count; i ++) {
        BottomOption *option = (BottomOption *)_categories[i];
        if ( [option editable]) {
            [indexPaths addObject:[NSIndexPath indexPathForItem:i inSection:0]];
        }
    }
    if ( indexPaths.count > 0) {
        [self categoryImagesWiggling:indexPaths];
    } else {
        [SVProgressHUD showInfoWithStatus:@"暂无可以编辑的类目"];
    }
    
}

- (void)normalMode {
    _collectionState = CollectionStateNormal;
    NSArray *visibleCells = [self visibleCells];
    for (BottomCollectionViewCell *cell in visibleCells) {
        [cell.layer removeAllAnimations];
    }
}

- (void)cancelAction {
    for (BottomOption *option in _categories) {
        option.selected = NO;
    }
    [self normalMode];
}

- (BOOL)deleteAction {
    
    BOOL deleteSuccess = YES;
    
    NSMutableArray *tempCategories = [_categories mutableCopy];
    NSMutableArray *selectedOptions = [[NSMutableArray alloc] init];
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    NSMutableArray *selectedOptionIds = [[NSMutableArray alloc] init];
    
    for (BottomOption *option in _categories) {
        if ( [option selected]) {
            [selectedOptions addObject:option];
            [selectedOptionIds addObject:[NSNumber numberWithInteger:[option optionId]]];
            [indexPaths addObject:[NSIndexPath indexPathForItem:[_categories indexOfObject:option] inSection:0]];
        }
    }
    
    //delete image from document directory
    // &
    //remove objects from data source
    for (BottomOption *option in selectedOptions) {
        if ( [option imageSource] == ImageSourceDocument) {
            NSString *imagePath = [URLUtil getCompleteImagePathWithComponent:[option imagePath]];
            [[NSFileManager defaultManager] removeItemAtPath:imagePath error:nil];
        }
        
        [tempCategories removeObject:option];
    }
    _categories = [tempCategories copy];
    
    //delete data from database
    if ([_settingsService deleteCategories:selectedOptionIds]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kCategoryCollectionDeleted object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshHomeTableData object:nil];
    } else {
        deleteSuccess = NO;
        NSLog(@"fail to delete categories and records");
    }
    
    //delete cells from collection
    [self deleteItemsAtIndexPaths:indexPaths];
    
    //post notification
    NSDictionary *userInfo = @{@"RightButtonType":[NSNumber numberWithInteger:RightButtonTypeEdit]};
    [[NSNotificationCenter defaultCenter] postNotificationName:kCategoryCollectionChangeRightButton object:nil userInfo:userInfo];
    
    [self normalMode];
    return deleteSuccess;
}

- (void)categoryImagesWiggling:(NSArray *)indexPaths {
    
    for (NSIndexPath *indexPath in indexPaths) {
        BottomCollectionViewCell *cell = (BottomCollectionViewCell *)[self cellForItemAtIndexPath:indexPath];
        CALayer *viewLayer = [cell layer];
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
        animation.duration = 0.1;
        animation.repeatCount = 100000;
        animation.autoreverses = YES;
        animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DRotate(viewLayer.transform, -0.05, 0.0, 0.0, 0.05)];
        animation.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(viewLayer.transform, 0.05, 0.0, 0.0, 0.05)];
        [viewLayer addAnimation:animation forKey:@"wiggle"];
    }
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.categories.count;
}

- (BottomCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BottomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    BottomOption *option = self.categories[indexPath.row];
    UIImage *image;
    if ( option.imageSource == ImageSourceBundle) {
        image = [UIImage imageNamed:[option imagePath]];
    } else if ( option.imageSource == ImageSourceDocument) {
        image = [[UIImage alloc] initWithContentsOfFile:[URLUtil getCompleteImagePathWithComponent:[option imagePath]]];
    }
    
    cell.catImage.image = image;
    cell.label.text = [option optionName];
    cell.backgroundColor = [ColorUtil collectionCellColor];
    cell.layer.cornerRadius  = 5.0f;
    cell.layer.masksToBounds = YES;
    cell.layer.borderColor   = _type == BudgetTypeIncome ? [ColorUtil incomeColor].CGColor : [ColorUtil expenditureColor].CGColor;
    if ( _collectionState == CollectionStateEditing) {
        cell.layer.borderWidth = [option selected] ? 2.0f : 0;
    } else if ( _collectionState == CollectionStateNormal ) {
        cell.layer.borderWidth = 0;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    BottomCollectionViewCell *cell = (BottomCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if ( _collectionState == CollectionStateNormal) {
        if ( indexPath.row == _categories.count - 1) {
            //add button
            AccountCategory *cat = [[AccountCategory alloc] init];
            cat.type = _type;
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SettingsCreateCategoryView" owner:self options:nil];
            SettingsCreateCategoryView *sccv = [nib objectAtIndex:0];
            [sccv setNestedViewController:self.nestedViewController];
            [sccv setCategoryData:cat state:PanelStateCreate];
            
            [self.nestedViewController.view addSubview:sccv];
            [sccv viewMovingInFromRight];
        } else {
            BottomOption *option = (BottomOption *)_categories[indexPath.row];
            AccountCategory *cat = [[AccountCategory alloc] init];
            cat.categoryId = option.optionId;
            cat.categoryName = option.optionName;
            cat.categoryDescription = option.optionDescription;
            cat.categoryImageUrl = option.imagePath;
            cat.categoryImageSource = option.imageSource;
            cat.categoryEditable = option.editable;
            cat.type = _type;
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SettingsCreateCategoryView" owner:self options:nil];
            SettingsCreateCategoryView *sccv = [nib objectAtIndex:0];
            [sccv setNestedViewController:self.nestedViewController];
            [sccv setType:_type];
            [sccv setCategoryData:cat state:PanelStateEdit];
            
            [self.nestedViewController.view addSubview:sccv];
            [sccv viewMovingInFromRight];
        }
    } else if ( _collectionState == CollectionStateEditing) {
        BottomOption *option = _categories[indexPath.row];
        if ( [option editable]) {
            if ( [option selected]) {
                cell.layer.borderWidth = 0;
                ((BottomOption *)_categories[indexPath.row]).selected = NO;
            } else {
                cell.layer.borderWidth = 2.0f;
                ((BottomOption *)_categories[indexPath.row]).selected = YES;
            }
            
            NSInteger *selectedNumber = 0;
            for (BottomOption *option in _categories) {
                if ( [option selected]) {
                    ++ selectedNumber;
                }
            }
            
            if ( selectedNumber == 0) {
                NSDictionary *userInfo = @{@"RightButtonType":[NSNumber numberWithInteger:RightButtonTypeCancel]};
                [[NSNotificationCenter defaultCenter] postNotificationName:kCategoryCollectionChangeRightButton object:nil userInfo:userInfo];
            } else {
                NSDictionary *userInfo = @{@"RightButtonType":[NSNumber numberWithInteger:RightButtonTypeDelete]};
                [[NSNotificationCenter defaultCenter] postNotificationName:kCategoryCollectionChangeRightButton object:nil userInfo:userInfo];
            }
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
