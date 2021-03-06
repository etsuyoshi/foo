//
//  Created by Jesse Squires
//  http://www.hexedbits.com
//
//
//  Documentation
//  http://cocoadocs.org/docsets/JSQMessagesViewController
//
//
//  GitHub
//  https://github.com/jessesquires/JSQMessagesViewController
//
//
//  License
//  Copyright (c) 2014 Jesse Squires
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

#import "JSQAppDelegate.h"
#import <Crashlytics/Crashlytics.h>

@implementation JSQAppDelegate

//毎回起動時に以下を実行→各画面のviewdidload時に実行することにした
//device_key、name、account_idをサーバーから取得してデバイス側に保存されている組み合わせが正しいか確認する
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Crashlytics startWithAPIKey:@"844ba808bc3843aa81b356efa4ceed91088c1e57"];
    return YES;
}

@end
