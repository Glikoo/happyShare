//
//  AppDelegate.m
//  HappyShare
//
//  Created by scsys on 15/4/30.
//  Copyright (c) 2015年 chx. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+easeMob.h"
#import "ChatListViewController.h"
#import "ShareViewController.h"
#import "MyViewController.h"
#import "LoginViewController.h"
#import "addressBookViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _connectionState = eEMConnectionConnected;
    self.window=[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:KNOTIFICATION_LOGINCHANGE
                                               object:nil];
    [self easeMobApplication:application didFinishLaunchingWithOptions:launchOptions];
    [self loginStateChange:nil];
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark -登陆状态改变
-(void)loginStateChange:(NSNotification *)notification
{
    UINavigationController *nav=nil;
    UINavigationController *ShareNav = nil;
    UINavigationController *chatListNav=nil;
    UINavigationController *myNav=nil;
    UINavigationController *addressBookNav=nil;
    UITabBarController *mainTabBar=nil;
    
    BOOL isAutoLogin = [[[EaseMob sharedInstance] chatManager] isAutoLoginEnabled];
    BOOL loginSuccess = [notification.object boolValue];
    if (isAutoLogin || loginSuccess) {
        //登陆成功加载主窗口控制器
        //加载申请通知的数据
        //        [[ApplyViewController shareController] loadDataSourceFromLocalDB];
        BmobUser *bUser = [BmobUser getCurrentObject];
        
        if (mainTabBar == nil) {
            shareViecontroller=[[ShareViewController alloc]init];
            chatListViewController = [[ChatListViewController alloc] init];
            myViewController = [[MyViewController alloc]init];
            addressBookController=[[addressBookViewController alloc]init];
            ShareNav=[[UINavigationController alloc]initWithRootViewController:shareViecontroller];
            chatListNav=[[UINavigationController alloc]initWithRootViewController:chatListViewController];
            myNav=[[UINavigationController alloc]initWithRootViewController:myViewController];
            addressBookNav=[[UINavigationController alloc]initWithRootViewController:addressBookController];
            NSArray *navlist=@[chatListNav,addressBookNav,ShareNav,myNav];
            mainTabBar=[[UITabBarController alloc]init];
            mainTabBar.viewControllers=navlist;
            mainTabBar.selectedIndex=2;
            //    设置 tabBar的文字
            UITabBarItem *item1=(UITabBarItem *)mainTabBar.tabBar.items[0];
            item1.title=@"聊天";
            UITabBarItem *item2=(UITabBarItem *)mainTabBar.tabBar.items[1];
            item2.title=@"通讯录";
            UITabBarItem *item3=(UITabBarItem *)mainTabBar.tabBar.items[2];
            item3.title=@"分享";
            UITabBarItem *item4=(UITabBarItem *)mainTabBar.tabBar.items[3];
            item4.title=@"我";
            self.window.rootViewController = mainTabBar;
        }
    }else{//登陆失败加载登陆页面控制器
        chatListViewController = nil;
        LoginViewController *loginController = [[LoginViewController alloc] init];
        nav = [[UINavigationController alloc] initWithRootViewController:loginController];
        loginController.title = @"登陆";
        self.window.rootViewController = nav;
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
