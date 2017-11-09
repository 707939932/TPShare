//
//  UIViewController+WeChatAndAliPayMethod.m

#import "UIViewController+WeChatAndAliPayMethod.h"

@implementation UIViewController (WeChatAndAliPayMethod)

// 服务器返回prepay_id
- (void)weChatPayWithPrepayInfo:(NSDictionary *)prepayInfo
{
    // 调起微信支付
    PayReq* req            = [[PayReq alloc] init];
    req.partnerId            = prepayInfo[@"partnerid"];
    req.prepayId             = prepayInfo[@"prepayid"];
    req.nonceStr            = prepayInfo[@"noncestr"];
    req.timeStamp          = [prepayInfo[@"timestamp"] intValue];
    req.package             = prepayInfo[@"package"];
    req.sign  = prepayInfo[@"sign"];

    [WXApi sendReq:req];
    
    // 添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weChatPayResultNoti:) name:WX_PAY_RESULT object:nil];

}

//支付宝支付
// 服务器处理返回数据
- (void)aliPayWithOrderString:(NSString *)orderString {
    
    /** 支付 */
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:kURLScheme callback:^(NSDictionary *resultDic)
     {
         if ([[resultDic objectForKey:@"resultStatus"] isEqual:@"9000"]) {
             //支付成功
             [[NSNotificationCenter defaultCenter] postNotificationName:ALI_PAY_RESULT object:ALIPAY_SUCCESSED];
             
         }else{
             [[NSNotificationCenter defaultCenter] postNotificationName:ALI_PAY_RESULT object:ALIPAY_FAILED];
         }
     }];
    
    // 添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(aliPayResultNoti:) name:ALI_PAY_RESULT object:nil];

}

//=========================== 分割线 ===============================

#pragma mark - noti
//微信支付付款成功失败
- (void)weChatPayResultNoti:(NSNotification *)noti {
    NSString *message = @"";
    switch ([noti.userInfo[@"code"] intValue]) {
        case -4:// 认证被否决
            message = @"认证被否决";
            break;
        case 0:// 正常返回
            message = @"支付成功";
            break;
        case -1:// 一般错误
            message = @"一般错误";
            break;
        case -3:// 发送失败
            message = @"发送失败";
            break;
        case -5:// 不支持的错误
            message = @"不支持的错误";
            break;
        case -2:// 用户取消
            message = @"用户取消";
            break;
            
    }

    if ([[noti object] isEqualToString:WXPAY_SUCCESSED]) {
        [(UIViewController <WeChatAndAliPayMethodDelegate> *)self handlePaymentResult:YES message:message];
    }else{
        [(UIViewController <WeChatAndAliPayMethodDelegate> *)self handlePaymentResult:NO message:message];
    }
    //上边添加了监听，这里记得移除
    [[NSNotificationCenter defaultCenter] removeObserver:self name:WX_PAY_RESULT object:nil];
    
}

//支付宝支付成功失败
- (void)aliPayResultNoti:(NSNotification *)noti {
    NSString *message = @"";
    if (noti.userInfo[@"memo"]) {
        message = noti.userInfo[@"memo"];
    }
    if ([[noti object] isEqualToString:ALIPAY_SUCCESSED]) {
        [(UIViewController <WeChatAndAliPayMethodDelegate> *)self handlePaymentResult:YES message:message];
    }else{
        [(UIViewController <WeChatAndAliPayMethodDelegate> *)self handlePaymentResult:NO message:message];
    }
    //上边添加了监听，这里记得移除
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ALI_PAY_RESULT object:nil];
}



@end
