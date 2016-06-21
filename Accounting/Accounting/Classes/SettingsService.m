//
//  SettingsService.m
//  Accounting
//
//  Created by mesird on 10/6/15.
//  Copyright © 2015 mesird. All rights reserved.
//

#import "SettingsService.h"
#import "UserDefaultsService.h"
#import "DBService.h"
#import "BottomOption.h"
#import "AccountCategory.h"
#import "URLUtil.h"


@implementation SettingsService

- (void)clearUserData {
    //clear record
    
    NSString *querySql = [NSString stringWithFormat:@"select imgUrl from AccountFlow"];
    FMResultSet *resultSet = [[DBService sharedDB] executeQuery:querySql];
    
    //delete pictures in document dir

    while ([resultSet next]) {
        NSString *imgName = [resultSet stringForColumnIndex:0];
        if ( ![imgName isEqualToString:@""]) {
            NSError *removeError = nil;
            [[NSFileManager defaultManager] removeItemAtPath:[URLUtil getCompleteImagePathWithComponent:imgName] error:&removeError];
            if ( removeError) {
                NSLog(@"fail to delete image : imageName = %@, error = %@", imgName, [removeError localizedDescription]);
            }
        }
    }
    
    NSString *deleteSql = [NSString stringWithFormat:@"delete from AccountFlow"];
    NSError *deleteError = nil;
    if (![[DBService sharedDB] executeUpdate:deleteSql withErrorAndBindings:&deleteError]) {
        NSLog(@"fail to clear account flows : error = %@", [deleteError localizedDescription]);
        return ;
    }
}

- (NSInteger)countCategory:(BudgetType)type {
    NSString *sql = [NSString stringWithFormat:@"select count(id) from Category where type = %ld", (long)type];
    FMResultSet *resultSet = [[DBService sharedDB] executeQuery:sql];
    if ( [resultSet next]) {
        return [resultSet intForColumnIndex:0];
    }
    return 0;
}

- (NSArray *)getCategories:(BudgetType)type {
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

- (BOOL)createCategory:(AccountCategory *)category {
    NSDate *now = [NSDate date];
    NSString *sql = [NSString stringWithFormat:@"insert into Category (title, description, type, imgUrl,imgSource, editable, gmtCreate, gmtModified) values ('%@', '%@', %ld, '%@', %ld, %ld, '%@', '%@')", [DBService transcodeString:category.categoryName], [DBService transcodeString:category.categoryDescription], (long)category.type, category.categoryImageUrl, category.categoryImageSource, category.categoryEditable, now, now];
    return [[DBService sharedDB] executeUpdate:sql];
}

- (BOOL)updateCategory:(AccountCategory *)category {
    NSDate *now = [NSDate date];
    NSString *sql = [NSString stringWithFormat:@"update Category set title = '%@', description = '%@', type = %ld, imgUrl = '%@', imgSource = %ld, editable = %ld, gmtModified = '%@' where id = %ld", [DBService transcodeString:category.categoryName], [DBService transcodeString:category.categoryDescription], (long)category.type, category.categoryImageUrl, category.categoryImageSource, category.categoryEditable, now, (long)category.categoryId];
    return [[DBService sharedDB] executeUpdate:sql];
}

- (BOOL)deleteCategories:(NSArray *)categoryIds {
    NSMutableString *idsString = [NSMutableString stringWithFormat:@"("];
    for (NSNumber *catId in categoryIds) {
        [idsString appendFormat:@"%@,", catId];
    }
    idsString = [[idsString substringToIndex:idsString.length - 1] mutableCopy];
    [idsString appendFormat:@")"];
    NSString *recDelSql = [NSString stringWithFormat:@"delete from AccountFlow where categoryId in %@;", idsString];
    NSString *catDelSql = [NSString stringWithFormat:@"delete from Category where id in %@;", idsString];
    return [[DBService sharedDB] executeStatements:[NSString stringWithFormat:@"%@%@", recDelSql, catDelSql]];
}

@end
