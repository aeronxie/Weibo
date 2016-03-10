//
//  AppDelegate.m
//  Weibo
//
//  Created by Fay on 15/9/13.
//  Copyright (c) 2015年 Fay. All rights reserved.
//

#import "AppDelegate.h"
#import "XFTabBarViewController.h"
#import "XFNewFeatureController.h"
#import "XFOAuthController.h"
#import "XFAccount.h"
#import "XFAccountTool.h"
#import "UIWindow+Extension.h"
#import "SDWebImageManager.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
     // 创建窗口
    self.window = [[UIWindow alloc]init];
    self.window.frame = [UIScreen mainScreen].bounds;
    
    //设置根控制器
    XFAccount *account = [XFAccountTool account];
    
    // 显示窗口
    [self.window makeKeyAndVisible];
    
    if (account) {
        
        [self.window switchRootViewController];
    
    } else{
        
        self.window.rootViewController = [[XFOAuthController alloc]init];
    }
    
    // 显示窗口
    [self.window makeKeyAndVisible];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

/**
 *  当app进入后台时调用
 */

- (void)applicationDidEnterBackground:(UIApplication *)application {
      
    /**
     *  app的状态
     *  1.死亡状态：没有打开app
     *  2.前台运行状态
     *  3.后台暂停状态：停止一切动画、定时器、多媒体、联网操作，很难再作其他操作
     *  4.后台运行状态
     */
    // 向操作系统申请后台运行的资格，能维持多久，是不确定的
    __block UIBackgroundTaskIdentifier task = [application beginBackgroundTaskWithExpirationHandler:^{
        // 当申请的后台运行时间已经结束（过期），就会调用这个block
        
        // 赶紧结束任务
        [application endBackgroundTask:task];
    }];
    
    // 在Info.plst中设置后台模式：Required background modes == App plays audio or streams audio/video using AirPlay
    // 搞一个0kb的MP3文件，没有声音
    // 循环播放
    
    // 以前的后台模式只有3种
    // 保持网络连接
    // 多媒体应用
    // VOIP:网络电话

    
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

-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
   
    SDWebImageManager *mgr = [SDWebImageManager sharedManager];
    //取消下载
    [mgr cancelAll];
    //清空缓存
    [mgr.imageCache clearMemory];
    
}

@end
