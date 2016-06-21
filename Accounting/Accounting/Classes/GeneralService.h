//
//  GeneralService.h
//  Accounting
//
//  Created by mesird on 11/16/15.
//  Copyright © 2015 mesird. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GeneralService : NSObject

+ (GeneralService *)sharedGeneralService;

- (BOOL)updatePocketName:(NSString *)pocketName;

@end
