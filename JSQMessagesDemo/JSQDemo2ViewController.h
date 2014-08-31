//
//  JSQDemo2ViewController.h
//  JSQMessages
//
//  Created by EndoTsuyoshi on 2014/08/28.
//  Copyright (c) 2014年 Hexed Bits. All rights reserved.
//
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

#import "JSQMessages.h"

@class JSQDemo2ViewController;


@protocol JSQDemo2ViewControllerDelegate <NSObject>

- (void)didDismissJSQDemoViewController:(JSQDemo2ViewController *)vc;

@end




@interface JSQDemo2ViewController : JSQMessagesViewController

@property (nonatomic ,copy) NSString *strtest;
@property (weak, nonatomic) id<JSQDemo2ViewControllerDelegate> delegateModal;

@property (strong, nonatomic) NSMutableArray *messages;
@property (copy, nonatomic) NSDictionary *avatars;

@property (strong, nonatomic) UIImageView *outgoingBubbleImageView;
@property (strong, nonatomic) UIImageView *incomingBubbleImageView;

- (void)receiveMessagePressed:(UIBarButtonItem *)sender;

- (void)closePressed:(UIBarButtonItem *)sender;

- (void)setupTestModel;

@end