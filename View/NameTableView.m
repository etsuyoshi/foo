//
//  NameTableView.m
//  JSQMessages
//
//  Created by EndoTsuyoshi on 2014/08/15.
//  Copyright (c) 2014年 Hexed Bits. All rights reserved.
//

#import "NameTableView.h"


@implementation NameTableView

@synthesize menuView;

- (id)initWithFrame:(CGRect)frame
{
    NSLog(@"initwithframe");
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self setup];

    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    NSLog(@"initwithcoder");
    self = [super initWithCoder:aDecoder];
    if(self){
        [self setup];
    }
    return self;
}

-(void)setup{
    NSLog(@"setup");
    self.menuView = [[UITableView alloc]initWithFrame:self.bounds];
    self.menuView.backgroundColor = [UIColor clearColor];
    self.menuView.delegate = self;
    self.menuView.dataSource = self;
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
    [self.menuView reloadData];
    [self addSubview:menuView];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 100;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *cellIdentifier = @"Cell1";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    
    for(id view in cell.contentView.subviews){
        [view removeFromSuperview];
    }
    
    if(cell.contentView.subviews.count == 0){
        UILabel *label = [[UILabel alloc]initWithFrame:cell.bounds];
        label.text = [NSString stringWithFormat:@"cell:%d", (int)indexPath.row];
        label.font = [UIFont systemFontOfSize:10.f];
        [cell.contentView addSubview:label];
        NSLog(@"cellForRowAtIndexPath = %d", (int)indexPath.row);
    }
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 27.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"tapped cell=%d in tableView", indexPath.row);
    
    
    
    [UIView animateWithDuration:0.5f
                     animations:^{
                         self.center = CGPointMake(-self.bounds.size.width, self.center.y);
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

@end
