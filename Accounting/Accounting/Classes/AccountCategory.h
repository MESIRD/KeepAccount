//
//  AccountCategory.h
//  Accounting
//
//  Created by mesird on 11/6/15.
//  Copyright © 2015 mesird. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface AccountCategory : NSObject

@property (nonatomic)            short categoryId;
@property (nonatomic, strong) NSString *categoryName;
@property (nonatomic, strong) NSString *categoryDescription;
@property (nonatomic)            short type;
@property (nonatomic, strong) NSString *categoryImageUrl;
@property (nonatomic)      ImageSource categoryImageSource;
@property (nonatomic)    EditableState categoryEditable;

@end
