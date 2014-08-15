//
//  BSBuyerAPIClient.h
//  BASE
//
//  Created by Takkun on 2014/02/17.
//  Copyright (c) 2014年 Takkun. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "BSDefaultViewObject.h"

@interface DataConnect : AFHTTPSessionManager


///---------------------------------------------------------------------------------------
/// @name インスタンスを得る
///---------------------------------------------------------------------------------------

+ (instancetype)sharedClient;

///---------------------------------------------------------------------------------------
/// @name API とのやりとり
///---------------------------------------------------------------------------------------


#pragma mark - Shops

-(void)createUserCompletion:(void (^)(NSDictionary *,
                                      NSURLSessionDataTask *,
                                      NSError *))block;


-(void)sendMessage:(NSString *)message
         deviceKey:(NSString *)deviceKey
        timeLineId:(NSString *)timeLineId
           members:(NSArray *)members
        completion:(void (^)(NSDictionary *,
                             NSURLSessionDataTask *,
                             NSError *))block;

@end
