//
//  WeiboHelper.m
//  SearchNet
//
//  Created by Me on 2017/11/8.
//  Copyright © 2017年 Me. All rights reserved.
//

#import "WeiboHelper.h"

@implementation WeiboHelper
@synthesize delegate;

- (void)registerAppWithKey:(NSString *)appKey {
    [WeiboSDK registerApp:appKey];
}

- (void)disposePlatformURL:(NSURL *)url {
    
    if ([self conformsToProtocol:@protocol(WeiboSDKDelegate)])
    {
        [WeiboSDK handleOpenURL:url delegate:self];
    }
}


#pragma mark - // WeiboSDKDelegate
// 微博SDK自带回调的方法
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
    
}
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
    
    NSLog(@"statusCode == %ld",response.statusCode);
    
    // 错误码处理
    NSInteger code = response.statusCode;
    if (code == 0) {
    }else if (code == -1) {
        code = -2;
    }else if (code == -2 || code == -3) {
        code = -3;
    }else {
        code = -1;
    }
    
    
    // 分享
    if ([response isKindOfClass:[WBSendMessageToWeiboResponse class]]) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(platformShareStateChanged:message:)]) {
            [self.delegate platformShareStateChanged:code message:@""];
        }
        
    }
    
    // 登陆
    if ([response isKindOfClass:[WBAuthorizeResponse class]]) {
        WBAuthorizeResponse *authResp = (WBAuthorizeResponse *)response;
        if (authResp.statusCode == WeiboSDKResponseStatusCodeSuccess) {
            NSDictionary *uParams = @{
                                      @"access_token":authResp.accessToken,
                                      @"uid":authResp.userID
                                      };
            [RequestHelper requestWithURL:@"https://api.weibo.com/2/users/show.json" params:uParams resultBlock:^(id response) {
                if (response) {
                    NSMutableDictionary *mResp = [response mutableCopy];
                    NSString *gender = response[@"gender"];
                    gender = [gender isEqualToString:@"m"] ? @"1":([gender isEqualToString:@"f"]?@"2":@"0");
                    [mResp addEntriesFromDictionary:@{@"gender":gender}];
                    
                    TPUserInfoModel *user = [TPUserInfoModel yy_modelWithJSON:mResp.copy];
                    
                    if (self.delegate && [self.delegate respondsToSelector:@selector(platformLoginStateChanged:message:user:)]) {
                        [self.delegate platformLoginStateChanged:code message:@"" user:user];
                    }
        
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
    
    // 图片
    WBImageObject *imageObj = [WBImageObject object];
    imageObj.imageData = UIImageJPEGRepresentation(sImage, .8);
    // 消息体
    WBMessageObject *message = [WBMessageObject message];
    message.text = [NSString stringWithFormat:@"【%@】%@ %@", title, description, shareUrl];
    message.imageObject = imageObj;
    //
    WBSendMessageToWeiboRequest *wbReq = [WBSendMessageToWeiboRequest requestWithMessage:message];
    [WeiboSDK sendRequest:wbReq];

}

#pragma mark - 登录
- (void)platformLogin {
    WBAuthorizeRequest *wbAuthReq = [WBAuthorizeRequest request];
    wbAuthReq.redirectURI = kRedirectURI;
    wbAuthReq.scope = @"all";
    [WeiboSDK sendRequest:wbAuthReq];

}




@end
