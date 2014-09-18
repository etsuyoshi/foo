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


//セルをchatousライクにする(左側にアイコン、中央上段にチャットid(もしくはname)、下段にステータス、右側に時間を設置

#import "JSQTableViewController.h"
#import "EditProfileTableViewController.h"

@implementation JSQTableViewController{
    NSMutableArray *arrGroupId;
    
    UITableView *selectChatTable;
    
    //account_id, name, timeLineIdの組合せ辞書を一つの要素とする配列にする：arrIndivisualId済(名称はファクタリングした方が良い)
    //account_id文字列を要素とする配列にした方が初期開発段階のこのクラス上ではきれいになる(containObject等使用時)が、TL画面でtimeLineIdと紐づけられない
    //さらに既にあるタイムラインに対して過去のメッセージを取得するのにこのtmidが必要になるので保有していた方が良い
    //これにより既にタイムライン上でメッセージのやりとりがあるかどうかも判定できる(NSString <-> nil)
    NSMutableArray *arrIndivisualId;
    NSMutableDictionary *dictNameToId;
    
    UITextField *textField;
    UIView *viewUnderKeyboard;
    
    BOOL isConnectMode;
    
    //受信用ステータスバー
    UILabel *labelMessageReceive;
    
    
    //フッタービュー：相手を追加するボタン設置
    UIView *viewFooter;
    int heightOfFooter;
    int diameterButton;

    
    NSArray *arrIcon;
    
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
    
    arrIcon = [NSArray arrayWithObjects:
               @"butterfly",
               @"elephant",
               @"fishes",
               @"ladybird",
               @"panda",
               @"rabbit",
               @"squirrel",
               nil];
    
    heightOfFooter = 60;
    diameterButton = 55;

    
    selectChatTable =
    [[UITableView alloc]initWithFrame:
     CGRectMake(0, 0, self.view.bounds.size.width,
                self.view.bounds.size.height-heightOfFooter)
                                style:UITableViewStyleGrouped];
    selectChatTable.delegate = self;
    selectChatTable.dataSource = self;
    [self.view addSubview:selectChatTable];
    
    //http://qiita.com/yimajo/items/7051af0919b5286aecfe
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.000 green:0.549 blue:0.890 alpha:1.000];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;
    
    //temporary:when reset : clear
//    NSArray *array = [NSArray array];
//    [CommonAPI setIdArray:array];
    
    
    
    isConnectMode = YES;
    
    
    UINib *nib = [UINib nibWithNibName:@"JSQSelectIdTableViewCell" bundle:nil];
    [selectChatTable registerNib:nib forCellReuseIdentifier:@"selectIdCell"];//xibファイルidentifier名
    
    
    //画面下段に追加ボタンを設置
    [self addFooterView];
    
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
    
    
    self.title = @"チャット";

    NSLog(@"viewdidload at jsqTableView");
    
    
    UIBarButtonItem *editButton =
    [[UIBarButtonItem alloc]
     initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
     target:self
     action:@selector(edit)];
    
    self.navigationItem.leftBarButtonItem = editButton;
    
    //追加ボタンは画面下段中央部に設置(ナビゲーションから追加させないようにする)
    
//    UIBarButtonItem *addButton =
//    [[UIBarButtonItem alloc]
//     initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
//     target:self
//     action:@selector(addInputId)];
//    // Here I think you wanna add the searchButton and not the filterButton..
//    self.navigationItem.rightBarButtonItem = addButton;
    
    
    
    //合い言葉を設定するapiがまだない。
    //最終的にはtime_line_idからサーバー経由で合い言葉、chat相手のidを取得
    //arrGroupId = (NSMutableArray *)[CommonAPI getIdArray];//[NSMutableArray arrayWithObjects:@"しょうぎ", @"らーめん", @"ふうりゅう", nil];
    //以下account_idの文字列のみ格納された配列になっている
//    NSArray *arrTmp = [[CommonAPI getIdArray] mutableCopy];//i.e.[NSMutableArray arrayWithObjects:@"taro", @"jiro",
    NSArray *arrTmp = [[CommonAPI getIdArray] mutableCopy];//i.e. factor -> [account_id, name, timeLineId]
    NSLog(@"arrTmp = %@", arrTmp);
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

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //example
//    [self receiveMessageView];
    
    
    //画面が表示されるたびにタイマー有効化
    timer = [NSTimer
             scheduledTimerWithTimeInterval:2
             target:self
             selector:@selector(checkMessage:)
             userInfo:nil
             repeats:YES];
    
    NSLog(@"timer validate");
    
    [selectChatTable reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    
    
    NSLog(@"finish viewwillappear");
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    NSLog(@"viewWillDisappear");
//    for(UIView *view in self.view.subviews){
//        [view removeFromSuperview];
//    }
    [labelMessageReceive removeFromSuperview];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    NSLog(@"viewDidDisappear");
    
//    for(UIView *view in self.view.subviews){
//        [view removeFromSuperview];
//    }
    [labelMessageReceive removeFromSuperview];
}

-(void)receiveMessageView:(NSString *)_strMessage{
    NSLog(@"receiveMessageView");
    [labelMessageReceive removeFromSuperview];
    
    labelMessageReceive =
    [[UILabel alloc]
     initWithFrame:
     CGRectMake(0, 0,
                self.view.bounds.size.width,
                50)];
    labelMessageReceive.backgroundColor =
    [[UIColor greenColor] colorWithAlphaComponent:0.9f];
    //test
    if([_strMessage isEqualToString:
        [NSString stringWithFormat:@"no message %@",
         [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"]]
        ]){
        labelMessageReceive.backgroundColor =
        [[UIColor redColor] colorWithAlphaComponent:0.9f];
    }
    
    labelMessageReceive.text = _strMessage;
    labelMessageReceive.textColor = [UIColor whiteColor];

    [self.view addSubview:labelMessageReceive];
    
    //時間遅れ
    [self performSelector:@selector(removeMessageView)
               withObject:nil
               afterDelay:1.0];
}

//メッセージを受信したとき
-(void)removeMessageView{
    [UIView
     animateWithDuration:0.5f
     animations:^{
         labelMessageReceive.alpha = 0.0f;
     }
     completion:^(BOOL finished){
         [labelMessageReceive removeFromSuperview];
     }];
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
            if(error == nil || [error isEqual:[NSNull null]]){
                NSLog(@"userInfo = %@", userInfo);
                
                
                NSLog(@"tableview : succeed = %d", (int)[userInfo[@"succeed"] integerValue]);
                NSLog(@"tableview : message = %@", userInfo[@"messages"]);
                
//            if([userInfo[@"succeed"] integerValue] == 1){
//                NSLog(@"tableview : 通信成功");
//            }
//            
//            if(userInfo[@"messages"] == nil ||
//               [userInfo[@"messages"] isEqual:[NSNull null]]){
//                NSLog(@"tableview : メッセージがnullです。");
//            }
                
                int numOfMessages = (int)((NSArray *)userInfo[@"messages"]).count;
                if(numOfMessages == 0){
                    NSLog(@"メッセージはありません");
                    //test
                    [self receiveMessageView:
                     [NSString stringWithFormat:@"no message %@",
                      [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"]]
                     ];
                }else{
                    NSLog(@"メッセージを受信しました");
                    //受信した全てのメッセージに対して
                    for(int iMsg = 0;iMsg < numOfMessages ;iMsg++){
                        NSLog(@"message info %d = %@", iMsg, userInfo[@"messages"][iMsg]);
//                    NSString *strMessage = userInfo[@"messages"][iMsg][@"message"];
//                    NSLog(@"message %d = %@", iMsg, strMessage);
                        
                        
                        //タイムライン上で表示させるため、メッセージの内容をデバイスに格納
                        [self addMessageObj:userInfo[@"messages"][iMsg]];
                        
                        //タイムライン上でメッセージを受信した時に表示する通知メッセージ
                        NSString *strDispNotification =
                        [NSString stringWithFormat:@"%@:%@",
                         userInfo[@"messages"][iMsg][@"account_id"],
                         userInfo[@"messages"][iMsg][@"message"]];
                        //タイムラインに遷移後にデバイスに保存したメッセージの内容を表示(時間等)
                        [self receiveMessageView:strDispNotification];
                        
                        
                        //受信した相手をまだ追加していない場合はテーブルビューに表示する
                        if(![CommonAPI findId:userInfo[@"messages"][iMsg][@"account_id"]]){
                            //apiをキックしてユーザー情報を取得してきてデバイスに保存する
                            [self determineAdd:userInfo[@"messages"][iMsg][@"account_id"]];
                        }
                    }
                }
                
                [selectChatTable reloadData];
                //メッセージがあれば内容をデバイスに一時的に保存してタイムラインに移動
                NSLog(@"tableview : receivemessage = %@", userInfo);
            }else{
                NSLog(@"サーバー通信上のエラーが発生しました");
                NSLog(@"error = %@", error);
            }
            
            
            
        }];
    }else{
        NSLog(@"isConnectMode = %d", isConnectMode);
    }
    
}

//最悪、ここはできなくてもよい
//入力：msgInfo(account_id, id, message, time_line_id):メッセージ情報
-(void)addMessageObj:(NSDictionary *)msgInfo{
    NSLog(@"addmessageObj : arg = %@", msgInfo);
    
    [CommonAPI addMessage:msgInfo];
    
    
//    NSArray *testArrMessage = [CommonAPI getMessageArray];
//    NSMutableDictionary *testDictMessage = [[testArrMessage lastObject] mutableCopy];
//    
//    NSLog(@"メッセージを格納しました , last : %@", testDictMessage);
//    for(int i = 0;i < testArrMessage.count;i++){
//        NSLog(@"all message : %d : %@", i, testArrMessage[i]);
//    }
    
    
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
    //test->remove
    for(int i = 0;i < arrIndivisualId.count;i++){
        NSLog(@"arrIndivisualId %d = %@", i, arrIndivisualId[i]);
    }
    NSLog(@"strAccountId = %@", strAccountId);
    //既存のarrIndivisualIdに上記メッセージ配列を追加する
    for(int i = 0;i < arrIndivisualId.count;i++){
        NSLog(@"for arrIndivisualId %d = %@", i, arrIndivisualId[i][@"account_id"]);
        //メッセージ情報から取得したアカウントが既にデバイスに格納されていれば
        if(  arrIndivisualId[i][@"account_id"] != nil &&
           ![arrIndivisualId[i][@"account_id"] isEqual:[NSNull null]]){
            NSLog(@"through arrindivisualId judgement : %@",
                  arrIndivisualId[i][@"account_id"]);
            
            //探索中idのアカウントが受信者アカウントに等しければ
            if([arrIndivisualId[i][@"account_id"] isEqualToString:strAccountId]){
                //受信者と同じidが既に選択画面に存在していればメッセージ格納用のmutableArrayを格納する
                
                
                //メッセージ配列が存在しない場合(初期状態)
                if(arrIndivisualId[i][@"messages"] == nil ||
                   [arrIndivisualId[i][@"messages"] isEqual:[NSNull null]]){
                    NSMutableArray *arrMessages =
                    [NSMutableArray arrayWithObjects:msgInfo, nil];
                    
                    //arrindivisualIdに追加する
                    
                    
                    
                    
                }
                
                
                
                //メッセージ配列が存在している場合(既にメッセージを受信しているが、タイムライン上で表示していない場合)
                
                
                
                
                
                
                
                
                
             
            }
            
            
            //既にメッセージ配列の部分に何かしらのオブジェクトが格納されていれば
            if(  arrIndivisualId[i][@"messages"] != nil &&
               ![arrIndivisualId[i][@"messages"] isEqual:[NSNull null]]){
                NSLog(@"through arrindivisualId judgement : %@",
                      arrIndivisualId[i][@"messages"]);
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
                
            }else{//デバイスに受信者のアカウントは登録されているが
                //メッセージ配列を新規作成して追加する
                NSMutableArray *mArrMsgInfo = [NSMutableArray array];
                [mArrMsgInfo addObject:msgInfo];
                
                //
                //arrIndivisualId[i][@"messages"] = mArrMsgInfo;
                mArrMsgInfo = nil;
                
                NSLog(@"メッセージ情報を新規追加 : arrIndivisualId = %@", arrIndivisualId);
            }
            
            NSLog(@"arrIndivisualId = %@", arrIndivisualId);
            
            
            //[commonAPIでデバイスsetする]
            [CommonAPI setIdArray:arrIndivisualId];
            
            //[self.tableView reloadData];
            [selectChatTable reloadData];
        }else{//メッセージ情報から取得したアカウントが格納されていない場合はそれを新たに作成してデバイスに保存する
            NSMutableDictionary *dictUserInfo = [NSMutableDictionary dictionary];
            dictUserInfo[@"account_id"] = strAccountId;
//            dictUserInfo[@"name"]
            //ここでnameをfinduserから取得してしまうと非同期処理が開始されてしまい、本スレッドで仮に複数のメッセージが存在した場合
            //同一account_idで重複してしまう
            
            arrIndivisualId[i][@"messages"] = [NSMutableArray array];///////////
            [((NSMutableArray *)arrIndivisualId[i][@"messages"]) addObject:dictUserInfo];
            
//            [arrIndivisualId[i][@"messages"] addObject:dictUserInfo];
            
//            [CommonAPI setIdArray:<#(NSArray *)#>]
            
        }
        
        
    }//for(i-arrIndivisualId.count)
    
    //呼び出すときから考えてやらなければいけない。
    
    
    
    NSLog(@"addMessageObj : arrIndivisualId = %@", arrIndivisualId);
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

//メニューの右ボタン(もしくは画面下段中央の)；追加ボタン
-(void)addInputId{
    
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
-(void)determineAdd:(NSString *)strText{//strTextは個人id

    NSLog(@"determine : text = %@", strText);
    
    
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"ichat"];
    NSString *strDeviceKey = store[@"device_key"];
    //apiをキックしてDBにidが存在していればtableViewの行を一つ増やす
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
                 
                 //arrIndivisualIdに追加する
//                 [arrIndivisualId addObject:userInfo[@"user"][@"account_id"]];
                 [arrIndivisualId addObject:userInfo[@"user"]];
                 NSLog(@"table add -> %@", userInfo[@"user"]);
//                 [self.tableView reloadData];
                 [selectChatTable reloadData];
                 
                 
                 //ダイアログの表示
                 [SVProgressHUD showSuccessWithStatus:
                  [NSString stringWithFormat:@"%@が追加されました!",
                   userInfo[@"user"][@"account_id"]]];
                 
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

-(CGFloat) tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
//    JSQSelectIdTableViewCell *cell =
//    (JSQSelectIdTableViewCell*)
//    [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    http://www.techotopia.com/index.php/Using_Xcode_Storyboards_to_Build_Dynamic_TableViews_with_Prototype_Table_View_Cells
    
    static NSString *CellIdentifier = @"selectIdCell";//xibファイルのidentifier
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    
    NSLog(@"cell.imvleft = %@", ((JSQSelectIdTableViewCell *)cell).imvLeft);
    ((JSQSelectIdTableViewCell *)cell).imvLeft.layer.cornerRadius =
    ((JSQSelectIdTableViewCell *)cell).imvLeft.bounds.size.width/2;//真円にするため半径設定
    ((JSQSelectIdTableViewCell *)cell).imvLeft.layer.masksToBounds = YES;
    ((JSQSelectIdTableViewCell *)cell).imvLeft.image =
    [UIImage imageNamed:arrIcon[indexPath.row % arrIcon.count]];
    ((JSQSelectIdTableViewCell *)cell).lblName.text = arrIndivisualId[indexPath.row][@"account_id"];
    ((JSQSelectIdTableViewCell *)cell).lblMessage.text = [self getLastMessageWithId:arrIndivisualId[indexPath.row][@"account_id"]];
    ((JSQSelectIdTableViewCell *)cell).lblMessage.textColor = [UIColor grayColor];
    ((JSQSelectIdTableViewCell *)cell).lblTime.text = @"00:00";
    ((JSQSelectIdTableViewCell *)cell).lblTime.textColor = [UIColor grayColor];
    NSLog(@"return cell = %@", cell);
    
    return cell;
    
    
    if (indexPath.section == 0 ||
        indexPath.section == 1) {
        
    
            
    
    /////////test from this point
    
//    NSLog(@"return : %d, %d", (int)indexPath.section, (int)indexPath.row);
//    static NSString *CellIdentifier = @"CellIdentifier";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    }
//    if(indexPath.section == 0){
//        NSLog(@"indexPath.sec%d, row%d = %@",
//              (int)indexPath.section,
//              (int)indexPath.row,
//              arrGroupId[indexPath.row]);
//        cell.textLabel.text = arrGroupId[indexPath.row][@"group_name"];//合い言葉 or Group_name?
//    }else{
//        NSLog(@"indexPath.sec%d, row%d = %@",
//              (int)indexPath.section,
//              (int)indexPath.row,
//              arrIndivisualId[indexPath.row]);
////        cell.textLabel.text = arrIndivisualId[indexPath.row];//ID
//        cell.textLabel.text =
//        [NSString stringWithFormat:@"%@(%@)",
//         arrIndivisualId[indexPath.row][@"account_id"],
//         arrIndivisualId[indexPath.row][@"timeLineId"]];
            
            
            //test until this point
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
        
        //ステータスバーを全て削除する
        for(UIView *view in self.view.subviews){
            [view removeFromSuperview];
        }
        
        
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
        NSLog(@"選択画面で%@が選択されました", strAccountId);
        [[DataConnect sharedClient]
         findUserWithDeviceKey:strDeviceKey
         accountId:strAccountId
         completion:^(NSDictionary *userInfo,
                     NSURLSessionDataTask *task,
                     NSError *error){
             NSLog(@"userInfo at findusers at tableView : %@", userInfo);
             NSArray *arrUsers = nil;//userInfo[@"user"];
             
             //arrUsersにはtimelineに属する全ユーザー情報を付与する
             //ここではaccountId一人のみだが、グループチャットする場合には複数登録をする必要がある
             if(userInfo[@"user"] != nil &&
                ![userInfo[@"user"] isEqual:[NSNull null]]){
                 NSLog(@"userはヌルではない : %@", userInfo[@"user"]);
                 arrUsers = [NSArray arrayWithObjects:userInfo[@"user"], nil];
//             [NSArray arrayWithObjects:userInfo[@"user"], nil];
             
                 //該当者が存在すれば
                 if((int)arrUsers.count > 0){//実際にはカウンターがゼロのことはない：該当idがなければarrUsersの要素にnullが格納されているため
                     
                     NSLog(@"arrUsers.count = %d, contents = %@", (int)arrUsers.count, arrUsers);
                     JSQDemoViewController *vc = [JSQDemoViewController messagesViewController];
                     vc.arrTimeLineUsers = arrUsers;
                     //timeLineIdが発行されている場合は入力されている(未入力の場合はnil)
                     vc.strTimeLineId = arrIndivisualId[indexPath.row][@"timeLineId"];
                     if(arrIndivisualId[indexPath.row][@"name"] == nil ||
                        [arrIndivisualId[indexPath.row][@"name"] isEqual:[NSNull null]]){
                         vc.title = arrIndivisualId[indexPath.row][@"name"];
                     }else{
                         vc.title = arrIndivisualId[indexPath.row][@"account_id"];
                     }
                     [timer invalidate];//タイマー停止
                     NSLog(@"tableview : タイマーを停止");
                     NSLog(@"vc.timelineusers = %@", vc.arrTimeLineUsers);
                     [self.navigationController pushViewController:vc animated:YES];
                     
                 }
             }else{
                 //該当者が存在しない
                 NSString *strNoManMessage =
                 [NSString stringWithFormat:@"%@が存在しません", strAccountId];
                 NSLog(@"%@", strNoManMessage);
                 [SVProgressHUD showSuccessWithStatus:strNoManMessage];
             }
             arrUsers = nil;
             NSLog(@"arrUsers初期化");
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

-(void)addFooterView{
    
    NSLog(@"add footer view");
    //画面サイズ自体がnavigationBarによって下にずれているのでその分を上位置に調整してあげる必要がある
    //テザリング等によりstatusBarの高さが変わる場合(未対応)http://dendrocopos.jp/wp/archives/298
    viewFooter =
    [[UIView alloc]
    initWithFrame:
    CGRectMake(0,
               self.view.bounds.size.height - heightOfFooter -
               self.navigationController.navigationBar.bounds.size.height -
               [UIApplication sharedApplication].statusBarFrame.size.height,
               self.view.bounds.size.width,
               heightOfFooter)];
    
    viewFooter.backgroundColor =
    [UIColor colorWithRed:1 green:1 blue:1 alpha:0];
    
    UIButton *buttonAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonAdd setImage:[UIImage imageNamed:@"addImgId"]
               forState:UIControlStateNormal];
    buttonAdd.frame =
    CGRectMake((self.view.bounds.size.width - diameterButton)/2,
               (heightOfFooter / diameterButton)/2,
               diameterButton, diameterButton);
    [buttonAdd addTarget:self
                  action:@selector(addInputId)
        forControlEvents:UIControlEventTouchUpInside];
    [viewFooter addSubview:buttonAdd];
    
    [self.view addSubview:viewFooter];
    
    NSLog(@"add footer view finished");
}

-(NSString *)getLastMessageWithId:(NSString *)strId{
    NSArray *arrMessageTmp = [CommonAPI getMessageArray];
    for(int i = (int)arrMessageTmp.count-1;i >= 0;i--){
        NSLog(@"message %d = %@", i, arrMessageTmp[i]);
        if([arrMessageTmp[i][@"account_id"] isEqualToString:strId]){
            NSLog(@"return %d is %@", i, arrMessageTmp[i][@"message"]);
            return arrMessageTmp[i][@"message"];
        }
    }
    arrMessageTmp = nil;//メモリ解放
    return nil;
}

@end
