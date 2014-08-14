//
//  BSDefaultViewObject.h
//  BASE
//
//  Created by Takkun on 2013/04/12.
//  Copyright (c) 2013年 Takkun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSDefaultViewObject : NSObject

+ (UIImageView*)setBackground;
+ (NSString*)setApiUrl;
+ (BOOL)isMoreIos7;
+ (void)customNavigationBar:(int)isBuySide;
//+ (void)customNavigationBarForIos7:(int)isBuySide;
+ (void)setNavigationBar:(UINavigationBar*)navBar;

@end
