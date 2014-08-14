//
//  BSSellerAPIClient.m
//  BASE
//
//  Created by Takkun on 2014/02/17.
//  Copyright (c) 2014年 Takkun. All rights reserved.
//

#import "BSSellerAPIClient.h"

//static NSString * const kBSAPIBaseURLString = @"https://dt.thebase.in";     // 本番環境
// static NSString * const kBSAPIBaseURLString = @"http://dt.base0.info";      // ステージング
// static NSString * const kBSAPIBaseURLString = @"http://api.base0.info";     // テスト
// static NSString * const kBSAPIBaseURLString = @"http://api.n-base.info";    // テスト
// static NSString * const kBSAPIBaseURLString = @"https://dt.thebase.in";     // 反社チェック用



@implementation BSSellerAPIClient


+ (instancetype)sharedClient
{
    static BSSellerAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    /*_/_/_/_/_/_/_/_/_/_/_/_/_/_/遠藤追加_/_/_/_/_/_/_/_/_/_/_/_/_/*/
    NSString * const kBSAPIBaseURLString = [BSDefaultViewObject setApiUrl];
    /*_/_/_/_/_/_/_/_/_/_/_/_/_/_/遠藤追加_/_/_/_/_/_/_/_/_/_/_/_/_/*/
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.HTTPAdditionalHeaders = @{
                                                @"Accept" : @"application/json",
                                                };
        
        _sharedClient = [[BSSellerAPIClient alloc]
                         initWithBaseURL:[NSURL URLWithString:kBSAPIBaseURLString]
                         sessionConfiguration:configuration];
    });
    
    return _sharedClient;
}

#pragma mark - Users
///---------------------------------------------------------------------------------------
/// @name Users
///---------------------------------------------------------------------------------------

- (void)postUsersSignInWithMailAddress:(NSString *)mailAddress password:(NSString *)password completion:(void (^)(NSDictionary *, NSError *))block
{
    [self POST:@"/users/sign_in"
    parameters:@{
                 @"mail_address"     : mailAddress,
                 @"password"         : password,
                 }
       success:^(NSURLSessionDataTask *task, id responseObject) {
           [BSUserManager sharedManager].sessionId = [responseObject valueForKeyPath:@"result.Auth.session_id"];

           if (block) block(responseObject, nil);
       }
       failure:^(NSURLSessionDataTask *task, NSError *error) {
           // 401 が返ったときログインが必要.
           if (((NSHTTPURLResponse *)task.response).statusCode == 401) {
               if (block) block(nil, nil);
           }
           else {
               if (block) block(nil, error);
           }
       }];
}

- (void)postUsersSignUpWithShopId:(NSString *)shopId password:(NSString *)password mailAddress:(NSString *)mailAddress completion:(void (^)(NSDictionary *, NSError *))block
{
    [self POST:@"/users/sign_up"
    parameters:@{
                 @"shop_id"          : shopId,
                 @"mail_address"     : mailAddress,
                 @"password"         : password,
                 }
       success:^(NSURLSessionDataTask *task, id responseObject) {
           [BSUserManager sharedManager].sessionId = [responseObject valueForKeyPath:@"result.Auth.session_id"];

           if (block) block(responseObject, nil);
           
       }
       failure:^(NSURLSessionDataTask *task, NSError *error) {
           // 401 が返ったときログインが必要.
           if (((NSHTTPURLResponse *)task.response).statusCode == 401) {
               if (block) block(nil, nil);
           }
           else {
               if (block) block(nil, error);
           }
       }];
}

- (void)postUsersResetPasswordWithMailAddress:(NSString *)mailAddress completion:(void (^)(NSDictionary *, NSError *))block
{
    [self POST:@"/users/reset_password"
    parameters:@{
                 @"mail_address"     : mailAddress,
                 }
       success:^(NSURLSessionDataTask *task, id responseObject) {
           if (block) block(responseObject, nil);
       }
       failure:^(NSURLSessionDataTask *task, NSError *error) {
           // 401 が返ったときログインが必要.
           if (((NSHTTPURLResponse *)task.response).statusCode == 401) {
               if (block) block(nil, nil);
           }
           else {
               if (block) block(nil, error);
           }
       }];
}


- (void)getUsersSignOutWithSessionId:(NSString *)sessionId token:(NSString *)token completion:(void (^)(NSDictionary *, NSError *))block
{
    
    NSLog(@"sessionid = %@", sessionId);
    NSLog(@"token = %@", token);
    
    [self GET:@"/users/sign_out"
   parameters:@{
                @"session_id"   : sessionId,
                @"token"        : token,
                }
      success:^(NSURLSessionDataTask *task, id responseObject) {
          if (block) block(responseObject, nil);
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          // 401 が返ったときログインが必要.
          if (((NSHTTPURLResponse *)task.response).statusCode == 401) {
              if (block) block(nil, nil);
          }
          else {
              if (block) block(nil, error);
          }
      }];
}


- (void)getUsersResignWithSessionId:(NSString *)sessionId reason:(NSString *)reason completion:(void (^)(NSDictionary *, NSError *))block
{
    
    [self GET:@"/users/resign"
   parameters:@{
                @"session_id" : sessionId,
                @"reason"     : reason,
                }
      success:^(NSURLSessionDataTask *task, id responseObject) {
          if (block) block(responseObject, nil);
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          // 401 が返ったときログインが必要.
          if (((NSHTTPURLResponse *)task.response).statusCode == 401) {
              if (block) block(nil, nil);
          }
          else {
              if (block) block(nil, error);
          }
      }];
    
}

- (void)getUsersDisplayWebViewWithSessionId:(NSString *)sessionId completion:(void (^)(NSDictionary *, NSError *))block
{
    
    
    [self GET:@"/users/display_webview"
   parameters:@{
                @"session_id" : sessionId,
                }
      success:^(NSURLSessionDataTask *task, id responseObject) {
          if (block) block(responseObject, nil);
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          // 401 が返ったときログインが必要.
          if (((NSHTTPURLResponse *)task.response).statusCode == 401) {
              if (block) block(nil, nil);
          }
          else {
              if (block) block(nil, error);
          }
      }];
    
}

- (void)getUsersShopWithSessionId:(NSString *)sessionId completion:(void (^)(NSDictionary *, NSError *))block
{
    
    
    [self GET:@"/users/get_shop"
   parameters:@{
                @"session_id" : sessionId,
                }
      success:^(NSURLSessionDataTask *task, id responseObject) {
          if (block) block(responseObject, nil);
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          // 401 が返ったときログインが必要.
          if (((NSHTTPURLResponse *)task.response).statusCode == 401) {
              if (block) block(nil, nil);
          }
          else {
              if (block) block(nil, error);
          }
      }];
    
}


- (void)getUsersEditNameWithSessionId:(NSString *)sessionId shopName:(NSString *)shopName completion:(void (^)(NSDictionary *, NSError *))block
{
    
    
    [self GET:@"/users/edit_name"
   parameters:@{
                @"session_id"   : sessionId,
                @"shop_name"    : shopName,
                }
      success:^(NSURLSessionDataTask *task, id responseObject) {
          if (block) block(responseObject, nil);
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          // 401 が返ったときログインが必要.
          if (((NSHTTPURLResponse *)task.response).statusCode == 401) {
              if (block) block(nil, nil);
          }
          else {
              if (block) block(nil, error);
          }
      }];
    
}


- (void)getUsersEditShopWithSessionId:(NSString *)sessionId ableToBusiness:(int)ableToBusiness shopIntroduction:(NSString *)shopIntroduction twitterId:(NSString *)twitterId facebookId:(NSString *)facebookId delivery:(int)delivery fee:(int)fee completion:(void (^)(NSDictionary *, NSError *))block
{
    
    
    
    [self GET:@"/users/edit_shop"
   parameters:@{
                @"session_id"           : sessionId,
                @"able_to_business"     : @(ableToBusiness),
                @"shop_introduction"    : shopIntroduction,
                @"twitter_id"           : twitterId,
                @"facebook_id"          : facebookId,
                @"delivery"             : @(delivery),
                @"fee"                  : @(fee),
                }
      success:^(NSURLSessionDataTask *task, id responseObject) {
          if (block) block(responseObject, nil);
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          // 401 が返ったときログインが必要.
          if (((NSHTTPURLResponse *)task.response).statusCode == 401) {
              if (block) block(nil, nil);
          }
          else {
              if (block) block(nil, error);
          }
      }];
    
    
}


- (void)getUsersPaymentWithSessionId:(NSString *)sessionId
                          completion:(void (^)(NSDictionary *, NSError *))block
{
 
    [self GET:@"/users/get_payment"
   parameters:@{
                @"session_id" : sessionId,
                }
      success:^(NSURLSessionDataTask *task, id responseObject) {
          if (block) block(responseObject, nil);
          if(block)NSLog(@"response1=%@", responseObject);
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          // 401 が返ったときログインが必要.
          if (((NSHTTPURLResponse *)task.response).statusCode == 401) {
              if (block) block(nil, nil);
          }
          else {
              if (block) block(nil, error);
          }
      }];
    
}

//- (void)postUsersEditPaymentWithSessionId:(NSString *)sessionId creditcartPayment:(int)creditcartPayment codPayment:(int)codPayment charge:(int)charge btPayment:(int)btPayment bankName:(NSString *)bankName branchName:(NSString *)branchName accountType:(NSString *)accountType accountName:(NSString *)accountName accountNumber:(int)accountNumber completion:(void (^)(NSDictionary *, NSError *))block
- (void)postUsersEditPaymentWithSessionId:(NSString *)sessionId
                        creditcartPayment:(int)creditcartPayment
                               codPayment:(int)codPayment
                                   charge:(int)charge
                                btPayment:(int)btPayment
                               cvsPayment:(int)cvsPayment
                                 bankName:(NSString *)bankName
                               branchName:(NSString *)branchName
                              accountType:(NSString *)accountType
                              accountName:(NSString *)accountName
                            accountNumber:(NSString *)accountNumber
                               completion:(void (^)(NSDictionary *, NSError *))block
{

    NSLog(@"cvs_payment = %@", @(cvsPayment));
    
    [self POST:@"/users/edit_payment"
    parameters:@{
                 @"session_id"          : sessionId,
                 @"creditcart_payment"  : @(creditcartPayment),
                 @"cod_payment"         : @(codPayment),
                 @"charge"              : @(charge),
                 @"bt_payment"          : @(btPayment),
                 @"cvs_payment"         : @(cvsPayment),
                 @"bank_name"           : bankName,
                 @"branch_name"         : branchName,
                 @"account_type"        : accountType,
                 @"account_name"        : accountName,
                 @"account_number"      : accountNumber,
//                 @"account_number"      : @(accountNumber),//問題？？？？？？？？？？
                 }
       success:^(NSURLSessionDataTask *task, id responseObject) {
           if (block) block(responseObject, nil);
       }
       failure:^(NSURLSessionDataTask *task, NSError *error) {
           // 401 が返ったときログインが必要.
           if (((NSHTTPURLResponse *)task.response).statusCode == 401) {
               if (block) block(nil, nil);
           }
           else {
               if (block) block(nil, error);
           }
       }];
    
}

- (void)getUsersTransactioinWithSessionId:(NSString *)sessionId completion:(void (^)(NSDictionary *, NSError *))block
{
    
    [self GET:@"/users/get_transaction"
   parameters:@{
                @"session_id" : sessionId,
                }
      success:^(NSURLSessionDataTask *task, id responseObject) {
          if (block) block(responseObject, nil);
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          // 401 が返ったときログインが必要.
          if (((NSHTTPURLResponse *)task.response).statusCode == 401) {
              if (block) block(nil, nil);
          }
          else {
              if (block) block(nil, error);
          }
      }];
    
}

- (void)getUsersEditTransactionWithSessionId:(NSString *)sessionId userType:(NSString *)userType corporateName:(NSString *)corporateName lastName:(NSString *)lastName firstName:(NSString *)firstName zipCode:(NSString *)zipCode prefecture:(NSString *)prefecture address:(NSString *)address telNo:(NSString *)telNo contact:(NSString *)contact price:(NSString *)price pay:(NSString *)pay service:(NSString *)service returnDescription:(NSString *)returnDescription completion:(void (^)(NSDictionary *, NSError *))block
{
    
    
    [self GET:@"/users/edit_transaction"
   parameters:@{
                @"session_id"       : sessionId,
                @"last_name"        : lastName,
                @"first_name"       : firstName,
                @"zip_code"         : zipCode,
                @"prefecture"       : prefecture,
                @"address"          : address,
                @"tel_no"           : telNo,
                @"contact"          : contact,
                @"price"            : price,
                @"pay"              : pay,
                @"service"          : service,
                @"return"           : returnDescription,
                }
      success:^(NSURLSessionDataTask *task, id responseObject) {
          if (block) block(responseObject, nil);
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          // 401 が返ったときログインが必要.
          if (((NSHTTPURLResponse *)task.response).statusCode == 401) {
              if (block) block(nil, nil);
          }
          else {
              if (block) block(nil, error);
          }
      }];
    
    
    
}

- (void)postUsersEditUserWithSessionId:(NSString *)sessionId mailAddress:(NSString *)mailAddress password:(NSString *)password completion:(void (^)(NSDictionary *, NSError *))block
{
    
    
    [self POST:@"/users/edit_user"
    parameters:@{
                 @"session_id"          : sessionId,
                 @"mail_address"        : mailAddress,
                 @"password"            : password,
                 }
       success:^(NSURLSessionDataTask *task, id responseObject) {
           if (block) block(responseObject, nil);
       }
       failure:^(NSURLSessionDataTask *task, NSError *error) {
           // 401 が返ったときログインが必要.
           if (((NSHTTPURLResponse *)task.response).statusCode == 401) {
               if (block) block(nil, nil);
           }
           else {
               if (block) block(nil, error);
           }
       }];
    
}


- (void)getUsersMailSettingWithSessionId:(NSString *)sessionId completion:(void (^)(NSDictionary *, NSError *))block
{
 
    [self GET:@"/users/get_mail_settings"
   parameters:@{
                @"session_id"       : sessionId,
                }
      success:^(NSURLSessionDataTask *task, id responseObject) {
          if (block) block(responseObject, nil);
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          // 401 が返ったときログインが必要.
          if (((NSHTTPURLResponse *)task.response).statusCode == 401) {
              if (block) block(nil, nil);
          }
          else {
              if (block) block(nil, error);
          }
      }];
    
}

- (void)getUsersEditMailSettingWithSessionId:(NSString *)sessionId mailRelease:(NSString *)mailRelease completion:(void (^)(NSDictionary *, NSError *))block
{
    
    [self GET:@"/users/edit_mail_settings"
   parameters:@{
                @"session_id"         : sessionId,
                @"mail_release"       : mailRelease,
                }
      success:^(NSURLSessionDataTask *task, id responseObject) {
          if (block) block(responseObject, nil);
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          // 401 が返ったときログインが必要.
          if (((NSHTTPURLResponse *)task.response).statusCode == 401) {
              if (block) block(nil, nil);
          }
          else {
              if (block) block(nil, error);
          }
      }];
    
    
}



#pragma mark - Design
///---------------------------------------------------------------------------------------
/// @name Design
///---------------------------------------------------------------------------------------


- (void)getDesignThemeWithSessionId:(NSString *)sessionId completion:(void (^)(NSDictionary *, NSError *))block
{

    [self GET:@"/design/get_theme"
   parameters:@{
                @"session_id"         : sessionId,
                }
      success:^(NSURLSessionDataTask *task, id responseObject) {
          if (block) block(responseObject, nil);
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          // 401 が返ったときログインが必要.
          if (((NSHTTPURLResponse *)task.response).statusCode == 401) {
              if (block) block(nil, nil);
          }
          else {
              if (block) block(nil, error);
          }
      }];
    
}

- (void)getDesignThemesWithSessionId:(NSString *)sessionId completion:(void (^)(NSDictionary *, NSError *))block
{
    
    
    [self GET:@"/design/get_themes"
   parameters:@{
                @"session_id"         : sessionId,
                }
      success:^(NSURLSessionDataTask *task, id responseObject) {
          if (block) block(responseObject, nil);
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          // 401 が返ったときログインが必要.
          if (((NSHTTPURLResponse *)task.response).statusCode == 401) {
              if (block) block(nil, nil);
          }
          else {
              if (block) block(nil, error);
          }
      }];
    
}


- (void)getDesignEditThemeWithSessionId:(NSString *)sessionId defaultView:(NSString *)defaultView completion:(void (^)(NSDictionary *, NSError *))block
{
    
    [self GET:@"/design/edit_theme"
   parameters:@{
                @"session_id"         : sessionId,
                @"default_view"       : defaultView,
                }
      success:^(NSURLSessionDataTask *task, id responseObject) {
          if (block) block(responseObject, nil);
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          // 401 が返ったときログインが必要.
          if (((NSHTTPURLResponse *)task.response).statusCode == 401) {
              if (block) block(nil, nil);
          }
          else {
              if (block) block(nil, error);
          }
      }];
    
}



- (void)getDesignBackgroundWithSessionId:(NSString *)sessionId completion:(void (^)(NSDictionary *, NSError *))block
{
    
    [self GET:@"/design/get_background"
   parameters:@{
                @"session_id"         : sessionId,
                }
      success:^(NSURLSessionDataTask *task, id responseObject) {
          if (block) block(responseObject, nil);
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          // 401 が返ったときログインが必要.
          if (((NSHTTPURLResponse *)task.response).statusCode == 401) {
              if (block) block(nil, nil);
          }
          else {
              if (block) block(nil, error);
          }
      }];
    
}

- (void)getDesignBackgroundsWithSessionId:(NSString *)sessionId completion:(void (^)(NSDictionary *, NSError *))block
{
    
    
    [self GET:@"/design/get_backgrounds"
   parameters:@{
                @"session_id"         : sessionId,
                }
      success:^(NSURLSessionDataTask *task, id responseObject) {
          if (block) block(responseObject, nil);
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          // 401 が返ったときログインが必要.
          if (((NSHTTPURLResponse *)task.response).statusCode == 401) {
              if (block) block(nil, nil);
          }
          else {
              if (block) block(nil, error);
          }
      }];
    
}

- (void)getDesignEditBackgroundWithSessionId:(NSString *)sessionId background:(NSString *)background completion:(void (^)(NSDictionary *, NSError *))block
{
    
    
    [self GET:@"/design/edit_background"
   parameters:@{
                @"session_id"         : sessionId,
                @"background"         : background,

                }
      success:^(NSURLSessionDataTask *task, id responseObject) {
          if (block) block(responseObject, nil);
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          // 401 が返ったときログインが必要.
          if (((NSHTTPURLResponse *)task.response).statusCode == 401) {
              if (block) block(nil, nil);
          }
          else {
              if (block) block(nil, error);
          }
      }];
    
}

- (void)getDesignDeleteBackgroundWithSessionId:(NSString *)sessionId completion:(void (^)(NSDictionary *, NSError *))block
{
    [self GET:@"/design/delete_background"
   parameters:@{
                @"session_id"         : sessionId,
                
                }
      success:^(NSURLSessionDataTask *task, id responseObject) {
          if (block) block(responseObject, nil);
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          // 401 が返ったときログインが必要.
          if (((NSHTTPURLResponse *)task.response).statusCode == 401) {
              if (block) block(nil, nil);
          }
          else {
              if (block) block(nil, error);
          }
      }];
}

- (void)getDesignLogoWithSessionId:(NSString *)sessionId completion:(void (^)(NSDictionary *, NSURLSessionDataTask *, NSError *))block
{
    
    [self GET:@"/design/get_logo"
   parameters:@{
                @"session_id"         : sessionId,
                
                }
      success:^(NSURLSessionDataTask *task, id responseObject) {
          
          if (block) block(responseObject, task, nil);
          
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          // 401 が返ったときログインが必要.
          if (((NSHTTPURLResponse *)task.response).statusCode == 401) {
              if (block) block(nil, task, nil);
          }
          else {
              if (block) block(nil, task, error);
          }
      }];
    
}

- (void)getDesignDeleteLogoWithSessionId:(NSString *)sessionId completion:(void (^)(NSDictionary *, NSError *))block
{
    [self GET:@"/design/delete_logo"
   parameters:@{
                @"session_id"         : sessionId,
                
                }
      success:^(NSURLSessionDataTask *task, id responseObject) {
          if (block) block(responseObject, nil);
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          // 401 が返ったときログインが必要.
          if (((NSHTTPURLResponse *)task.response).statusCode == 401) {
              if (block) block(nil, nil);
          }
          else {
              if (block) block(nil, error);
          }
      }];
}


#pragma mark - Items
///---------------------------------------------------------------------------------------
/// @name Items
///---------------------------------------------------------------------------------------

- (void)getItemsWithSessionId:(NSString *)sessionId completion:(void (^)(NSDictionary *, NSError *))block
{
    [self GET:@"/items/get_items"
   parameters:@{
                @"session_id"         : sessionId,
                
                }
      success:^(NSURLSessionDataTask *task, id responseObject) {
          if (block) block(responseObject, nil);
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          // 401 が返ったときログインが必要.
          if (((NSHTTPURLResponse *)task.response).statusCode == 401) {
              if (block) block(nil, nil);
          }
          else {
              if (block) block(nil, error);
          }
      }];
}


- (void)getItemWithSessionId:(NSString *)sessionId itemId:(NSString *)itemId completion:(void (^)(NSDictionary *, NSError *))block
{
    
    
    [self GET:@"/items/get_item"
   parameters:@{
                @"session_id"         : sessionId,
                @"item_id"            : itemId,
                }
      success:^(NSURLSessionDataTask *task, id responseObject) {
          if (block) block(responseObject, nil);
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          // 401 が返ったときログインが必要.
          if (((NSHTTPURLResponse *)task.response).statusCode == 401) {
              if (block) block(nil, nil);
          }
          else {
              if (block) block(nil, error);
          }
      }];
}

#pragma mark - Banks
///---------------------------------------------------------------------------------------
/// @name Banks
///---------------------------------------------------------------------------------------
- (void)getAllBanksWithSessionId:(NSString *)sessionId completion:(void (^)(NSDictionary *results, NSError *error))block;
{
    
    [self GET:@"/banks/get_all_banks"
   parameters:@{
                @"session_id"         : sessionId
                }
      success:^(NSURLSessionDataTask *task, id responseObject) {
          if (block) block(responseObject, nil);
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          // 401 が返ったときログインが必要.
          if (((NSHTTPURLResponse *)task.response).statusCode == 401) {
              if (block) block(nil, nil);
          }
          else {
              if (block) block(nil, error);
          }
      }];
}

- (void)getAllBankBranchesWithSessionId:(NSString *)sessionId bankCode:(NSString *)bankCode completion:(void (^)(NSDictionary *results, NSError *error))block
{
    
    
    [self GET:@"banks/get_all_branches"
   parameters:@{
                @"session_id"   : sessionId,
                @"bank_code"    : bankCode
                }
      success:^(NSURLSessionDataTask *task, id responseObject) {
          if (block) block(responseObject, nil);
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          // 401 が返ったときログインが必要.
          if (((NSHTTPURLResponse *)task.response).statusCode == 401) {
              if (block) block(nil, nil);
          }
          else {
              if (block) block(nil, error);
          }
      }];
    
    
}

#pragma mark - Data
///---------------------------------------------------------------------------------------
/// @name Data
///---------------------------------------------------------------------------------------

- (void)getDataFinanceWithSessionId:(NSString *)sessionId type:(NSString *)type completion:(void (^)(NSDictionary *, NSError *))block
{
    
    NSDictionary *parameter;
    
    if (type) {
        parameter = @{
                      @"session_id"         : sessionId,
                      @"type"            : type,
                      };
    } else {
        parameter = @{
                      @"session_id"         : sessionId,
                      };
    }
    [self GET:@"/data/get_finance"
   parameters:parameter
      success:^(NSURLSessionDataTask *task, id responseObject) {
          if (block) block(responseObject, nil);
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          // 401 が返ったときログインが必要.
          if (((NSHTTPURLResponse *)task.response).statusCode == 401) {
              if (block) block(nil, nil);
          }
          else {
              if (block) block(nil, error);
          }
      }];
    
}

- (void)getDataPVWithSessionId:(NSString *)sessionId completion:(void (^)(NSDictionary *, NSError *))block
{
    
    NSLog(@"sessionId=%@", sessionId);
    
    if(sessionId == nil ||
       [sessionId isEqual:[NSNull null]]){
        return;
    }
    
    [self GET:@"/data/get_pv"
   parameters:@{
                @"session_id"         : sessionId,
                }
      success:^(NSURLSessionDataTask *task, id responseObject) {
          if (block) block(responseObject, nil);
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          // 401 が返ったときログインが必要.
          if (((NSHTTPURLResponse *)task.response).statusCode == 401) {
              if (block) block(nil, nil);
          }
          else {
              if (block) block(nil, error);
          }
      }];

    
}

- (void)getDataDispatchStatusWithSessionId:(NSString *)sessionId completion:(void (^)(NSDictionary *, NSError *))block
{
    [self GET:@"/data/get_dispatch_status"
   parameters:@{
                @"session_id"         : sessionId,
                }
      success:^(NSURLSessionDataTask *task, id responseObject) {
          if (block) block(responseObject, nil);
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          // 401 が返ったときログインが必要.
          if (((NSHTTPURLResponse *)task.response).statusCode == 401) {
              if (block) block(nil, nil);
          }
          else {
              if (block) block(nil, error);
          }
      }];
}

- (void)getOrderHeadersOrdersWithSessionId:(NSString *)sessionId completion:(void (^)(NSDictionary *, NSError *))block
{
    
    [self GET:@"/order_headers/get_orders"
   parameters:@{
                @"session_id"         : sessionId,
                }
      success:^(NSURLSessionDataTask *task, id responseObject) {
          if (block) block(responseObject, nil);
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          // 401 が返ったときログインが必要.
          if (((NSHTTPURLResponse *)task.response).statusCode == 401) {
              if (block) block(nil, nil);
          }
          else {
              if (block) block(nil, error);
          }
      }];
    
}

- (void)getOrderHeadersOrderWithSessionId:(NSString *)sessionId uniqueKey:(NSString *)uniqueKey completion:(void (^)(NSDictionary *, NSError *))block
{
    [self GET:@"/order_headers/get_order"
   parameters:@{
                @"session_id"         : sessionId,
                @"unique_key"         : uniqueKey,

                }
      success:^(NSURLSessionDataTask *task, id responseObject) {
          if (block) block(responseObject, nil);
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          // 401 が返ったときログインが必要.
          if (((NSHTTPURLResponse *)task.response).statusCode == 401) {
              if (block) block(nil, nil);
          }
          else {
              if (block) block(nil, error);
          }
      }];
}

- (void)getOrdersWithSessionId:(NSString *)sessionId completion:(void (^)(NSDictionary *, NSError *))block
{
    [self GET:@"/orders/get_orders"
   parameters:@{
                @"session_id"         : sessionId,
                
                }
      success:^(NSURLSessionDataTask *task, id responseObject) {
          if (block) block(responseObject, nil);
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          // 401 が返ったときログインが必要.
          if (((NSHTTPURLResponse *)task.response).statusCode == 401) {
              if (block) block(nil, nil);
          }
          else {
              if (block) block(nil, error);
          }
      }];
}


- (void)getSavingsWithSessionId:(NSString *)sessionId completion:(void (^)(NSDictionary *, NSError *))block
{
    [self GET:@"/savings/get_savings"
   parameters:@{
                @"session_id"         : sessionId,
                
                }
      success:^(NSURLSessionDataTask *task, id responseObject) {
          if (block) block(responseObject, nil);
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          // 401 が返ったときログインが必要.
          if (((NSHTTPURLResponse *)task.response).statusCode == 401) {
              if (block) block(nil, nil);
          }
          else {
              if (block) block(nil, error);
          }
      }];
}

- (void)getOrdersChangeDispathcStatusWithSessionId:(NSString *)sessionId orderId:(NSString *)orderId status:(NSString *)status completion:(void (^)(NSDictionary *, NSError *))block
{
    
    [self GET:@"/orders/change_dispatch_status"
   parameters:@{
                @"session_id"         : sessionId,
                @"order_id"           : orderId,
                @"status"             : status,
                }
      success:^(NSURLSessionDataTask *task, id responseObject) {
          if (block) block(responseObject, nil);
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          // 401 が返ったときログインが必要.
          if (((NSHTTPURLResponse *)task.response).statusCode == 401) {
              if (block) block(nil, nil);
          }
          else {
              if (block) block(nil, error);
          }
      }];
    
}


- (void)getChangingStatusMessageWithSessionId:(NSString *)sessionId orderId:(NSString *)orderId status:(NSString *)status completion:(void (^)(NSDictionary *, NSError *))block
{
    
    [self GET:@"/orders/get_changing_status_message"
   parameters:@{
                @"session_id"         : sessionId,
                @"order_id"           : orderId,
                @"status"             : status,
                }
      success:^(NSURLSessionDataTask *task, id responseObject) {
          if (block) block(responseObject, nil);
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          // 401 が返ったときログインが必要.
          if (((NSHTTPURLResponse *)task.response).statusCode == 401) {
              if (block) block(nil, nil);
          }
          else {
              if (block) block(nil, error);
          }
      }];
    
}


- (void)postSavingsApplyToWithdrawWithSessionId:(NSString *)sessionId bankName:(NSString *)bankName branchName:(NSString *)branchName accountType:(NSString *)accountType accountName:(NSString *)accountName accountNumber:(NSString *)accountNumber drawings:(NSString *)drawings password:(NSString *)password completion:(void (^)(NSDictionary *, NSError *))block
{
    
    
    [self POST:@"/savings/apply_to_withdraw"
    parameters:@{
                 @"session_id"          : sessionId,
                 @"bank_name"           : bankName,
                 @"branch_name"         : branchName,
                 @"account_type"        : accountType,
                 @"account_name"        : accountName,
                 @"account_number"      : accountNumber,
                 @"drawings"            : drawings,
                 @"password"            : password,
                 }
       success:^(NSURLSessionDataTask *task, id responseObject) {
           if (block) block(responseObject, nil);
       }
       failure:^(NSURLSessionDataTask *task, NSError *error) {
           // 401 が返ったときログインが必要.
           if (((NSHTTPURLResponse *)task.response).statusCode == 401) {
               if (block) block(nil, nil);
           }
           else {
               if (block) block(nil, error);
           }
       }];
    
    
}

#pragma mark - Inquiries
///---------------------------------------------------------------------------------------
/// @name Inquiries
///---------------------------------------------------------------------------------------

- (void)getInquirysWithSessionId:(NSString *)sessionId title:(NSString *)title name:(NSString *)name mailAddress:(NSString *)mailAddress inquiry:(NSString *)inquiry completion:(void (^)(NSDictionary *, NSError *))block
{
    [self GET:@"/inquiries/inquiry"
   parameters:@{
                @"session_id"         : sessionId,
                @"title"              : title,
                @"name"               : name,
                @"mail_address"       : mailAddress,
                @"inquiry"            : inquiry,

                }
      success:^(NSURLSessionDataTask *task, id responseObject) {
          if (block) block(responseObject, nil);
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          // 401 が返ったときログインが必要.
          if (((NSHTTPURLResponse *)task.response).statusCode == 401) {
              if (block) block(nil, nil);
          }
          else {
              if (block) block(nil, error);
          }
      }];
}


#pragma mark - Abouts
///---------------------------------------------------------------------------------------
/// @name Abouts
///---------------------------------------------------------------------------------------

- (void)getAboutsCompletion:(void (^)(NSDictionary *, NSError *))block
{
    [self GET:@"/abouts/get_agreement"
   parameters:nil
      success:^(NSURLSessionDataTask *task, id responseObject) {
          if (block) block(responseObject, nil);
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          // 401 が返ったときログインが必要.
          if (((NSHTTPURLResponse *)task.response).statusCode == 401) {
              if (block) block(nil, nil);
          }
          else {
              if (block) block(nil, error);
          }
      }];
}

/*_/_/_/_/_/遠藤追加_/_/_/_/_/_/*/
- (void)getMessageConfirmDeposit:(NSString *)sessionId
                         orderId:(NSString *)orderId
                          status:(NSString *)status
                      completion:(void (^)(NSDictionary *, NSError *))block
{
    //message	◯	"""発送済みの商品について購入者様にメールを送信します。この処理は戻すことができません。ステータスを「キャンセル」にしてもよろしいでしょうか？”"
//    error
//    message	◯	”クレジットカード決済のキャンセルはできません。”	エラーの場合のみ必須
    
    
//    [self GET:@"/aaaaa/bbbbbbbbb"
    [self GET:@"/orders/get_changing_status_message"
   parameters:@{
                @"session_id"   : sessionId,
                @"order_id"     : orderId,
                @"status"       : status,
                }
      success:^(NSURLSessionDataTask *task, id responseObject) {
          if (block) block(responseObject, nil);
//          if(block){
//              NSLog(@"responseObject = %@", responseObject);
//                block(responseObject, nil);
//          }
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          // 401 が返ったときログインが必要.
          if (((NSHTTPURLResponse *)task.response).statusCode == 401) {
              if (block) block(nil, nil);
          }
          else {
              if (block) block(nil, error);
          }
      }];
    
}
/*_/_/_/_/_/遠藤追加_/_/_/_/_/_/*/

@end
