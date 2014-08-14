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


//初期起動時のユーザー認証:メアドとパスワードでやってる。。
- (void)autoSignInWithBlock:(void (^)(NSError *error))block
{
    
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"in.thebase"];
    
    NSLog(@"[store stringForKeyEm:%@",[store stringForKey:@"email"]);
    NSLog(@"[store stringForKeyPs%@",[store stringForKey:@"password"]);
    NSString *email = [store stringForKey:@"email"];
    NSString *password = [store stringForKey:@"password"];
    
    NSLog(@"autoSignInWithBlock");

    [[BSSellerAPIClient sharedClient] postUsersSignInWithMailAddress:email password:password completion:^(NSDictionary *results, NSError *error) {
       
        NSLog(@"postUsersSignInWithMailAddress");
        if (error) {
            if (block) block(error);
        } else{
            NSLog(@"results = %@", results);
            NSDictionary *result = results[@"result"];
            NSDictionary *Auth = result[@"Auth"];
            NSLog(@"session_id:%@",Auth[@"session_id"]);
            NSString *session = Auth[@"session_id"];
            NSString *shopId = [results valueForKeyPath:@"result.User.shop_id"];
            
            _shopId = shopId;
            _sessionId = session;
            if (!Auth[@"session_id"]){
                [SVProgressHUD showErrorWithStatus:@"パスワードかメールアドレスが正しくありません"];
                [store removeItemForKey:@"email"];
                [store removeItemForKey:@"password"];
                [store synchronize];
                
            } else {
                
                //[SVProgressHUD showSuccessWithStatus:@"ログイン完了！"];
            }
            
            if (block) block(nil);

        }
    }];
}

@end
