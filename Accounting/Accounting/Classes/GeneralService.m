//
//  GeneralService.m
//  Accounting
//
//  Created by mesird on 11/16/15.
//  Copyright © 2015 mesird. All rights reserved.
//

#import "GeneralService.h"
#import "DBService.h"

@implementation GeneralService

+ (GeneralService *)sharedGeneralService {
    static GeneralService *sharedGeneralService;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedGeneralService = [[self alloc] init];
    });
    return sharedGeneralService;
}

- (BOOL)updatePocketName:(NSString *)pocketName {
    NSString *sql = [NSString stringWithFormat:@"update Pocket set name = '%@'", [DBService transcodeString:pocketName]];
    return [[DBService sharedDB] executeUpdate:sql];
}

@end
