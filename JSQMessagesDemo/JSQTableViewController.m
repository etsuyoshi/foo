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

#import "JSQTableViewController.h"
#import "EditProfileTableViewController.h"

@implementation JSQTableViewController{
    NSMutableArray *arrGroupId;
    NSMutableArray *arrIndivisualId;
    NSMutableDictionary *dictNameToId;
    
    UITextView *textView;
    UIView *viewUnderKeyboard;
    
    BOOL isConnectMode;
    
    
}

@synthesize timer;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    
    [super viewDidLoad];
    
    isConnectMode = YES;
    
    [[BSUserManager sharedManager]
     autoSignInWithBlock:^(NSError *error){
         if(error != nil &&
            [error isEqual:[NSNull null]]){
             
             NSLog(@"jsqTableViewControllerでaccount=%@",
                   [UICKeyChainStore keyChainStoreWithService:@"ichat"]);
             
             NSLog(@"正常に起動しました");
         }else{
             NSLog(@"at jsqTableView didload: error = %@", error);
         }
     }];
    
    
    
    timer = [NSTimer
             scheduledTimerWithTimeInterval:1
             target:self
             selector:@selector(checkMessage:)
             userInfo:nil
             repeats:YES];
    
    NSLog(@"timer validate");
    
    
    
    
    self.title = @"チャット";
    NSLog(@"viewdidload at jsqTableView");
    
    
    UIBarButtonItem *editButton =
    [[UIBarButtonItem alloc]
     initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
     target:self
     action:@selector(edit)];
    self.navigationItem.leftBarButtonItem = editButton;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                   target:self
                                   action:@selector(addId)];
    // Here I think you wanna add the searchButton and not the filterButton..
    self.navigationItem.rightBarButtonItem = addButton;
    
    
    
    //最終的にはtime_line_idからサーバー経由で合い言葉、chat相手のidを取得
    arrGroupId = (NSMutableArray *)[CommonAPI getIdArray];//[NSMutableArray arrayWithObjects:@"しょうぎ", @"らーめん", @"ふうりゅう", nil];
//    arrIndivisualId = (NSMutableArray *)[CommonAPI getIdArray];//[NSMutableArray arrayWithObjects:@"taro", @"jiro", nil];
    arrIndivisualId = [NSMutableArray array];
    
    dictNameToId = nil;
    
    
    
    
    //cellが反応しない
//    UITapGestureRecognizer *gestureRecognizer =
//    [[UITapGestureRecognizer alloc]
//     initWithTarget:self action:@selector(closeSoftKeyboard)];
//    [self.view addGestureRecognizer:gestureRecognizer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    
    [self.tableView reloadData];
}

-(void)checkMessage:(NSTimer *)timer{
    NSLog(@"checkMessage");
    
    
    //通信可能状態(＝データ通信中ではない)の時のみreceiveMessageを実行
    if(isConnectMode){
        
        //通信中に設定するので今回の通信が完了しない限り、次回の通信は行わない
        isConnectMode = NO;
        
        UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"ichat"];
        NSString *strDeviceKey = store[@"device_key"];
        
        
        [[DataConnect sharedClient]
        receiveMessageToDeviceKey:strDeviceKey
        timeLineId:nil
        completion:^(NSDictionary *userInfo,
                     NSURLSessionDataTask *task,
                     NSError *error){
            //データ通信中なので通信可能状態に設定
            isConnectMode = YES;
            
            NSLog(@"succeed = %d", [userInfo[@"succeed"] integerValue]);
            NSLog(@"message = %@", userInfo[@"messages"]);
            
            if([userInfo[@"succeed"] integerValue] == 1){
                NSLog(@"通信成功");
            }
            
            if(userInfo[@"messages"] == nil ||
               [userInfo[@"messages"] isEqual:[NSNull null]]){
                NSLog(@"メッセージがnullです。");
            }
            
            int numOfMessages = ((NSArray *)userInfo[@"messages"]).count;
            if(numOfMessages == 0){
                NSLog(@"メッセージの個数がゼロ");
            }else{
                for(int iMsg = 0;iMsg < numOfMessages ;iMsg++){
                    
                }
            }
            
            //メッセージの有無を判定
            
            
            //メッセージがあれば内容をデバイスに一時的に保存してタイムラインに移動
            NSLog(@"receivemessage = %@", userInfo);
                  
                  
            //タイムラインに遷移後にデバイスに保存したメッセージの内容を表示(時間等)
            
            
            
        }];
    }
    
}

//-(void)closeSoftKeyboard{
//    [self.view endEditing:YES];
//}

-(void)edit{
    NSLog(@"編集中...");
    [timer invalidate];
    EditProfileTableViewController *vc = [[EditProfileTableViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
//
-(void)addId{
//    //keyboardを立ち上げる
//    UITextView *textView = [[UITextView alloc]init];
//    [self.view addSubview:textView];
//    // キーボードを出す
//    [textView becomeFirstResponder];
    
    //念のため一旦隠す
    [self dismissKeyBoard];
    
    
    
    
    viewUnderKeyboard =
    [[UIView alloc]
     initWithFrame:self.view.bounds];
//     CGRectMake(0, 0,
//                self.view.bounds.size.width,
//                self.view.bounds.size.height)];
    viewUnderKeyboard.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.f];
    [self.view addSubview:viewUnderKeyboard];
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc]
     initWithTarget:self
     action:@selector(dismissKeyBoard)];

    [viewUnderKeyboard addGestureRecognizer:singleFingerTap];
    
    
    
    
    //
    textView = [[UITextView alloc]init];
    [viewUnderKeyboard addSubview:textView];
    
    // ボタンを配置するUIViewを作成
    UIView* accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,39)];
    accessoryView.backgroundColor = [UIColor whiteColor];
    
//    textView.frame = CGRectMake(150, 0, 100, 50);
//    [accessoryView addSubview:textView];
    
    //新規にテキストフィールドを作成してaccessoryViewに貼付ける
    
    
    //キャンセルボタン
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelButton.frame = CGRectMake(0, 5, 100, 30);
    [cancelButton setTitle:@"キャンセル" forState:UIControlStateNormal];
    cancelButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [cancelButton// ボタンを押したときに呼ばれる動作を設定
     addTarget:self
     action:@selector(dismissKeyBoard)
     forControlEvents:UIControlEventTouchUpInside];
    [accessoryView addSubview:cancelButton];
    
    
    
    // 決定ボタンを作成
    UIButton* decideButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    decideButton.frame = CGRectMake(250,5,100,30);
    [decideButton setTitle:@"決定" forState:UIControlStateNormal];
    [decideButton// ボタンを押したときに呼ばれる動作を設定
     addTarget:self
     action:@selector(determineAdd)
     forControlEvents:UIControlEventTouchUpInside];
    
    // ボタンをViewに追加
    [accessoryView addSubview:decideButton];
    
    // ビューをUITextViewのinputAccessoryViewに設定
    textView.inputAccessoryView = accessoryView;
    
    [textView becomeFirstResponder];
    
    [UIView
     animateWithDuration:0.8f
     animations:^{
         viewUnderKeyboard.backgroundColor =
         [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
     }
     completion:^(BOOL finished){
         
     }];
    
}

//決定ボタンを押したとき
-(void)determineAdd{
    NSLog(@"determine : text = %@", textView.text);
    
    
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"ichat"];
    NSString *strDeviceKey = store[@"device_key"];
    //idが存在していればtableViewの行を一つ増やす
    [[DataConnect sharedClient]
     findUserWithDeviceKey:strDeviceKey
     accountId:textView.text
     completion:^(NSDictionary *userInfo,
                  NSURLSessionDataTask *task,
                  NSError *error){
         NSLog(@"userinfo = %@", userInfo);
         NSLog(@"succeed = %@ : %@", userInfo[@"succeed"], [userInfo[@"succeed"] class]);
         if(userInfo == nil || [userInfo isEqual:[NSNull null]]){
             [self dispError:1];
         }else if([userInfo[@"succeed"] intValue] == 1){
             //id検索に成功した場合
             
             if(![arrIndivisualId containsObject:userInfo[@"user"][@"account_id"]]){
                 [arrIndivisualId addObject:userInfo[@"user"][@"account_id"]];
                 [self.tableView reloadData];
                 
                 [SVProgressHUD showSuccessWithStatus:@"追加しました!"];
             }else{
                 [SVProgressHUD showSuccessWithStatus:@"既に追加されています!"];
             }
             
         }else if([userInfo[@"succeed"] intValue] == 0){
             [self dispError:0];
         }
     }];
     
     [self dismissKeyBoard];
     store = nil;
}

-(void)dispError:(int)errorCode{
    if(errorCode == 0){
        [SVProgressHUD showSuccessWithStatus:
         [NSString stringWithFormat:@"ユーザーが見つかりません。\nerrorcode=%d", errorCode]];
    }else if(errorCode == 1){
        [SVProgressHUD showSuccessWithStatus:
         [NSString stringWithFormat:@"検索に失敗しました。\nerrorcode=%d", errorCode]];
    }

}

//キーボードを消すのみ
-(void)dismissKeyBoard{
    NSLog(@"dismissKeyboard");
    textView = nil;
    [viewUnderKeyboard removeFromSuperview];
    viewUnderKeyboard = nil;

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return arrGroupId.count;
    }else{
        return  arrIndivisualId.count;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return @"あいことば";
    }else{
        return @"id";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if(indexPath.section == 0){
        cell.textLabel.text = arrGroupId[indexPath.row];//合い言葉
    }else{
        cell.textLabel.text = arrIndivisualId[indexPath.row];//ID
    }
//    if (indexPath.section == 0) {
//        switch (indexPath.row) {
//            case 0:
//                cell.textLabel.text = @"Push via storyboard";
//                break;
//            case 1:
//                cell.textLabel.text = @"Push programmatically";
//                break;
//        }
//    }
//    else if (indexPath.section == 1) {
//        switch (indexPath.row) {
//            case 0:
//                cell.textLabel.text = @"Modal via storyboard";
//                break;
//            case 1:
//                cell.textLabel.text = @"Modal programmatically";
//                break;
//        }
//    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return (section == [tableView numberOfSections] - 1) ? @"Copyright © 2014\nBASE一同\n" : nil;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
//        switch (indexPath.row) {
//            case 0:
//                [self performSegueWithIdentifier:@"seguePushDemoVC" sender:self];
//                break;
//            case 1:
//            {
//                JSQDemoViewController *vc = [JSQDemoViewController messagesViewController];
//                [self.navigationController pushViewController:vc animated:YES];
//            }
//                break;
//        }
//    }
//    else if (indexPath.section == 1) {
//        switch (indexPath.row) {
//            case 0:
//                [self performSegueWithIdentifier:@"segueModalDemoVC" sender:self];
//                break;
//            case 1:
//            {
//                JSQDemoViewController *vc = [JSQDemoViewController messagesViewController];
//                vc.delegateModal = self;
//                UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
//                [self presentViewController:nc animated:YES completion:nil];
//            }
//                break;
//        }
        
        
        //タイマーを無効にする
        [timer invalidate];
        
        JSQDemoViewController *vc = [JSQDemoViewController messagesViewController];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    if(indexPath.section == 1){
        
        
        
        JSQDemoViewController *vc = [JSQDemoViewController messagesViewController];
        vc.strTimeLineId = @"";
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segueModalDemoVC"]) {
        UINavigationController *nc = segue.destinationViewController;
        JSQDemoViewController *vc = (JSQDemoViewController *)nc.topViewController;
        vc.delegateModal = self;
    }
}

- (IBAction)unwindSegue:(UIStoryboardSegue *)sender { }

#pragma mark - Demo delegate

- (void)didDismissJSQDemoViewController:(JSQDemoViewController *)vc
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


//?
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if(tableView == tableViewA)
//        return UITableViewCellEditingStyleNone;
//    else
        return UITableViewCellEditingStyleDelete;
}

-(void)dealloc{
    arrGroupId = nil;
    arrIndivisualId = nil;
    dictNameToId = nil;
    
    textView = nil;
    viewUnderKeyboard = nil;
}

@end
