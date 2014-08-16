//
//  EditProfileTableViewController.m
//  JSQMessages
//
//  Created by EndoTsuyoshi on 2014/08/16.
//  Copyright (c) 2014年 Hexed Bits. All rights reserved.
//

#import "EditProfileTableViewController.h"

@interface EditProfileTableViewController ()

@end

@implementation EditProfileTableViewController{
    NSString *accountId;
    NSString *name;
    NSString *deviceKey;
    
    UITextField *tfName;
    UITextField *tfAccountId;
    
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"設定";
    
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
    
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"ichat"];
//    NSLog(@"store = %@", store);
    
    accountId = store[@"account_id"];
    name = store[@"name"];
    deviceKey = store[@"device_key"];
    
    NSLog(@"accountId = %@\nname = %@\ndeviceKey = %@",
          accountId, name, deviceKey);
    
//    self.title = store[@"]
    
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.alwaysBounceVertical = NO;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CellIdentifier"];
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.tableView reloadData];
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 1;
}

//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    return
//    (section == 0)?
//    [NSString stringWithFormat:@"アカウント名:"]:
//    [NSString stringWithFormat:@"アカウントID:"];
//}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
//    if(section == 0){
//        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
//        header.backgroundColor = [UIColor redColor];
//        return header;
//    }else{
//        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 10)];
//        header.backgroundColor = [UIColor redColor];
//        return header;
//    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    //textFieldの下にラインを入れる
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 2)];
//    view.backgroundColor = [UIColor grayColor];
//    return view;
    return nil;

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section ==0){
        return 50;
    }else{
        return 10;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 0 || section == 1){
        return 1;
    }else{
        return 100;
    }
//    if(section == 0){
//        return 10;
//    }else{
//        return 50;
//    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 2){//button
        NSLog(@"aaa");
        
        [self saveInfo];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =
    [tableView
     dequeueReusableCellWithIdentifier:@"CellIdentifier"
     forIndexPath:indexPath];
    
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
    _commitBtn.tag = indexPath.row;
    // ボタンをToolbarに設定
    NSArray *toolBarItems = [NSArray arrayWithObjects:spacer, _commitBtn, nil];
    // 表示・非表示の設定
    [toolBar setItems:toolBarItems animated:YES];
    
    cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
    
    
    
    
    if(indexPath.section == 0){
        tfName = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 200, cell.bounds.size.height)];
        [cell.contentView addSubview:tfName];
        
        
        
        tfName.delegate = self;
        tfName.placeholder = [UICKeyChainStore keyChainStoreWithService:@"ichat"][@"name"];
        tfName.tag = indexPath.section;
        tfName.inputAccessoryView = toolBar;
        
        
        
        cell.accessoryView = tfName;
        cell.textLabel.text = @"アカウント名";
        
        
        return cell;
    }
    
    if(indexPath.section == 1){
        tfAccountId = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, cell.bounds.size.height)];
        [cell.contentView addSubview:tfAccountId];
        
        
        
        tfAccountId.delegate = self;
        tfAccountId.placeholder = [UICKeyChainStore keyChainStoreWithService:@"ichat"][@"account_id"];
        tfAccountId.tag = indexPath.section;
        tfAccountId.inputAccessoryView = toolBar;
        
        
        
        cell.accessoryView = tfAccountId;
        cell.textLabel.text = @"アカウントID";
        
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
        
        cell.textLabel.text = @"使用可能かどうか判定";
        cell.textLabel.textColor = [UIColor blackColor];
        return  cell;
    }
    
    // Configure the cell...
    
    return nil;
}

-(void)saveInfo{
    NSLog(@"saveinfo");
    
    [self.view endEditing:YES];
    
    NSLog(@"tfName=%@, keychain=%@",
          tfName.text,
          [UICKeyChainStore keyChainStoreWithService:@"ichat"][@"name"]);
    //既に保存されているものと同じかどうか判定もしくはnull
    if(tfName.text == nil || [tfName.text isEqual:[NSNull null]] ||
       [tfName.text isEqualToString:@""] ||
       [tfName.text isEqualToString:[UICKeyChainStore keyChainStoreWithService:@"ichat"][@"name"]]){
        [self dispError:@"既に保存されているアカウント名と同じです"];
        return;
    }
    
    
    NSLog(@"tfAccountId=%@, keychain=%@",
          tfAccountId.text,
          [UICKeyChainStore keyChainStoreWithService:@"ichat"][@"account_id"]);
    if(tfAccountId.text == nil || [tfAccountId.text isEqual:[NSNull null]] ||
       [tfAccountId.text isEqualToString:@""] ||
       [tfAccountId.text isEqualToString:[UICKeyChainStore keyChainStoreWithService:@"ichat"][@"account_id"]]){
        [self dispError:@"既に保存されているアカウントIDと同じです"];
        return;
    }
    
    [[DataConnect sharedClient]
     updateUsersWithDeviceKey:[UICKeyChainStore keyChainStoreWithService:@"ichat"][@"device_key"]
     accountId:tfAccountId.text//[UICKeyChainStore keyChainStoreWithService:@"ichat"][@"account_id"]
     name:tfName.text//[UICKeyChainStore keyChainStoreWithService:@"ichat"][@"name"]
    completion:^(NSDictionary *userInfo,
                  NSURLSessionDataTask *task,
                  NSError *error){
        if(userInfo == nil || [userInfo isEqual:[NSNull null]]){
            NSLog(@"save error : null");
            return ;
        }else if([userInfo[@"succeed"] intValue] == 1){
            NSLog(@"succeed userinfo=%@",userInfo);
            
            
            UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"ichat"];
//            [[UICKeyChainStore keyChainStoreWithService:@"ichat"]
            [store
             setString:userInfo[@"user"][@"account_id"]
             forKey:@"account_id"];
            
//            [[UICKeyChainStore keyChainStoreWithService:@"ichat"]
            [store
             setString:userInfo[@"user"][@"name"]
             forKey:@"name"];
            
            
//            [SVProgressHUD showSuccessWithStatus:userInfo[@"user"]];
            
            
            
            //なぜか反映されていない！！！！！！！！！！！！！！！！！！！！！！！
            NSLog(@"complete = %@" , [UICKeyChainStore keyChainStoreWithService:@"ichat"]);
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
    [SVProgressHUD showSuccessWithStatus:
     [NSString stringWithFormat:@"%@", errorContents]];
}

-(void)nextTextFieldActivate:(id)sender{
    NSLog(@"nexttextfieldactivate %d", ((UITextField *)sender).tag);
    if(((UITextField *)sender).tag == 0){
        [tfAccountId becomeFirstResponder];
    }else if(((UITextField *)sender).tag == 1){
        //全てのキーボードを非表示にする
//        [self.view endEditing:YES];//効かない？
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

@end
