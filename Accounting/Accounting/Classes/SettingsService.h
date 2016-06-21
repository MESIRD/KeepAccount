//
//  SettingsService.h
//  Accounting
//
//  Created by mesird on 10/6/15.
//  Copyright © 2015 mesird. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@class AccountCategory;
@interface SettingsService : NSObject

- (void)clearUserData;

- (NSInteger)countCategory:(BudgetType)type;
- (NSArray *)getCategories:(BudgetType)type;
- (BOOL)createCategory:(AccountCategory *)category;
- (BOOL)deleteCategories:(NSArray *)categoryIds;
- (BOOL)updateCategory:(AccountCategory *)category;

@end
