//
//  BottomOptionController.h
//  Accounting
//
//  Created by mesird on 11/3/15.
//  Copyright © 2015 mesird. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@protocol BottomOptionDelegate <NSObject>

@optional
- (void)willShow;
- (void)didShow;
- (void)willDisappear;
- (void)didDisappear;

@end

@interface BottomOptionController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate>

- (instancetype)initWithOptions:(NSArray *)options superFrame:(CGRect)frame andBudgetType:(BudgetType)type;

- (void)viewMovingInFromBottom;
- (void)viewMovingOutToBottom;

- (void)setNestedView:(UIView *)nestedView;

@property (nonatomic, assign) id<BottomOptionDelegate> delegate;

@end


