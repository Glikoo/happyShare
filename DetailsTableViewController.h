//
//  DetailsTableViewController.h
//  HappyShare
//
//  Created by scsys on 15/5/2.
//  Copyright (c) 2015年 chx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsTableViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,IChatManagerDelegate>
@property (atomic,copy)NSString *userName;
@property (atomic,copy)NSString *nickName;
@end
