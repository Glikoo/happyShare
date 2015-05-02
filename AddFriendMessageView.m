//
//  AddFriendMessageView.m
//  HappyShare
//
//  Created by scsys on 15/5/2.
//  Copyright (c) 2015年 chx. All rights reserved.
//

#import "AddFriendMessageView.h"

@interface AddFriendMessageView ()
{
    BmobObject *obj;
    NSString *message;
}
@end

@implementation AddFriendMessageView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"朋友验证";
    self.view.backgroundColor=[UIColor whiteColor];
    UITableView *tableView=[[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(sendAddFriend)];
    self.navigationItem.rightBarButtonItem=rightItem;
}

#pragma mark - 设置cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

#pragma mark - 设置cell内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId=@"detailsCell";
    UITableViewCell *messageCell=[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!messageCell) {
        messageCell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    BmobUser *bUser = [BmobUser getCurrentObject];
    
    UITextField *messageView=[[UITextField alloc]initWithFrame:CGRectMake(20, 0, CGRectGetWidth(messageCell.frame), CGRectGetHeight(messageCell.frame))];
    messageView.placeholder=[NSString stringWithFormat:@"我是%@",[bUser objectForKey:@"nickName"]];
    [messageView setValue:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    [messageCell addSubview:messageView];
    return messageCell;
    
    
}

#pragma mark - 设置cell行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

#pragma mark - 设置cell表头高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
    
}

#pragma mark -设置表头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *headView=[[UIView alloc]init];
    UILabel *headLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, 300, 45)];
    headLabel.text=@"你需要发送验证申请，等对方通过";
    headLabel.textColor=[UIColor colorWithWhite:0.646 alpha:1.000];
    headLabel.font=[UIFont systemFontOfSize:15];
    [headView addSubview:headLabel];
    return headView;
}

#pragma mark - 获取输入框内容
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    message=textField.text;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (void)sendAddFriend
{
    EMError *error = nil;
    BOOL isSuccess = [[EaseMob sharedInstance].chatManager addBuddy:[self buildID:self.userName] message:message error:&error];
    if (isSuccess && !error) {
        NSLog(@"添加成功");
    }
    else if(error){
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:error.description
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];

    }
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

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=NO;
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
