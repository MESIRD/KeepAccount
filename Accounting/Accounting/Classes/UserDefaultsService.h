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

- (void)setPocketBalance:(NSInteger)balance;
- (NSInteger)getPocketBalance;

@end
