//
//  CommonAPI.m
//  JSQMessages
//
//  Created by EndoTsuyoshi on 2014/08/17.
//  Copyright (c) 2014年 Hexed Bits. All rights reserved.
//

#import "CommonAPI.h"

@implementation CommonAPI



//IDを格納する配列を返す
+(NSArray *)getIdArray{
    NSLog(@"getIdarray");
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"ichat"];
    
    NSData *dataReturn = [store dataForKey:@"array_id"];
    
    // 変換前のオブジェクトに復元(デコード)
    NSArray *arrayReturn = [NSKeyedUnarchiver unarchiveObjectWithData:dataReturn];
    
    for(id obj in arrayReturn){
        NSLog(@"obj1 = %@", obj);
    }
    
//    dataReturn = nil;
    store = nil;
    
    
    if(arrayReturn == nil ||
       [arrayReturn isEqual:[NSNull null]]){
        arrayReturn = [NSMutableArray array];
    }
    
    return arrayReturn;
}

+(NSString *)getIdNoAt:(int)no{
    NSArray *array = [CommonAPI getIdArray];
    if(array.count <= no){
        NSLog(@"指定したインデックスが配列の個数を超えています。");
        return nil;
    }
    return array[no];
}

//配列にIDを格納してデバイスに保存
+(void)setIdArray:(NSArray *)arrayInput{
    //uickeychainstoreテスト
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"ichat"];
    
    
    // NSDataオブジェクトへ変換(エンコード)
    NSData *dataInput = [NSKeyedArchiver archivedDataWithRootObject:arrayInput];
    
    //格納
    [store setData:dataInput forKey:@"array_id"];
    [store synchronize];
    
    store = nil;
    dataInput = nil;
}

//指定されたIDを配列に格納してデバイスに保存
+(BOOL)addId:(NSDictionary*)dictUser{
    
    NSArray *arrTmp = [CommonAPI getIdArray];
    
    if(arrTmp == nil || [arrTmp isEqual:[NSNull null]]){
        arrTmp = [NSArray array];
    }
    NSMutableArray *arrId = [arrTmp mutableCopy];
    arrTmp = nil;
    
    //if([arrId containsObject:strId]){
    if([self containsIdArray:dictUser]){
        NSLog(@"重複しているので追加しません。");
        return false;
    }else{
        NSLog(@"追加 : dictUser = %@", dictUser);
        [arrId addObject:dictUser];
        [CommonAPI setIdArray:arrId];
        return true;
    }
}

//既に保存されているaccount_idのユーザーとのタイムラインidを編集する
//※新規にユーザーを追加した段階ではuserInfoの中にタイムラインidはnil(もしくはそんな項目すらない状態になっている？)
+(BOOL)modifyTimeLineId:(NSString *)argStrTimeLineId toUserId:(NSString *)argStrUserId{
    NSMutableArray *arrUserInfo = [[self getIdArray] mutableCopy];
    int noOfId = [self getNoOfId:argStrUserId];
    if(noOfId != -1){
        NSLog(@"before : userInfo = %@", arrUserInfo[noOfId]);
//        arrUserInfo[noOfId][@"timeLineId"] = argStrTimeLineId;
        NSMutableDictionary *userInfo = [arrUserInfo[noOfId] mutableCopy];
        userInfo[@"timeLineId"] = argStrTimeLineId;
        
        arrUserInfo[noOfId] = userInfo;
        NSLog(@"after : userInfo = %@", arrUserInfo[noOfId]);
        
        
        [self setIdArray:(NSArray *)arrUserInfo];
    }
    
    return false;
}

//デバイスに保存されているユーザー情報配列の中に指定したdictUserのaccount_idのuserInfoが存在していればtrueを返す
+(BOOL)containsIdArray:(NSDictionary *)dictUser{
    NSMutableArray *arrayInDevice = [[self getIdArray] mutableCopy];
    for(NSDictionary *dictInDevice in arrayInDevice){
//        NSLog(@"account_id = %@", dictUser[@"account_id"]);
//        NSLog(@"dictInDevice = %@", dictInDevice);
        if(  dictUser[@"account_id"] != nil &&
           ![dictUser[@"account_id"] isEqual:[NSNull null]] &&
            dictInDevice != nil &&
           ![dictInDevice isEqual:[NSNull null]]){
            
            if([dictInDevice[@"account_id"] isEqualToString:dictUser[@"account_id"]]){
                return true;
            }
        }
    }
    return false;
}

//デバイスに保存されているユーザー情報配列の中にaccount_idのuserInfoが存在していればtrueを返す
+(int)getNoOfId:(NSString *)strId{
    NSArray *arrayInDevice = [self getIdArray];
//    for(NSDictionary *userInfo in arrayInDevice){
    for(int numberInArray = 0;numberInArray < arrayInDevice.count;numberInArray++){
//        if([userInfo[@"account_id"] isEqualToString:strId]){
        if([arrayInDevice[numberInArray][@"account_id"] isEqualToString:strId]){
            return numberInArray;
        }
    }
    
    return -1;
}

////デバイスに保存されているグループIDを取得して返す
//+(NSArray *)initArrayGroupId{
//    NSArray *arrReturn = [NSArray array];
//    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"ichat"];
//    
//}



+(NSArray *)getMessageArray{
    NSLog(@"getMessageArray");
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"ichat"];
    
    NSData *dataReturn = [store dataForKey:@"array_message"];
    
    // 変換前のオブジェクトに復元(デコード)
    NSArray *arrayReturn = [NSKeyedUnarchiver unarchiveObjectWithData:dataReturn];
    
    
    if(arrayReturn == nil ||
       [arrayReturn isEqual:[NSNull null]]){
        NSLog(@"getMessageArray : arrayReturn=null so initialize");
        arrayReturn = [NSMutableArray array];
    }
    
    store = nil;
    NSLog(@"getMessageArray : arrayReturn = %@", arrayReturn);
    return arrayReturn;
}

//指定されたIDを配列に格納してデバイスに保存
+(BOOL)addMessage:(NSDictionary*)dictMessage{
    
    NSArray *arrTmp = [CommonAPI getMessageArray];
    
    if(arrTmp == nil || [arrTmp isEqual:[NSNull null]]){
        arrTmp = [NSArray array];
    }
    NSMutableArray *arrMessage = [arrTmp mutableCopy];
    arrTmp = nil;
    
    
    NSLog(@"追加 : dictMessage = %@", dictMessage);
    [arrMessage addObject:dictMessage];
    
    NSLog(@"addMessage : arrmessage = %@", arrMessage);
    [CommonAPI setMessageArray:arrMessage];
    
    NSLog(@"addMessage : getMessageArray = %@", [CommonAPI getMessageArray]);
    return true;//特に意味はない
}


+(BOOL)deleteMessage:(int)no{
    NSArray *arrTmp = [CommonAPI getIdArray];
    
    if(arrTmp == nil || [arrTmp isEqual:[NSNull null]]){
        arrTmp = [NSArray array];
    }
    NSMutableArray *arrMessage = [arrTmp mutableCopy];
    arrTmp = nil;
    
    [arrMessage removeObjectAtIndex:no];
    [CommonAPI setMessageArray:arrMessage];
    return true;
    
}

+(void)setMessageArray:(NSArray *)arrayInput{
    //uickeychainstoreテスト
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"ichat"];
    
    
    // NSDataオブジェクトへ変換(エンコード)
    NSData *dataInput = [NSKeyedArchiver archivedDataWithRootObject:arrayInput];
    
    //格納
    [store setData:dataInput forKey:@"array_message"];
    [store synchronize];
    
    store = nil;
    dataInput = nil;
}

@end
