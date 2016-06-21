//
//  DBService.m
//  Accounting
//
//  Created by mesird on 10/27/15.
//  Copyright © 2015 mesird. All rights reserved.
//

#import "DBService.h"
#import "URLUtil.h"
#import "Constants.h"

static FMDatabase *db = nil;

@interface DBService()

@end

@implementation DBService

+ (FMDatabase *)sharedDB {
    if ( !db) {
        NSString *dbConfigPath = [[NSBundle mainBundle] pathForResource:@"db" ofType:@"plist"];
        if ( dbConfigPath) {
            NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:dbConfigPath];
            NSString *dbPath = [URLUtil getCompletePathWithComponent:[dic objectForKey:@"db_name"]];
            NSLog(@"%@", dbPath);
            db = [FMDatabase databaseWithPath:dbPath];
            if ( ![db open]) {
                return nil;
            }
        } else {
            NSLog(@"database is not initialized : Cannot find db path.");
        }
    }
    return db;
}

+ (BOOL)createApplicationTables {
    
    NSString *sql = @"CREATE TABLE User (id integer PRIMARY KEY AUTOINCREMENT NOT NULL, name varchar(128), mobile varchar(18), gender tinyint(1), mail varchar(256), birthdate date, gmtCreate date, gmtModified date);"
    "CREATE TABLE Pocket ( id integer PRIMARY KEY AUTOINCREMENT NOT NULL, name varchar(128) DEFAULT(''), balance bigint, imgUrl varchar(512), gmtCreate date, gmtModified date );"
    "CREATE TABLE Category ( id integer PRIMARY KEY AUTOINCREMENT NOT NULL, title varchar(128), description varchar(512), type tinyint(1), imgUrl varchar(512), imgSource tinyint(1), editable tinyint(1), gmtCreate date, gmtModified date);"
    "CREATE TABLE AccountFlow ( id integer PRIMARY KEY AUTOINCREMENT NOT NULL, pocketId integer, categoryId integer, amount bigint, description varchar(1024) DEFAULT(''), budgetType tinyint(1), imgUrl varchar(512) DEFAULT(''), imgSource tinyint(1), gmtCreate date, gmtModified date);";
    
    return [[self sharedDB] executeStatements:sql];
}

+ (BOOL)insertInitialData {
    
    NSDate *now = [NSDate date];
    //create categories
    NSString *catSql = [NSString stringWithFormat:@"INSERT INTO Category(title, description, type, imgUrl, imgSource, editable, gmtCreate, gmtModified) VALUES"

                        //默认支出类目
                        "('一般', '普通的消费类目', 1, 'cat_general',   0, 0, '%@', '%@'),"
                        "('餐饮', '吃吃喝喝',      1, 'cat_food',      0, 0, '%@', '%@'),"
                        "('交通', '各种出行方式',   1, 'cat_transport', 0, 0, '%@', '%@'),"
                        "('家居', '家庭物品',      1, 'cat_living',    0, 0, '%@', '%@'),"
                        "('衣物', '穿衣搭配',      1, 'cat_clothes',   0, 0, '%@', '%@'),"
                        
                        //默认收入类目
                        "('一般', '普通的收入类目', 0, 'cat_general',   0, 0, '%@', '%@'),"
                        "('薪水', '辛苦工作的回报', 0, 'cat_salary',    0, 0, '%@', '%@')", now, now, now, now, now, now, now, now, now, now, now, now, now, now];
    
    //create default pocket
    NSString *pocketSql = [NSString stringWithFormat:@"INSERT INTO Pocket(name, balance, imgUrl, gmtCreate, gmtModified) VALUES ('主人的钱包', 0, '', '%@', '%@')", now, now];
    
    //execute sql
    NSString *sql = [NSString stringWithFormat:@"%@;%@;", catSql, pocketSql];
    return [[self sharedDB] executeStatements:sql];
}


//convert the original string to the savable format string
+ (NSString *)transcodeString:(NSString *)string {
    return [string stringByReplacingOccurrencesOfString:@"\'" withString:@"\'\'"];
}

@end
