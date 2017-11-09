//
//  AlipayHelper.m
//  SearchNet
//
//  Created by Me on 2017/11/8.
//  Copyright © 2017年 Me. All rights reserved.
//

#import "AlipayHelper.h"

@implementation AlipayHelper


+ (void)disposeAlipayURL:(NSURL *)url {
    
    //跳转支付宝钱包进行支付，处理支付结果
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        
        if ([[resultDic objectForKey:@"resultStatus"] isEqual:@"9000"]) {
            //支付成功
            [[NSNotificationCenter defaultCenter] postNotificationName:ALI_PAY_RESULT object:ALIPAY_SUCCESSED userInfo:resultDic];
            
        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName:ALI_PAY_RESULT object:ALIPAY_FAILED userInfo:resultDic];
        }
        
    }];
    
}


@end
