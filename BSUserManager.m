//
//  BSUserManager.m
//  BASE
//
//  Created by Takkun on 2014/02/18.
//  Copyright (c) 2014年 Takkun. All rights reserved.
//

#import "BSUserManager.h"

#import "UICKeyChainStore.h"
#import "SVProgressHUD.h"


@implementation BSUserManager

@synthesize shopId = _shopId;
@synthesize sessionId = _sessionId;

+ (BSUserManager *)sharedManager
{
    static BSUserManager *_instance = nil;
    
    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }
    
    return _instance;
}


//初期起動時のユーザー認証:
- (void)autoSignInWithBlock:(void (^)(NSError *error))block
{
    
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"ichat"];
    NSString *strDeviceKey = store[@"device_key"];
    if([strDeviceKey isEqual:[NSNull null]] ||
       strDeviceKey == nil){
        
        NSLog(@"account acquiring");
        
        [SVProgressHUD
         showWithStatus:@"アカウント取得中..."
         maskType:SVProgressHUDMaskTypeGradient];
        
        [[DataConnect sharedClient]
         createUserCompletion:^(NSDictionary *userInfo,
                                NSURLSessionDataTask *task,
                                NSError *error){
             
             
             
             NSLog(@"userinfo = %@", userInfo);
             
             if([userInfo[@"succeed"] integerValue] == 1){
                 
                 NSLog(@"アカウント発行：jsonData ... %@",
                       userInfo);
                 
                 [store setString:userInfo[@"user"][@"account_id"]
                           forKey:@"account_id"];
                 [store setString:userInfo[@"user"][@"name"]
                           forKey:@"name"];
                 [store setString:userInfo[@"user"][@"device_key"]
                           forKey:@"device_key"];
                 
                 NSLog(@"設定後: account_id=%@, name=%@, devicekey = %@",
                       store[@"account_id"],
                       store[@"name"],
                       store[@"device_key"]);
                 [store synchronize];
                 
                 [SVProgressHUD showSuccessWithStatus:@"新規アカウント取得完了！"];
                 
                 //                 NSLog(@"格納後 = %@", )
             }else{
                 NSLog(@"read data failure");
                 [SVProgressHUD showSuccessWithStatus:@"受信失敗！"];
             }
         }];
    }else{//デバイスキーがそもそも存在すれば
        NSLog(@"アカウントを確認しました!");
        [SVProgressHUD showSuccessWithStatus:
         [NSString stringWithFormat:@"ようこそ、%@さん", store[@"name"]]];
    }
    
}

@end
