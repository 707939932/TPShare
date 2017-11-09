//
//  ThreepartiesHelper.m
//  SearchNet
//
//  Created by Me on 2017/11/6.
//  Copyright © 2017年 Me. All rights reserved.
//

#import "ThreepartiesHelper.h"
#import "AlipayHelper.h"
#import "WeiboHelper.h"
#import "WechatHelper.h"
#import "TencentHelper.h"

@interface ThreepartiesHelper ()<TPPlatformStateDelegate>

// 用户信息
@property (nonatomic, copy) TPGetUserHandler userHandler;
// 分享
@property (nonatomic, copy) TPShareHandler shareHandler;

@property (nonatomic, strong) WeiboHelper *weibo;
@property (nonatomic, strong) WechatHelper *wechat;
@property (nonatomic, strong) TencentHelper *tencent;

@end

static ThreepartiesHelper *_helper = nil;

@implementation ThreepartiesHelper

+ (instancetype)sharedHelper {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _helper = [[ThreepartiesHelper alloc] init];
        [_helper setPlatformDelegate];
    });
    return _helper;
}

- (void)setPlatformDelegate {
    _helper.weibo = [[WeiboHelper alloc] init];
    _helper.weibo.delegate = self;
    
    _helper.wechat = [[WechatHelper alloc] init];
    _helper.wechat.delegate = self;
    
    _helper.tencent = [[TencentHelper alloc] init];
    _helper.tencent.delegate = self;
    
}

#pragma mark - 平台注册
+ (void)registerActivePlatforms:(NSArray *)activePlatforms onImportAppKey:(NSString *(^)(TPPlatformType platformType))importHandler {

    [activePlatforms enumerateObjectsUsingBlock:^(NSNumber   * _Nonnull platforms, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *importKey = importHandler(platforms.unsignedIntegerValue);
        switch (platforms.unsignedIntegerValue) {
            case TPPlatformTypeQQ:
                [[ThreepartiesHelper sharedHelper].tencent registerAppWithKey:importKey];
                break;
            case TPPlatformTypeWechat:
                [[ThreepartiesHelper sharedHelper].wechat registerAppWithKey:importKey];
                break;
            case TPPlatformTypeWeibo:
                [[ThreepartiesHelper sharedHelper].weibo registerAppWithKey:importKey];
                break;

            default:
                break;
        }

    }];
    
}

#pragma mark - 回调URL
+ (void)openWithURL:(NSURL *)url {
    
    // alipay
    if ([url.host isEqualToString:@"safepay"]) {
        [AlipayHelper disposeAlipayURL:url];
    }
    
    // wechat
    if([url.scheme compare:kWechatAppKey] == NSOrderedSame)
    {
        [[ThreepartiesHelper sharedHelper].wechat disposePlatformURL:url];
    }
    
    // weibo
    if([url.scheme compare:[@"wb" stringByAppendingString:kWeiboAppKey]] == NSOrderedSame)
    {
        [[ThreepartiesHelper sharedHelper].weibo disposePlatformURL:url];
    }
 
    // qq
    if([url.scheme compare:[@"tencent" stringByAppendingString:kqqAppKey]] == NSOrderedSame)
    {
        [[ThreepartiesHelper sharedHelper].tencent disposePlatformURL:url];
    }

}


#pragma mark - 分享
+ (void)shareMessageWithType:(TPPlatformType)type
                       title:(NSString *)title
                 description:(NSString *)description
                   imageName:(NSString *)imageName
                    shareUrl:(NSString *)shareUrl
                       scene:(int)scene
           shareStateChanged:(TPShareHandler)stateChangedHandler {

    UIImage *sImage = nil;
    if ([imageName hasPrefix:@"http"]) {
        sImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageName]]];
    }else {
        sImage = [UIImage imageNamed:imageName];
    }
    
    switch (type) {
        case TPPlatformTypeQQ:
            [[ThreepartiesHelper sharedHelper].tencent platformShareWithTitle:title description:description shareUrl:shareUrl sImage:sImage scene:scene];
            break;
        case TPPlatformTypeWeibo:
            [[ThreepartiesHelper sharedHelper].weibo platformShareWithTitle:title description:description shareUrl:shareUrl sImage:sImage scene:0];
            break;
        case TPPlatformTypeWechat:
            [[ThreepartiesHelper sharedHelper].wechat platformShareWithTitle:title description:description shareUrl:shareUrl sImage:sImage scene:scene];
            break;

        default:
            break;
    }
    
    // 回调分享信息
    [ThreepartiesHelper sharedHelper].shareHandler = ^(TPResponseState state, NSString *message) {
      
        !stateChangedHandler?:stateChangedHandler(state, message);

    };
}

#pragma mark - 登录
+ (void)loginWithType:(TPPlatformType)type
       platformAccont:(TPAccountModel *)platformAccont
    loginStateChanged:(TPGetUserHandler)stateChangedHandler {
    
    switch (type) {
        case TPPlatformTypeQQ:
            [[ThreepartiesHelper sharedHelper].tencent platformLogin];
            break;
        case TPPlatformTypeWeibo:
            [[ThreepartiesHelper sharedHelper].weibo platformLogin];
            break;
        case TPPlatformTypeWechat:
            [[ThreepartiesHelper sharedHelper].wechat platformLoginWithPlatformAccont:platformAccont];
            break;

        default:
            break;
    }
    
     // 回调用户信息 状态 ...
     [ThreepartiesHelper sharedHelper].userHandler = ^(TPResponseState state, NSString *message, TPUserInfoModel *user) {
         
         !stateChangedHandler?:stateChangedHandler(state, message, user);
         
     };

}

#pragma mark - 平台信息回调
// TPPlatformStateDelegate
- (void)platformLoginStateChanged:(TPResponseState)state message:(NSString *)message user:(TPUserInfoModel *)user {
    ![ThreepartiesHelper sharedHelper].userHandler?:[ThreepartiesHelper sharedHelper].userHandler(state, message, user);
}
- (void)platformShareStateChanged:(TPResponseState)state message:(NSString *)message {
    ![ThreepartiesHelper sharedHelper].shareHandler?:[ThreepartiesHelper sharedHelper].shareHandler(state, message);
}


@synthesize delegate;

@end
