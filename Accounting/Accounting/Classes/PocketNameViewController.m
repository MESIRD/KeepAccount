//
//  PocketNameViewController.m
//  Accounting
//
//  Created by mesird on 10/9/15.
//  Copyright © 2015 mesird. All rights reserved.
//

#import "PocketNameViewController.h"
#import "UserDefaultsService.h"
#import "Constants.h"

@implementation PocketNameViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if ( self) {
        //set title
        self.title = @"钱包名";
        
        //create done button
        UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(updatePocketName)];
        doneButtonItem.tintColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem = doneButtonItem;
    }
    return self;
}

- (void)awakeFromNib {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //set default value of pocket name
    self.pocketNameLabel.text = [[UserDefaultsService sharedUserDefaultsService] getPocketName];
    
    //configure appearance
    self.inputView.layer.cornerRadius = 5.0f;
    self.inputView.layer.masksToBounds = YES;
    self.inputView.layer.borderWidth = 1.0f;
    self.inputView.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void)updatePocketName {
    if ( ![[[UserDefaultsService sharedUserDefaultsService] getPocketName] isEqualToString:self.pocketNameLabel.text]) {
        [[UserDefaultsService sharedUserDefaultsService] setPocketName:self.pocketNameLabel.text];
        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdatePocketName object:nil];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
