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

#import <UIKit/UIKit.h>

#import "JSQDemoViewController.h"
#import "JSQDemo2ViewController.h"
#import "JSQSelectIdTableViewCell.h"

@interface JSQTableViewController : UIViewController
//UITableViewController
<
JSQDemoViewControllerDelegate
, UITextFieldDelegate
, UITableViewDelegate
, UITableViewDataSource
>

@property (nonatomic, weak) NSTimer *timer;

- (IBAction)unwindSegue:(UIStoryboardSegue *)sender;

@end
