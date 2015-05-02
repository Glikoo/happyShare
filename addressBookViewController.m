//
//  addressBookViewController.m
//  HappyShare
//
//  Created by scsys on 15/4/26.
//  Copyright (c) 2015年 chx. All rights reserved.
//

#import "addressBookViewController.h"
#import "addressBookCell.h"
#import "AddFriendViewController.h"
#import "DetailsTableViewController.h"

@interface addressBookViewController ()
{
    NSArray *buddyActionData;
    AddFriendViewController *addFriend;
    NSString *userName1;
    NSString *nickName1;
}

@end

@implementation addressBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"通讯录";
    self.view.backgroundColor=[UIColor whiteColor];
    buddyActionData=@[@"新的朋友",@"我的黑名单",@"我的关注"];
    //注册环信监听
    [self registerEaseMobNotification];
    [self tableView];
}

- (void)tableView
{
    UITableView *buddyListTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-self.navigationController.navigationBar.bounds.size.height) style:UITableViewStylePlain];
    buddyListTableView.delegate=self;
    buddyListTableView.dataSource=self;
    [self.view addSubview:buddyListTableView];
}

- (void)registerEaseMobNotification{
    [self unRegisterEaseMobNotification];
    // 将self 添加到SDK回调中，以便本类可以收到SDK回调
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

- (void)unRegisterEaseMobNotification{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

#pragma mark - 设置cell组别
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

#pragma mark - 设置cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section==0) {
        return 3;
    }
    else
    return self.BuddyList.count;;
}

#pragma mark - 设置cell内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId=@"buddyCell";
    addressBookCell *buddyCell=[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!buddyCell) {
        buddyCell=[[addressBookCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    if (indexPath.section==0) {
        buddyCell.headImage.image=[UIImage imageNamed:@"chatListCellHead"];
        buddyCell.nameLabel.text=buddyActionData[indexPath.row];

    } else{
        EMBuddy *userBuddy=self.BuddyList[indexPath.row];
        buddyCell.headImage.image=[UIImage imageNamed:@"chatListCellHead"];
        BmobQuery *query = [BmobUser query];
        [query whereKey:@"username" equalTo:[self IMId:userBuddy.username]];
        [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            BmobUser *user=array[0];
            buddyCell.nameLabel.text=[user objectForKey:@"nickName"];
        }];
    }
    return buddyCell;
    
    
}
#pragma mark - 设置cell行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

#pragma mark - 设置cell表头高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 40;
    }
    else{
        return 20;
    }

}

#pragma mark -设置表头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UISearchBar *serchView=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
        serchView.backgroundColor=[UIColor grayColor];
        return serchView;
    }
    else{
        return nil;
    }
}

#pragma mark -创建bmobID
- (NSString *)IMId:(NSString *)ID
{
    NSMutableString *ImID;
    if (ID) {
        ImID=[[NSMutableString alloc]initWithString:ID];
        
        NSRange range=[ImID rangeOfString:@"_"];
        [ImID replaceCharactersInRange:range withString:@"@"];
    }
    return ImID;
}

#pragma mark - 选中cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        switch (indexPath.row) {
            case 0:
                addFriend=[[AddFriendViewController alloc]init];
                [self.navigationController pushViewController:addFriend animated:YES];
                break;
                
            default:
                break;
        }
    }
    else{
        
        EMBuddy *userBuddy=self.BuddyList[indexPath.row];
        BmobQuery *query = [BmobUser query];
        [query whereKey:@"username" equalTo:[self IMId:userBuddy.username]];
        [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            BmobUser *user=array[0];
            [self performSelectorOnMainThread:@selector(pushDetails:) withObject:user waitUntilDone:YES];
            
        }];
     
    }

}

- (void)pushDetails:(BmobUser *)user
{
    DetailsTableViewController *details=[[DetailsTableViewController alloc]init];
    details.userName=[user objectForKey:@"username"];
    details.nickName=[user objectForKey:@"nickName"];
    NSLog(@"%@%@",[user objectForKey:@"username"],[user objectForKey:@"nickName"]);
    [self.navigationController pushViewController:details animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=NO;
    self.tabBarController.tabBar.hidden=NO;
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
