//
//  SettingsCreateCategoryView.m
//  Accounting
//
//  Created by mesird on 11/9/15.
//  Copyright © 2015 mesird. All rights reserved.
//

#import "SettingsCreateCategoryView.h"
#import "SettingsService.h"
#import "SVProgressHUD.h"
#import "ImageUtil.h"
#import "ColorUtil.h"
#import "URLUtil.h"
#import "AccountCategory.h"

@interface SettingsCreateCategoryView()

@property (strong, nonatomic) IBOutlet UIImageView  *categoryImageView;
@property (strong, nonatomic) IBOutlet UIView       *categoryNameView;
@property (strong, nonatomic) IBOutlet UITextField  *categoryNameTextField;
@property (strong, nonatomic) IBOutlet UIView       *categoryDescriptionView;
@property (strong, nonatomic) IBOutlet UITextField  *categoryDescriptionTextField;
@property (strong, nonatomic) IBOutlet UIButton     *createButton;
@property (strong, nonatomic) IBOutlet UIButton     *dismissButton;
@property (strong, nonatomic) IBOutlet UIImageView  *categoryReminderImageView;
@property (strong, nonatomic) IBOutlet UILabel      *panelTitleLabel;

@property (strong, nonatomic) IBOutlet UIView       *entireView;
@property (strong, nonatomic) IBOutlet UIView       *contentView;
@property (strong, nonatomic) IBOutlet UIView       *titleView;
@property (strong, nonatomic) IBOutlet UIView       *imageContentView;

@property (weak, nonatomic)            UIViewController *nestedViewController;
@property (nonatomic, strong)   UIImagePickerController *imgPicker;
@property (nonatomic, strong)           SettingsService *settingsService;

@property (nonatomic, strong)           AccountCategory *category;

@end

@implementation SettingsCreateCategoryView

- (UIImagePickerController *)imgPicker {
    if ( !_imgPicker) {
        _imgPicker = [[UIImagePickerController alloc] init];
        _imgPicker.delegate = self;
        _imgPicker.allowsEditing = YES;
    }
    return _imgPicker;
}

- (SettingsService *)settingsService {
    if ( !_settingsService) {
        _settingsService = [[SettingsService alloc] init];
    }
    return _settingsService;
}

- (void)setNestedViewController:(UIViewController *)nestedViewController {
    _nestedViewController = nestedViewController;
}

- (void)setType:(BudgetType)type {
    _category.type = type;
}

- (void)setCategoryData:(AccountCategory *)accountCategory state:(PanelState)state {        //初始化设置
    
    _category = accountCategory;
    
    if ( state == PanelStateEdit) {
        
        UIImage *image;
        if ( accountCategory.categoryImageSource == ImageSourceBundle) {
            image = [UIImage imageNamed:[accountCategory categoryImageUrl]];
        } else if ( accountCategory.categoryImageSource == ImageSourceDocument) {
            image = [UIImage imageWithData:[NSData dataWithContentsOfFile:[URLUtil getCompleteImagePathWithComponent:[accountCategory categoryImageUrl]]]];
        }
        if ( image) {
            _categoryImageView.image = image;
            _categoryReminderImageView.hidden = YES;
        }
        
        _categoryNameTextField.text = [accountCategory categoryName];
        _categoryDescriptionTextField.text = [accountCategory categoryDescription];
        
        if ( [accountCategory categoryEditable] == EditableStateYES) {
            [_createButton setTitle:@"修改" forState:UIControlStateNormal];
            [_createButton removeTarget:self action:@selector(createCategory) forControlEvents:UIControlEventTouchUpInside];
            [_createButton addTarget:self action:@selector(updateCategory) forControlEvents:UIControlEventTouchUpInside];
            
            _panelTitleLabel.text = @"类目编辑";
        } else if ( [accountCategory categoryEditable] == EditableStateNO) {
            
            [_createButton setTitle:@"确定" forState:UIControlStateNormal];
            [_createButton removeTarget:self action:@selector(createCategory) forControlEvents:UIControlEventTouchUpInside];
            [_createButton addTarget:self action:@selector(viewMovingOutToTop) forControlEvents:UIControlEventTouchUpInside];
            
            _panelTitleLabel.text = @"类目查看";
            
            _categoryImageView.userInteractionEnabled = NO;
            
            _categoryNameTextField.userInteractionEnabled = NO;
            _categoryNameTextField.textColor = [UIColor grayColor];
            
            _categoryDescriptionTextField.userInteractionEnabled = NO;
            _categoryDescriptionTextField.textColor = [UIColor grayColor];
        }
        
    } else if ( state == PanelStateCreate) {
        
        if ( [accountCategory type] == BudgetTypeIncome) {
            _createButton.backgroundColor = [ColorUtil incomeColor];
        } else if ( [accountCategory type] == BudgetTypeExpenditure) {
            _createButton.backgroundColor = [ColorUtil expenditureColor];
        }
    }
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if ( self) {
        _category = [[AccountCategory alloc] init];
    }
    return self;
}

- (void)awakeFromNib {
    
    //add target to button
    [_dismissButton addTarget:self action:@selector(viewMovingOutToTop) forControlEvents:UIControlEventTouchUpInside];
    [_createButton addTarget:self action:@selector(createCategory) forControlEvents:UIControlEventTouchUpInside];
    
    //config subviews
    [self configSubviews];
    
    //add tap gesture recognizer
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAddPhotoOptions:)];
    tapRecognizer.numberOfTapsRequired = 1;
    tapRecognizer.numberOfTouchesRequired = 1;
    [_categoryImageView addGestureRecognizer:tapRecognizer];
}

- (void)configSubviews {
    
    [self configView:_categoryImageView];
    [self configView:_categoryNameView];
    [self configView:_categoryDescriptionView];
    [self configView:_createButton];
    [self configView:_contentView];
    [self configView:_titleView];
    [self configView:_imageContentView];
    
    //additional configurations
    CGRect frame = _entireView.frame;
    _entireView.frame = CGRectMake(CGRectGetWidth(self.frame), frame.origin.y, CGRectGetWidth(frame), CGRectGetHeight(frame));
}

- (void)configView:(UIView *)view {
    view.layer.cornerRadius = 5.0f;
    view.layer.masksToBounds = YES;
}

- (void)viewMovingInFromRight {
    self.nestedViewController.navigationController.navigationBar.userInteractionEnabled = NO;
    CGRect frame = _entireView.frame;
    [UIView animateWithDuration:defaultAnimationDuration animations:^{
        _entireView.frame = CGRectMake( (CGRectGetWidth(self.frame) - CGRectGetWidth(frame)) / 2, frame.origin.y, CGRectGetWidth(frame), CGRectGetHeight(frame));
    } completion:^(BOOL finished) {
        
    }];
}

- (void)viewMovingOutToTop {
    CGRect frame = _entireView.frame;
    [UIView animateWithDuration:defaultAnimationDuration animations:^{
        _entireView.frame = CGRectMake( frame.origin.x, frame.origin.y - 200.0f, CGRectGetWidth(frame), CGRectGetHeight(frame));
        _entireView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        if ( finished) {
            self.nestedViewController.navigationController.navigationBar.userInteractionEnabled = YES;
            [self removeFromSuperview];
        }
    }];
}

- (void)showAddPhotoOptions:(UIGestureRecognizer *)sender {
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

- (void)createCategory {
    if ( _category.type == BudgetTypeInit) {
        NSLog(@"type hasnt set yet. fail to create category.");
        return ;
    }
    if ( [_categoryNameTextField.text isEqualToString:@""]) {
        [SVProgressHUD showInfoWithStatus:@"请填写类目名称"];
        return ;
    }
    //
    BOOL saveImageSuccess = NO;
    NSString *imageName = [NSString stringWithFormat:@"cat_%@.png", _categoryNameTextField.text];
    NSString *imageUrl = [URLUtil getCompleteImagePathWithComponent:imageName];
    NSLog(@"%@", imageUrl);
    if ( _categoryImageView.image) {
        NSData *data = [ImageUtil compressImage:_categoryImageView.image withRate:0.5f];
        if ([data writeToFile:imageUrl atomically:NO]) {
            saveImageSuccess = YES;
        }
    }
    
    _category.categoryName = _categoryNameTextField.text;
    _category.categoryImageUrl = saveImageSuccess ? imageName : @"";
    _category.categoryDescription = _categoryDescriptionTextField.text;
    _category.categoryImageSource = ImageSourceDocument;
    _category.categoryEditable = EditableStateYES;
    if ([self.settingsService createCategory:_category]) {
        [SVProgressHUD showInfoWithStatus:@"创建成功!"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kCreateCategorySuccess object:nil];
        [self viewMovingOutToTop];
    }
}

- (void)updateCategory {
    if ( _category.type == BudgetTypeInit) {
        NSLog(@"type hasnt set yet. fail to create category.");
        return ;
    }
    if ( [_categoryNameTextField.text isEqualToString:@""]) {
        [SVProgressHUD showInfoWithStatus:@"请填写类目名称"];
        return ;
    }
    
    //delete image in document
    if ( ![_category.categoryImageUrl isEqualToString:@""] && _category.categoryImageSource == ImageSourceDocument) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *removeFileError = nil;
        [fileManager removeItemAtPath:[URLUtil getCompleteImagePathWithComponent:[_category categoryImageUrl]] error:&removeFileError];
        if ( removeFileError) {
            NSLog(@"fail to delete image : error = %@", removeFileError.localizedDescription);
        }
    }
    
    BOOL saveImageSuccess = NO;
    NSString *imageName = [NSString stringWithFormat:@"cat_%@.png", _categoryNameTextField.text];
    NSString *imageUrl = [URLUtil getCompleteImagePathWithComponent:imageName];
    NSLog(@"%@", imageUrl);
    if ( _categoryImageView.image) {
        NSData *data = [ImageUtil compressImage:_categoryImageView.image withRate:0.5f];
        if ([data writeToFile:imageUrl atomically:NO]) {
            saveImageSuccess = YES;
        }
    }
    _category.categoryName = _categoryNameTextField.text;
    _category.categoryImageUrl = saveImageSuccess ? imageName : @"";
    _category.categoryDescription = _categoryDescriptionTextField.text;
    _category.categoryImageSource = ImageSourceDocument;
    _category.categoryEditable = EditableStateYES;
    if ([self.settingsService updateCategory:_category]) {
        [SVProgressHUD showInfoWithStatus:@"更新成功!"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateCategorySuccess object:nil];
        [self viewMovingOutToTop];
    }
}

#pragma -mark UIImagePicker Delegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self.nestedViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    [self.nestedViewController dismissViewControllerAnimated:YES completion:nil];
    BOOL success = YES;
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if ( !image) {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
        success = NO;
    }
    if ( success) {
        _categoryReminderImageView.hidden = YES;
    }
    _categoryImageView.image = image;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
