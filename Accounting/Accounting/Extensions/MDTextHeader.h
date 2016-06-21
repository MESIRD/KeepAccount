//
//  MDTextHeader.h
//  Accounting
//
//  Created by mesird on 10/30/15.
//  Copyright © 2015 mesird. All rights reserved.
//

#import <MJRefresh/MJRefresh.h>

@interface MDTextHeader : MJRefreshHeader

- (void)setIdelTitle:(NSString *)idel pullingTitle:(NSString *)pulling andRefreshingTitle:(NSString *)refreshing;
- (void)setLabelFont:(UIFont *)font;

@end
