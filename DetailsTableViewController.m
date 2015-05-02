//
//  DetailsTableViewController.m
//  HappyShare
//
//  Created by scsys on 15/5/2.
//  Copyright (c) 2015年 chx. All rights reserved.
//

#import "DetailsTableViewController.h"
#import "DetailsCell.h"

@interface DetailsTableViewController ()
{
    NSArray *contentArr;
}
@end

@implementation DetailsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    contentArr=@[@"地区",@"个性签名",@"社交活动"];
    self.title=@"详细资料";
    self.view.backgroundColor=[UIColor whiteColor];
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-self.navigationController.navigationBar.bounds.size.height-20) style:UITableViewStyleGrouped];
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];

}
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=NO;
}

#pragma mark - 设置cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
#pragma mark - 设置cell内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId=@"detailsCell";
    DetailsCell *detailsCell=[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!detailsCell) {
        detailsCell=[[DetailsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId indexPath:indexPath];
    }
    if (indexPath.row<=1) {
        detailsCell.headName.text=contentArr[indexPath.row];
        detailsCell.contentLabel.text=@"河南";
    }
    else{
        
        detailsCell.headName.frame=CGRectMake(10, 5, 80, 80-10);
        detailsCell.contentLabel.frame=CGRectMake(detailsCell.SocialImage.frame.origin.x+60+20, 5, detailsCell.frame.size.width-detailsCell.SocialImage.frame.origin.x-detailsCell.SocialImage.frame.size.width-20, 80-10);
        detailsCell.SocialImage.frame=CGRectMake(detailsCell.headName.frame.size.width+20, 10, 80-20, 80-20);
        
        detailsCell.headName.text=contentArr[indexPath.row];
        detailsCell.contentLabel.text=@"河南";
        detailsCell.SocialImage.image=[UIImage imageNamed:@"chatListCellHead"];
    }
    return detailsCell;
    
    
}

#pragma mark - 设置cell行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==2) {
        return 90;
    }
    else{
    return 45;
    }
}

#pragma mark - 设置cell表头高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 80;
    
}

#pragma mark -设置表头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 80)];
    UIImageView *headImage=[[UIImageView alloc]initWithFrame:CGRectMake(5, 10, headView.frame.size.height-20,headView.frame.size.height-20)];
    headImage.image=[UIImage imageNamed:@"chatListCellHead"];
    [headView addSubview:headImage];
    UILabel *emailLabel=[[UILabel alloc]initWithFrame:CGRectMake(headImage.frame.size.width+15, 10, 200, 30)];
    emailLabel.backgroundColor=[UIColor redColor];
    [headView addSubview:emailLabel];
    UILabel *nickLabel=[[UILabel alloc]initWithFrame:CGRectMake(headImage.frame.size.width+15, 40, 200, 30)];
    nickLabel.backgroundColor=[UIColor redColor];
    [headView addSubview:nickLabel];
    return headView;
}

#pragma mark -设置表尾视图
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/2)];
    UIButton *talkButton=[UIButton buttonWithType:UIButtonTypeCustom];
    talkButton.frame=CGRectMake(10, 20, footView.frame.size.width-20, 40);
    talkButton.backgroundColor=[UIColor colorWithRed:0.011 green:0.685 blue:0.029 alpha:1.000];
    [talkButton setTitle:@"打招呼" forState: UIControlStateNormal];
    [talkButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    talkButton.layer.cornerRadius=4;
    [talkButton.layer masksToBounds];
    [footView addSubview:talkButton];
    UIButton *addButton=[UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame=CGRectMake(10, 80, footView.frame.size.width-20, 40);
    addButton.backgroundColor=[UIColor colorWithRed:0.011 green:0.685 blue:0.029 alpha:1.000];
    [addButton setTitle:@"加为好友" forState: UIControlStateNormal];
    [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addButton.layer.cornerRadius=4;
    [addButton.layer masksToBounds];
    [footView addSubview:addButton];
    return footView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
