//
//  AppDelegate.m
//  Accounting
//
//  Created by mesird on 10/3/15.
//  Copyright © 2015 mesird. All rights reserved.
//

#import "AppDelegate.h"
#import "TalkingData.h"
#import "UserDefaultsService.h"
#import "DBService.h"
#import "URLUtil.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

NSString *talkingDataAppId = @"3BD513E38E7CF056BD207A2AC74E9598";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //add TalkingData sdk to monitor application situations
    [TalkingData sessionStarted:talkingDataAppId withChannelId:@"开发测试"];
    
    
    //fisrt launch application
    if ( [[UserDefaultsService sharedUserDefaultsService] getFirstLaunchingApplication]) {
        //create db and tables
        [self initializeApplicationDatabase];
        
        //set default pocket name
        [[UserDefaultsService sharedUserDefaultsService] setPocketName:@"钱包名称"];
        
        [[UserDefaultsService sharedUserDefaultsService] setFirstLaunchingApplication:NO];
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    //close database connection
    FMDatabase *db = [DBService sharedDB];
    if ( db) {
        [db close];
    }
}

#pragma -mark additional
- (void)initializeApplicationDatabase {
    
    //create application tables
    [DBService createApplicationTables];
    
    //insert initial data
    [DBService insertInitialData];
    
    //create dir
    [self createDirectory];
}

- (void)createDirectory {

    //create image dir
    [[NSFileManager defaultManager] createDirectoryAtPath:[URLUtil getCompleteImagePath] withIntermediateDirectories:YES attributes:nil error:nil];
}

@end
