//
//  DBService.h
//  Accounting
//
//  Created by mesird on 10/27/15.
//  Copyright © 2015 mesird. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface DBService : NSObject

+ (FMDatabase *)sharedDB;

+ (BOOL)createApplicationTables;
+ (BOOL)insertInitialData;

+ (NSString *)transcodeString:(NSString *)string;
@end
