//
//  MyTextField.m
//  HappyShare
//
//  Created by scsys on 15/4/30.
//  Copyright (c) 2015年 chx. All rights reserved.
//

#import "MyTextField.h"

@implementation MyTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame Icon:(NSString *)iconName
{
    self=[super initWithFrame:frame];
    if (self) {
        CGFloat height=frame.size.height;
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 1, height+5, height - 2)];
        UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconName]];
        icon.frame = CGRectMake(height / 4, height / 4, height / 2, height / 2);
        [leftView addSubview:icon];
        self.leftView=leftView;
        self.leftViewMode=UITextFieldViewModeAlways;
        
        self.backgroundColor=[UIColor whiteColor];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame Text:(NSString *)content
{
    self=[super initWithFrame:frame];
    if (self) {
        CGFloat height=frame.size.height;
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 1, height+5, height - 2)];
        UILabel *textContent = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, height+5, height-2)];
        if ([content length]>=4) {
            leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 1, height+40, height - 2)];
            textContent = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, height+40, height-2)];
        }
        textContent.text=content;
        [leftView addSubview:textContent];
        self.leftView=leftView;
        self.leftViewMode=UITextFieldViewModeAlways;
        self.layer.borderWidth=1.0;
        self.layer.borderColor=[UIColor colorWithWhite:0.742 alpha:1.000].CGColor;
        self.layer.cornerRadius=4.0;
        self.backgroundColor=[UIColor whiteColor];
        [self.layer masksToBounds];
    }
    return self;
}

-(CGRect) leftViewRectForBounds:(CGRect)bounds {
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += 1;
    return iconRect;
}

@end
