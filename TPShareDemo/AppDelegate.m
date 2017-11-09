//
//  AppDelegate.m
//  TPShareDemo
//
//  Created by Me on 2017/11/8.
//  Copyright © 2017年 Me. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [ThreepartiesHelper registerActivePlatforms:@[
                                                  @(TPPlatformTypeQQ),
                                                  @(TPPlatformTypeWeibo),
                                                  @(TPPlatformTypeWechat)
                                                  ]
                                 onImportAppKey:^NSString *(TPPlatformType platformType) {
        switch (platformType) {
            case TPPlatformTypeQQ:
                return kqqAppKey;
                break;
            case TPPlatformTypeWechat:
                return kWechatAppKey;
                break;
            case TPPlatformTypeWeibo:
                return kWeiboAppKey;
                break;

            default:
                return @"";
                break;
        }
    }];
    return YES;
}


#pragma mark - // 三方回调
// iOS9.0 之前
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    [ThreepartiesHelper openWithURL:url];
    return YES;
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    [ThreepartiesHelper openWithURL:url];
    return YES;
}

// iOS9.0 之后
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    [ThreepartiesHelper openWithURL:url];
    return YES;
}




@end
