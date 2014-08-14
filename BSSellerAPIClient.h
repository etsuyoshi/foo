//
//  BSSellerAPIClient.h
//  BASE
//
//  Created by Takkun on 2014/02/17.
//  Copyright (c) 2014年 Takkun. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface BSSellerAPIClient : AFHTTPSessionManager

///---------------------------------------------------------------------------------------
/// @name インスタンスを得る
///---------------------------------------------------------------------------------------

+ (instancetype)sharedClient;

///---------------------------------------------------------------------------------------
/// @name API とのやりとり
///---------------------------------------------------------------------------------------

#pragma mark - Users
///---------------------------------------------------------------------------------------
/// @name Users
///---------------------------------------------------------------------------------------

/** ログイン
 
 @param mailAddress ログインするメールアドレス.
 @param password ログインするパスワード.
 @param block 完了時に呼び出される blocks.
 */
- (void)postUsersSignInWithMailAddress:(NSString *)mailAddress password:(NSString *)password completion:(void (^)(NSDictionary *results, NSError *error))block;


/** 会員登録
 
 @param shopId 会員登録するショップid.
 @param mailAddress 会員登録会員登録するメールアドレス.
 @param password 会員登録するパスワード.
 @param block 完了時に呼び出される blocks.
 */
- (void)postUsersSignUpWithShopId:(NSString *)shopId password:(NSString *)password mailAddress:(NSString *)mailAddress completion:(void (^)(NSDictionary *results, NSError *error))block;

/** パスワードリセット
 
 パスワードを忘れた時のリセット
 
 @param shopId 会員登録するショップid.
 @param mailAddress 会員登録会員登録するメールアドレス.
 @param password 会員登録するパスワード.
 @param block 完了時に呼び出される blocks.
 */
- (void)postUsersResetPasswordWithMailAddress:(NSString *)mailAddress completion:(void (^)(NSDictionary *results, NSError *error))block;

/** ログアウト
 
 @param sessionId セッション.
 @param token 端末のdeviseToken（プッシュの時に使う）.
 @param block 完了時に呼び出される blocks.
 */
- (void)getUsersSignOutWithSessionId:(NSString *)sessionId token:(NSString *)token completion:(void (^)(NSDictionary *results, NSError *error))block;

/** 退会
 
 @param sessionId セッション.
 @param reason 退会理由.
 @param block 完了時に呼び出される blocks.
 */
- (void)getUsersResignWithSessionId:(NSString *)sessionId reason:(NSString *)reason completion:(void (^)(NSDictionary *results, NSError *error))block;


/** WebView表示判定
 
 @param sessionId セッション.
 @param block 完了時に呼び出される blocks.
 */
- (void)getUsersDisplayWebViewWithSessionId:(NSString *)sessionId completion:(void (^)(NSDictionary *results, NSError *error))block;


/** ショップの情報
 
 @param sessionId セッション.
 @param block 完了時に呼び出される blocks.
 */
- (void)getUsersShopWithSessionId:(NSString *)sessionId completion:(void (^)(NSDictionary *results, NSError *error))block;

/** ショップ名の変更
 
 @param sessionId セッション.
 @param shopName 変更したいショップ名.
 @param block 完了時に呼び出される blocks.
 */
- (void)getUsersEditNameWithSessionId:(NSString *)sessionId shopName:(NSString *)shopName completion:(void (^)(NSDictionary *results, NSError *error))block;

/** ショップ情報の編集
 
 @param sessionId セッション.
 @param ableToBusiness 公開可能.                 // 1 or 0
 @param shopIntroduction ショップの説明.          // 必須ではない
 @param twitterId TwitterId.                   // 必須ではない
 @param facebookId facebookId.                 // 必須ではない
 @param delivery 送料の設定.                     // 1 or 0
 @param fee 送料.                               // deliveryが1の場合のみ必須
 @param block 完了時に呼び出される blocks.
 */
- (void)getUsersEditShopWithSessionId:(NSString *)sessionId ableToBusiness:(int)ableToBusiness shopIntroduction:(NSString *)shopIntroduction twitterId:(NSString *)twitterId facebookId:(NSString *)facebookId delivery:(int)delivery fee:(int)fee completion:(void (^)(NSDictionary *results, NSError *error))block;


/** 決済方法の取得
 
 @param sessionId セッション.
 @param block 完了時に呼び出される blocks.
 */
- (void)getUsersPaymentWithSessionId:(NSString *)sessionId completion:(void (^)(NSDictionary *results, NSError *error))block;


/** 決済方法の編集
 
 @param sessionId セッション.
 @param creditcartPayment クレジットカードを利用するか.                 // 1 or 0
 @param codPayment 代引き決済を利用するか.                             // 1 or 0
 @param charge 代引き決済の手数料.                                    // codPaymentが1の時のみ
 @param btPayment 銀行決済を利用するか.                                // 1 or 0
 @param bankName 銀行名.                                             // btPaymentが1の場合のみ必須
 @param branchName 支店名.                                           // btPaymentが1の場合のみ必須
 @param accountType 口座種別.                                        // btPaymentが1の場合のみ必須
 @param accountName 口座名義.                                        // btPaymentが1の場合のみ必須
 @param accountNumber 口座番号.                                      // btPaymentが1の場合のみ必須

 @param block 完了時に呼び出される blocks.
 */
//- (void)postUsersEditPaymentWithSessionId:(NSString *)sessionId creditcartPayment:(int)creditcartPayment codPayment:(int)codPayment charge:(int)charge btPayment:(int)btPayment bankName:(NSString *)bankName branchName:(NSString *)branchName accountType:(NSString *)accountType accountName:(NSString *)accountName accountNumber:(int)accountNumber completion:(void (^)(NSDictionary *results, NSError *error))block;
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
                               completion:(void (^)(NSDictionary *results, NSError *error))block;



/** 特商法の取得
 
 @param sessionId セッション.
 @param block 完了時に呼び出される blocks.
 */
- (void)getUsersTransactioinWithSessionId:(NSString *)sessionId completion:(void (^)(NSDictionary *results, NSError *error))block;

/** 特商法の編集
 
 @param sessionId セッション.
 @param userType 個人または法人の選択.                       // ”individual” or ”corporation”
 @param corporateName 会社名.                             // user_typeがcorporationの場合のみ必須
 @param lastName 姓.                                   
 @param firstName 名.
 @param zipCode 郵便番号.                                  // “001-0001”
 @param prefecture 都道府県名.                             // “東京都”
 @param address 住所.
 @param telNo 電話番号.                                    // “001-000-0011”
 @param contact 連絡先.
 @param price 料金形態の説明.
 @param pay 支払い方法の説明.
 @param service サービスの説明.
 @param returnDescription 返品についての説明.

 @param block 完了時に呼び出される blocks.
 */
- (void)getUsersEditTransactionWithSessionId:(NSString *)sessionId userType:(NSString *)userType corporateName:(NSString *)corporateName lastName:(NSString *)lastName firstName:(NSString *)firstName zipCode:(NSString *)zipCode prefecture:(NSString *)prefecture address:(NSString *)address telNo:(NSString *)telNo contact:(NSString *)contact price:(NSString *)price pay:(NSString *)pay service:(NSString *)service returnDescription:(NSString *)returnDescription completion:(void (^)(NSDictionary *results, NSError *error))block;


/** ユーザ情報の編集
 
 @param sessionId セッション.
 @param mailAddress 変更したいメールアドレス.
 @param password 変更したいパスワード.
 
 @param block 完了時に呼び出される blocks.
 */
- (void)postUsersEditUserWithSessionId:(NSString *)sessionId mailAddress:(NSString *)mailAddress password:(NSString *)password completion:(void (^)(NSDictionary *results, NSError *error))block;


/** メール配信設定の取得
 
 @param sessionId セッション.
 @param block 完了時に呼び出される blocks.
 */
- (void)getUsersMailSettingWithSessionId:(NSString *)sessionId completion:(void (^)(NSDictionary *results, NSError *error))block;


/** メール配信設定の取得
 
 @param sessionId セッション.
 @param mailRelease 配信するかしないか. // 0: 配信しない, 1: 配信する
 @param block 完了時に呼び出される blocks.
 */
- (void)getUsersEditMailSettingWithSessionId:(NSString *)sessionId mailRelease:(NSString *)mailRelease completion:(void (^)(NSDictionary *results, NSError *error))block;



#pragma mark - Design
///---------------------------------------------------------------------------------------
/// @name Design
///---------------------------------------------------------------------------------------


/** 現在のテーマの情報
 
 @param sessionId セッション.
 @param block 完了時に呼び出される blocks.
 */
- (void)getDesignThemeWithSessionId:(NSString *)sessionId completion:(void (^)(NSDictionary *results, NSError *error))block;


/** テーマ一覧の情報
 
 @param sessionId セッション.
 @param block 完了時に呼び出される blocks.
 */
- (void)getDesignThemesWithSessionId:(NSString *)sessionId completion:(void (^)(NSDictionary *results, NSError *error))block;

/** テーマの変更
 
 @param sessionId セッション.
 @param defaultView テーマ.            // 例:"shop_01"
 @param block 完了時に呼び出される blocks.
 */
- (void)getDesignEditThemeWithSessionId:(NSString *)sessionId defaultView:(NSString *)defaultView completion:(void (^)(NSDictionary *results, NSError *error))block;

/** 現在のバックグランドの取得
 
 @param sessionId セッション.
 @param block 完了時に呼び出される blocks.
 */
- (void)getDesignBackgroundWithSessionId:(NSString *)sessionId completion:(void (^)(NSDictionary *results, NSError *error))block;

/** バックグランド一覧の取得
 
 @param sessionId セッション.
 @param block 完了時に呼び出される blocks.
 */
- (void)getDesignBackgroundsWithSessionId:(NSString *)sessionId completion:(void (^)(NSDictionary *results, NSError *error))block;


/** バックグランドの変更
 
 @param sessionId セッション.
 @param background 背景.            // 例:"bgimg_01.jpg"
 @param block 完了時に呼び出される blocks.
 */
- (void)getDesignEditBackgroundWithSessionId:(NSString *)sessionId background:(NSString *)background completion:(void (^)(NSDictionary *results, NSError *error))block;


/** バックグランドのアップロード
 
 @param sessionId セッション.
 @param background 背景画像.            // 例:"shop_01"
 @param block 完了時に呼び出される blocks.
 */
- (void)postDesignUploadBackgroundWithSessionId:(NSString *)sessionId background:(NSString *)background completion:(void (^)(NSDictionary *results, NSError *error))block;


/** バックグランドの削除
 
 @param sessionId セッション.
 @param block 完了時に呼び出される blocks.
 */
- (void)getDesignDeleteBackgroundWithSessionId:(NSString *)sessionId completion:(void (^)(NSDictionary *results, NSError *error))block;



/** 現在のロゴの取得
 
 @param sessionId セッション.
 @param block 完了時に呼び出される blocks.
 */
- (void)getDesignLogoWithSessionId:(NSString *)sessionId completion:(void (^)(NSDictionary *results, NSURLSessionDataTask *task, NSError *error))block;


/** 現在のロゴの取得
 
 @param sessionId セッション.
 @param block 完了時に呼び出される blocks.
 */
- (void)postDesignLogoWithSessionId:(NSString *)sessionId completion:(void (^)(NSDictionary *results, NSError *error))block;

/** ロゴの削除
 
 @param sessionId セッション.
 @param block 完了時に呼び出される blocks.
 */
- (void)getDesignDeleteLogoWithSessionId:(NSString *)sessionId completion:(void (^)(NSDictionary *results, NSError *error))block;



#pragma mark - Items
///---------------------------------------------------------------------------------------
/// @name Items
///---------------------------------------------------------------------------------------


/** アイテムの取得
 
 @param sessionId セッション.
 @param block 完了時に呼び出される blocks.
 */
- (void)getItemsWithSessionId:(NSString *)sessionId completion:(void (^)(NSDictionary *results, NSError *error))block;

/** アイテムの取得(一件)
 
 @param sessionId セッション.
 @param itemId 商品id.
 @param block 完了時に呼び出される blocks.
 */
- (void)getItemWithSessionId:(NSString *)sessionId itemId:(NSString *)itemId completion:(void (^)(NSDictionary *results, NSError *error))block;

/** アイテムの取得(一件)
 
 @param sessionId セッション.
 @param itemId 商品id.
 @param block 完了時に呼び出される blocks.
 */
//- (void)postItemWithSessionId:(NSString *)sessionId itemId:(NSString *)itemId completion:(void (^)(NSDictionary *results, NSError *error))block;
/*アイテムの登録とアイテムの編集部分はあとで*/


/** アイテムの削除
 
 @param sessionId セッション.
 @param itemId 削除する商品id.
 @param block 完了時に呼び出される blocks.
 */
- (void)getItemDeleteItemWithSessionId:(NSString *)sessionId itemId:(NSString *)itemId completion:(void (^)(NSDictionary *results, NSError *error))block;

/*
 バリエージョンの編集
 アイテムイメージの登録
 アイテムイメージの削除
 はあとで
*/


#pragma mark - Data
///---------------------------------------------------------------------------------------
/// @name Data
///---------------------------------------------------------------------------------------

/** 財務情報の取得
 
 @param sessionId セッション.
 @param type 取得する情報  例："sales".            //省略の場合は売上と引出可能額の両方を返す "sales" : 売上 "withdrawal" : 引出可能額
 @param block 完了時に呼び出される blocks.
 */
- (void)getDataFinanceWithSessionId:(NSString *)sessionId type:(NSString *)type completion:(void (^)(NSDictionary *results, NSError *error))block;


/** PV情報の取得
 
 @param sessionId セッション.
 @param block 完了時に呼び出される blocks.
 */
- (void)getDataPVWithSessionId:(NSString *)sessionId completion:(void (^)(NSDictionary *results, NSError *error))block;

/** 発送状況の取得
 
 @param sessionId セッション.
 @param block 完了時に呼び出される blocks.
 */
- (void)getDataDispatchStatusWithSessionId:(NSString *)sessionId completion:(void (^)(NSDictionary *results, NSError *error))block;


#pragma mark - OrderHeaders
///---------------------------------------------------------------------------------------
/// @name OrderHeaders
///---------------------------------------------------------------------------------------


/** 注文一覧の取得
 
 @param sessionId セッション.
 @param block 完了時に呼び出される blocks.
 */
- (void)getOrderHeadersOrdersWithSessionId:(NSString *)sessionId completion:(void (^)(NSDictionary *results, NSError *error))block;


/** 注文詳細の取得
 
 @param sessionId セッション.
 @param uniqueKey 注文情報のユニークキー.
 @param block 完了時に呼び出される blocks.
 */
- (void)getOrderHeadersOrderWithSessionId:(NSString *)sessionId uniqueKey:(NSString *)uniqueKey completion:(void (^)(NSDictionary *results, NSError *error))block;


#pragma mark - Orders
///---------------------------------------------------------------------------------------
/// @name Orders
///---------------------------------------------------------------------------------------

/** 注文履歴の取得
 
 @param sessionId セッション.
 @param block 完了時に呼び出される blocks.
 */
- (void)getOrdersWithSessionId:(NSString *)sessionId completion:(void (^)(NSDictionary *results, NSError *error))block;

/** 発送状況の変更
 
 @param sessionId セッション.
 @param orderId 注文ID.
 @param status  dispatched : 発送完了, cancelled : キャンセル.

 @param block 完了時に呼び出される blocks.
 */
- (void)getOrdersChangeDispathcStatusWithSessionId:(NSString *)sessionId orderId:(NSString *)orderId status:(NSString *)status completion:(void (^)(NSDictionary *results, NSError *error))block;

/** 発送ステータス変更メッセージの取得
 
 @param sessionId セッション.
 @param orderId 注文ID.
 @param status  dispatched : 発送完了, cancelled : キャンセル.
 
 @param block 完了時に呼び出される blocks.
 */
- (void)getChangingStatusMessageWithSessionId:(NSString *)sessionId orderId:(NSString *)orderId status:(NSString *)status completion:(void (^)(NSDictionary *results, NSError *error))block;


#pragma mark - Savings
///---------------------------------------------------------------------------------------
/// @name Savings
///---------------------------------------------------------------------------------------

/** 引出申請履歴の取得
 
 @param sessionId セッション.
 @param block 完了時に呼び出される blocks.
 */
- (void)getSavingsWithSessionId:(NSString *)sessionId completion:(void (^)(NSDictionary *results, NSError *error))block;

/** 引出申請
 
 @param sessionId セッション.
 @param bankName 銀行名.
 @param branchName 支店名.
 @param accountType 口座種別.
 @param accountName 口座名義.
 @param accountNumber 口座番号.
 @param drawings 引き出し金額.
 @param password パスワード.
 @param block 完了時に呼び出される blocks.
 */
- (void)postSavingsApplyToWithdrawWithSessionId:(NSString *)sessionId bankName:(NSString *)bankName branchName:(NSString *)branchName accountType:(NSString *)accountType accountName:(NSString *)accountName accountNumber:(NSString *)accountNumber drawings:(NSString *)drawings password:(NSString *)password completion:(void (^)(NSDictionary *results, NSError *error))block;

#pragma mark - Banks
///---------------------------------------------------------------------------------------
/// @name Banks
///---------------------------------------------------------------------------------------

/** 全銀行情報取得
 
 @param block 完了時に呼び出される blocks.
 */
- (void)getAllBanksWithSessionId:(NSString *)sessionId completion:(void (^)(NSDictionary *results, NSError *error))block;
/** 全支店情報取得
 
 @param block 完了時に呼び出される blocks.
 */
- (void)getAllBankBranchesWithSessionId:(NSString *)sessionId bankCode:(NSString *)bankCode completion:(void (^)(NSDictionary *results, NSError *error))block;

#pragma mark - Inquiries
///---------------------------------------------------------------------------------------
/// @name Inquiries
///---------------------------------------------------------------------------------------

/** お問い合わせ
 
 @param sessionId セッション.
 @param title お問い合せタイトル.
 @param name 名前.
 @param mailAddress メールアドレス.
 @param inquiry お問い合せ内容.
 @param block 完了時に呼び出される blocks.
 */
- (void)getInquirysWithSessionId:(NSString *)sessionId title:(NSString *)title name:(NSString *)name mailAddress:(NSString *)mailAddress inquiry:(NSString *)inquiry completion:(void (^)(NSDictionary *results, NSError *error))block;

#pragma mark - Abouts
///---------------------------------------------------------------------------------------
/// @name Abouts
///---------------------------------------------------------------------------------------

/** 利用規約の取得
 
 */
- (void)getAboutsCompletion:(void (^)(NSDictionary *results, NSError *error))block;



/*_/_/_/_/_/遠藤追加_/_/_/_/_/_/*/
//- (void)isFinishedConfirmDeposit:(NSString *)sessionId
//                         orderId:(NSString *)orderId
//                      completion:(void (^)(NSDictionary *, NSError *))block;
- (void)getMessageConfirmDeposit:(NSString *)sessionId
                         orderId:(NSString *)orderId
                          status:(NSString *)status
                      completion:(void (^)(NSDictionary *, NSError *))block;
/*_/_/_/_/_/遠藤追加_/_/_/_/_/_/*/

@end
