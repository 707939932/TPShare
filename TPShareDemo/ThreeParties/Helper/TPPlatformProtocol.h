//
//  TPPlatformProtocol.h
//  SearchNet
//
//  Created by Me on 2017/11/8.
//  Copyright © 2017年 Me. All rights reserved.
//

#ifndef TPPlatformProtocol_h
#define TPPlatformProtocol_h

/**
 三方响应类型 (这里只是简单的处理，详细错误信息看该平台的错误码)
 */
typedef NS_ENUM(NSInteger, TPResponseState) {
    TPResponseStateSuccess    = 0,      // 成功
    TPResponseStateUnknown     = -1,     // 未知
    TPResponseStateCancel     = -2,     // 取消
    TPResponseStateFail       = -3,      // 失败
};



@protocol TPPlatformProtocol <NSObject>

/**
 注册三方应用
 
 @param appKey appid
 */
- (void)registerAppWithKey:(NSString *)appKey;

/**
 处理三方平台URL
 
 @param url 回调URL
 */
- (void)disposePlatformURL:(NSURL *)url;

@optional

/**
 三方登录
 */
- (void)platformLogin;


/**
 三方登录
 
 @param platformAccont 开发者账号信息
 */
- (void)platformLoginWithPlatformAccont:(TPAccountModel *)platformAccont;


/**
 分享
 
 @param title 标题
 @param description 描述
 @param shareUrl URL
 @param sImage 图片
 @param scene //WXScene 场景
 */
- (void)platformShareWithTitle:(NSString *)title
                 description:(NSString *)description
                    shareUrl:(NSString *)shareUrl
                      sImage:(UIImage *)sImage
                       scene:(int)scene;



@end




#endif /* TPPlatformProtocol_h */
