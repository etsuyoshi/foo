//
//  PlaceHolderTextView.h
//  JSQMessages
//
//  Created by EndoTsuyoshi on 2014/09/23.
//  Copyright (c) 2014年 Hexed Bits. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaceHolderTextView : UITextView

@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end
