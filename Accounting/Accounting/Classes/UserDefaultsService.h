//
//  UserDefaultsService.h
//  Accounting
//
//  Created by mesird on 10/5/15.
//  Copyright © 2015 mesird. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDefaultsService : NSObject

+ (UserDefaultsService *)sharedUserDefaultsService;

- (void)setPocketName:(NSString *)pocketName;
- (NSString *)getPocketName;

- (void)setPocketId:(NSInteger)pocketId;
- (NSInteger)getPocketId;

- (void)setPocketBalance:(NSInteger)balance;
- (NSInteger)getPocketBalance;

- (void)setFirstLaunchingApplication:(BOOL)isFirstLaunchingApplication;
- (BOOL)getFirstLaunchingApplication;

@end
