//
//  LoginViewController.m
//  HappyShare
//
//  Created by scsys on 15/4/25.
//  Copyright (c) 2015年 chx. All rights reserved.
//

#import "LoginViewController.h"
#import "MyTextField.h"
#import "RegisterViewController.h"


@interface LoginViewController ()
{
    NSMutableDictionary *userInfo;


}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithWhite:0.953 alpha:1.000];
    [self buldingView];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView)];
    [self.view addGestureRecognizer:tap];
    
}

- (void)tapView
{
    [self.view endEditing:YES];
}

- (void)buldingView
{
    userInfo=[NSMutableDictionary dictionary];
    
    UIView *textFieldBoxView=[[UIView alloc]initWithFrame:CGRectMake(10, 280, self.view.frame.size.width-20, 100)];
    textFieldBoxView.backgroundColor=[UIColor whiteColor];
    textFieldBoxView.layer.cornerRadius=4.0;
    textFieldBoxView.layer.borderWidth=1.0;
    textFieldBoxView.layer.borderColor=[UIColor colorWithWhite:0.742 alpha:1.000].CGColor;
    [textFieldBoxView.layer masksToBounds];
    [self.view addSubview:textFieldBoxView];
    
    MyTextField *userName=[[MyTextField alloc]initWithFrame:CGRectMake(5, 0, textFieldBoxView.frame.size.width-10, 50) Icon:@"account"];
    userName.tag=1;
    userName.delegate=self;
    userName.placeholder=@"请输入邮箱";
    [textFieldBoxView addSubview:userName];
    
    MyTextField *passWord=[[MyTextField alloc]initWithFrame:CGRectMake(5, 50, textFieldBoxView.frame.size.width-10, 50) Icon:@"password"];
    passWord.tag=2;
    passWord.delegate=self;
    passWord.secureTextEntry=YES;
    passWord.placeholder=@"请输入密码";
    [textFieldBoxView addSubview:passWord];
    
    UILabel *line=[[UILabel alloc]initWithFrame:CGRectMake(0, 50, textFieldBoxView.frame.size.width, 1)];
    line.backgroundColor=[UIColor colorWithWhite:0.742 alpha:1.000];
    [textFieldBoxView addSubview:line];
    
    UIButton *login=[UIButton buttonWithType:UIButtonTypeCustom];
    login.frame=CGRectMake(20, 410, self.view.frame.size.width-40, 50);
    [login setTitle:@"登陆" forState:UIControlStateNormal];
    [login setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    login.backgroundColor=[UIColor colorWithRed:0.253 green:0.664 blue:1.000 alpha:1.000];
    login.layer.cornerRadius=4.0;
    [login.layer masksToBounds];
    login.showsTouchWhenHighlighted=YES;
    [login addTarget:self action:@selector(tapLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:login];
    
    
    UIView *footView=[[UIView alloc]initWithFrame:CGRectMake(50, self.view.frame.size.height-80, self.view.frame.size.width-100, 40)];
    [self.view addSubview:footView];
    UILabel *reminder=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, footView.frame.size.width*2/3, 40)];
    reminder.text=@"还没有账号？";
    reminder.textAlignment=NSTextAlignmentCenter;
    reminder.textColor=[UIColor colorWithWhite:0.541 alpha:1.000];
    [footView addSubview:reminder];
    UIButton *registerButton=[UIButton buttonWithType:UIButtonTypeCustom];
    registerButton.frame=CGRectMake(footView.frame.size.width*2/3-40, 0, footView.frame.size.width/3, 40);
    [registerButton setTitle:@"立即注册 >" forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor colorWithRed:0.253 green:0.664 blue:1.000 alpha:1.000] forState:UIControlStateNormal];
    registerButton.showsTouchWhenHighlighted=YES;
    [registerButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:registerButton];

}


#pragma mark - 获取输入框内容
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString *content=textField.text;
    if (textField.tag==1) {
        [userInfo setObject:content forKey:@"userName"];
    }
    else{
        [userInfo setObject:content forKey:@"userPassword"];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - 判断用户名和密码是否为空
- (BOOL)isEmpty
{
    BOOL result=nil;
    NSString *name=[userInfo objectForKey:@"userName"];
    NSString *passWord=[userInfo objectForKey:@"userPassword"];
    if (!name || !passWord) {
        result=YES;
        UIAlertView *error=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请重新填写'用户名'和'密码'" delegate: self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        error.tag=100;
        
        [error show];
    }
    return result;
}

#pragma mark -点击注册
- (void)login
{
    RegisterViewController *registerView=[[RegisterViewController alloc]init];
    [self.navigationController pushViewController:registerView animated:YES];
}



#pragma mark -点击登录后操作
- (void)tapLogin
{
    if (![self isEmpty]) {
        [self.view endEditing:YES];
        [self doLogin];
    }
}
#pragma mark -登陆
- (void)doLogin
{
    [BmobUser loginWithUsernameInBackground:[userInfo objectForKey:@"userName"] password:[userInfo objectForKey:@"userPassword"] block:^(BmobUser *user, NSError *error) {
        NSLog(@"1");
    }];
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:[self IMId:[userInfo objectForKey:@"userName"]] password:[userInfo objectForKey:@"userPassword"] completion:^(NSDictionary *loginInfo, EMError *error) {
    if (loginInfo && !error) {
//        获取好友列表
        [[EaseMob sharedInstance].chatManager asyncFetchBuddyList];
        
        //设置是否自动登录
        [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
        
        //将旧版的coredata数据导入新的数据库
        EMError *error = [[EaseMob sharedInstance].chatManager importDataToNewDatabase];
        if (!error) {
            error = [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
        }
        
        //发送自动登陆状态通知
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
    }
    else{
        switch (error.errorCode) {
            case EMErrorServerNotReachable:
                [self TTAlertNoTitle:@"没有连接到网络"];
                break;
            case EMErrorServerAuthenticationFailure:
                [self TTAlertNoTitle:error.description];
                break;
            case EMErrorServerTimeout:
                [self TTAlertNoTitle:@"连接超时"];
                break;
            default:
                [self TTAlertNoTitle:@"登陆失败"];
                break;
        }
    }
    
} onQueue:nil];


}

#pragma mark -创建环信ID
- (NSString *)IMId:(NSString *)ID
{
    NSMutableString *ImID;
    if (ID) {
        ImID=[[NSMutableString alloc]initWithString:ID];
        
        NSRange range=[ImID rangeOfString:@"@"];
        [ImID replaceCharactersInRange:range withString:@"_"];
    }
    return ImID;
}

#pragma mark -提示框
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==100) {
        if (buttonIndex==0) {
            [userInfo removeAllObjects];
        }
    }
    if (alertView.tag==101) {
        if (buttonIndex==1) {
            [self doLogin];
        }
    }
}

- (void)TTAlertNoTitle:(NSString* )message
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
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
