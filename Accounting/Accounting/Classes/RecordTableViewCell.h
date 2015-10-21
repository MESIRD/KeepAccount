//
//  RecordTableViewCell.h
//  Accounting
//
//  Created by mesird on 10/4/15.
//  Copyright © 2015 mesird. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel  *amountLabel;
@property (strong, nonatomic) IBOutlet UILabel  *categoryLabel;
@property (strong, nonatomic) IBOutlet UIView   *categoryView;

@property (nonatomic) NSInteger amount;
@property (strong, nonatomic) NSString  *category;

@end
