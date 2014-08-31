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
//  一定間隔でstream messageを実行しているが、メッセージを取得しても何もしていない
//  相手を見つけて発見したらデバイスにarray_idとして格納(commonApi setIdArray)
//  その相手をタップするとタイムラインに移行
//  arrIndivisualIdはaccount_idだけ->だめ!!!!
//  arrIndivisualIdはuserInfo[account_id, name, timeLineId]

#import "JSQTableViewController.h"
#import "EditProfileTableViewController.h"

@implementation JSQTableViewController{
    NSMutableArray *arrGroupId;
    
    
    //account_id, name, timeLineIdの組合せ辞書を一つの要素とする配列にする：arrIndivisualId済(名称はファクタリングした方が良い)
    //account_id文字列を要素とする配列にした方が初期開発段階のこのクラス上ではきれいになる(containObject等使用時)が、TL画面でtimeLineIdと紐づけられない
    //さらに既にあるタイムラインに対して過去のメッセージを取得するのにこのtmidが必要になるので保有していた方が良い
    //これにより既にタイムライン上でメッセージのやりとりがあるかどうかも判定できる(NSString <-> nil)
    NSMutableArray *arrIndivisualId;
    NSMutableDictionary *dictNameToId;
    
    UITextField *textField;
    UIView *viewUnderKeyboard;
    
    BOOL isConnectMode;
    
    
    //キーボード関連
//    UIView *viewTable;
//    UIView *viewForm;
//    BOOL keyboardIsShown;
//    int kTabBarHeight;
}

@synthesize timer;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
//    // register for keyboard notifications
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillShow:)
//                                                 name:UIKeyboardWillShowNotification
//                                               object:self.view.window];
//    // register for keyboard notifications
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillHide:)
//                                                 name:UIKeyboardWillHideNotification
//                                               object:self.view.window];
//    keyboardIsShown = NO;
//    //make contentSize bigger than your scrollSize (you will need to figure out for your own use case)
//    CGSize scrollContentSize = CGSizeMake(320, 345);
//    self.tableView.contentSize = scrollContentSize;
    
    
    [super viewDidLoad];
    
    
    
//    //temporary:when reset : clear
//    NSArray *array = [NSArray array];
//    [CommonAPI setIdArray:array];
    
    
    
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
    
    UIBarButtonItem *addButton =
    [[UIBarButtonItem alloc]
     initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
     target:self
     action:@selector(addId)];
    // Here I think you wanna add the searchButton and not the filterButton..
    self.navigationItem.rightBarButtonItem = addButton;
    
    
    
    //合い言葉を設定するapiがまだない。
    //最終的にはtime_line_idからサーバー経由で合い言葉、chat相手のidを取得
//    arrGroupId = (NSMutableArray *)[CommonAPI getIdArray];//[NSMutableArray arrayWithObjects:@"しょうぎ", @"らーめん", @"ふうりゅう", nil];
    //以下account_idの文字列のみ格納された配列になっている
//    NSArray *arrTmp = [[CommonAPI getIdArray] mutableCopy];//i.e.[NSMutableArray arrayWithObjects:@"taro", @"jiro",
    NSArray *arrTmp = [[CommonAPI getIdArray] mutableCopy];//i.e. factor -> [account_id, name, timeLineId]
    arrIndivisualId = [NSMutableArray array];
    for(int i = 0;i < arrTmp.count;i++){
//        [arrIndivisualId addObject:arrTmp[i][@"account_id"]];
        [arrIndivisualId addObject:arrTmp[i]];
        
        //強制的にtimelineidを入力させる
//        arrIndivisualId[i][@"time_line_id"] = @"32";
//        [CommonAPI modifyTimeLineId:@"32"
//                           toUserId:[arrIndivisualId lastObject][@"account_id"]];
    }
    NSLog(@"arrIndivisualId = %@", arrIndivisualId);
    
    dictNameToId = nil;
    
    NSLog(@"finish didload");
    
    
    //cellが反応しない
//    UITapGestureRecognizer *gestureRecognizer =
//    [[UITapGestureRecognizer alloc]
//     initWithTarget:self action:@selector(closeSoftKeyboard)];
//    [self.view addGestureRecognizer:gestureRecognizer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    
    [self.tableView reloadData];
    
    NSLog(@"finish viewwillappear");
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
            
            NSLog(@"tableview : succeed = %d", (int)[userInfo[@"succeed"] integerValue]);
            NSLog(@"tableview : message = %@", userInfo[@"messages"]);
            
            if([userInfo[@"succeed"] integerValue] == 1){
                NSLog(@"tableview : 通信成功");
            }
            
            if(userInfo[@"messages"] == nil ||
               [userInfo[@"messages"] isEqual:[NSNull null]]){
                NSLog(@"tableview : メッセージがnullです。");
            }
            
            int numOfMessages = (int)((NSArray *)userInfo[@"messages"]).count;
            if(numOfMessages == 0){
                NSLog(@"tableview : メッセージの個数がゼロ");
            }else{
                NSLog(@"tableview : メッセージの内容は以下の通りです");
                for(int iMsg = 0;iMsg < numOfMessages ;iMsg++){
                    NSString *strMessage = userInfo[@"messages"][iMsg][@"message"];
                    NSLog(@"message %d = %@", iMsg, strMessage);
                    
                    
                    //メッセージの内容をデバイスに格納して、後で表示させる必要がある。
                    [self addMessageObj:userInfo[@"messages"][iMsg]];
                }
            }
            
            //メッセージの有無を判定
            
            
            //メッセージがあれば内容をデバイスに一時的に保存してタイムラインに移動
            NSLog(@"tableview : receivemessage = %@", userInfo);
                  
                  
            //タイムラインに遷移後にデバイスに保存したメッセージの内容を表示(時間等)
            
            
            
        }];
    }
    
}

//最悪、ここはできなくてもよい
//入力：msgInfo(account_id, id, message, time_line_id):メッセージ情報
-(void)addMessageObj:(NSDictionary *)msgInfo{
    return;//テスト：以下本番では作る必要あり(時間なかったので後回し)
    //機能１
    //user情報にmessageObjを紐づける
    //既存のuserInfo
    //"account_id" = taro;
    //name = TARO;
    //上記のuserInfoに対して以下のメッセージ配列を作成する
    //message = {{account_id, id, message, time_line_id}, {...}, ...}みたいな感じで追加していく
    
    
    //機能２
    //user情報がなければaccount_id, nameを作成した上で上記と同じデータ構造でuserInfoを作成する
    
    
    //メッセージ情報からアカウントを把握
    NSString *strAccountId = msgInfo[@"account_id"];
    
    
    
    //既存のarrIndivisualIdに上記メッセージ配列を追加する
    for(int i = 0;i < arrIndivisualId.count;i++){
        //メッセージ情報から取得したアカウントが格納されていれば
        if(arrIndivisualId[i][strAccountId] != nil &&
           [arrIndivisualId[i][strAccountId] isEqual:[NSNull null]]){
            //既にメッセージ配列の部分に何かしらのオブジェクトが格納されていれば
            if(arrIndivisualId[i][@"messages"] != nil &&
               [arrIndivisualId[i][@"messages"] isEqual:[NSNull null]]){
                
                //メッセージ配列に格納されているオブジェクトが配列型かどうか
                if([arrIndivisualId[i][@"messages"] isKindOfClass:[NSMutableArray class]]){
//                   [arrIndivisualId[i][@"messages"] isKindOfClass:[NSArray class]]){
                   
//                    for(int j = 0;j < ((NSMutableArray *)arrIndivisualId[i][@"messages"]).count;j++){
//                        
//                    }
                    
                    //最後にメッセージオブジェクトを追加する
//                    NSMutableArray *mArrMsgInfo = arrIndivisualId[i][@"messages"];
                    [arrIndivisualId[i][@"messages"] addObject:msgInfo];
                    
                }else{
                    NSLog(@"クリティカルエラー：arrIndivisualIdが配列ではない別のオブジェクトが格納されています。");
                }
                
            }else{
                //メッセージ配列を新規作成して追加する
                NSMutableArray *mArrMsgInfo = [NSMutableArray array];
                [mArrMsgInfo addObject:msgInfo];
                arrIndivisualId[i][@"messages"] = mArrMsgInfo;
                mArrMsgInfo = nil;
                
                NSLog(@"メッセージ情報を新規追加 : arrIndivisualId = %@", arrIndivisualId);
            }
            
            //[commonAPIでデバイスsetする]
            [CommonAPI setIdArray:arrIndivisualId];
            
            [self.tableView reloadData];
        }else{//メッセージ情報から取得したアカウントが格納されていない場合はそれを新たに作成してデバイスに保存する
            NSMutableDictionary *dictUserInfo = [NSMutableDictionary dictionary];
            dictUserInfo[@"account_id"] = strAccountId;
//            dictUserInfo[@"name"]
            //ここでnameをfinduserから取得してしまうと非同期処理が開始されてしまい、本スレッドで仮に複数のメッセージが存在した場合
            //同一account_idで重複してしまう
            
            arrIndivisualId[i][@"messages"] = [NSMutableArray array];
            [((NSMutableArray *)arrIndivisualId[i][@"messages"]) addObject:dictUserInfo];
            
//            [arrIndivisualId[i][@"messages"] addObject:dictUserInfo];
            
//            [CommonAPI setIdArray:<#(NSArray *)#>]
            
        }
        
        
    }//for(i-arrIndivisualId.count)
    
    //呼び出すときから考えてやらなければいけない。
    
}

//-(void)closeSoftKeyboard{
//    [self.view endEditing:YES];
//}

-(void)edit{
    NSLog(@"編集中...");
    [timer invalidate];
    NSLog(@"tableview : タイマーを停止");
    EditProfileTableViewController *vc = [[EditProfileTableViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)alertView:
(UIAlertView*)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSLog(@"alertViewが選択されました.");
    
    switch (buttonIndex) {
        case 0:
            //１番目のボタンが押されたときの処理を記述する
            NSLog(@"キャンセル");
            break;
        case 1:
            //２番目のボタンが押されたときの処理を記述する
            NSLog(@"text = %@",[alertView textFieldAtIndex:0].text);
            [self determineAdd:[alertView textFieldAtIndex:0].text];
            break;
    }
    
    
}

//メニューの右ボタン；追加ボタン
-(void)addId{
    
    //case1
    //アラートメッセージで入力させる場合(開始)
    NSLog(@"add id");
    UIAlertView *alertView =
    [[UIAlertView alloc]
     initWithTitle:@"追加するidを入力して下さい"
     message:@"人を追加するのかtimelineを入力させるか"
     delegate:self
     cancelButtonTitle:@"cancel"
     otherButtonTitles:@"OK", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    alertView.delegate = self;
    [alertView show];
    return;
    //アラートメッセージ入力(終了)
    
    
    //case2
    //カスタム入力フォーム
    
    //念のため(表示されている場合のために)一旦隠す
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
    
    
    //入力フィールドの場所を決定させるためにキーボードの位置を取得する
    //CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    
    //
    textField = [[UITextField alloc]init];
    
    textField.frame = CGRectMake(0, 100, self.view.bounds.size.width, 50);
    //画面中心位置だと上すぎて不自然なので下にずらした
    textField.center = CGPointMake(viewUnderKeyboard.center.x,
                                   viewUnderKeyboard.center.y + 80);//viewUnderKeyboard.center;
    textField.center = self.view.center;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.font = [UIFont systemFontOfSize:15];
    textField.placeholder = @"enter id";
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.keyboardType = UIKeyboardTypeDefault;
    textField.returnKeyType = UIReturnKeyDone;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.delegate = self;
    [viewUnderKeyboard addSubview:textField];
    
    
    // ボタンを配置するUIViewを作成
    UIView* accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.view.bounds.size.width,39)];
    accessoryView.backgroundColor = [UIColor whiteColor];
//    [accessoryView addSubview:textField];//これをやるとキーボードが表示されない(おそらくキーボードの生成とaccessoryの生成が無限ループになっている可能性)
    
    
    
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

    [decideButton// ボタンを押したときに呼ばれる動作を設定
     addTarget:self
     action:@selector(determineAdd)
     forControlEvents:UIControlEventTouchUpInside];
    
    
    // ボタンをViewに追加
    [accessoryView addSubview:decideButton];
    
    // ビューをUITextFieldのinputAccessoryViewに設定
    textField.inputAccessoryView = accessoryView;
    
    [textField becomeFirstResponder];
    
    [UIView
     animateWithDuration:0.8f
     animations:^{
         viewUnderKeyboard.backgroundColor =
         [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
     }
     completion:^(BOOL finished){
         
     }];
    
}


//キーボードの入力パターンで二通りの渡し方を用意した
//決定ボタンを押したとき:
-(void)determineAdd{
    
    [self determineAdd:textField.text];
}

//上記determinAdd及びテキストフィールドから決定ボタンが押されたとき
-(void)determineAdd:(NSString *)strText{

    NSLog(@"determine : text = %@", strText);
    
    
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"ichat"];
    NSString *strDeviceKey = store[@"device_key"];
    //idが存在していればtableViewの行を一つ増やす
    [[DataConnect sharedClient]
     findUserWithDeviceKey:strDeviceKey
     accountId:strText
     completion:^(NSDictionary *userInfo,
                  NSURLSessionDataTask *task,
                  NSError *error){
         
         NSLog(@"userinfo = %@", userInfo);
//         NSLog(@"succeed = %@ : %@", userInfo[@"succeed"], [userInfo[@"succeed"] class]);//1:BOOL
         if(userInfo == nil || [userInfo isEqual:[NSNull null]]){
             [self dispError:1];
         }else if([userInfo[@"succeed"] intValue] == 1){
             //id検索に成功した場合
             
             //デバイスに保存されているユーザー情報配列の中にaccount_idが含まれているか
//             if(![arrIndivisualId containsObject:userInfo[@"user"][@"account_id"]]){
             if(![self containsIndivisualId:userInfo[@"user"][@"account_id"]]){
                 
//                 [arrIndivisualId addObject:userInfo[@"user"][@"account_id"]];
                 [arrIndivisualId addObject:userInfo[@"user"]];
                 [self.tableView reloadData];
                 
                 [SVProgressHUD showSuccessWithStatus:@"追加しました!"];
                 
                 //デバイスに格納する相手に関する情報
                 //将来的にタップした時にtimelineに渡される辞書になる。
                 //UICKeyChainStoreから格納用の配列を取得し、更新した上で再度格納する
//                 [CommonAPI addId:userInfo[@"user"][@"account_id"]];
                 //account_idではなくnameとaccount_id両方保存する
                 BOOL isSuccessAdd = [CommonAPI addId:userInfo[@"user"]];
                 if(isSuccessAdd){
                     NSLog(@"保存成功");
                 }else{
                     NSLog(@"保存失敗");
                 }
                 
//                 NSMutableDictionary *dictPerson = [NSMutableDictionary dictionary];
//                 dictPerson[@"members"] = [NSArray arrayWithObjects:userInfo[@"user"][@"account_id"], nil];//account_idを格納する
                 
                 
                 
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

//arrIndivisualIdの中にstrIdのaccount_idのuserInfo[account_id, name, timelineid]が含まれているか
-(BOOL)containsIndivisualId:(NSString *)strId{
    for(NSDictionary *dictUser in arrIndivisualId){
        if([dictUser[@"account_id"] isEqualToString:strId]){
            NSLog(@"match strId %@ in device", strId);
            return YES;
        }
    }
    
    return NO;
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
    textField = nil;
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
        NSLog(@"arrgroup = %d", arrGroupId.count);
        return arrGroupId.count;
    }else{
        NSLog(@"arrind = %d", arrIndivisualId.count);
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
    NSLog(@"return : %d, %d", (int)indexPath.section, (int)indexPath.row);
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if(indexPath.section == 0){
        NSLog(@"indexPath.sec%d, row%d = %@",
              (int)indexPath.section,
              (int)indexPath.row,
              arrGroupId[indexPath.row]);
        cell.textLabel.text = arrGroupId[indexPath.row][@"group_name"];//合い言葉 or Group_name?
    }else{
        NSLog(@"indexPath.sec%d, row%d = %@",
              (int)indexPath.section,
              (int)indexPath.row,
              arrIndivisualId[indexPath.row]);
//        cell.textLabel.text = arrIndivisualId[indexPath.row];//ID
        cell.textLabel.text =
        [NSString stringWithFormat:@"%@(%@)",
         arrIndivisualId[indexPath.row][@"account_id"],
         arrIndivisualId[indexPath.row][@"timeLineId"]];
        NSLog(@"aaa %i, %i",
              indexPath.section,
              indexPath.row);
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
    NSLog(@"%@",
          (section == [tableView numberOfSections] - 1) ? @"Copyright © 2014\nBASE一同\n" : nil);
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
        NSLog(@"tableview : タイマーを停止");
        //本番
        JSQDemoViewController *vc = [JSQDemoViewController messagesViewController];
//        JSQDemo2ViewController *vc = [JSQDemo2ViewController messagesViewController];
        
//postするときに必要なデータ
//        device_key	string          Required. Device Key that was issued when you create the user.
//        time_line_id	string          Required for the time line. The ID of the time line.
//        members       string array    Required for new time line. Account IDs of the time line.
//        message       string          Required. The contents of message.
//        vc.timeLineData = nil;//[[CommonAPI getIdArray] objectAtIndex:indexPath.row];//デバイスに保存されたNSDictionaryを取得して渡す
        //おそらくここでtimelineに必要なパラメータの設定を行う(タイムラインidもしくは相手のid配列等)
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    if(indexPath.section == 1){
        UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"ichat"];
        NSString *strDeviceKey = store[@"device_key"];
        
        //遷移先に送る為のaccount_idとnameの組み合わせを作成するため
//        NSString *strAccountId = arrIndivisualId[indexPath.row];
        NSString *strAccountId = arrIndivisualId[indexPath.row][@"account_id"];
        [[DataConnect sharedClient]
         findUserWithDeviceKey:strDeviceKey
         accountId:strAccountId
         completion:^(NSDictionary *userInfo,
                     NSURLSessionDataTask *task,
                     NSError *error){
             NSLog(@"userInfo at findusers at tableView : %@", userInfo);
             NSArray *arrUsers = [NSArray arrayWithObjects:userInfo[@"user"], nil];
             JSQDemoViewController *vc = [JSQDemoViewController messagesViewController];
             vc.arrTimeLineUsers = arrUsers;
             //timeLineIdが発行されている場合は入力されている(未入力の場合はnil)
             vc.strTimeLineId = arrIndivisualId[indexPath.row][@"timeLineId"];
             [timer invalidate];
             NSLog(@"tableview : タイマーを停止");
             NSLog(@"vc.timelineusers = %@", vc.arrTimeLineUsers);
             [self.navigationController pushViewController:vc animated:YES];
             arrUsers = nil;
         }];
        store = nil;
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
    
    textField = nil;
    viewUnderKeyboard = nil;
    
    [self.timer invalidate];
    self.timer = nil;
}


//- (void)keyboardWillHide:(NSNotification *)n
//{
//    NSLog(@"keyboard will hide");
//    NSDictionary* userInfo = [n userInfo];
//    
//    // get the size of the keyboard
//    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//    
//    
//    // resize the scrollview
//    CGRect viewFrame = self.tableView.frame;
//    // I'm also subtracting a constant kTabBarHeight because my UIScrollView was offset by the UITabBar so really only the portion of the keyboard that is leftover pass the UITabBar is obscuring my UIScrollView.
//    viewFrame.size.height += (keyboardSize.height - kTabBarHeight);
//    
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationBeginsFromCurrentState:YES];
//    [self.tableView setFrame:viewFrame];
//    [UIView commitAnimations];
//    
//    keyboardIsShown = NO;
//}
//
//- (void)keyboardWillShow:(NSNotification *)n
//{
//    NSLog(@"keyboard will show");
//    // This is an ivar I'm using to ensure that we do not do the frame size adjustment on the `UIScrollView` if the keyboard is already shown.  This can happen if the user, after fixing editing a `UITextField`, scrolls the resized `UIScrollView` to another `UITextField` and attempts to edit the next `UITextField`.  If we were to resize the `UIScrollView` again, it would be disastrous.  NOTE: The keyboard notification will fire even when the keyboard is already shown.
//    if (keyboardIsShown) {
//        return;
//    }
//    
//    NSDictionary* userInfo = [n userInfo];
//    
//    // get the size of the keyboard
//    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//    
//    // resize the noteView
//    CGRect viewFrame = self.tableView.frame;
//    // I'm also subtracting a constant kTabBarHeight because my UIScrollView was offset by the UITabBar so really only the portion of the keyboard that is leftover pass the UITabBar is obscuring my UIScrollView.
//    viewFrame.size.height -= (keyboardSize.height - kTabBarHeight);
//    
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationBeginsFromCurrentState:YES];
//    [self.tableView setFrame:viewFrame];
//    [UIView commitAnimations];
//    keyboardIsShown = YES;
//}



@end
