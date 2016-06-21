//
//  UserDefaultsService.m
//  Accounting
//
//  Created by mesird on 10/5/15.
//  Copyright © 2015 mesird. All rights reserved.
//

#import "UserDefaultsService.h"
#import "GeneralService.h"

@interface UserDefaultsService()

@property (strong, nonatomic) NSUserDefaults *userDefaults;

@end

@implementation UserDefaultsService

static NSString *POCKET_NAME    = @"pocket_name";
static NSString *POCKET_ID      = @"pocket_id";
static NSString *POCKET_BALANCE = @"pocket_balance";
static NSString *FIRST_LAUNCH   = @"first_launch";

static NSString *TRUE_STR       = @"yes";
static NSString *FALSE_STR      = @"no";

+ (UserDefaultsService *)sharedUserDefaultsService {
    
    static dispatch_once_t once;
    static UserDefaultsService *sharedUserDefaultsService;
    dispatch_once(&once, ^ {
        sharedUserDefaultsService = [[self alloc] init];
        sharedUserDefaultsService.userDefaults = [NSUserDefaults standardUserDefaults];
    });
    return sharedUserDefaultsService;
}

- (void)setPocketName:(NSString *)pocketName {
    //change pocket name in database
    [[GeneralService sharedGeneralService] updatePocketName:pocketName];
    
    //change pocket name in user defaults
    [self.userDefaults setObject:pocketName forKey:POCKET_NAME];
}

- (NSString *)getPocketName {
    return [NSString stringWithFormat:@"%@", [self.userDefaults objectForKey:POCKET_NAME]];
}

- (void)setPocketId:(NSInteger)pocketId {
    [self.userDefaults setObject:[NSNumber numberWithLong:pocketId] forKey:POCKET_ID];
}

- (NSInteger)getPocketId {
    return [[self.userDefaults objectForKey:POCKET_ID] integerValue];
}

- (void)setPocketBalance:(NSInteger)balance {
    [self.userDefaults setObject:[NSNumber numberWithInteger:balance] forKey:POCKET_BALANCE];
}

- (NSInteger)getPocketBalance {
    return [[self.userDefaults objectForKey:POCKET_BALANCE] integerValue];
}

- (void)setFirstLaunchingApplication:(BOOL)isFirstLaunchingApplication {
    [self.userDefaults setObject:isFirstLaunchingApplication ? TRUE_STR : FALSE_STR forKey:FIRST_LAUNCH];
}

- (BOOL)getFirstLaunchingApplication {
    BOOL secondLaunch = [[self.userDefaults objectForKey:FIRST_LAUNCH] isEqualToString:FALSE_STR];
    return !secondLaunch;
}

@end
