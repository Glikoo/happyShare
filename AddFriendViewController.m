//
//  AddFriendViewController.m
//  HappyShare
//
//  Created by scsys on 15/5/1.
//  Copyright (c) 2015年 chx. All rights reserved.
//

#import "AddFriendViewController.h"
#import "addressBookCell.h"
#import "DetailsTableViewController.h"
#import "ManagerView.h"

@interface AddFriendViewController ()
{
    UISearchBar *searchView;
    UIButton *cancelButton;
    ManagerView *clearView;
    NSArray *result;
    UITapGestureRecognizer *tap;
}
@end

@implementation AddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.title=@"新的朋友";
    result=[NSArray array];
    [self searhBar];
}




#pragma mark - 创建searhBar
- (void)searhBar
{
    searchView=[[UISearchBar alloc]initWithFrame:CGRectMake(0,self.navigationController.navigationBar.bounds.size.height+20, self.view.bounds.size.width, 40)];
    searchView.backgroundImage = [self imageWithColor:[UIColor colorWithWhite:0.850 alpha:1.000]];
    searchView.placeholder=@"邮箱/好友昵称";
    searchView.delegate=self;
    [self.view addSubview:searchView];
}


#pragma mark - 显示提示
- (void)reminder
{
    UILabel *reminderView=[[UILabel alloc]initWithFrame:CGRectMake(50, 200, self.view.frame.size.width-100, 40)];
    reminderView.textColor=[UIColor colorWithWhite:0.724 alpha:1.000];
    reminderView.text=@"无匹配结果";
    reminderView.textAlignment=NSTextAlignmentCenter;
    [clearView addSubview:reminderView];
}

#pragma mark - 设置cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return result.count;
}

#pragma mark - 设置cell内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId=@"buddyCell";
    addressBookCell *buddyCell=[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!buddyCell) {
        buddyCell=[[addressBookCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    buddyCell.headImage.image=[UIImage imageNamed:@"chatListCellHead"];
    BmobObject *obj=result[indexPath.row];
    buddyCell.nameLabel.text=[obj objectForKey:@"nickName"];
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
    return 20;
    
}

#pragma mark - 选中cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailsTableViewController *details=[[DetailsTableViewController alloc]init];
    details.userInfo=result;
    details.selectIndexPath=indexPath;
    [self.navigationController pushViewController:details animated:YES];
    
}

#pragma mark - 点击searchBar触发
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchView.backgroundImage = [self imageWithColor:[UIColor colorWithWhite:0.900 alpha:0.500]];
    UITextField *searchField;
    searchField=[((UIView *)[searchView.subviews objectAtIndex:0]).subviews objectAtIndex:1];
    searchField.frame=CGRectMake(8, 6, 320, 28);
    
    cancelButton=[UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame=CGRectMake(330, 0, 40, 40);
    [cancelButton setTitleColor:[UIColor colorWithRed:0.136 green:0.810 blue:0.171 alpha:1.000] forState:UIControlStateNormal];
    [cancelButton setTitle:@"取消" forState: UIControlStateNormal];
    cancelButton.showsTouchWhenHighlighted=YES;
    [cancelButton addTarget:self action:@selector(cancelSearch) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:cancelButton];
    
    clearView=[ManagerView defaultManager];
    clearView.frame=self.view.frame;
    clearView.backgroundColor=[UIColor colorWithWhite:0.500 alpha:0.100];
    [self.view addSubview:clearView];
    
    tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapViews)];
    [clearView addGestureRecognizer:tap];
    
    
    
    [UIView animateWithDuration:0.5 animations:^{
        self.navigationController.navigationBarHidden=YES;
        searchView.frame=CGRectMake(0, 20, self.view.bounds.size.width, 40);
        [self.view bringSubviewToFront:searchView];
    }];

}

#pragma mark - 点击search调用
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    BmobQuery   *queryUserName = [BmobQuery queryForUser];
    [queryUserName whereKey:@"username" equalTo:searchBar
     .text];
    [queryUserName findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (!error) {
            [clearView removeGestureRecognizer:tap];
            if (array.count>=1) {
                result=array;
                UITableView *resultView=[[UITableView alloc]initWithFrame:CGRectMake(0, searchView.frame.origin.y+40, self.view.frame.size.width, self.view.frame.size.height-60)];
                resultView.delegate=self;
                resultView.dataSource=self;
                [clearView addSubview:resultView];
            }
            else{
                BmobQuery   *queryNickName = [BmobQuery queryForUser];
                [queryNickName whereKey:@"nickName" equalTo:searchBar
                 .text];
                [queryNickName findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                    if (array.count>=1 && !error) {
                        result=array;
                        UITableView *resultView=[[UITableView alloc]initWithFrame:CGRectMake(0, searchView.frame.origin.y+40, self.view.frame.size.width, self.view.frame.size.height-60)];
                        resultView.delegate=self;
                        resultView.dataSource=self;
                        [clearView addSubview:resultView];
                    }
                    else{
                        [clearView addGestureRecognizer:tap];
                        [self reminder];
                    }
                }];
            }
        }
        else{
            [clearView addGestureRecognizer:tap];
            [self reminder];
        }
    }];
}


#pragma mark - 取消搜索
- (void)cancelSearch
{
    [searchView removeFromSuperview];
    
    
    for(UIView *view in [clearView subviews])
    {
        [view removeFromSuperview];
    }
    

    [clearView removeFromSuperview];
    [self searhBar];
    searchView.frame=CGRectMake(0, 20, self.view.bounds.size.width, 40);
    
    [UIView animateWithDuration:0.5 animations:^{
        self.navigationController.navigationBarHidden=NO;
        searchView.frame=CGRectMake(0,self.navigationController.navigationBar.bounds.size.height+20, self.view.bounds.size.width, 40);
    }];
    [self.view endEditing:YES];
}

#pragma mark - 改变searchBar背景颜色
- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - 点击手势
- (void)tapViews
{
    [self.view endEditing:YES];
    [self cancelSearch];
}

#pragma mark - 隐藏tabBarController
- (void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden=YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.view endEditing:YES];
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
