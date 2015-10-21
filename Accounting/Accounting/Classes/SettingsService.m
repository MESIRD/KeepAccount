//
//  SettingsService.m
//  Accounting
//
//  Created by mesird on 10/6/15.
//  Copyright © 2015 mesird. All rights reserved.
//

#import "SettingsService.h"
#import "UserDefaultsService.h"

@implementation SettingsService

- (void)clearUserData {
    //1. reset pocket balance
    [[UserDefaultsService sharedUserDefaultsService] setPocketBalance:0];
}

@end
