//
//  BottomOption.h
//  Accounting
//
//  Created by mesird on 11/5/15.
//  Copyright © 2015 mesird. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"


@interface BottomOption : NSObject

@property (nonatomic, strong) NSString      *imagePath;
@property (nonatomic)         ImageSource    imageSource;
@property (nonatomic, strong) NSString      *optionName;
@property (nonatomic, strong) NSString      *optionDescription;
@property (nonatomic)         NSInteger      optionId;
@property (nonatomic)         EditableState  editable;
@property (nonatomic)         BOOL           selected;

@end
