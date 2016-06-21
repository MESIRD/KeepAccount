//
//  HomeController.h
//  Accounting
//
//  Created by mesird on 10/3/15.
//  Copyright © 2015 mesird. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecentRecordTableView.h"

@interface HomeController : UIViewController
@property (strong, nonatomic) IBOutlet RecentRecordTableView *recentRecordTV;
@property (strong, nonatomic) IBOutlet UIView *showEmptyView;
@property (strong, nonatomic) IBOutlet UIVisualEffectView *blurEffectView;


- (void)showNewRecordOptions;

@end
