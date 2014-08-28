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
    if([self containsObject:dictUser]){
        NSLog(@"重複しているので追加しません。");
        return false;
    }else{
        
        [arrId addObject:dictUser];
        
        [CommonAPI setIdArray:arrId];
        return true;
    }
}

+(BOOL)containsObject:(NSDictionary *)dictUser{
    //既存のarray_idにdictUserのaccount_idが存在していればtrueを返す
    NSMutableArray *arrayInDevice = [[self getIdArray] mutableCopy];
    for(NSDictionary *dictInDevice in arrayInDevice){
        NSLog(@"account_id = %@", dictUser[@"account_id"]);
        NSLog(@"dictInDevice = %@", dictInDevice);
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

////デバイスに保存されているグループIDを取得して返す
//+(NSArray *)initArrayGroupId{
//    NSArray *arrReturn = [NSArray array];
//    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"ichat"];
//    
//}



@end
