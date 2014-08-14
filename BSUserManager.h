//
//  BSUserManager.h
//  BASE
//
//  Created by Takkun on 2014/02/18.
//  Copyright (c) 2014年 Takkun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSUserManager : NSObject

@property (retain,readonly) NSString *shopId; // 作成したお店のID
@property (retain,strong) NSString *sessionId; // ログイン時に発行されるセッション


///---------------------------------------------------------------------------------------
/// @name 管理オブジェクトを得る
///---------------------------------------------------------------------------------------

/** シングルトンの管理オブジェクトを得る
 
 @return `BSUserManager`.
 */
+ (BSUserManager *)sharedManager;


/** 自動ログイン
 
 @return `BSUserManager`.
 */
- (void)autoSignInWithBlock:(void (^)(NSError *error))block;

@end
