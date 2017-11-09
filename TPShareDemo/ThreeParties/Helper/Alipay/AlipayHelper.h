//
//  AlipayHelper.h
//  SearchNet
//
//  Created by Me on 2017/11/8.
//  Copyright © 2017年 Me. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlipayHelper : NSObject


/**
处理支付宝URL

 @param url 支付宝回调URL
 */
+ (void)disposeAlipayURL:(NSURL *)url;

@end
