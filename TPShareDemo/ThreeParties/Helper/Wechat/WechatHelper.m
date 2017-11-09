//
//  WechatHelper.m
//  SearchNet
//
//  Created by Me on 2017/11/8.
//  Copyright © 2017年 Me. All rights reserved.
//

#import "WechatHelper.h"

@interface WechatHelper ()

@property (nonatomic, strong) TPAccountModel *accountModel;

@end

@implementation WechatHelper
@synthesize delegate;

- (void)registerAppWithKey:(NSString *)appKey {
    [WXApi registerApp:appKey enableMTA:NO];
}

- (void)disposePlatformURL:(NSURL *)url {

    if ([self conformsToProtocol:@protocol(WXApiDelegate)])
    {
        [WXApi handleOpenURL:url delegate:self];
    }

}

#pragma mark - // WXApiDelegate
// 微信SDK自带的方法，处理从微信客户端完成操作后返回程序之后的回调方法
- (void)onResp:(BaseResp *)resp {
    // 支付
    if([resp isKindOfClass:[PayResp class]]) {
        switch (resp.errCode) {
            case WXSuccess:
                //如果支付成功的话，全局发送一个通知，支付成功
                [[NSNotificationCenter defaultCenter] postNotificationName:WX_PAY_RESULT object:WXPAY_SUCCESSED userInfo:@{@"code":[NSString  stringWithFormat:@"%d", resp.errCode]}];
                break;
            default:
                //如果支付失败的话，全局发送一个通知，支付失败
                [[NSNotificationCenter defaultCenter] postNotificationName:WX_PAY_RESULT object:WXPAY_FAILED userInfo:@{@"code":[NSString  stringWithFormat:@"%d", resp.errCode]}];
                break;
        }
    }
    
    
    NSInteger code = (resp.errCode == 0 || resp.errCode == -2 || resp.errCode == -3) ? resp.errCode : -1;
    
    // 分享
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {

        if (self.delegate && [self.delegate respondsToSelector:@selector(platformShareStateChanged:message:)]) {
            [self.delegate platformShareStateChanged:code message:@""];
        }

    }
    
    // 登陆
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp *authResp = (SendAuthResp *)resp;
        
        if (authResp.code) {
            // 授权成功
            
            NSDictionary *accParams = @{
                                        @"appid":self.accountModel.appId,
                                        @"secret":self.accountModel.appSecret,
                                        @"code":authResp.code,
                                        @"grant_type":@"authorization_code"
                                        };
            
            // 获取access_token
            [RequestHelper requestWithURL:@"https://api.weixin.qq.com/sns/oauth2/access_token" params:accParams resultBlock:^(id response) {
                if (response) {
                    
                    NSDictionary *infoParams = @{
                                                 @"access_token":response[@"access_token"],
                                                 @"openid":response[@"openid"]
                                                 };
                    
                    // 获取userinfo //unionid
                    [RequestHelper requestWithURL:@"https://api.weixin.qq.com/sns/userinfo" params:infoParams resultBlock:^(id response) {
                        if (response) {
                            
                            TPUserInfoModel *user = [TPUserInfoModel yy_modelWithJSON:response];
                            
                            if (self.delegate && [self.delegate respondsToSelector:@selector(platformLoginStateChanged:message:user:)]) {
                                [self.delegate platformLoginStateChanged:code message:@"" user:user];
                            }
                        }
                    }];
                }
            }];
            
        }else {
         
            // 授权失败
            if (self.delegate && [self.delegate respondsToSelector:@selector(platformLoginStateChanged:message:user:)]) {
                [self.delegate platformLoginStateChanged:code message:@"" user:nil];
            }

        }
    }
    
}


#pragma mark - 分享
- (void)platformShareWithTitle:(NSString *)title
                description:(NSString *)description
                   shareUrl:(NSString *)shareUrl
                      sImage:(UIImage *)sImage
                       scene:(int)scene {

    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    [message setThumbImage:sImage];
    //
    WXWebpageObject *webObj = [WXWebpageObject object];
    webObj.webpageUrl = shareUrl; //分享链接
    message.mediaObject = webObj;
    //
    SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
    sendReq.bText = NO;
    sendReq.message = message;
    sendReq.scene = scene;
    [WXApi sendReq:sendReq];
}

#pragma mark - 登录
- (void)platformLoginWithPlatformAccont:(TPAccountModel *)platformAccont {
    self.accountModel = platformAccont;
    
    SendAuthReq *wAuthReq = [[SendAuthReq alloc] init];
    wAuthReq.scope = @"snsapi_userinfo";
    wAuthReq.state = kURLScheme;
    [WXApi sendReq:wAuthReq];

}

@end
