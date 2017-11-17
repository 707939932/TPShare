//
//  TencentHelper.m
//  SearchNet
//
//  Created by Me on 2017/11/8.
//  Copyright © 2017年 Me. All rights reserved.
//

#import "TencentHelper.h"

@interface TencentHelper ()
{
    // qq 授权对象
    TencentOAuth *_tencentAuth;
}
@end

@implementation TencentHelper
@synthesize delegate;


- (void)registerAppWithKey:(NSString *)appKey {
    _tencentAuth = [[TencentOAuth alloc] initWithAppId:appKey andDelegate:self];
    _tencentAuth.redirectURI = kRedirectURI;
}

- (void)disposePlatformURL:(NSURL *)url {

    if ([self conformsToProtocol:@protocol(TencentSessionDelegate)])
    {
        [TencentOAuth HandleOpenURL:url];
    }
}


#pragma mark - // TencentSessionDelegate
//  SDK自带回调的方法
- (void)tencentDidLogin {
    [_tencentAuth getUserInfo];
}
- (void)tencentDidNotLogin:(BOOL)cancelled {
    TPResponseState code;
    NSString *message;
    if (cancelled) {
        // 用户取消
        code = TPResponseStateCancel;
        message = kTipsTPCancel;
    }else {
        // 登录失败
        code = TPResponseStateUnknown;
        message = kTipsTPUnknow;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(platformLoginStateChanged:message:user:)]) {
        [self.delegate platformLoginStateChanged:code message:message user:nil];
    }
    
}
- (void)tencentDidNotNetWork {
    if (self.delegate && [self.delegate respondsToSelector:@selector(platformLoginStateChanged:message:user:)]) {
        [self.delegate platformLoginStateChanged:-1 message:@"网络异常" user:nil];
    }
}
//
- (void)getUserInfoResponse:(APIResponse *)response {
    if (response.retCode == 0) {
        NSMutableDictionary *mResp = [response.jsonResponse mutableCopy];
        NSString *gender = mResp[@"gender"];
        gender = [gender isEqualToString:@"男"] ? @"1":([gender isEqualToString:@"女"]?@"2":@"0");
        [mResp addEntriesFromDictionary:@{@"gender":gender,@"openid":_tencentAuth.openId,@"uid":_tencentAuth.openId}];
        TPUserInfoModel *model = [TPUserInfoModel yy_modelWithJSON:mResp];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(platformLoginStateChanged:message:user:)]) {
            [self.delegate platformLoginStateChanged:TPResponseStateSuccess message:kTipsTPSuccess user:model];
        }
        
    }
}


#pragma mark - 分享
- (void)platformShareWithTitle:(NSString *)title description:(NSString *)description shareUrl:(NSString *)shareUrl sImage:(UIImage *)sImage scene:(int)scene {

    QQApiURLObject *newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:shareUrl] title:title description:description previewImageData:UIImageJPEGRepresentation(sImage, .8) targetContentType:QQApiURLTargetTypeNews];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    
    if (scene == 0) {
        //将内容分享到qq
        [QQApiInterface sendReq:req];
    }else {
        //将内容分享到qzone
        [QQApiInterface SendReqToQZone:req];
    }

}

#pragma mark - 登录
- (void)platformLogin {
    [_tencentAuth authorize:@[@"get_user_info", @"get_simple_userinfo", @"add_t"] inSafari:NO];
}


@end
