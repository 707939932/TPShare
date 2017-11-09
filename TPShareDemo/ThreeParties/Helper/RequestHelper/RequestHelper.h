//
//  RequestHelper.h
//  SearchNet
//
//  Created by Me on 2017/11/8.
//  Copyright © 2017年 Me. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestHelper : NSObject


/**
 auth 2.0 信息获取

 @param URL 对应平台的URL
 @param params 参数
 @param resultBlock 返回的信息
 */
+ (void)requestWithURL:(NSString *)URL
                params:(NSDictionary *)params
           resultBlock:(void(^)(id response))resultBlock;


@end
