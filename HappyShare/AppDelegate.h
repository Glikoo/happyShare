//
//  AppDelegate.h
//  HappyShare
//
//  Created by scsys on 15/4/30.
//  Copyright (c) 2015年 chx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareViewController.h"
#import "ChatListViewController.h"
#import "MyViewController.h"
#import "addressBookViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,IChatManagerDelegate>
{
        EMConnectionState _connectionState;
        ShareViewController *shareViecontroller;
        ChatListViewController *chatListViewController;
        MyViewController *myViewController;
        addressBookViewController *addressBookController;
    
}
@property (strong, nonatomic) UIWindow *window;


@end

