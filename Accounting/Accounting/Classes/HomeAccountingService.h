//
//  HomeAccountingService.h
//  Accounting
//
//  Created by mesird on 10/5/15.
//  Copyright © 2015 mesird. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Record.h"
#import "Constants.h"

@interface HomeAccountingService : NSObject

- (NSArray *)fetchRecentRecordsFromLocal;

- (BOOL)createNewRecord:(Record *)record;

- (NSArray *)getCategory:(BudgetType)type;

- (NSInteger)getCurrentPocketBalanceWithPocketId:(NSInteger)pocketId;
- (NSInteger)getCurrentMonthIncomeWithPocketId:(NSInteger)pocketId;
- (NSInteger)getCurrentMonthExpenditureWithPocketId:(NSInteger)pocketId;
@end
