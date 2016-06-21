//
//  HomeAccountingService.m
//  Accounting
//
//  Created by mesird on 10/5/15.
//  Copyright © 2015 mesird. All rights reserved.
//

#import "HomeAccountingService.h"
#import "DBService.h"
#import "BottomOption.h"
#import "Constants.h"

@implementation HomeAccountingService

- (NSArray *)fetchRecentRecordsFromLocal {
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    NSString *sql = [NSString stringWithFormat:@"select a.amount, a.description, a.budgetType, a.imgUrl, a.imgSource, b.title, b.imgUrl, b.imgSource, a.gmtCreate from AccountFlow as a left join Category as b where a.categoryId = b.id order by a.gmtCreate desc"];
    FMResultSet *resultSet = [[DBService sharedDB] executeQuery:sql];
    while ( [resultSet next]) {
        Record *record = [[Record alloc] init];
        record.amount = [resultSet longForColumnIndex:0];
        record.recDescription = [resultSet stringForColumnIndex:1];
        record.budgetType = [resultSet intForColumnIndex:2];
        record.imgUrl = [resultSet stringForColumnIndex:3];
        record.recImgSource = [resultSet intForColumnIndex:4];
        record.categoryName = [resultSet stringForColumnIndex:5];
        record.categoryImageUrl = [resultSet stringForColumnIndex:6];
        record.catImgSource = [resultSet intForColumnIndex:7];
        record.gmtCreate = [resultSet dateForColumnIndex:8];
        [array addObject:record];
    }
    return array;
}

- (BOOL)createNewRecord:(Record *)record {
    
    NSString *sql = [NSString stringWithFormat:@"insert into AccountFlow ('pocketId', 'categoryId', 'amount', 'description', 'budgetType', 'imgUrl', 'imgSource', 'gmtCreate', 'gmtModified') values (%ld, %ld, %ld, '%@', %d, '%@', %ld, '%@', '%@')", (long)record.pocketId, (long)record.categoryId, (long)record.amount, [DBService transcodeString:record.recDescription], record.budgetType, record.imgUrl, record.recImgSource, [NSDate date], [NSDate date]];
    return [[DBService sharedDB] executeUpdate:sql];
}

- (NSArray *)getCategory:(BudgetType)type {
    
    NSMutableArray *options = [[NSMutableArray alloc] init];
    NSString *sql = [NSString stringWithFormat:@"select id, title, description, imgUrl, imgSource, editable from Category where type = %ld", (long)type];
    FMResultSet *resultSet = [[DBService sharedDB] executeQuery:sql];
    while ( [resultSet next]) {
        BottomOption *option = [[BottomOption alloc] init];
        option.optionId = [resultSet intForColumnIndex:0];
        option.optionName = [resultSet stringForColumnIndex:1];
        option.optionDescription = [resultSet stringForColumnIndex:2];
        option.imagePath = [resultSet stringForColumnIndex:3];
        option.imageSource = [resultSet intForColumnIndex:4];
        option.editable = [resultSet intForColumnIndex:5];
        [options addObject:option];
    }
    return options;
}

- (NSInteger)getCurrentPocketBalanceWithPocketId:(NSInteger)pocketId {
    
    NSString *sql = [NSString stringWithFormat:@"select ifnull(sum(amount),0) - (select ifnull(sum(amount),0) from AccountFlow where pocketId = %ld and budgetType = 1) from AccountFlow where pocketId = %ld and budgetType = 0", (long)pocketId, (long)pocketId];
    FMResultSet *resultSet = [[DBService sharedDB] executeQuery:sql];
    if ( [resultSet next]) {
        return [resultSet intForColumnIndex:0];
    }
    NSLog(@"get pocket balance failed.");
    return 0;
}

- (NSInteger)getCurrentMonthExpenditureWithPocketId:(NSInteger)pocketId {
    
    NSString *sql = [NSString stringWithFormat:@"select ifnull(sum(amount), 0) from AccountFlow where pocketId = %ld and budgetType = %ld and gmtCreate > datetime('now', 'localtime', 'start of month')", (long)pocketId, (long)BudgetTypeExpenditure];
    FMResultSet *resultSet = [[DBService sharedDB] executeQuery:sql];
    if ( [resultSet next]) {
        return [resultSet intForColumnIndex:0];
    }
    NSLog(@"get current month expenditure failed.");
    return 0;
}

- (NSInteger)getCurrentMonthIncomeWithPocketId:(NSInteger)pocketId {
    
    NSString *sql = [NSString stringWithFormat:@"select ifnull(sum(amount), 0) from AccountFlow where pocketId = %ld and budgetType = %ld and gmtCreate > datetime('now', 'localtime', 'start of month')", (long)pocketId, (long)BudgetTypeIncome];
    FMResultSet *resultSet = [[DBService sharedDB] executeQuery:sql];
    if ( [resultSet next]) {
        return [resultSet intForColumnIndex:0];
    }
    NSLog(@"get current month income failed.");
    return 0;
}

@end
