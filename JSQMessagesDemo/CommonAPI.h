//
//  CommonAPI.h
//  JSQMessages
//
//  Created by EndoTsuyoshi on 2014/08/17.
//  Copyright (c) 2014年 Hexed Bits. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonAPI : NSObject


+(void)setIdArray:(NSArray *)arrayInput;
+(NSArray *)getIdArray;
+(BOOL)addId:(NSString *)strId;
+(NSString *)getIdNoAt:(int)no;
//+(NSArray *)initArrayGroupId;

@end
