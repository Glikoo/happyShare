//
//  ManagerView.m
//  HappyShare
//
//  Created by scsys on 15/5/2.
//  Copyright (c) 2015年 chx. All rights reserved.
//

#import "ManagerView.h"

static ManagerView *view;

@implementation ManagerView
+(id)defaultManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        view = [[ManagerView alloc] init];
    });
    return view;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
