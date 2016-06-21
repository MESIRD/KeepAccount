//
//  Record.h
//  Accounting
//
//  Created by mesird on 10/4/15.
//  Copyright © 2015 mesird. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface Record : NSObject

@property (nonatomic) NSInteger   id;
@property (nonatomic) NSInteger   pocketId;
@property (nonatomic) NSString    *pocketName;
@property (nonatomic) NSInteger   categoryId;
@property (nonatomic) NSString    *categoryName;
@property (nonatomic) NSString    *categoryImageUrl;
@property (nonatomic) ImageSource catImgSource;
@property (nonatomic) long        amount;
@property (nonatomic) NSString    *recDescription;
@property (nonatomic) short       budgetType;
@property (nonatomic) NSString    *imgUrl;
@property (nonatomic) ImageSource recImgSource;
@property (nonatomic) NSDate      *gmtCreate;
@property (nonatomic) NSDate      *gmtModified;

@end
