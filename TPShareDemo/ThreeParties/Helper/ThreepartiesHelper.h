//
//  ThreepartiesHelper.h
//  SearchNet
//
//  Created by Me on 2017/11/6.
//  Copyright © 2017年 Me. All rights reserved.
//


#import <Foundation/Foundation.h>

/**
 三方支持类型
 */
typedef NS_ENUM(NSUInteger, TPPlatformType) {
    TPPlatformTypeQQ = 0,
    TPPlatformTypeWeibo = 1,
    TPPlatformTypeWechat = 2
};


/**
 三方用户信息回调
 */
typedef void(^TPGetUserHandler)(TPResponseState state, NSString *message ,TPUserInfoModel *user);

/**
 三方分享回调
*/
typedef void(^TPShareHandler)(TPResponseState state, NSString *message);


@interface ThreepartiesHelper : NSObject

/**
    Appdelegate 
 */
+ (void)openWithURL:(NSURL *)url;



/**
 注册三方平台appkey

 @param activePlatforms 需要注册平台的TPPlatformType
 @param importHandler 回调平台TPPlatformType, 且返回值为appkey
 */
+ (void)registerActivePlatforms:(NSArray *)activePlatforms
                 onImportAppKey:(NSString *(^)(TPPlatformType platformType))importHandler;



/**
 三方分享

 @param type 平台类型
 @param title 标题
 @param description 描述
 @param imageName 图片名字／url
 @param shareUrl 链接
 @param scene 该平台下的场景 qq/wechat is need
  */
+ (void)shareMessageWithType:(TPPlatformType)type
                       title:(NSString *)title
                 description:(NSString *)description
                   imageName:(NSString *)imageName
                    shareUrl:(NSString *)shareUrl
                       scene:(int)scene
           shareStateChanged:(TPShareHandler)stateChangedHandler;

/**
 三方登录

 @param type 三方类型
 @param stateChangedHandler 登录状态回调
 */
+ (void)loginWithType:(TPPlatformType)type
       platformAccont:(TPAccountModel *)platformAccont
    loginStateChanged:(TPGetUserHandler)stateChangedHandler;


@end
