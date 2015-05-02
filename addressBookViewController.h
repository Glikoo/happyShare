//
//  addressBookViewController.h
//  HappyShare
//
//  Created by scsys on 15/4/26.
//  Copyright (c) 2015年 chx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface addressBookViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,IChatManagerDelegate,UIAlertViewDelegate>

@property (copy) NSArray *BuddyList;

@end
