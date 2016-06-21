//
//  AccountingView.m
//  Accounting
//
//  Created by mesird on 10/31/15.
//  Copyright © 2015 mesird. All rights reserved.
//

#import "AccountingView.h"
#import "HomeAccountingService.h"
#import "SVProgressHUD.h"
#import "NumberUtil.h"
#import "Constants.h"
#import "ImageUtil.h"
#import "FontUtil.h"
#import "URLUtil.h"
#import "BottomOption.h"


@interface AccountingView()
{
    BOOL isTextViewMovedUp;
}

@property (strong, nonatomic) IBOutlet UIButton     *incomeBtn;
@property (strong, nonatomic) IBOutlet UIButton     *expendBtn;
@property (strong, nonatomic) IBOutlet UIView       *recordCreateView;
@property (strong, nonatomic) IBOutlet UIView       *topTitleBar;
@property (strong, nonatomic) IBOutlet UIView       *topTitleBarShadow;
@property (strong, nonatomic) IBOutlet UIView       *amountView;
@property (strong, nonatomic) IBOutlet UIView       *categoryView;
@property (strong, nonatomic) IBOutlet UIView       *descriptionView;
@property (strong, nonatomic) IBOutlet UIView       *imageView;
@property (strong, nonatomic) IBOutlet UIImageView  *attachedImageView;
@property (strong, nonatomic) IBOutlet UILabel      *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton     *cancelBtn;
@property (strong, nonatomic) IBOutlet UIButton     *doneBtn;
@property (strong, nonatomic) IBOutlet UIButton     *cameraBtn;
@property (strong, nonatomic) IBOutlet UITextField  *amountTextField;
@property (strong, nonatomic) IBOutlet UILabel      *categoryLabel;
@property (strong, nonatomic) IBOutlet UITextView   *descriptionTextView;
@property (strong, nonatomic) IBOutlet UIButton     *hideBtn;
@property (strong, nonatomic) IBOutlet UILabel      *descriptionReminderLabel;


@property (strong, nonatomic) UIImagePickerController *imgPicker;
@property (nonatomic)                      BudgetType budgetType;
@property (nonatomic)                           short categoryId;
@property (nonatomic, strong)   HomeAccountingService *homeAccountingService;
@property (weak, nonatomic)          UIViewController *nestedViewController;

@end

@implementation AccountingView

- (UIImagePickerController *)imgPicker {
    if ( !_imgPicker) {
        _imgPicker = [[UIImagePickerController alloc] init];
        _imgPicker.delegate = self;
        _imgPicker.allowsEditing = YES;
    }
    return _imgPicker;
}

- (HomeAccountingService *)homeAccountingService {
    if ( !_homeAccountingService) {
        _homeAccountingService = [[HomeAccountingService alloc] init];
    }
    return _homeAccountingService;
}

- (void)setCategory:(AccountCategory *)category {
    _categoryId = category.categoryId;
    _categoryLabel.text = category.categoryName;
}

- (void)awakeFromNib {
    
    //initializing here
    [_cancelBtn addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
    [_doneBtn   addTarget:self action:@selector(createRecord) forControlEvents:UIControlEventTouchUpInside];
    [_incomeBtn addTarget:self action:@selector(showIncomePanel) forControlEvents:UIControlEventTouchUpInside];
    [_expendBtn addTarget:self action:@selector(showExpenditurePanel) forControlEvents:UIControlEventTouchUpInside];
    [_cameraBtn addTarget:self action:@selector(showAddPhotoOptions) forControlEvents:UIControlEventTouchUpInside];
    
    //set delegate
    _amountTextField.delegate = self;
    _descriptionTextView.delegate = self;
    
    //register notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //register category tap gesture
    UITapGestureRecognizer *categoryTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showCategoryOptions:)];
    categoryTapGesture.numberOfTapsRequired    = 1;
    categoryTapGesture.numberOfTouchesRequired = 1;
    [_categoryView addGestureRecognizer:categoryTapGesture];
    
    //set default data
    _categoryId = -1;
    isTextViewMovedUp = NO;
}

- (void)layoutSubviews {
    
    //hide
    _recordCreateView.hidden = YES;
    
    [self viewReconfiguration:_recordCreateView];
    [self viewReconfiguration:_amountView];
    [self viewReconfiguration:_categoryView];
    [self viewReconfiguration:_descriptionView];
    [self viewReconfiguration:_imageView];
    
    _titleLabel.font = [FontUtil defaultFontWithSize:24];
    _amountTextField.font = [FontUtil defaultFontWithSize:22];
    _categoryLabel.font = [FontUtil defaultFontWithSize:20];
    _descriptionTextView.font = [FontUtil defaultFontWithSize:18];
    _descriptionReminderLabel.font = [FontUtil defaultFontWithSize:18];
    
    
}

- (IBAction)dismissSelf {
    [self.delegate accoutingViewWillHide];
    [self.nestedViewController.navigationController.navigationBar setUserInteractionEnabled:YES];
    [self.delegate accoutingViewHidden];
    [self removeFromSuperview];
}

- (void)createRecord {
    
    if ( ![self informationValidationCheck]) {
        return ;
    }
    
    Record *record = [[Record alloc] init];
    record.amount = [NumberUtil yuanToCent:_amountTextField.text];
    record.pocketId = 0;
    record.categoryId = _categoryId;
    record.budgetType = _budgetType;
    
    if ( ![_descriptionTextView.text isEqualToString:@""]) {
        record.recDescription = _descriptionTextView.text;
    } else {
        record.recDescription = @"";
    }
    
    if ( _attachedImageView.image) {
        NSData *data = [ImageUtil compressImage:_attachedImageView.image withRate:0.5f];
        //generate image file name
        NSString *imgName = [NSString stringWithFormat:@"rec_%@_%d.png", _categoryLabel.text, (int)[[NSDate date] timeIntervalSince1970]];
        NSString *imgPath = [URLUtil getCompleteImagePathWithComponent:imgName];
        [data writeToFile:imgPath atomically:NO];
        record.imgUrl = imgName;
    } else {
        record.imgUrl = @"";
    }
    
    //insert into db
    if (![self.homeAccountingService createNewRecord:record]) {
        [SVProgressHUD showErrorWithStatus:@"创建失败"];
        return ;
    }
    [SVProgressHUD showSuccessWithStatus:@"账单创建成功"];
    [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshHomeTableData object:nil];
    [self dismissSelf];
}

- (void)showIncomePanel {
    [self showRecordPanel:BudgetTypeIncome];
}

- (void)showExpenditurePanel {
    [self showRecordPanel:BudgetTypeExpenditure];
}

- (void)showRecordPanel:(BudgetType)type {
    _incomeBtn.hidden = YES;
    _expendBtn.hidden = YES;
    _hideBtn.hidden   = YES;
    _recordCreateView.hidden = NO;

    self.budgetType = type;
    
    BOOL fromLeft = YES;
    
    //reset title bar
    if ( type == BudgetTypeIncome) {
        _topTitleBar.backgroundColor = [UIColor colorWithRed:111.0/255 green:157.0/255 blue:76.0/255 alpha:1.0f];
        _topTitleBarShadow.backgroundColor = [UIColor colorWithRed:84.0/255 green:115.0/255 blue:60.0/255 alpha:1.0f];
        _titleLabel.text = @"收入详细";
        fromLeft = NO;
    } else if ( type == BudgetTypeExpenditure) {
        _topTitleBar.backgroundColor = [UIColor colorWithRed:226.0/255 green:95.0/255 blue:76.0/255 alpha:1.0f];
        _topTitleBarShadow.backgroundColor = [UIColor colorWithRed:148.0/255 green:58.0/255 blue:47.0/255 alpha:1.0f];
        _titleLabel.text = @"支出详细";
    }
    
    CGRect pFrame = _recordCreateView.frame;
    _recordCreateView.frame = CGRectMake( fromLeft ? -CGRectGetWidth(pFrame) : CGRectGetWidth(self.nestedViewController.view.frame), pFrame.origin.y, CGRectGetWidth(pFrame), CGRectGetHeight(pFrame));
    [UIView animateWithDuration:defaultAnimationDuration animations:^{
        _recordCreateView.frame = pFrame;
    }];
}

- (void)showAddPhotoOptions {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"添加图片方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            self.imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self.nestedViewController presentViewController:self.imgPicker animated:YES completion:nil];
        } else {
            NSLog(@"Photo library source type is not available.");
        }
    }];
    UIAlertAction *takingAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            self.imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self.nestedViewController presentViewController:self.imgPicker animated:YES completion:nil];
        } else {
            NSLog(@"Camera source type is not available.");
        }
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:albumAction];
    [alertController addAction:takingAction];
    [self.nestedViewController presentViewController:alertController animated:YES completion:nil];
}

- (void)showCategoryOptions:(UIGestureRecognizer *)sender {
    //fetch categories from db
    NSMutableArray *options = [[NSMutableArray alloc] initWithArray:[self.homeAccountingService getCategory:_budgetType]];

    BottomOptionController *boc = [[BottomOptionController alloc] initWithOptions:options superFrame:self.frame andBudgetType:_budgetType];
    boc.delegate = self;
    [boc setNestedView:self];

    [self.nestedViewController addChildViewController:boc];
    [self.nestedViewController.view addSubview:boc.view];
    [boc viewMovingInFromBottom];
}

- (void)viewReconfiguration:(UIView *)view {
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 5.0f;
}

- (void)setNestedViewController:(UIViewController *)viewController {
    _nestedViewController = viewController;
}

- (BOOL)informationValidationCheck {
    
    NSString *amount = _amountTextField.text;
    amount = [amount stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ( [amount isEqualToString:@""]){
        [SVProgressHUD showInfoWithStatus:@"请输入金额～"];
        return NO;
    } else if ( ![NumberUtil isNumber:amount]) {
        [SVProgressHUD showInfoWithStatus:@"请输入正确的金钱～"];
        return NO;
    } else if ( [NumberUtil isZero:amount]) {
        [SVProgressHUD showInfoWithStatus:@"0毛钱就不用记账了吧～"];
        return NO;
    } else if ( _categoryId == -1) {
        [SVProgressHUD showInfoWithStatus:@"请选择类目～"];
        return NO;
    }
    return YES;
}

- (void)buttonsPopIn {
    [self.delegate accoutingViewWillShow];
    CGRect inFrame = _incomeBtn.imageView.frame;
    CGRect exFrame = _expendBtn.imageView.frame;
    _incomeBtn.imageView.frame = CGRectMake(inFrame.origin.x + CGRectGetWidth(inFrame) / 2, inFrame.origin.y + CGRectGetHeight(inFrame) / 2, 0, 0);
    _expendBtn.imageView.frame = CGRectMake(exFrame.origin.x + CGRectGetWidth(exFrame) / 2, exFrame.origin.y + CGRectGetHeight(exFrame) / 2, 0, 0);
    [UIView animateWithDuration:defaultAnimationDuration animations:^{
        _incomeBtn.imageView.frame = inFrame;
        _expendBtn.imageView.frame = exFrame;
    } completion:^(BOOL finished) {
        [self.delegate accoutingViewShowed];
    }];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSLog(@"keyboard will show");
    CGRect kbeFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect frame = self.nestedViewController.view.frame;
    CGRect selfFrame = self.recordCreateView.frame;
    
    if ( [_descriptionTextView isFirstResponder] && !isTextViewMovedUp) {
        //moving view for description text view
        CGRect tvFrame = _descriptionView.frame;
        CGFloat offset = (selfFrame.origin.y + tvFrame.origin.y + CGRectGetHeight(tvFrame) + CGRectGetHeight(kbeFrame) + 10) - CGRectGetHeight(frame);
        if ( offset > 0) {
            //keyboard covers text input box
            [UIView animateWithDuration:defaultAnimationDuration animations:^{
                self.nestedViewController.view.frame = CGRectMake(0, frame.origin.y - offset, CGRectGetWidth(frame), CGRectGetHeight(frame));
            } completion:^(BOOL finished) {
                isTextViewMovedUp = YES;
            }];
        }
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSLog(@"keyboard will hide");
    CGRect frame = self.nestedViewController.view.frame;
    CGFloat statusHeight = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    CGFloat navigationBarHeight = CGRectGetHeight(self.nestedViewController.navigationController.navigationBar.frame);
    [UIView animateWithDuration:defaultAnimationDuration animations:^{
        self.nestedViewController.view.frame = CGRectMake(0, statusHeight + navigationBarHeight, CGRectGetWidth(frame), CGRectGetHeight(frame));
    } completion:^(BOOL finished) {
        isTextViewMovedUp = NO;
    }];
}


#pragma -mark UITextView Delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ( [text isEqualToString:@"\n"]) {
        if ( [textView canResignFirstResponder]) {
            [textView resignFirstResponder];
            return NO;
        }
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if ( [textView.text isEqualToString:@""]) {
        _descriptionReminderLabel.hidden = NO;
    } else {
        _descriptionReminderLabel.hidden = YES;
    }
}

#pragma -mark UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ( [textField canResignFirstResponder]) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ( [string isEqualToString:@" "]) {
        return NO;
    }
    
    if ( ![NumberUtil isNumber:string] && ![string isEqualToString:@"."] && ![string isEqualToString:@""]) {
        return NO;
    }
    
    NSString *amount = textField.text;
    
    if ( amount.length == 0 && [string isEqualToString:@"."]) {
        return NO;
    }
    
    if ( string.length == 1) {
        
        if ( [amount containsString:@"."]) {
            //return no if the string is "."
            if ( [string isEqualToString:@"."]) {
                return NO;
            }
            
            //check the number of decimal
            NSRange pointRange = [amount rangeOfString:@"."];
            if ( amount.length - 1 - pointRange.location >= 2 && ![string isEqualToString:@""]) {
                return NO;
            }
        } else {
            //check whether the first char is "0"
            if ( [amount isEqualToString:@"0"]) {
                if ( ![string isEqualToString:@"."]) {
                    textField.text = string;
                    return NO;
                }
            }
        }
    }
    
    return YES;
}

#pragma -mark Bottom Option Delegate

- (void)willShow {
    NSLog(@"BottomOptionControllerWillShow");
    self.userInteractionEnabled = NO;
}

- (void)willDisappear {
    NSLog(@"BottomOptionControllerWillDisappear");
}

- (void)didShow {
    NSLog(@"BottomOptionControllerDidShow");
}


- (void)didDisappear {
    NSLog(@"BottomOptionControllerDidDisappear");
    self.userInteractionEnabled = YES;
    
    if ( [_amountTextField isFirstResponder] && [_amountTextField canResignFirstResponder]) {
        [_amountTextField resignFirstResponder];
    }

    
    //FIXME
//    if ( [_descriptionTextView isFirstResponder] && [_descriptionTextView canResignFirstResponder]) {
//        [_descriptionTextView resignFirstResponder];
//    }
    
}

#pragma -mark UIImagePicker Delegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self.nestedViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    [self.nestedViewController dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if ( !image) {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    _attachedImageView.image = image;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
