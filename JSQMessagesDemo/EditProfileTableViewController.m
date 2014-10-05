//
//  EditProfileTableViewController.m
//  JSQMessages
//
//  Created by EndoTsuyoshi on 2014/08/16.
//  Copyright (c) 2014年 Hexed Bits. All rights reserved.
//

#import "EditProfileTableViewController.h"
#import "PlaceHolderTextView.h"


#define HEIGHT_ORDINARY_CELL 40

@interface EditProfileTableViewController ()

@end

@implementation EditProfileTableViewController{
    NSString *accountId;
    NSString *name;
    NSString *deviceKey;
    
    //indexPath.section=0
    UITextField *tfName;
    UITextField *tfAccountId;
    
    //indexPath.section=1
    UIButton *btnGender;
    UIButton *btnAddress;
    NSArray *arrStrGender;//性別：女性・男性
    int intGender;//0:女性・1:男性
    NSArray *arrColorGender;
//    UITextView *tvIntro;
    PlaceHolderTextView *tvIntro;
    
    
    UITableView *mainTableView;
}

//- (id)initWithStyle:(UITableViewStyle)style
//{
//    self = [super initWithStyle:style];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"ichat"];
    self.title =
    @"設定";
//    [NSString stringWithFormat:@"設定(%@)",
//     store[@"device_key"]];
    
    
    
    //各種設定
    arrStrGender = [NSArray arrayWithObjects:@"女性", @"男性", nil];
    arrColorGender = [NSArray arrayWithObjects:
                      [UIColor redColor],
                      [UIColor blueColor],
                      nil];
    intGender = 0;//本来的にはuickeychainstoreから取得する
    
    
    NSLog(@"viewdidload at editprodileViewCon : key = %@",
          [UICKeyChainStore keyChainStoreWithService:@"ichat"]);
    
    //saveButton
//    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
//                                   initWithBarButtonSystemItem:UIBarButtonSystemItemSave
//                                   target:self
//                                   action:@selector(save)];
//    // Here I think you wanna add the searchButton and not the filterButton..
//    self.navigationItem.rightBarButtonItem = saveButton;
    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
//    
//    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"ichat"];
////    NSLog(@"store = %@", store);
//    
//    accountId = store[@"account_id"];
//    name = store[@"name"];
//    deviceKey = store[@"device_key"];
//    
//    NSLog(@"accountId = %@\nname = %@\ndeviceKey = %@",
//          accountId, name, deviceKey);
    
//    self.title = store[@"]
    
    mainTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    mainTableView.tableHeaderView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"panda"]];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
//    mainTableView.userInteractionEnabled = NO;//これをやるとサブビューの挙動も抑制されてしまう
//    mainTableView.separatorColor = [UIColor clearColor];
    mainTableView.alwaysBounceVertical = YES;
//    mainTableView.contentSize =
//    CGSizeMake(self.view.bounds.size.width,
//               self.view.bounds.size.height*2);
    [mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CellIdentifier"];
    
    [self.view addSubview:mainTableView];
    
    
    store = nil;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [mainTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)save{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
//    return 1;
    if(section == 0){
        return 2;//account_name,account_id
    }else{
        return 3;
    }
}

//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return
//    (section == 0)?
//    [NSString stringWithFormat:@"アカウント名:"]:
//    [NSString stringWithFormat:@"アカウントID:"];
//}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    return nil;
    if(section == 0){
//        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
//        header.backgroundColor = [UIColor redColor];
//        return header;
//    }else{
//        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 10)];
//        header.backgroundColor = [UIColor yellowColor];
//        return header;
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 10)];
        headerView.backgroundColor = [UIColor grayColor];
        return headerView;
    }else{
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 10)];
        headerView.backgroundColor = [UIColor grayColor];
        return headerView;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    //textFieldの下にラインを入れる
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 2)];
//    view.backgroundColor = [UIColor grayColor];
//    return view;
    return nil;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        //account_idとaccount_nameの両方
        return HEIGHT_ORDINARY_CELL;
    }else if(indexPath.section == 1){
        if(indexPath.section == 1){
            if(indexPath.row == 0){//性別入力
                return HEIGHT_ORDINARY_CELL;
            }
            if(indexPath.row == 1){//自己紹介
                return HEIGHT_ORDINARY_CELL*3;//３行まで入力させる
            }
        }
    }
    
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section ==0){
        return 2;
    }else{
        return 2;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
//    if(section == 0 || section == 1){
//        return 1;
//    }else{
//        return 100;
//    }
    
    
    
    
//    if(section == 0){
//        return 10;
//    }else{
//        return 50;
//    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 2){//button
        //戻るボタンで一旦保存する
//        [self saveInfo];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =
    [tableView
     dequeueReusableCellWithIdentifier:@"CellIdentifier"
     forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//タップしても反応しないようにする
    
    //ツールバーを生成
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    //スタイルの設定
    toolBar.barStyle = UIBarStyleDefault;
    //ツールバーを画面サイズに合わせる
    [toolBar sizeToFit];
    // 「完了」ボタンを右端に配置したいためフレキシブルなスペースを作成する。
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    //　完了ボタンの生成
    UIBarButtonItem *_commitBtn =
    [[UIBarButtonItem alloc]
     initWithTitle:@"次へ"
     style:UIBarButtonItemStylePlain
     target:self action:@selector(nextTextFieldActivate:)];
    _commitBtn.tag = [[NSString stringWithFormat:@"%d%d", (int)indexPath.section, (int)indexPath.row] integerValue];
    // ボタンをToolbarに設定
    NSArray *toolBarItems = [NSArray arrayWithObjects:spacer, _commitBtn, nil];
    // 表示・非表示の設定
    [toolBar setItems:toolBarItems animated:YES];
    
    cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
    
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"ichat"];
    
    
    if(indexPath.section == 0){
        
        if(indexPath.row == 0){
            tfName = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 200, cell.bounds.size.height)];
            [cell.contentView addSubview:tfName];
            
            
            
            tfName.delegate = self;
            tfName.placeholder = store[@"name"];
            NSLog(@"placeholder(%d) = %@", (int)indexPath.section, tfName.placeholder);
            tfName.tag = indexPath.section;
            tfName.inputAccessoryView = toolBar;
            
            
            
            cell.accessoryView = tfName;
            cell.textLabel.text = @"アカウント名";
            
//            tfName = nil;
        
        }else if(indexPath.row == 1){
            tfAccountId = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, cell.bounds.size.height)];
            [cell.contentView addSubview:tfAccountId];
            
            
            
            tfAccountId.delegate = self;
            tfAccountId.placeholder = store[@"account_id"];
            NSLog(@"placeholder(%d) = %@", (int)indexPath.section, tfAccountId.placeholder);
            tfAccountId.tag = indexPath.section;
            tfAccountId.inputAccessoryView = toolBar;
            
            
            
            cell.accessoryView = tfAccountId;
            cell.textLabel.text = @"アカウントID";
            
//            tfAccountId = nil;
        }
        
        store = nil;
        return cell;
    }
    
    if(indexPath.section == 1){
        if(indexPath.row == 0){
            //性別
            btnGender = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 120, 30)];
            btnGender.center = CGPointMake(self.view.bounds.size.width/2,
                                           HEIGHT_ORDINARY_CELL/2);
            btnGender.backgroundColor = [UIColor whiteColor];
            btnGender.layer.borderWidth = 2.0f;
            btnGender.layer.borderColor =
            [(UIColor *)arrColorGender[intGender] CGColor];//[[UIColor redColor] CGColor];
            btnGender.layer.cornerRadius = 10.0f;
    //        [btnGender setTitle:arrGender[intGender] forState:UIControlStateNormal];
            [btnGender setTitle:arrStrGender[intGender] forState:UIControlStateNormal];
            [btnGender setTitleColor:arrColorGender[intGender] forState:UIControlStateNormal];
            [btnGender addTarget:self action:@selector(tapBtnGenderChange:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:btnGender];
            
            
            
        }else if(indexPath.row == 1){
            //自己紹介
//            tvIntro = [[UITextView alloc]
//                       initWithFrame:
//                       CGRectMake(10, 0, self.view.bounds.size.width-20,
//                                  HEIGHT_ORDINARY_CELL*3)];
//            tvIntro.userInteractionEnabled = YES;
//            tvIntro.editable = YES;
//            tvIntro.delegate = self;
//            tvIntro.inputAccessoryView = toolBar;
//
////        textContainer:<#(NSTextContainer *)#>
//            [cell.contentView addSubview:tvIntro];
            tvIntro = [[PlaceHolderTextView alloc]
                       initWithFrame:CGRectMake(10, 0, self.view.bounds.size.width-20,
                                                HEIGHT_ORDINARY_CELL*3)];
            tvIntro.placeholder         = @"自己紹介文を入力してください";
            tvIntro.placeholderColor = [UIColor grayColor];
            tvIntro.userInteractionEnabled = YES;
            tvIntro.editable = YES;
            tvIntro.delegate = self;
            tvIntro.inputAccessoryView = toolBar;
            
            [cell.contentView addSubview:tvIntro];
            
        }
        return cell;
    }
    
    if(indexPath.section == 2){
//        UIButton *useButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        useButton.titleLabel.text = @"使用可能か確認";
//        [useButton sizeToFit];
//        useButton.titleLabel.textColor = [UIColor whiteColor];
//        useButton.center = cell.center;
//        useButton.backgroundColor = [UIColor grayColor];
//        [useButton addTarget:self action:@selector(saveInfo)
//            forControlEvents:UIControlEventTouchUpInside];
//        [cell.contentView addSubview:useButton];
        
        cell.textLabel.text = @"変更を反映する";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor blackColor];
        
        store = nil;
        return  cell;
    }
    
    // Configure the cell...
    
    return nil;
}

-(void)saveInfo{
    NSLog(@"saveinfo");
    
    [self.view endEditing:YES];
    
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"ichat"];
    //testのためコメントアウト
    NSLog(@"tfName=%@, keychain=%@",
          tfName.text,
          store[@"name"]);
    NSLog(@"tfAccountId=%@, keychain=%@",
          tfAccountId.text,
          store[@"account_id"]);
    
    //両方が既に保存されているものと同じかもしくはnullかどうか判定
    if((
       tfName.text == nil || [tfName.text isEqual:[NSNull null]] ||
       [tfName.text isEqualToString:@""] ||
       [tfName.text isEqualToString:store[@"name"]])
       
       &&(
       tfAccountId.text == nil || [tfAccountId.text isEqual:[NSNull null]] ||
       [tfAccountId.text isEqualToString:@""] ||
       [tfAccountId.text isEqualToString:store[@"account_id"]])
       ){
//        [self dispError:@"既に保存されているアカウント名、IDと同じです"];
        return;
    }
    
    if([tfName.text isEqualToString:@""]){
        tfName.text = store[@"name"];
    }
    if([tfAccountId.text isEqualToString:@""]){
        tfAccountId.text = store[@"account_id"];
    }
    
    [[DataConnect sharedClient]
     updateUsersWithDeviceKey:store[@"device_key"]
     accountId:tfAccountId.text
     name:tfName.text
    completion:^(NSDictionary *userInfo,
                  NSURLSessionDataTask *task,
                  NSError *error){
        if(userInfo == nil || [userInfo isEqual:[NSNull null]]){
            NSLog(@"save error : null");
            [self dispError:[NSString stringWithFormat:@"%@", error]];//ちゃんとエラーメッセージが返せるように変更しなくてはいけない
            return ;
        }else if([userInfo[@"succeed"] intValue] == 1){
            NSLog(@"succeed userinfo=%@",userInfo);
            
            
//            UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"ichat"];
//            [[UICKeyChainStore keyChainStoreWithService:@"ichat"]
            [store
             setString:userInfo[@"user"][@"account_id"]
             forKey:@"account_id"];
            [store synchronize];
            NSLog(@"set accountid = %@", store[@"account_id"]);
            
//            [[UICKeyChainStore keyChainStoreWithService:@"ichat"]
            [store
             setString:userInfo[@"user"][@"name"]
             forKey:@"name"];
            [store synchronize];
            NSLog(@"set name = %@", store[@"name"]);
            
            NSLog(@"complete1");
            [SVProgressHUD showSuccessWithStatus:@"更新成功しました!"];
            
            NSLog(@"complete = %@" , store);
            //store = nil;
            return;
        }else if([userInfo[@"succeed"] intValue] == 0){
            
            NSLog(@"failed 0");
            return;
        }
        NSLog(@"userinfo=%@", userInfo);
        
        
     }];
}

/*
 [store setString:userInfo[@"user"][@"account_id"]
 forKey:@"account_id"];
 [store setString:userInfo[@"user"][@"name"]
 forKey:@"name"];
 */

-(void)dispError:(NSString *) errorContents{
    NSLog(@"disperror");
    [SVProgressHUD showErrorWithStatus:
     [NSString stringWithFormat:@"%@", errorContents]];
}

-(void)nextTextFieldActivate:(id)sender{
    
    //sender.tag=(sectionNo)&(rowNo)
    NSLog(@"nexttextfieldactivate %d", (int)((UITextField *)sender).tag);
    NSLog(@"sender class = %@", [sender class]);
    
    
    if([sender isKindOfClass:[UIBarButtonItem class]]){
        if(((UIBarButtonItem *)sender).tag == 0){//section=0,row=0

    //    if(sender == tfName){
            [tfAccountId becomeFirstResponder];
            
        }else if(((UIBarButtonItem *)sender).tag == 1){//section=0,row=1
            NSLog(@"bbb");
            //全てのキーボードを非表示にする
    //        [self.view endEditing:YES];//効かない？
            [tfAccountId resignFirstResponder];
        }else if(((UIBarButtonItem *)sender).tag == 10){//section=1,row=0
            NSLog(@"意図しない番号");
        }else if(((UIBarButtonItem *)sender).tag == 11){//section=1,row=1
            NSLog(@"tapped textView");
            
            [tvIntro resignFirstResponder];
        }else{
            NSLog(@"else tag = %d", (int)[sender tag]);
        }
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)tapBtnGenderChange:(id)sender{
    NSLog(@"tapped button gender change : %@", sender);
    
    [self changeGenderBtnStatus];
}

-(void)changeGenderBtnStatus{
    
    intGender += 1;
    intGender %= 2;
    btnGender.layer.borderColor =
    [(UIColor *)arrColorGender[intGender] CGColor];//[[UIColor redColor] CGColor];
    btnGender.layer.cornerRadius = 10.0f;
    //        [btnGender setTitle:arrGender[intGender] forState:UIControlStateNormal];
    [btnGender setTitle:arrStrGender[intGender] forState:UIControlStateNormal];
    [btnGender setTitleColor:arrColorGender[intGender] forState:UIControlStateNormal];
}

//uitextView delegate method
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    CGPoint pt;
    CGRect rc = [textField bounds];
    rc = [textField convertRect:rc toView:mainTableView];
    pt = rc.origin;
    pt.x = 0;
    pt.y -= 60;
    
    //    [scrollView setContentOffset:pt animated:YES];
    [mainTableView setContentOffset:pt animated:YES];
    
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
//    NSLog(@"textViewDidBeginEditing %@", textView);
//    
//    CGPoint pnt = [mainTableView convertPoint:textView.bounds.origin fromView:mainTableView];
//    NSLog(@"pnt = %f, %f", pnt.x, pnt.y);
//    NSIndexPath* path = [mainTableView indexPathForRowAtPoint:pnt];
//    NSLog(@"path = %@", path);
//    [mainTableView
//     scrollToRowAtIndexPath:path
//     atScrollPosition:UITableViewScrollPositionTop
//     animated:YES];
    
    
    
    CGPoint pt;
    CGRect rc = [textView bounds];
    //    rc = [textView convertRect:rc toView:scrollView];
    rc = [textView convertRect:rc toView:mainTableView];
    pt = rc.origin;
    pt.x = 0;
    pt.y -= 60;
    
    //    [scrollView setContentOffset:pt animated:YES];
    [mainTableView setContentOffset:pt animated:YES];

    
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
}


//http://qiita.com/yimajo/items/d9409d83fecf9875061d
//追加もしくは削除された後に動作する
- (void)didMoveToParentViewController:(UIViewController *)parent{
    if (![parent isEqual:self.parentViewController]) {
        NSLog(@"back");
        
        
//        UITextField *tfName;
//        UITextField *tfAccountId;
//        
//        //indexPath.section=1
//        UIButton *btnGender;
//        UIButton *btnAddress;
//        NSArray *arrStrGender;//性別：女性・男性
//        int intGender;//0:女性・1:男性
//        NSArray *arrColorGender;
//        UITextView *tvIntro;
        
        NSLog(@"tfName = %@", tfName);
        NSLog(@"tfAccountId = %@", tfAccountId);
        NSLog(@"btnGender = %@", btnGender);
        NSLog(@"tvIntro = %@", tvIntro);
        
        //メソッド内部で入力済みかどうか確認している：性別と自己紹介文はapi未対応
        [self saveInfo];//まだnameとaccountIdのみしか入力できない
        
    }
}

@end
