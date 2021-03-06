//
//  AppDelegate.m
//  OnTheWay
//
//  Created by machunyan on 2017/7/5.
//  Copyright © 2017年 WeiHuan. All rights reserved.
//

#import "AppDelegate.h"
#import "OTWLaunchViewController.h"
#import "OTWUserModel.h"
#import "OTWUtils.h"
//#import "BNCoreServices.h"

#define UMAppKey @"598c217d8f4a9d55d80004f6"

@interface AppDelegate ()<UNUserNotificationCenterDelegate>
@property (nonatomic,assign) BOOL isNetWork;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.rootViewController = [[OTWLaunchViewController alloc] init];
    [[OTWUserModel shared] load];
    _mapManager = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:@"uyQP9vycrVQwe5G3Sus9tTGNdKWmWfTG"  generalDelegate:nil];
    if (!ret) {
        DLog(@"manager start failed!");
    }
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    //配置友盟推送
    [self configureUMessageWithLaunchOptions:launchOptions];
    
    _isNetWork = [OTWNetworkManager isNetwork];
    
    DLog(@"当前网络状态 _isNetWork: %d",_isNetWork);
    
    [_window makeKeyAndVisible];
//    [BNCoreServices_Instance initServices:@"uyQP9vycrVQwe5G3Sus9tTGNdKWmWfTG"];
//    [BNCoreServices_Instance startServicesAsyn:nil fail:nil];
    return YES;
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //关闭友盟自带弹出框
    [UMessage setAutoAlert:NO];
    
    [UMessage didReceiveRemoteNotification:userInfo];
    
    self.userInfo = userInfo;
    
    //定制自定义弹出框
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"测试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    DLog(@"deviceToken%@",[[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""]stringByReplacingOccurrencesOfString:@">" withString:@""]stringByReplacingOccurrencesOfString:@" " withString:@""]);
    [UMessage registerDeviceToken:deviceToken];
}

//后台打开
- (void)applicationWillResignActive:(UIApplication *)application {
    
    DLog(@"applicationWillResignActive");
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

//前台进入后台
- (void) :(UIApplication *)application {
    DLog(@"applicationDidEnterBackground");
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

//后台进入前台
- (void)applicationWillEnterForeground:(UIApplication *)application {
    DLog(@"applicationWillEnterForeground");
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

//变得活跃
- (void)applicationDidBecomeActive:(UIApplication *)application {
    DLog(@"applicationDidBecomeActive");
    //监听网络变化，需要重新初始化一下百度地图，如果开始没网络，后面监听到又网络，才重新初始化百度地图
    [OTWNetworkManager networkStatusWithBlock:^(PPNetworkStatusType status){
        if(status != PPNetworkStatusNotReachable && !_isNetWork){
            DLog(@"网络状态变化，由无网络变为有网络");
            _mapManager = [[BMKMapManager alloc]init];
            BOOL ret = [_mapManager start:@"uyQP9vycrVQwe5G3Sus9tTGNdKWmWfTG"  generalDelegate:nil];
            if (!ret) {
                DLog(@"manager start failed!");
            }
            _isNetWork = YES;
        }else if(status == PPNetworkStatusNotReachable){
            _isNetWork = NO;
        }
        DLog(@"当前网络状态 _isNetWork: %d",_isNetWork);
    }];
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

//
- (void)applicationWillTerminate:(UIApplication *)application {
    DLog(@"applicationWillTerminate");
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)configureUMessageWithLaunchOptions:(NSDictionary*)launchOptions
{
    //设置AppKey & launchOptions
    [UMessage startWithAppkey:UMAppKey launchOptions:launchOptions];
    //检查是否为ios 10.0以上版本
    if ([OTWUtils system_version_greater_than_or_equal_to:10.0]) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        UNAuthorizationOptions types10 = UNAuthorizationOptionBadge | UNAuthorizationOptionAlert | UNAuthorizationOptionSound;
        [center requestAuthorizationWithOptions:types10 completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                //点击允许
            } else {
                //点击不允许
            }
        }];
    }
    if ([OTWUtils system_version_gerater_between:8.0 and:10.0]) {
        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
        action1.identifier = @"action1_identifier";
        action1.title = @"Accept";
        //点击时启动应用
        action1.activationMode = UIUserNotificationActivationModeForeground;
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];
        action2.identifier = @"action2_identifier";
        action2.title = @"Reject";
        //点击时不启动应用，在后台处理
        action2.activationMode = UIUserNotificationActivationModeBackground;
        //需要解锁才能处理，如果action2.activationMode = UIUserNotificationActivationModeBackground则这个属性呗忽略
        action2.authenticationRequired = YES;
        action2.destructive = YES;
        UIMutableUserNotificationCategory  *categorys = [[UIMutableUserNotificationCategory alloc] init];
        //这组动作的唯一标示
        categorys.identifier = @"category1";
        [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
        [UMessage registerForRemoteNotifications];
    }
    if ([OTWUtils system_version_greater_less_than:8.0]) {
        DLog(@"进来了%@",@"版本82");
        [UMessage registerForRemoteNotifications];
    }
    //初始化
    [UMessage registerForRemoteNotifications];
    //开启log
    [UMessage setLogEnabled:YES];
    
}

#pragma mark iOS10新增：处理前台收到通知的代理方法
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    NSDictionary *userInfo = notification.request.content.userInfo;
    if ([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //关闭友盟自带的弹出框
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
    } else {
        //应用处于前台时的本地推送接受
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNAuthorizationOptionSound | UNAuthorizationOptionBadge | UNAuthorizationOptionAlert);
}

#pragma mark iOS10新增：处理后台点击通知的代理方法
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    if ([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
    } else {
        //应用处于后台时的本地推送接受
    }
}

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [UMessage sendClickReportForRemoteNotification:self.userInfo];
}


@end
