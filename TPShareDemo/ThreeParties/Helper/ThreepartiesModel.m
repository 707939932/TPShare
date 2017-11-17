//
//  ThreepartiesModel.m
//  SearchNet
//
//  Created by Me on 2017/11/6.
//  Copyright © 2017年 Me. All rights reserved.
//

#import "ThreepartiesModel.h"

@implementation ThreepartiesModel
@end


@implementation TPAccountModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{
             @"appId":@[@"AppID",@"AppKey",@"AppID"],
             @"appSecret":@[@"AppKey",@"AppSecret",@"AppSecret"]
             };
}


@end

@implementation TPUserInfoModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{
             @"face":@[@"headimgurl",@"profile_image_url",@"headimgurl",@"figureurl_qq_2"],
             @"uid":@[@"id",@"openid",@"uid"],
             @"nickname":@[@"name",@"nickname"],
             @"sex":@[@"gender",@"sex"]
             };
    
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"headimgurl == %@ \n  nickename == %@ \n  sex == %ld", self.headimgurl, self.nickname, (long)self.sex];
}

@end
