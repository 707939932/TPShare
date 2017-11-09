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
    TencentOAuth *_qqAuth;
}
@end

@implementation TencentHelper
@synthesize delegate;


- (void)registerAppWithKey:(NSString *)appKey {
    _qqAuth = [[TencentOAuth alloc] initWithAppId:appKey andDelegate:self];
    _qqAuth.redirectURI = kRedirectURI;
}

- (void)disposePlatformURL:(NSURL *)url {

    if ([self conformsToProtocol:@protocol(TencentSessionDelegate)])
    {
        [TencentOAuth HandleOpenURL:url];
    }
}


#pragma mark - // TencentSessionDelegate
// qq SDK自带回调的方法
- (void)tencentDidLogin {
    
}
- (void)tencentDidNotLogin:(BOOL)cancelled {
    
}
- (void)tencentDidNotNetWork {
    
}
- (void)getUserInfoResponse:(APIResponse *)response {
    
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
    [_qqAuth authorize:@[@"get_user_info", @"get_simple_userinfo", @"add_t"] inSafari:NO];
}


@end
