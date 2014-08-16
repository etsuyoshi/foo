//
//  BSBuyerAPIClient.m
//  BASE
//
//  Created by Takkun on 2014/02/17.
//  Copyright (c) 2014年 Takkun. All rights reserved.
//

#import "DataConnect.h"


// static NSString * const kBSAPIBaseURLString = @"https://dt.thebase.in";     // 本番環境
// static NSString * const kBSAPIBaseURLString = @"http://dt.base0.info";      // ステージング
// static NSString * const kBSAPIBaseURLString = @"http://api.base0.info";     // テスト
// static NSString * const kBSAPIBaseURLString = @"http://api.n-base.info";    // テスト
// static NSString * const kBSAPIBaseURLString = @"https://dt.thebase.in";     // 反社チェック用


@implementation DataConnect

+ (instancetype)sharedClient
{
    static DataConnect *_sharedClient = nil;
    static dispatch_once_t onceToken;
    /*_/_/_/_/_/_/_/_/_/_/_/_/_/_/遠藤追加_/_/_/_/_/_/_/_/_/_/_/_/_/*/
    NSString * const kBSAPIBaseURLString = [BSDefaultViewObject setApiUrl];
    /*_/_/_/_/_/_/_/_/_/_/_/_/_/_/遠藤追加_/_/_/_/_/_/_/_/_/_/_/_/_/*/
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.HTTPAdditionalHeaders = @{
                                                @"Accept" : @"application/json",
                                                };
        
        _sharedClient = [[DataConnect alloc]
                         initWithBaseURL:[NSURL URLWithString:kBSAPIBaseURLString]
                         sessionConfiguration:configuration];
    });
    
    return _sharedClient;
}

#pragma mark - Shops



-(void)createUserCompletion:(void (^)(NSDictionary *,
                                      NSURLSessionDataTask *,
                                      NSError *))block{
    
    
//    if([strSessionId isEqual:[NSNull null]] ||
//       strSessionId == nil){
//        
//        return ;
//    }
    
    
    [self GET:@"/users/create"
   parameters:nil
      success:^(NSURLSessionDataTask *task, id responseObject) {
          NSLog(@"success");
         if (block) block(responseObject, task, nil);
     }failure:^(NSURLSessionDataTask *task, NSError *error) {
         NSLog(@"failure");
          // 401 が返ったときログインが必要.
         if (block) block(nil, task, error);
//          if (((NSHTTPURLResponse *)task.response).statusCode == 401) {
//              if (block) block(nil, task, nil);
//          }
//          else {
//              if (block) block(nil, task, error);
//          }
      }];
}


-(void)sendMessage:(NSString *)message
         deviceKey:(NSString *)deviceKey
        timeLineId:(NSString *)timeLineId
           members:(NSArray *)members
        completion:(void (^)(NSDictionary *,
                             NSURLSessionDataTask *,
                             NSError *))block{
    NSMutableDictionary *parameters =
    [NSMutableDictionary dictionary];
    
    if(deviceKey){
        parameters[@"device_key"] = deviceKey;
    }else{
        NSLog(@"device_key null");
        return;
    }
//    timelineidははじめてのチャットのケースでnil
//    if(timeLineId){
//        parameters[@"time_line_id"] = timeLineId;
//    }else{
//        NSLog(@"time_line_id null");
//        return;
//    }
    if(members.count > 0){
        parameters[@"members"] = members;
    }else{
        NSLog(@"members count = 0");
        return;
    }
    if(message){
        parameters[@"message"] = message;
    }else{
        NSLog(@"message null");
        return;
    }
    
    [self POST:@"/messages/post"
   parameters:parameters
      success:^(NSURLSessionDataTask *task,
                id responseObject){
          NSLog(@"success");
          if(block)block(responseObject, task, nil);
      }
      failure:^(NSURLSessionDataTask *task,
                NSError *error){
          NSLog(@"failure");
          if(block)block(nil, task, error);
      }];
    
    
}

//POST /users/find
-(void)findUserWithDeviceKey:(NSString *)deviceKey
           accountId:(NSString *)accountId
        completion:(void (^)(NSDictionary *,
                             NSURLSessionDataTask *,
                             NSError *))block{
    NSMutableDictionary *parameters =
    [NSMutableDictionary dictionary];
    
    if(deviceKey){
        parameters[@"device_key"] = deviceKey;
    }else{
        NSLog(@"device_key null");
        return;
    }
    if(accountId){
        parameters[@"account_id"] = accountId;
    }else{
        NSLog(@"account_id null");
        return;
    }
    
    [self POST:@"/users/find"
    parameters:parameters
       success:^(NSURLSessionDataTask *task,
                 id responseObject){
           NSLog(@"success");
           if(block)block(responseObject, task, nil);
       }
       failure:^(NSURLSessionDataTask *task,
                 NSError *error){
           NSLog(@"failure");
           if(block)block(nil, task, error);
       }];
    
    
}

-(void)updateUsersWithDeviceKey:(NSString *)deviceKey
                      accountId:(NSString *)accountId
                           name:(NSString *)name
                     completion:(void (^)(NSDictionary *,
                                          NSURLSessionDataTask *,
                                          NSError *))block{
    NSMutableDictionary *parameters =
    [NSMutableDictionary dictionary];
    
    if(deviceKey){
        parameters[@"device_key"] = deviceKey;
    }else{
        NSLog(@"devicekey null");
    }
    
    if(!(name      == nil || [name isEqual:[NSNull null]]) ||
       !(accountId == nil || [accountId isEqual:[NSNull null]])
       ){
        if(name){
            parameters[@"name"] = name;
        }
        
        if(accountId){
            parameters[@"account_id"] = accountId;
        }
    }else{
        NSLog(@"null error");
        return;
    }
    
    
    
    [self POST:@"/users/update"
    parameters:parameters
       success:^(NSURLSessionDataTask *task,
                 id responseObject){
           NSLog(@"success");
           if(block)block(responseObject, task, nil);
       }
       failure:^(NSURLSessionDataTask *task,
                 NSError *error){
           NSLog(@"failure");
           if(block)block(nil, task, error);
       }];
    
}

@end
