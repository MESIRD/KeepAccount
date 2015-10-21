//
//  HomeAccountingService.m
//  Accounting
//
//  Created by mesird on 10/5/15.
//  Copyright © 2015 mesird. All rights reserved.
//

#import "HomeAccountingService.h"
#import "Record.h"

@implementation HomeAccountingService

- (NSArray *)fetchRecentRecordFromLocal {
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < 10; ++ i) {
        Record *record = [[Record alloc] init];
        record.amount = i * 100 + 829;
        record.category = @"食";
        [array addObject:record];
    }
    return [array copy];
}

@end
