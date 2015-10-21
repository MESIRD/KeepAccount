//
//  UserDefaultsService.m
//  Accounting
//
//  Created by mesird on 10/5/15.
//  Copyright © 2015 mesird. All rights reserved.
//

#import "UserDefaultsService.h"

@interface UserDefaultsService()

@property (strong, nonatomic) NSUserDefaults *userDefaults;

@end

@implementation UserDefaultsService

static NSString *POCKET_NAME    = @"pocket_name";
static NSString *POCKET_BALANCE = @"pocket_balance";

static UserDefaultsService *sharedUserDefaultsService;

+ (UserDefaultsService *)sharedUserDefaultsService {
    if ( !sharedUserDefaultsService) {
        sharedUserDefaultsService = [[UserDefaultsService alloc] init];
        sharedUserDefaultsService.userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return sharedUserDefaultsService;
}

- (void)setPocketName:(NSString *)pocketName {
    [self.userDefaults setObject:pocketName forKey:POCKET_NAME];
}

- (NSString *)getPocketName {
    return [NSString stringWithFormat:@"%@", [self.userDefaults objectForKey:POCKET_NAME]];
}

- (void)setPocketBalance:(NSInteger)balance {
    [self.userDefaults setObject:[NSNumber numberWithInteger:balance] forKey:POCKET_BALANCE];
}

- (NSInteger)getPocketBalance {
    return [[self.userDefaults objectForKey:POCKET_BALANCE] integerValue];
}

@end
