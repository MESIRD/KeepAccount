//
//  AccountingView.h
//  Accounting
//
//  Created by mesird on 10/31/15.
//  Copyright © 2015 mesird. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BottomOptionController.h"
#import "AccountCategory.h"

@protocol AccoutingViewDelegate <NSObject>

@optional
- (void)accoutingViewWillShow;
- (void)accoutingViewShowed;
- (void)accoutingViewWillHide;
- (void)accoutingViewHidden;

@end

@interface AccountingView : UIView <UIImagePickerControllerDelegate, UINavigationControllerDelegate, BottomOptionDelegate, UITextFieldDelegate, UITextViewDelegate>

- (void)setNestedViewController:(UIViewController *)viewController;

- (void)setCategory:(AccountCategory *)category;

- (void)buttonsPopIn;

@property (nonatomic, weak) id<AccoutingViewDelegate> delegate;

@end
