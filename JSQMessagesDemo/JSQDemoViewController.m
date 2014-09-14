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


//sendボタンを完了ボタンにして押下後キーボード消去[self.view endEditing:YES];

//postするときに必要なデータ
//        device_key	string          Required. Device Key that was issued when you create the user.
//        time_line_id	string          Required for the time line. The ID of the time line.
//        members       string array    Required for new time line. Account IDs of the time line.
//        message       string          Required. The contents of message.

#import "JSQDemoViewController.h"
#import "PersonViewController.h"
#import "DataConnect.h"


//static NSString * const kJSQDemoAvatarNameCook = @"じんぐうじ";//Tim Cook";
//static NSString * const kJSQDemoAvatarNameJobs = @"Jobs";
//static NSString * const kJSQDemoAvatarNameWoz = @"Steve Wozniak";


@implementation JSQDemoViewController{
    
    
    float firstX;
    float firstY;
    
    NameTableView *tableView;
    
    NSString *strDeviceKey;
}

//はじめて一対一で話をする時はtimeLineIdは存在しないのでヌルのまま
//その場合、メッセージを送った(postした)ときに初めてtimeLineIdが配布されるのでそれを登録する(未実装)
//その場合、登録方法はUICKeyChainに保存する！(未実装)
//次回以降(既存のタイムラインに対して)timelineを選択する場合には上記で保存したtimelineidをuickeychainを使ってサーバーに問い合わせて(TL画面に遷移後)過去メッセージを取得する(未実装)
@synthesize strTimeLineId;
@synthesize timerConversation;
@synthesize arrTimeLineUsers;//messages/postに必要なtime_line_idとmembers(相手のaccount_idとnameの組合せ辞書を格納している配列)
//time_line_idは新規の場合、nilで最初のポストで返りに新規idが付与される
//構造的には以下のような感じ
//(
// {
//     "account_id" = taro;
//     name = TARO;
// },
// {
//     "account_id" = jiro;
//     name = JIRO;
//)

#pragma mark - Demo setup

- (void)initialize
{
    NSLog(@"initialize");
    /**
     *  Load some fake messages for demo.
     *
     *  You should have a mutable array or orderedSet, or something.
     */
    
    
    
    self.messages = [[NSMutableArray alloc] initWithObjects:
                     
                     //test-data
//                     [[JSQMessage alloc] initWithText:@"できたよ！" sender:self.sender date:[NSDate distantPast]],
//                     [[JSQMessage alloc] initWithText:@"まじかよ！" sender:kJSQDemoAvatarNameWoz date:[NSDate distantPast]],
//                     [[JSQMessage alloc] initWithText:@"遠藤天才？" sender:self.sender date:[NSDate distantPast]],
//                     [[JSQMessage alloc] initWithText:@"次は神宮司さんからjsonを！" sender:kJSQDemoAvatarNameJobs date:[NSDate date]],
//                     [[JSQMessage alloc] initWithText:@"はよ" sender:kJSQDemoAvatarNameCook date:[NSDate date]],
//                     [[JSQMessage alloc] initWithText:@"遠藤です" sender:self.sender date:[NSDate date]],
                     //test-data2
//                     [[JSQMessage alloc] initWithText:@"Welcome to JSQMessages: A messaging UI framework for iOS." sender:self.sender date:[NSDate distantPast]],
//                     [[JSQMessage alloc] initWithText:@"It is simple, elegant, and easy to use. There are super sweet default settings, but you can customize like crazy." sender:kJSQDemoAvatarNameWoz date:[NSDate distantPast]],
//                     [[JSQMessage alloc] initWithText:@"It even has data detectors. You can call me tonight. My cell number is 123-456-7890. My website is www.hexedbits.com." sender:self.sender date:[NSDate distantPast]],
//                     [[JSQMessage alloc] initWithText:@"JSQMessagesViewController is nearly an exact replica of the iOS Messages App. And perhaps, better." sender:kJSQDemoAvatarNameJobs date:[NSDate date]],
//                     [[JSQMessage alloc] initWithText:@"It is unit-tested, free, and open-source." sender:kJSQDemoAvatarNameCook date:[NSDate date]],
//                     [[JSQMessage alloc] initWithText:@"Oh, and there's sweet documentation." sender:self.sender date:[NSDate date]],
                     nil];
    
    
    
    //①commonAPIからgetMessageArrayで当該タイムライン(個人の場合はaccount_idが等しいもの)のみ抽出
    //②抽出したら以下のself.messagesにメッセージを格納
    //③(次回以降同じメッセージを表示しないよう)格納したらdeleteMessageArrayで当該メッセージオブジェクト自体を削除する
    /*
     ①②③
     ここに書く！！！！！！！！！！！！！！
     */
    //①commonAPIからgetMessageArrayで当該タイムライン(個人の場合はaccount_idが等しいもの)のみ抽出
    NSMutableArray *arrMessage = [[CommonAPI getMessageArray] mutableCopy];
    NSLog(@"arrMessage.count = %d", (int)arrMessage.count);
    for(int i =0;i < arrMessage.count;i++){
        NSLog(@"initializer : %d : %@", i, arrMessage[i]);
        
        //既に格納されているタイムラインユーザーとの照合
        for(int j = 0;j < self.arrTimeLineUsers.count;j++){
            
            if([arrMessage[i][@"account_id"] isEqualToString:self.arrTimeLineUsers[j][@"account_id"] ]){
                //↑正しいか分からない
                NSLog(@"照合！！！！");
                
                //②抽出したら以下のself.messagesにメッセージを格納
                JSQMessage *addMessage =
                [JSQMessage messageWithText:arrMessage[i][@"message"]
                                     sender:arrMessage[i][@"account_id"]];//本当はnameにしたい！！
                [self.messages addObject:addMessage];
                
                
                //③(次回以降同じメッセージを表示しないよう)格納したらdeleteMessageArrayで当該メッセージオブジェクト自体を削除する
                [CommonAPI deleteMessage:i];
            }
        }
    }
    
    
    
    
    
    /**
     *  Create avatar images once.
     *
     *  Be sure to create your avatars one time and reuse them for good performance.
     *
     *  If you are not using avatars, ignore this.
     */
    //自分のアイコンの直径
    CGFloat outgoingDiameter = self.collectionView.collectionViewLayout.outgoingAvatarViewSize.width;
    
    //自分のアイコンイメージ
    UIImage *jsqImage = [JSQMessagesAvatarFactory avatarWithUserInitials:@"JSQ"
                                                         backgroundColor:[UIColor colorWithWhite:0.85f alpha:1.0f]
                                                               textColor:[UIColor colorWithWhite:0.60f alpha:1.0f]
                                                                    font:[UIFont systemFontOfSize:14.0f]
                                                                diameter:outgoingDiameter];
    
    //相手のアイコンの直径
    CGFloat incomingDiameter = self.collectionView.collectionViewLayout.incomingAvatarViewSize.width;
    
    //相手のアイコンイメージ
    UIImage *otherUser = [JSQMessagesAvatarFactory avatarWithImage:[UIImage imageNamed:@"takkun"]
                                                          diameter:incomingDiameter];
    
    
    
//    UIImage *cookImage = [JSQMessagesAvatarFactory avatarWithImage:[UIImage imageNamed:@"jin1"]//demo_avatar_cook"]
//                                                          diameter:incomingDiameter];
//    
//    UIImage *jobsImage = [JSQMessagesAvatarFactory avatarWithImage:[UIImage imageNamed:@"takkun"]//demo_avatar_jobs"]
//                                                          diameter:incomingDiameter];
//    
//    UIImage *wozImage = [JSQMessagesAvatarFactory avatarWithImage:[UIImage imageNamed:@"tanaka"]//demo_avatar_woz"]
//                                                         diameter:incomingDiameter];
    
//    self.avatars = @{ self.sender : jsqImage,
//                      kJSQDemoAvatarNameCook : cookImage,
//                      kJSQDemoAvatarNameJobs : jobsImage,
//                      kJSQDemoAvatarNameWoz : wozImage };
    NSLog(@"相手の人数 = %d", (int)self.arrTimeLineUsers.count);
    NSLog(@"\nselfsender = %@,\n jsqImage = %@,\n selfarrTimeLineUsers[0][accountid]=%@,\n otherUser = %@",
          self.sender,
          jsqImage,
          self.arrTimeLineUsers,//[0][@"account_id"],
//          @"aaa",
          otherUser
          );
    self.avatars = @{self.sender : jsqImage
                     ,self.arrTimeLineUsers[0][@"account_id"] : otherUser
//                     ,self.arrTimeLineUsers[1][@"account_id"] : otherUser
//                     ,...
                     };
    
    
    /**
     *  Change to add more messages for testing
     */
    NSUInteger messagesToAdd = 0;
    NSArray *copyOfMessages = [self.messages copy];
    for (NSUInteger i = 0; i < messagesToAdd; i++) {
        [self.messages addObjectsFromArray:copyOfMessages];
    }
    
    /**
     *  Change to YES to add a super long message for testing
     *  You should see "END" twice
     */
    BOOL addREALLYLongMessage = NO;
    if (addREALLYLongMessage) {
        JSQMessage *reallyLongMessage = [JSQMessage messageWithText:@"Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur? END Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur? END" sender:self.sender];
        [self.messages addObject:reallyLongMessage];
    }
    
    
}


//-(void)sendMessage:(NSString *)strMessage toId:(NSString *)strAccountId{
//    JSQMessage *jsqMessage = [JSQMessage messageWithText:strMessage sender:strAccountId];
//    [self.messages addObject:jsqMessage];
//}



#pragma mark - View lifecycle

/**
 *  Override point for customization.
 *
 *  Customize your view.
 *  Look at the properties on `JSQMessagesViewController` to see what is possible.
 *
 *  Customize your layout.
 *  Look at the properties on `JSQMessagesCollectionViewFlowLayout` to see what is possible.
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"timeLineUsers = %@", self.arrTimeLineUsers);
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"ichat"];
    strDeviceKey = store[@"device_key"];
    store = nil;
    
    self.title = @"base time line";
    
    self.sender = @"myself defined in view didload";
    
//    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"ichat"];
//    
//    NSString *strDeviceKey = store[@"device_key"];
//    NSLog(@"strDeviceKey = %@", strDeviceKey);
    
    [[BSUserManager sharedManager]
     autoSignInWithBlock:^(NSError *error){
         if(error != nil &&
            [error isEqual:[NSNull null]]){
             
             
             NSLog(@"errorが発生しました!");
         }
     }];
    
    //navigationBarのアイテムの編集
//    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 100, 70)];
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(10, 10, 100, 70);
//    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
////    [button setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
//    button.titleLabel.text = @"config";
//    button.titleLabel.textColor = [UIColor blackColor];
//    
////    UIBarButtonItem *item; = [[UIBarButtonItem alloc] initWithCustomView:button];
//
//    
//    UIBarButtonItem *barLeftButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
//    barLeftButtonItem.title = @"config";
////    barLeftButtonItem.tintColor = [UIColor redColor];
//    self.navigationItem.leftBarButtonItem = barLeftButtonItem;
    
    
    [self initialize];
    
    /**
     *  Remove camera button since media messages are not yet implemented
     *
     *   self.inputToolbar.contentView.leftBarButtonItem = nil;
     *
     *  Or, you can set a custom `leftBarButtonItem` and a custom `rightBarButtonItem`
     */
    
    /**
     *  Create bubble images.
     *
     *  Be sure to create your avatars one time and reuse them for good performance.
     *
     */
    self.outgoingBubbleImageView = [JSQMessagesBubbleImageFactory
                                    outgoingMessageBubbleImageViewWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
    
    self.incomingBubbleImageView = [JSQMessagesBubbleImageFactory
                                    incomingMessageBubbleImageViewWithColor:[UIColor jsq_messageBubbleGreenColor]];
    
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"typing"]
                                     style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(receiveMessagePressed:)];

    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                   target:self
                                   action:@selector(back)];
    // Here I think you wanna add the searchButton and not the filterButton..
    self.navigationItem.leftBarButtonItem = backButton;
    
    
    
    NSLog(@"add table");
    
//    //panすると左からスライドするメニュー
//    tableView =
//    [[NameTableView alloc]initWithFrame:
//     CGRectMake(0, 0, self.view.bounds.size.width*3/4, self.view.bounds.size.height)];
//    [tableView.menuView reloadData];
//    [self.view addSubview:tableView];
//    
//    //ジェスチャーをつけるのはself.viewにしてpannedメソッドの中で動かすものだけtableViewにする
    //panGesture or - (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
    UIPanGestureRecognizer *panGesture =
    [[UIPanGestureRecognizer alloc]
     initWithTarget:self action:@selector(panned:)];//動かす対
    [self.view addGestureRecognizer:panGesture];//タッチする対象？
}

-(void)checkMessage:(NSTimer *)timer{
    NSLog(@"checkmessage");
    
//    if(self.strTimeLineId != nil &&
//       [self.strTimeLineId isEqual:[NSNull null]]){
    
    
    
    //20140901:self.strTimeLineIdに現在のタイムラインと異なるidでは受信できないかもしれない
    //→self.strTimeLineIdがnullで受け取るようにする
    [[DataConnect sharedClient]
     receiveMessageToDeviceKey:strDeviceKey
     timeLineId:nil//self.strTimeLineId
     completion:^(NSDictionary *userInfo,
                  NSURLSessionDataTask *task,
                  NSError *error){
         
         NSLog(@"tableview : message = %@", userInfo[@"messages"]);
         
         
             if([userInfo[@"succeed"] integerValue] != 1){
                 NSLog(@"succeed != 1");
                 [self dispSendError:1];
                 return;
             }else {
//                 NSLog(@"receiveMessage : userinfo=%@", userInfo);
                 if(userInfo == nil ||
                    [userInfo isEqual:[NSNull null]]){
                     [self dispSendError:0];
                     return;
                 }else if([userInfo[@"succeed"] intValue] == 1){
//                     NSLog(@"メッセージ受信のためにサーバと通信しました");
                     
//                 {
//                     "succeed": true,
//                     "messages": [
//                          {
//                              "id": "20",
//                              "account_id": "momoca",
//                              "time_line_id": "16",
//                              "message": "Hello, everyone."
//                              "created": "2014-08-10 17:06:26"
//                          }
//                          {
//                              "id": "21",
//                              "account_id": "fasdfa",
//                              "time_line_id": "16",
//                              "message": "testtest"
//                              "created": "2014-08-10 17:06:27"
//                          }
//                    ]
//                 }
                     
                     NSArray *arrMessage = userInfo[@"messages"];
                     for(int i = 0;i < arrMessage.count;i++){
                         NSString *strAccountId = arrMessage[i][@"account_id"];
                         NSLog(@"data = %@", [NSDate date]);
                         
                         
                         JSQMessage *messageReceived =
                         [[JSQMessage alloc]
                          initWithText:arrMessage[i][@"message"]
                          sender:strAccountId
                          date:[NSDate date]];
                         
    //                     [self.messages addObject:messageReceived];
    //                     [self finishSendingMessage];
                         
                         
                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                                      (int64_t)(1.0 * NSEC_PER_SEC)),
                                        dispatch_get_main_queue(), ^{
                             
                            //既存のアバターのキー配列を取得
    //                         NSMutableArray *copyAvatars = [[self.avatars allKeys] mutableCopy];
    //                         [copyAvatars removeObject:self.sender];
    //                         copyMessage.sender = [copyAvatars objectAtIndex:arc4random_uniform((int)[copyAvatars count])];
                             
                             /**
                              *  This you should do upon receiving a message:
                              *
                              *  1. Play sound (optional)
                              *  2. Add new id<JSQMessageData> object to your data source
                              *  3. Call `finishReceivingMessage`
                              */
                             [JSQSystemSoundPlayer jsq_playMessageReceivedSound];
                             [self.messages addObject:messageReceived];
                             [self finishReceivingMessage];
                             NSLog(@"message finished %d", i);
                         });
                     }
                 }
             }
        }];
//    }
}

-(void)back{
    NSLog(@"back");
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)panned:(UIPanGestureRecognizer *)sender{
    NSLog(@"panned %@", [(UIPanGestureRecognizer *)sender view]);
    
    
    
    
    
    return;
    
    //以下テーブルを動かす(今回は必要ない)
//    [self.view bringSubviewToFront:[(UIPanGestureRecognizer*)sender view]];
    [self.view bringSubviewToFront:tableView];//[(UIPanGestureRecognizer *)sender view]];
//    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];
    CGPoint translatedPoint = [(UIPanGestureRecognizer *)sender translationInView:tableView];
    
    if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
//        firstX = [[sender view] center].x;
//        firstY = [[sender view] center].y;
        firstX = tableView.center.x;
        firstY = tableView.center.y;
    }
    
    //横位置動作のみ
//    if(firstX + translatedPoint.x < self.view.center.x/2)
        translatedPoint = CGPointMake(firstX+translatedPoint.x, firstY);
    
//    [[sender view] setCenter:translatedPoint];
    [tableView setCenter:translatedPoint];
    
    if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
//        CGFloat velocityX = (0.2*[(UIPanGestureRecognizer*)sender velocityInView:self.view].x);
        CGFloat velocityX = (0.2*[(UIPanGestureRecognizer *)sender velocityInView:tableView].x);
        
        
        CGFloat finalX = translatedPoint.x + velocityX;
        CGFloat finalY = firstY;// translatedPoint.y + (.35*[(UIPanGestureRecognizer*)sender velocityInView:self.view].y);
        
        if (UIDeviceOrientationIsPortrait([[UIDevice currentDevice] orientation])) {
            if (finalX < 0) {
                //finalX = 0;
            } else if (finalX > 768) {
                //finalX = 768;
            }
            
            if (finalY < 0) {
                finalY = 0;
            } else if (finalY > 1024) {
                finalY = 1024;
            }
        } else {
            if (finalX < 0) {
                //finalX = 0;
            } else if (finalX > 1024) {
                //finalX = 768;
            }
            
            if (finalY < 0) {
                finalY = 0;
            } else if (finalY > 768) {
                finalY = 1024;
            }
        }
        
        CGFloat animationDuration = (ABS(velocityX)*.0002)+.2;
        
        NSLog(@"the duration is: %f", animationDuration);
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidFinish)];
//        [[sender view] setCenter:CGPointMake(finalX, finalY)];
//        if(finalX < self.view.center.x/2){
            [tableView setCenter:CGPointMake(finalX, finalY)];
//        }
        [UIView commitAnimations];
    }
    
    
}

-(void)animationDidFinish{
    NSLog(@"animate finished");
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touches count : %d (touchesMoved:withEvent:)", (int)touches.count);
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.delegateModal) {
        self.navigationItem.leftBarButtonItem =
        [[UIBarButtonItem alloc]
         initWithBarButtonSystemItem:UIBarButtonSystemItemStop
         target:self
         action:@selector(closePressed:)];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    timerConversation = [NSTimer
             scheduledTimerWithTimeInterval:5
             target:self
             selector:@selector(checkMessage:)
             userInfo:nil
             repeats:YES];
    
    
    
    /**
     *  Enable/disable springy bubbles, default is NO.
     *  You must set this from `viewDidAppear:`
     *  Note: this feature is mostly stable, but still experimental
     */
    self.collectionView.collectionViewLayout.springinessEnabled = YES;
}



#pragma mark - Actions

- (void)receiveMessagePressed:(UIBarButtonItem *)sender
{
    /**
     *  The following is simply to simulate received messages for the demo.
     *  Do not actually do this.
     */
    
    
    /**
     *  Set the typing indicator to be shown
     */
    self.showTypingIndicator = !self.showTypingIndicator;
    
    /**
     *  Scroll to actually view the indicator
     */
    [self scrollToBottomAnimated:YES];
    
    
    JSQMessage *copyMessage = [[self.messages lastObject] copy];
    
    if (!copyMessage) {
        return;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSMutableArray *copyAvatars = [[self.avatars allKeys] mutableCopy];
        [copyAvatars removeObject:self.sender];
        copyMessage.sender = [copyAvatars objectAtIndex:arc4random_uniform((int)[copyAvatars count])];
        
        /**
         *  This you should do upon receiving a message:
         *
         *  1. Play sound (optional)
         *  2. Add new id<JSQMessageData> object to your data source
         *  3. Call `finishReceivingMessage`
         */
        [JSQSystemSoundPlayer jsq_playMessageReceivedSound];
        [self.messages addObject:copyMessage];
        [self finishReceivingMessage];
    });
}

- (void)closePressed:(UIBarButtonItem *)sender
{
    [self.delegateModal didDismissJSQDemoViewController:self];
}




#pragma mark - JSQMessagesViewController method overrides

- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                    sender:(NSString *)sender
                      date:(NSDate *)date
{
    /**
     *  Sending a message. Your implementation of this method should do *at least* the following:
     *
     *  1. Play sound (optional)
     *  2. Add new id<JSQMessageData> object to your data source
     *  3. Call `finishSendingMessage`
     */
    
    NSLog(@"didPressSendButton");
    
    [JSQSystemSoundPlayer jsq_playMessageSentSound];
    JSQMessage *message = [[JSQMessage alloc] initWithText:text sender:sender date:date];
    
    
//    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"ichat"];
//    NSString *strDeviceKey = store[@"device_key"];
//    store = nil;
    
    //送り先配列の作成
    NSMutableArray *arrUserIdToSend = [NSMutableArray array];
    for(id userInfo in self.arrTimeLineUsers){
        [arrUserIdToSend addObject:userInfo[@"account_id"]];
    }
    
    NSLog(@"deviceId:%@からtimielineid:%@でmember:%@にメッセージ%@を送信します",
          strDeviceKey, self.strTimeLineId, arrUserIdToSend, text);
    
    [[DataConnect sharedClient]
     sendMessage:text
     deviceKey:strDeviceKey
     timeLineId:self.strTimeLineId
//     members:(NSArray *)[NSArray arrayWithObjects:@"taro", @"jiro", nil]
     members:arrUserIdToSend
     completion:^(NSDictionary *userInfo,
                  NSURLSessionDataTask *task,
                  NSError *error){
         
         /*
          //timelineidが見つからない場合
          userinfo={
          message = "not found current account id";
          succeed = 0;
          }
          
          //成功した場合
         succeed = 1;
         "time_line" =     {
             "host_id" = 107;
             id = 16;
             members =         (
                                {
                                    "account_id" = jiro;
                                    id = 84;
                                    name = JIRO;
                                },
                                {
                                    "account_id" = taro;
                                    id = 85;
                                    name = TARO;
                                }
                                );
             name = "JIRO, TARO";
         };
     }
     */

         
         
         
         NSLog(@"userinfo=%@", userInfo);
         if(userInfo == nil ||
            [userInfo isEqual:[NSNull null]]){
             [self dispSendError:0];
             return;
         }else if([userInfo[@"succeed"] intValue] == 1){
//             data-architecture
//             {
//                 "succeed": true,
//                 "time_line": {
//                     "id": "15",
//                     "host_id": "95",
//                     "name": "JIRO, TARO",
//                     "members": [
//                         {
//                             "account_id": "jiro",
//                             "name": "JIRO",
//                             "id": "84"
//                         },
//                         {
//                             "account_id": "taro",
//                             "name": "TARO",
//                             "id": "85"
//                         }
//                         ]
//                 }
//             }
             
             //問題は
             //Idが発行されてないタイムラインで新規投稿した場合、受信側はそのメッセージが受信されない
             //receivemessageで受信されない原因はaccount_idではなくタイムラインidでしか共有できていないため？
             
             //apiの仕様上の問題(お互いのタイムライン開いている時のtimelineid二重発行問題)はネイティブで解決
             //apiで問題になっているところ
             //1:投げたポストが受け取り側に送られていない(クリティカル)
             //→ポストが投げられたタイムラインidをsequelで確認：送り先のaccount_id(は見えないがnameが正しい)を確認
             //postが投げられたタイムラインは存在するが、メッセージの送信場所がstreamになっていることを確認すべき
             //→確認できたが、送り先(receiver_id=92)が自分なのかどうかが不明
             //→receiver_id＝９２が自分なのかどうか確認すべき=>apiから当該数値idが与えられていない。
             //いっせいさんに言ってreceiver_idではなくaccount_idで表示してもらう対応策、もしくはcreateUserでreceiver_idを受け取るよう対応してもらうのいずれか必要
             //simulatoracのreceiver_id=９２が正しいとして、メッセージを受け取れているか確認する
             //messages/streamで受け取れているか確認：このapiは(B端末ではタイムラインidが取得できていないので無指定)device_keyのみでキックしているが、ここで受け取れているか
             //messages/streamをするとネイティブ上ではメッセージが受け取れていない(message.count=0)が、DB上ではis_streamedが１になってしまっている
             
             
             
             //2:timelineの見方が不明なのだが、name欄に送信側と受信側のnameが表示されていない(現状送り手のみ表示されてる)のは問題なのか確認
             
             //timeLineIdが未発行の場合はデバイスに新規に保存させる必要がある！
             //その場合、ここまでuserInfo[account_id, name, timeLineId]のtimeLineIdは未作成
             //以下、グループチャットの場合は別に作成する必要がある(新規グループの場合はどんな変数が渡されてTL画面に遷移しているか未決定)かによって別途対応必要
             //個人チャットの場合
             if(self.arrTimeLineUsers.count == 1){
                 //null判定しなくていいかも
                 if(self.strTimeLineId == nil ||
                    [self.strTimeLineId isEqual:[NSNull null]]){
                     //初回ポストの場合、timelineid
                     NSLog(@"初回ポストにつき、timelineidを保存開始");
                     
                     //このvc内でのタイムラインidを保存
                     self.strTimeLineId = userInfo[@"time_line"][@"id"];
                     
                     //
    //                 NSMutableDictionary *userInfo = [CommonAPI getIdArray];
//                     NSMutableDictionary *userInfoInTimeLine = [self.arrTimeLineUsers[0] mutableCopy];
//                     userInfoInTimeLine[@"timeLineId"] = userInfo[@"time_line"][@"id"];
                     
                     //個人ユーザー情報(にtimeLineIdを紐づけてやる)の取得
                     NSString *strAccountId = self.arrTimeLineUsers[0][@"account_id"];//その人個人とのtimeLineIdをデバイスに保存
                     //デバイスに保存(既存のユーザー情報を編集してtimelineidを保存)
                     if([CommonAPI modifyTimeLineId:self.strTimeLineId
                                           toUserId:strAccountId]){
                         NSLog(@"タイムラインidの保存成功 : %@", self.strTimeLineId);
                     }else{
                         NSLog(@"タイムラインidの保存失敗 : %@", self.strTimeLineId);
                     }
                 }else{
                     NSLog(@"初回ポストではないのでtimelineidを保存しない : %@", self.strTimeLineId);
                 }
             }
             NSLog(@"userinfo[succeed]=%d", [userInfo[@"succeed"] intValue]);
             [SVProgressHUD showSuccessWithStatus:@"送信しました!"];
             [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@", userInfo]];
             NSLog(@"userinfo = %@", userInfo);
             [self.messages addObject:message];
             [self finishSendingMessage];
         }else{
             [self dispSendError:1];
         }
     }];
    
}

-(void)dispSendError:(int)errorNo{
    /**
     **エラーコード
     *0:インターネット通信はあるけどサーバーから返ってきた値がsucceedが０だった場合
     *1:インターネット通信がない場合
     */
    if(errorNo == 0){
        [SVProgressHUD showSuccessWithStatus:
         [NSString stringWithFormat:@"メッセージの送信に失敗しました。\nerrorcode=%d", errorNo]];
    }else if(errorNo == 1){
        [SVProgressHUD showSuccessWithStatus:
         [NSString stringWithFormat:@"サーバーとの通信に失敗しました。\nerrorcode=%d", errorNo]];
    }
}

- (void)didPressAccessoryButton:(UIButton *)sender
{
    NSLog(@"Camera pressed!");
    /**
     *  Accessory button has no default functionality, yet.
     */
}



#pragma mark - JSQMessages CollectionView DataSource

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.messages objectAtIndex:indexPath.item];
}

- (UIImageView *)collectionView:(JSQMessagesCollectionView *)collectionView bubbleImageViewForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  You may return nil here if you do not want bubbles.
     *  In this case, you should set the background color of your collection view cell's textView.
     */
    
    /**
     *  Reuse created bubble images, but create new imageView to add to each cell
     *  Otherwise, each cell would be referencing the same imageView and bubbles would disappear from cells
     */
    
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    
    if ([message.sender isEqualToString:self.sender]) {
        return [[UIImageView alloc] initWithImage:self.outgoingBubbleImageView.image
                                 highlightedImage:self.outgoingBubbleImageView.highlightedImage];
    }
    
    return [[UIImageView alloc] initWithImage:self.incomingBubbleImageView.image
                             highlightedImage:self.incomingBubbleImageView.highlightedImage];
}

- (UIImageView *)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageViewForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     
     *  Return `nil` here if you do not want avatars.
     *  If you do return `nil`, be sure to do the following in `viewDidLoad`:
     *
     *  self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
     *  self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
     *
     *  It is possible to have only outgoing avatars or only incoming avatars, too.
     */
    
    /**
     *  Reuse created avatar images, but create new imageView to add to each cell
     *  Otherwise, each cell would be referencing the same imageView and avatars would disappear from cells
     *
     *  Note: these images will be sized according to these values:
     *
     *  self.collectionView.collectionViewLayout.incomingAvatarViewSize
     *  self.collectionView.collectionViewLayout.outgoingAvatarViewSize
     *
     *  Override the defaults in `viewDidLoad`
     */
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    
    UIImage *avatarImage = [self.avatars objectForKey:message.sender];
    return [[UIImageView alloc] initWithImage:avatarImage];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  This logic should be consistent with what you return from `heightForCellTopLabelAtIndexPath:`
     *  The other label text delegate methods should follow a similar pattern.
     *
     *  Show a timestamp for every 3rd message
     */
    if (indexPath.item % 3 == 0) {
        JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
        return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
    }
    
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    
    /**
     *  iOS7-style sender name labels
     */
    if ([message.sender isEqualToString:self.sender]) {
        return nil;
    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self.messages objectAtIndex:indexPath.item - 1];
        if ([[previousMessage sender] isEqualToString:message.sender]) {
            return nil;
        }
    }
    
    /**
     *  Don't specify attributes to use the defaults.
     */
    return [[NSAttributedString alloc] initWithString:message.sender];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.messages count];
}

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Override point for customizing cells
     */
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    /**
     *  Configure almost *anything* on the cell
     *  
     *  Text colors, label text, label colors, etc.
     *
     *
     *  DO NOT set `cell.textView.font` !
     *  Instead, you need to set `self.collectionView.collectionViewLayout.messageBubbleFont` to the font you want in `viewDidLoad`
     *
     *  
     *  DO NOT manipulate cell layout information!
     *  Instead, override the properties you want on `self.collectionView.collectionViewLayout` from `viewDidLoad`
     */
    
    JSQMessage *msg = [self.messages objectAtIndex:indexPath.item];
    
    if ([msg.sender isEqualToString:self.sender]) {
        cell.textView.textColor = [UIColor blackColor];
    }
    else {
        cell.textView.textColor = [UIColor whiteColor];
    }
    
    cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                          NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    
    return cell;
}



#pragma mark - JSQMessages collection view flow layout delegate

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Each label in a cell has a `height` delegate method that corresponds to its text dataSource method
     */
    
    /**
     *  This logic should be consistent with what you return from `attributedTextForCellTopLabelAtIndexPath:`
     *  The other label height delegate methods should follow similarly
     *
     *  Show a timestamp for every 3rd message
     */
    if (indexPath.item % 3 == 0) {
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    
    return 0.0f;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  iOS7-style sender name labels
     */
    JSQMessage *currentMessage = [self.messages objectAtIndex:indexPath.item];
    if ([[currentMessage sender] isEqualToString:self.sender]) {
        return 0.0f;
    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self.messages objectAtIndex:indexPath.item - 1];
        if ([[previousMessage sender] isEqualToString:[currentMessage sender]]) {
            return 0.0f;
        }
    }
    
    return kJSQMessagesCollectionViewCellLabelHeightDefault;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return 0.0f;
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView
                header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender
{
    NSLog(@"Load earlier messages!");
}

-(void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"aaa");
}

-(void)collectionView:(JSQMessagesCollectionView *)collectionView didTapAvatarImageView:(UIImageView *)avatarImageView atIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"tapped avatar imageView");
    
    [self pushedPerson:[NSString stringWithFormat:@"person %d", indexPath.row]];
}

-(void)pushedPerson:(NSString *)name{
    PersonViewController *vc = [[PersonViewController alloc]init];
    vc.title = name;//navigationControllerにはデフォルトでtitleフィールドが存在する
    [self.navigationController pushViewController:vc animated:YES];
}


@end
