//
//  ThreepartiesModel.h
//  SearchNet
//
//  Created by Me on 2017/11/6.
//  Copyright © 2017年 Me. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThreepartiesModel : NSObject
@end

@interface TPAccountModel : NSObject

// qq为AppID AppKey，weibo为AppKey AppSecret， weixin为AppID AppSecret
// 执行属性替换
@property (nonatomic, copy) NSString *appId;
@property (nonatomic, copy) NSString *appSecret;

@end


// 把三方信息用户换成通用 Model
@interface TPUserInfoModel : NSObject

// 执行属性替换
// wechat为headimgurl， weibo为profile_image_url， qq为figureurl_qq_2
@property (nonatomic, copy) NSString *headimgurl;

// wechat为nickname， weibo为name， qq为nickname
@property (nonatomic, copy) NSString *nickname;

// wechat为sex， weibo为gender， qq为gender
@property (nonatomic, assign) NSInteger sex;

// wechat 不更改， weibo为id， qq为openid
@property (nonatomic, copy) NSString *uid;

// 以下为微信用户信息
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *country;
@property (nonatomic, copy) NSString *language;
@property (nonatomic, copy) NSString *openid;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *unionid;

@end

