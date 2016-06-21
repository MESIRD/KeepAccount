//
//  BottomOptionController.m
//  Accounting
//
//  Created by mesird on 11/3/15.
//  Copyright © 2015 mesird. All rights reserved.
//

#import "BottomOptionController.h"
#import "BottomCollectionViewCell.h"
#import "BottomOption.h"
#import "ColorUtil.h"
#import "URLUtil.h"
#import "AccountCategory.h"
#import "AccountingView.h"


@interface BottomOptionController ()

{
    CGFloat bottomViewDefaultOriginY;
}

@property (nonatomic, strong) UICollectionView  *collectionView;
@property (nonatomic, strong) UIView            *bottomView;
@property (nonatomic, strong) UIView            *backBlackView;
@property (nonatomic, strong) UIButton          *dismissBtn;


@property (nonatomic, weak)   AccountingView    *outerView;
@property (nonatomic, copy)   NSArray           *options;
@property (nonatomic)         BOOL              isIn;

@property (nonatomic)         BudgetType        type;
@property (nonatomic)         NSInteger         selectedCategoryIndex;

@end


@implementation BottomOptionController

static NSString * const reuseIdentifier  = @"Bottom Collection View Cell";
NSInteger const numberOfOptionsInOnePage = 8;
NSInteger const numberOfRowsInOnePage    = 2;
CGFloat const horizontalMargin           = 30.0f;


- (void)setNestedView:(UIView *)nestedView {
    self.outerView = (AccountingView *)nestedView;
}

- (instancetype)initWithOptions:(NSArray *)options superFrame:(CGRect)frame andBudgetType:(BudgetType)type {
    self = [super init];
    if ( self) {
        self.view.frame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
        
        //init options
        _options = [options copy];
        
        //init type
        _type = type;
        
        //init back view
        _backBlackView = [[UIView alloc] initWithFrame:frame];
        _backBlackView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        [self.view addSubview:_backBlackView];
        
        //init dismiss button [this btn cannot perform it's function]
        _dismissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _dismissBtn.frame = frame;
        _dismissBtn.backgroundColor = [UIColor clearColor];
        [_dismissBtn addTarget:self action:@selector(viewMovingOutToBottom) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_dismissBtn];
        
        //init bottom view
        CGRect bFrame = CGRectMake(0, CGRectGetHeight(frame), CGRectGetWidth(frame), CGRectGetHeight(frame) * 0.5f);
        _bottomView = [[UIView alloc] initWithFrame:bFrame];
        _bottomView.backgroundColor = [ColorUtil backgroundColor];
        [self.view addSubview:_bottomView];
        
        //init top title label
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, CGRectGetWidth(frame), 40)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:20];
        label.textColor = [UIColor whiteColor];
        label.text = type == BudgetTypeIncome ? @"收入类目" : @"支出类目";
        [_bottomView addSubview:label];
        
        //init drag lines
        UIImageView *dragLines = [[UIImageView alloc] initWithFrame:CGRectMake(0, 22, CGRectGetWidth(frame), 15)];
        dragLines.image = [UIImage imageNamed:@"drag_line"];
        [_bottomView addSubview:dragLines];
        
        //add pan gesture recognizer to drag lines
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragAction:)];
        [dragLines addGestureRecognizer:panRecognizer];
        dragLines.userInteractionEnabled = YES;
        
        
        //init collection view
        CGSize    itemSize                 = CGSizeMake(80, 100);
        NSInteger numberOfColsInOnePage    = numberOfOptionsInOnePage / numberOfRowsInOnePage;
        CGRect cFrame = CGRectMake(0, CGRectGetHeight(label.frame), CGRectGetWidth(frame), 240);
        CGFloat   collectionMinLineSpacing = (CGRectGetWidth(frame) - numberOfColsInOnePage * itemSize.width - 2 * horizontalMargin) / (numberOfColsInOnePage - 1);
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize           = itemSize;
        layout.sectionInset       = UIEdgeInsetsMake(20, horizontalMargin, 10, horizontalMargin);
        layout.minimumLineSpacing = collectionMinLineSpacing;
        layout.scrollDirection    = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:cFrame collectionViewLayout:layout];
        _collectionView.backgroundColor = [ColorUtil backgroundColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_bottomView addSubview:_collectionView];
        
        //init done button
        UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(horizontalMargin, cFrame.origin.y + CGRectGetHeight(cFrame), CGRectGetWidth(frame) - 2 * horizontalMargin, 40)];
        doneButton.backgroundColor = _type == BudgetTypeIncome ? [ColorUtil incomeColor] : [ColorUtil expenditureColor];
        [doneButton setTitle:@"确定" forState:UIControlStateNormal];
        doneButton.titleLabel.font = [UIFont boldSystemFontOfSize:22];
        doneButton.layer.cornerRadius = 5.0f;
        doneButton.layer.masksToBounds = YES;
        [doneButton addTarget:self action:@selector(selectCategory) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:doneButton];
        
        //register collcetion view cell
        [_collectionView registerClass:[BottomCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
        
        self.view.backgroundColor = [UIColor clearColor];
        self.view.userInteractionEnabled = NO;
        
        //init default data
        _isIn = NO;
        _selectedCategoryIndex = 0;
        bottomViewDefaultOriginY = frame.size.height - bFrame.size.height;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewMovingInFromBottom {
    [self.delegate willShow];
    CGRect cFrame = _bottomView.frame;
    [UIView animateWithDuration:defaultAnimationDuration animations:^{
        _bottomView.frame = CGRectMake(cFrame.origin.x, bottomViewDefaultOriginY, cFrame.size.width, cFrame.size.height);
    } completion:^(BOOL finished) {
        if ( finished) {
            self.view.userInteractionEnabled = YES;
            [self.delegate didShow];
        }
    }];
}

- (void)viewMovingOutToBottom {
    [self.delegate willDisappear];
    self.view.userInteractionEnabled = NO;
    CGRect cFrame = self.collectionView.frame;
    [UIView animateWithDuration:defaultAnimationDuration animations:^{
        _bottomView.frame = CGRectMake(cFrame.origin.x, self.view.frame.size.height, cFrame.size.width, cFrame.size.height);
    } completion:^(BOOL finished) {
        if ( finished) {
            [self.delegate didDisappear];
            [self.view removeFromSuperview];
        }
    }];
}

#pragma -mark Done Button Action

- (void)selectCategory {
    NSLog(@"cat img btn action");
    BottomOption *option = (BottomOption *)self.options[_selectedCategoryIndex];
    
    AccountCategory *cat = [[AccountCategory alloc] init];
    cat.categoryId       = option.optionId;
    cat.categoryName     = option.optionName;
    cat.categoryImageUrl = option.imagePath;
    
    [self.outerView setCategory:cat];
    [self viewMovingOutToBottom];
}

#pragma -mark Draging Action

- (void)dragAction:(UIPanGestureRecognizer *)recognizer {
    
    CGPoint point = [recognizer translationInView:self.view];
    NSLog(@"x = %f, y = %f", point.x, point.y);
    
    if ( point.y < 0 && _bottomView.frame.origin.y >= bottomViewDefaultOriginY) {
        return ;
    }
    
    if ( recognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"draging began");
    } else if ( recognizer.state == UIGestureRecognizerStateChanged) {
        _bottomView.frame = CGRectMake(0, bottomViewDefaultOriginY + point.y, CGRectGetWidth(_bottomView.frame), CGRectGetHeight(_bottomView.frame));
    } else if ( recognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"draging ended");
        CGFloat midDivideY = bottomViewDefaultOriginY + CGRectGetHeight(_bottomView.frame) / 2;
        if ( _bottomView.frame.origin.y < midDivideY) {
            _bottomView.frame = CGRectMake(_bottomView.frame.origin.x, bottomViewDefaultOriginY, CGRectGetWidth(_bottomView.frame), CGRectGetHeight(_bottomView.frame));
        } else {
            [self viewMovingOutToBottom];
        }
    }
}

#pragma -mark Collection View Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.options.count;
}

- (BottomCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BottomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    BottomOption *option = self.options[indexPath.row];
    UIImage *image;
    if ( option.imageSource == ImageSourceBundle) {
        image = [UIImage imageNamed:[option imagePath]];
    } else if ( option.imageSource == ImageSourceDocument) {
        image = [[UIImage alloc] initWithContentsOfFile:[URLUtil getCompleteImagePathWithComponent:[option imagePath]]];
    }
    
    cell.label.text = [option optionName];
    cell.catImage.image = image;
    cell.backgroundColor = [ColorUtil collectionCellColor];
    cell.layer.cornerRadius  = 5.0f;
    cell.layer.masksToBounds = YES;
    cell.layer.borderColor   = _type == BudgetTypeIncome ? [ColorUtil incomeColor].CGColor : [ColorUtil expenditureColor].CGColor;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BottomCollectionViewCell *cell = (BottomCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.layer.borderWidth   = 2.0f;
    _selectedCategoryIndex = indexPath.row;
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BottomCollectionViewCell *cell = (BottomCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.layer.borderWidth   = 0;

}

@end
