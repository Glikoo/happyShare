//
//  AppDelegate+easeMob.m
//  HappyShare
//
//  Created by scsys on 15/4/25.
//  Copyright (c) 2015年 chx. All rights reserved.
//

#import "AppDelegate+easeMob.h"

@implementation AppDelegate (easeMob)

- (void)easeMobApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if (launchOptions) {
        NSDictionary *useInfo=[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (useInfo) {
            [self didReiveceRemoteNotificatison:(NSDictionary *)useInfo];
        }
    }
    _connectionState = eEMConnectionConnected;
    [self registerRemoteNotification];
    
    NSString *apnsCertName = nil;
#if DEBUG
    apnsCertName=@"shareCertificate";
#endif
    
    [[EaseMob sharedInstance] registerSDKWithAppKey:@"cstar#ishare" apnsCertName:apnsCertName otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];
//    IsAutoFetchBuddyList 登陆成功后自动调用asyncFetchBuddyList方法 获取好友列表
    [[EaseMob sharedInstance].chatManager setIsAutoFetchBuddyList:YES];
    
    // 注册环信监听
    [self registerEaseMobNotification];
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    [self setupNotifiers];
    
}
// 监听系统生命周期回调，以便将需要的事件传给SDK
- (void)setupNotifiers{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidEnterBackgroundNotif:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidFinishLaunching:)
                                                 name:UIApplicationDidFinishLaunchingNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidBecomeActiveNotif:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillResignActiveNotif:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidReceiveMemoryWarning:)
                                                 name:UIApplicationDidReceiveMemoryWarningNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillTerminateNotif:)
                                                 name:UIApplicationWillTerminateNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appProtectedDataWillBecomeUnavailableNotif:)
                                                 name:UIApplicationProtectedDataWillBecomeUnavailable
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appProtectedDataDidBecomeAvailableNotif:)
                                                 name:UIApplicationProtectedDataDidBecomeAvailable
                                               object:nil];
}

#pragma mark - notifiers
- (void)appDidEnterBackgroundNotif:(NSNotification*)notif{
    [[EaseMob sharedInstance] applicationDidEnterBackground:notif.object];
}

- (void)appWillEnterForeground:(NSNotification*)notif
{
    [[EaseMob sharedInstance] applicationWillEnterForeground:notif.object];
}

- (void)appDidFinishLaunching:(NSNotification*)notif
{
    [[EaseMob sharedInstance] applicationDidFinishLaunching:notif.object];
}

- (void)appDidBecomeActiveNotif:(NSNotification*)notif
{
    [[EaseMob sharedInstance] applicationDidBecomeActive:notif.object];
}

- (void)appWillResignActiveNotif:(NSNotification*)notif
{
    [[EaseMob sharedInstance] applicationWillResignActive:notif.object];
}

- (void)appDidReceiveMemoryWarning:(NSNotification*)notif
{
    [[EaseMob sharedInstance] applicationDidReceiveMemoryWarning:notif.object];
}

- (void)appWillTerminateNotif:(NSNotification*)notif
{
    [[EaseMob sharedInstance] applicationWillTerminate:notif.object];
}

- (void)appProtectedDataWillBecomeUnavailableNotif:(NSNotification*)notif
{
    [[EaseMob sharedInstance] applicationProtectedDataWillBecomeUnavailable:notif.object];
}

- (void)appProtectedDataDidBecomeAvailableNotif:(NSNotification*)notif
{
    [[EaseMob sharedInstance] applicationProtectedDataDidBecomeAvailable:notif.object];
}

// 将得到的deviceToken传给SDK
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [[EaseMob sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

// 注册deviceToken失败，此处失败，与环信SDK无关，一般是您的环境配置或者证书配置有误
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    [[EaseMob sharedInstance] application:application didFailToRegisterForRemoteNotificationsWithError:error];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fail to register apns"
                                                    message:error.description
                                                   delegate:self
                                          cancelButtonTitle:@"ok"
                                          otherButtonTitles:nil];
    [alert show];
}


- (void)registerEaseMobNotification{
    [self unRegisterEaseMobNotification];
    // 将self 添加到SDK回调中，以便本类可以收到SDK回调
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

- (void)unRegisterEaseMobNotification{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

#pragma mark - IChatManagerDelegate
#pragma mark -开始自动登录回调
-(void)willAutoLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error
{
    UIAlertView *alertView = nil;
    if (error) {
        //发送自动登陆状态通知
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
    }
    else{
        alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"正在自动登录中,请稍后" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    }
    
    [alertView show];
}
#pragma mark -结束自动登录
-(void)didAutoLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error
{
    if (error) {
        //发送自动登陆状态通知
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
    }
    else{
        //获取好友列表
        [[EaseMob sharedInstance].chatManager asyncFetchBuddyList];
    }
}

#pragma mark - 回调好友列表
- (void)didFetchedBuddyList:(NSArray *)buddyList error:(EMError *)error
{
    addressBookController.BuddyList=buddyList;
    
}



#pragma mark -好友申请回调
- (void)didReceiveBuddyRequest:(NSString *)username
                       message:(NSString *)message
{
    if (!username) {
        return;
    }
    if (!message) {
        message = [NSString stringWithFormat:@"%@ add you as a friend", username];
    }
//    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"title":username, @"username":username, @"applyMessage":message}];
//    [[ApplyViewController shareController] addNewApply:dic];
//    if (self.mainController) {
//        [self.mainController setupUntreatedApplyCount];
//    }
}

//#pragma mark -离开群组回调
//- (void)group:(EMGroup *)group didLeave:(EMGroupLeaveReason)reason error:(EMError *)error
//{
//    NSString *tmpStr = group.groupSubject;
//    NSString *str;
//    if (!tmpStr || tmpStr.length == 0) {
//        NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
//        for (EMGroup *obj in groupArray) {
//            if ([obj.groupId isEqualToString:group.groupId]) {
//                tmpStr = obj.groupSubject;
//                break;
//            }
//        }
//    }
//    
//    if (reason == eGroupLeaveReason_BeRemoved) {
//        str = [NSString stringWithFormat:@"您被管理员从群'%@'中移除", tmpStr];
//    }
//    if (str.length > 0) {
//        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
//                                                        message:str
//                                                       delegate:self
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//        [alert show];
//    }
//}

//#pragma mark -申请加入群组被拒绝回调
//- (void)didReceiveRejectApplyToJoinGroupFrom:(NSString *)fromId
//                                   groupname:(NSString *)groupname
//                                      reason:(NSString *)reason
//                                       error:(EMError *)error{
//    if (!reason || reason.length == 0) {
//        reason = [NSString stringWithFormat:@"您被拒绝加入群'%@'", groupname];
//    }
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:reason delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
//    [alertView show];
//}

//#pragma mark -接收到入群申请
//- (void)didReceiveApplyToJoinGroup:(NSString *)groupId
//                         groupname:(NSString *)groupname
//                     applyUsername:(NSString *)username
//                            reason:(NSString *)reason
//                             error:(EMError *)error
//{
//    if (!groupId || !username) {
//        return;
//    }
//    
//    if (!reason || reason.length == 0) {
//        reason = [NSString stringWithFormat:@"%@申请加入群'%@'", username, groupname];
//    }
//    else{
//        reason = [NSString stringWithFormat:@"%@申请加入群'%@'：%@", username, groupname, reason];
//    }
//    
//    if (error) {
//        NSString *message = [NSString stringWithFormat: @"发送申请失败:%@\n原因：%@", reason, error.description];
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error", @"Error") message:message delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
//        [alertView show];
//    }
//    else{
//        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:@{@"title":groupname, @"groupId":groupId, @"username":username, @"groupname":groupname, @"applyMessage":reason, @"applyStyle":[NSNumber numberWithInteger:ApplyStyleJoinGroup]}];
//        [[ApplyViewController shareController] addNewApply:dic];
//        if (self.mainController) {
//            [self.mainController setupUntreatedApplyCount];
//        }
//    }
//}

//#pragma mark -已经同意并且加入群组后的回调
//- (void)didAcceptInvitationFromGroup:(EMGroup *)group
//                               error:(EMError *)error
//{
//    if(error)
//    {
//        return;
//    }
//    
//    NSString *groupTag = group.groupSubject;
//    if ([groupTag length] == 0) {
//        groupTag = group.groupId;
//    }
//    
//    NSString *message = [NSString stringWithFormat: @"您加入群'%@'的请求通过了", groupTag];
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
//    [alertView show];
//}

#pragma mark - 绑定deviceToken回调
- (void)didBindDeviceWithError:(EMError *)error
{
    if (error) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"绑定deviceToken失败"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - 网络状态变化回调
- (void)didConnectionStateChanged:(EMConnectionState)connectionState
{
    _connectionState = connectionState;
//    [self.mainController networkChanged:connectionState];
}

#pragma mark -注册推送
- (void)registerRemoteNotification{
    UIApplication *application = [UIApplication sharedApplication];
    application.applicationIconBadgeNumber = 0;
    
    if([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
#if !TARGET_IPHONE_SIMULATOR
    //iOS8 注册APNS
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
    }else{
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
#endif
}
#pragma mark -打印收到的apns信息
-(void)didReiveceRemoteNotificatison:(NSDictionary *)userInfo{
    NSError *parseError = nil;
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:userInfo
                                                        options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *str =  [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"推送内容"
                                                    message:str
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
                                          otherButtonTitles:nil];
    [alert show];
    
}
@end
