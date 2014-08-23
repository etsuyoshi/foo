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
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"ichat"];
    
    NSData *dataReturn = [store dataForKey:@"array_id"];
    
    // 変換前のオブジェクトに復元(デコード)
    NSArray *arrayReturn = [NSKeyedUnarchiver unarchiveObjectWithData:dataReturn];
    
    for(id obj in arrayReturn){
        NSLog(@"obj1 = %@", obj);
    }
    
    dataReturn = nil;
    store = nil;
    
    return arrayReturn;
}

//配列にIDを格納してデバイスに保存
+(void)setIdArray:(NSArray *)arrayInput{
    //uickeychainstoreテスト
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"ichat"];
    
    
    // NSDataオブジェクトへ変換(エンコード)
    NSData *dataInput = [NSKeyedArchiver archivedDataWithRootObject:arrayInput];
    
    //格納
    [store setData:dataInput forKey:@"array_id"];
    
    store = nil;
    dataInput = nil;
}

//指定されたIDを配列に格納してデバイスに保存
+(BOOL)addId:(NSString *)strId{
    
    NSArray *arrTmp = [CommonAPI getIdArray];
    
    if(arrTmp == nil || [arrTmp isEqual:[NSNull null]]){
        arrTmp = [NSArray array];
    }
    NSMutableArray *arrId = [arrTmp mutableCopy];
    arrTmp = nil;
    
    if([arrId containsObject:strId]){
        NSLog(@"重複しているので追加しません。");
        return false;
    }else{
        
        [arrId addObject:strId];
        
        [CommonAPI setIdArray:arrId];
        return true;
    }
}

////デバイスに保存されているグループIDを取得して返す
//+(NSArray *)initArrayGroupId{
//    NSArray *arrReturn = [NSArray array];
//    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"ichat"];
//    
//}



@end
