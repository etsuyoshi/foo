//
//  JSQSelectIdTableViewCell.m
//  JSQMessages
//
//  Created by EndoTsuyoshi on 2014/09/15.
//  Copyright (c) 2014年 Hexed Bits. All rights reserved.
//

#import "JSQSelectIdTableViewCell.h"

@implementation JSQSelectIdTableViewCell

//@synthesize imvLeft;
//@synthesize lblTime;
//@synthesize lblMessage;
//@synthesize lblName;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
