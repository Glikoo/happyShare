//
//  MyViewController.m
//  HappyShare
//
//  Created by scsys on 15/4/25.
//  Copyright (c) 2015年 chx. All rights reserved.
//

#import "MyViewController.h"

@interface MyViewController ()

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.title=@"我";
    UIButton *outLogin=[UIButton buttonWithType:UIButtonTypeCustom];
    outLogin.frame=CGRectMake(50, 50, 100, 50);
    outLogin.backgroundColor=[UIColor blueColor];
    [outLogin setTitle:@"退出登陆" forState:UIControlStateNormal];
    [outLogin setTintColor:[UIColor whiteColor]];
    [outLogin addTarget:self action:@selector(outLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:outLogin];
    // Do any additional setup after loading the view.
}

- (void)outLogin
{
    [BmobUser logout];
    EMError *error = nil;
    NSDictionary *info = [[EaseMob sharedInstance].chatManager logoffWithUnbindDeviceToken:YES error:&error];
    if (!error && info) {
        NSLog(@"退出成功");
    }
    BOOL isAutoLogin = [[EaseMob sharedInstance].chatManager isAutoLoginEnabled];
    NSLog(@"%d",isAutoLogin);
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
