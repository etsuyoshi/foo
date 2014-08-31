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
    NSLog(@"/message/post : %@", parameters);
    [self POST:@"/messages/post"
   parameters:parameters
      success:^(NSURLSessionDataTask *task,
                id responseObject){
          NSLog(@"success");
          if(block)block(responseObject, task, nil);
      }
      failure:^(NSURLSessionDataTask *task,
                NSError *error){
          NSLog(@"failure : error= %@", error);
          if(block)block(nil, task, error);
      }];
    
    parameters = nil;
    
}

//POST /users/find
/*
 userinfo = {
     succeed = 1;
     user =     {
        "account_id" = taro;
        name = TARO;
     };
 
 */
-(void)findUserWithDeviceKey:(NSString *)deviceKey
           accountId:(NSString *)accountId
        completion:(void (^)(NSDictionary *,
                             NSURLSessionDataTask *,
                             NSError *))block{
    NSMutableDictionary *parameters =
    [NSMutableDictionary dictionary];
    
    //deviceKeyいらない
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
    
    parameters = nil;
    
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
        if(name != nil && ![name isEqual:[NSNull null]]){
            parameters[@"name"] = name;
            NSLog(@"nameを%@に設定します", name);
        }
        
        if(accountId != nil && ![accountId isEqual:[NSNull null]]){
            parameters[@"account_id"] = accountId;
            NSLog(@"account_idを%@に設定します", accountId);
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
    parameters = nil;
    
}

//id配列からidと名前の関連づけを作成
//+(void)createDictToUserName:(NSArray *)arrId{
//    for(int i = 0;i < arrId.count;i++){
//        [DataConnect:(NSString *)[UICKeyChainStore keyChainStoreWithService:@"ichat"]
//         accountId:(NSString *)arrId[i]
//         name:nil
//         completion:(void (^)(NSDictionary *,
//                              NSURLSessionDataTask *,
//                              NSError *))block{
//            
//            
//        }];
//    }
//}

//+(void)createTimeLine

-(void)receiveMessageToDeviceKey:(NSString *)deviceKey
                      timeLineId:(NSString *)timeLineId
                      completion:(void (^)(NSDictionary *,
                                           NSURLSessionDataTask *,
                                           NSError *))block{
    NSMutableDictionary *parameters =
    [NSMutableDictionary dictionary];
    
    if(deviceKey){
        parameters[@"device_key"] = deviceKey;
    }else{
        NSLog(@"devicekey null");
        return;
    }
    
    if(timeLineId) {
        parameters[@"time_line_id"] = timeLineId;
    }else{
        //do nothing
    }
    
    
    //メッセージを受信する
    [self POST:@"/messages/stream"
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
    parameters = nil;
}


-(void)postMessageToDeviceKey:(NSString *)deviceKey//required
                   timeLineId:(NSString *)timeLineId//required toward exist timeline
                      members:(NSArray *)arrMembers//required
                      message:(NSString *)strMessage//required
                   completion:(void (^)(NSDictionary *,
                                        NSURLSessionDataTask *,
                                        NSError *))block{

    NSMutableDictionary *parameters =
    [NSMutableDictionary dictionary];
    
    if(deviceKey){
        parameters[@"device_key"] = deviceKey;
    }else{
        NSLog(@"devicekey null");
        parameters = nil;
        return;
    }
    
    if(timeLineId) {
        parameters[@"time_line_id"] = timeLineId;
    }else{
        //do nothing
        NSLog(@"time_line_id create by api caz no id sended");
    }
    
    if(strMessage){
        parameters[@"message"] = strMessage;
    }else{
        NSLog(@"message is null");
        parameters = nil;
        return;
    }
    if(arrMembers){
        //time_line_id is null... but continue to create new timeline
        NSLog(@"return caz arrMembers is nil");
        parameters = nil;
        return;
    }else if(arrMembers.count == 0){
        NSLog(@"return caz no members");
        parameters = nil;
        return;
    }else{
        parameters[@"members"] = arrMembers;
    }
    
    
    
    //メッセージを受信する
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
    parameters = nil;
}

@end
