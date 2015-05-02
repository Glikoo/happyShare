//
//  RegisterViewController.m
//  HappyShare
//
//  Created by scsys on 15/5/1.
//  Copyright (c) 2015年 chx. All rights reserved.
//

#import "RegisterViewController.h"
#import "LoginViewController.h"
#import "MyTextField.h"

@interface RegisterViewController ()
{
    NSMutableDictionary *userInfo;
    BmobUser *bUser;
    
}
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    userInfo=[NSMutableDictionary dictionary];
    self.view.backgroundColor=[UIColor colorWithWhite:0.953 alpha:1.000];
    self.title=@"注册";
    MyTextField *userName=[[MyTextField alloc]initWithFrame:CGRectMake(10,self.navigationController.navigationBar.bounds.size.height+20+10, self.view.frame.size.width-20, 50) Text:@"账号："];
    userName.tag=1;
    userName.delegate=self;
    userName.placeholder=@"请输入邮箱";
    [self.view addSubview:userName];
    
    MyTextField *nickname=[[MyTextField alloc]initWithFrame:CGRectMake(10, userName.frame.origin.y+60, self.view.frame.size.width-20, 50) Text:@"昵称："];
    nickname.tag=2;
    nickname.delegate=self;
    nickname.placeholder=@"请输入昵称";
    [self.view addSubview: nickname];
    
    MyTextField *passWord=[[MyTextField alloc]initWithFrame:CGRectMake(10, nickname.frame.origin.y+60, self.view.frame.size.width-20, 50) Text:@"密码："];
    passWord.tag=3;
    passWord.delegate=self;
    passWord.secureTextEntry=YES;
    passWord.placeholder=@"请输入密码";
    [self.view addSubview:passWord];
    
    MyTextField *RpassWord=[[MyTextField alloc]initWithFrame:CGRectMake(10, passWord.frame.origin.y+60, self.view.frame.size.width-20, 50) Text:@"确认密码："];
    RpassWord.tag=4;
    RpassWord.delegate=self;
    RpassWord.secureTextEntry=YES;
    RpassWord.placeholder=@"请再次输入密码";
    [self.view addSubview:RpassWord];
    
    UIButton *login=[UIButton buttonWithType:UIButtonTypeCustom];
    login.frame=CGRectMake(20, RpassWord.frame.origin.y+70, self.view.frame.size.width-40, 50);
    [login setTitle:@"注册" forState:UIControlStateNormal];
    [login setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    login.backgroundColor=[UIColor colorWithRed:0.253 green:0.664 blue:1.000 alpha:1.000];
    login.layer.cornerRadius=4.0;
    [login.layer masksToBounds];
    [login addTarget:self action:@selector(doRegister) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:login];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapView)];
    [self.view addGestureRecognizer:tap];
}

- (void)tapView
{
    [self.view endEditing:YES];
}

#pragma mark - 获取输入框内容
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString *content=textField.text;
    if (textField.tag==1) {
        [userInfo setObject:content forKey:@"userName"];
    }
    else if(textField.tag==2){
        [userInfo setObject:content forKey:@"userNickName"];
    }
    else if(textField.tag==3){
        [userInfo setObject:content forKey:@"userPassword"];
    }
    else{
        [userInfo setObject:content forKey:@"RuserPassword"];
    }
    NSLog(@"%@",userInfo);
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - 判断用户名和密码是否为空
- (BOOL)isEmpty
{
    NSLog(@"%@",userInfo);
    BOOL result=nil;
    NSString *name=[userInfo objectForKey:@"userName"];
    NSString *passWord=[userInfo objectForKey:@"userPassword"];
    NSString *RpassWord=[userInfo objectForKey:@"RuserPassword"];
    NSString *nickname=[userInfo objectForKey:@"userNickName"];
    if (!name || !passWord || ![passWord isEqualToString:RpassWord] ||!nickname) {
        result=YES;
        UIAlertView *error=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请重新填写'用户名'和'密码'" delegate: self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        error.tag=100;
        
        [error show];
    }
    return result;
}

#pragma mark -注册账号
- (void)doRegister
{
    if (![self isEmpty]) {
        [self.view endEditing:YES];
        bUser=[[BmobUser alloc]init];
        [bUser setUserName:[userInfo objectForKey:@"userName"]];
        [bUser setPassword:[userInfo objectForKey:@"userPassword"]];
        [bUser setObject:[userInfo objectForKey:@"userNickName"] forKey:@"nickName"];
        [bUser signUpInBackground];
        [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:[self buildID:[userInfo objectForKey:@"userName"]] password:[userInfo objectForKey:@"userPassword"] withCompletion:^(NSString *username, NSString *password, EMError *error) {
            if (!error) {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"恭喜您已经注册成功！" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:@"马上登陆", nil];
                alert.tag=101;
                [alert show];
            }
            else{
                switch (error.errorCode) {
                    case EMErrorServerNotReachable:
                        [self TTAlertNoTitle:@"没有连接到网络"];
                        break;
                    case EMErrorServerDuplicatedAccount:
                        [self TTAlertNoTitle:@"用户已存在"];
                        break;
                    case EMErrorServerTimeout:
                        [self TTAlertNoTitle:@"连接超时"];
                        break;
                    default:
                        [self TTAlertNoTitle:@"注册失败"];
                        break;
                }
                
            }
        } onQueue:nil];
        
    }
}

#pragma mark -登陆
- (void)doLogin
{
    [BmobUser loginWithUsernameInBackground:[userInfo objectForKey:@"userName"] password:[userInfo objectForKey:@"userPassword"] block:^(BmobUser *user, NSError *error) {
        NSLog(@"%@",user);
    }];
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:[self buildID:[userInfo objectForKey:@"userName"]] password:[userInfo objectForKey:@"userPassword"] completion:^(NSDictionary *loginInfo, EMError *error) {
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
- (NSString *)buildID:(NSString *)ID
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
