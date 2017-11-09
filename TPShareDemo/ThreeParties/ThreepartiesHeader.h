//
//  ThreepartiesHeader.h
//  SearchNet
//
//  Created by Me on 2017/11/2.
//  Copyright © 2017年 Me. All rights reserved.
//

#ifndef ThreepartiesHeader_h
#define ThreepartiesHeader_h


#define kURLScheme @"kURLScheme"

// weixin
#import "WXApi.h"
#define kWechatAppKey          @"11111111111"

#define WX_PAY_RESULT   @"weixin_pay_result"
#define WXPAY_SUCCESSED    @"wechat_pay_isSuccessed"
#define WXPAY_FAILED       @"wechat_pay_isFailed"


// ali
#import <AlipaySDK/AlipaySDK.h>

#define ALI_PAY_RESULT      @"ali_pay_result"
#define ALIPAY_SUCCESSED    @"ali_pay_isSuccessed"
#define ALIPAY_FAILED       @"ali_pay_isFailed"

// weibo
#import <WeiboSDK.h>

#define kWeiboAppKey @"11111111111"
#define kRedirectURI @"https://www.souza.cn"

// qq
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/QQApiInterface.h>

#define kqqAppKey @"11111111111"


// helper
#import "UIViewController+WeChatAndAliPayMethod.h"
#import "ThreepartiesModel.h"
#import "RequestHelper.h"
#import "TPPlatformProtocol.h"
#import "TPPlatformStateDelegate.h"
#import "ThreepartiesHelper.h"


#endif /* ThreepartiesHeader_h */
