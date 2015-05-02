//
//  ChatListViewController.m
//  HappyShare
//
//  Created by scsys on 15/4/26.
//  Copyright (c) 2015年 chx. All rights reserved.
//

#import "ChatListViewController.h"
#import "ChatListCell.h"

@interface ChatListViewController ()
{
    NSArray *BuddyList;
}
@end

@implementation ChatListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"消息列表";
    self.view.backgroundColor=[UIColor whiteColor];
    
    
}

- (void)buldingView
{
    UITableView *buddyListTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bounds.size.height, self.view.frame.size.width, self.view.frame.size.height-self.navigationController.navigationBar.bounds.size.height) style:UITableViewStylePlain];
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

- (void)didFetchedBuddyList:(NSArray *)buddyList error:(EMError *)error
{
    BuddyList=[[NSArray array]initWithArray:buddyList];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return BuddyList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId=@"buddyCell";
    ChatListCell *buddyCell=[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!buddyCell) {
        
    }
    return buddyCell;
    

}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar tintColorDidChange];
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
