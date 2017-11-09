//
//  ViewController.m
//  TPShareDemo
//
//  Created by Me on 2017/11/8.
//  Copyright © 2017年 Me. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)qqLogin:(UIButton *)sender {
    NSLog(@"qqLogin----- %s",__func__);
    [ThreepartiesHelper loginWithType:TPPlatformTypeQQ platformAccont:nil loginStateChanged:^(TPResponseState state, NSString *message, TPUserInfoModel *user) {
        NSLog(@"login -->  state = %ld \n message = %@\n user = %@",state, message, user);
    }];
}

- (IBAction)wechatLogin:(UIButton *)sender {
    NSLog(@"wechatLogin------ %s",__func__);
    TPAccountModel *model;
//    TPAccountModel *model = [[TPAccountModel alloc] init];
//    model.appId = @"111111";
//    model.appSecret = @"1111111";

#warning
    NSAssert(model, @"model 不能为空");
    
    [ThreepartiesHelper loginWithType:TPPlatformTypeWechat platformAccont:model loginStateChanged:^(TPResponseState state, NSString *message, TPUserInfoModel *user) {
        NSLog(@"login -->  state = %ld \n message = %@\n user = %@",state, message, user);
    }];

}

- (IBAction)weiboLogin:(UIButton *)sender {
    NSLog(@"weiboLogin------- %s",__func__);
    [ThreepartiesHelper loginWithType:TPPlatformTypeWeibo platformAccont:nil loginStateChanged:^(TPResponseState state, NSString *message, TPUserInfoModel *user) {
        NSLog(@"login --> state = %ld \n message = %@\n user = %@",state, message, user);
    }];

}


- (IBAction)qqShare:(UIButton *)sender {
    NSLog(@"qqShare---------- %s",__func__);
    // 0 为 qq好友   1 为 qq空间
    [self shareWithType:TPPlatformTypeQQ scene:0];
}

- (IBAction)wechatShare:(UIButton *)sender {
    NSLog(@"wechatShare------  %s",__func__);
    // 0 为 微信好友   1 为 朋友圈
    [self shareWithType:TPPlatformTypeWechat scene:0];

}

- (IBAction)weiboShare:(UIButton *)sender {
    NSLog(@"weiboShare-------  %s",__func__);
    // 微博无 scene 区分
    [self shareWithType:TPPlatformTypeWeibo scene:0];
}

- (IBAction)alipay:(UIButton *)sender {
    NSLog(@"alipay----------- %s",__func__);
    
#warning 本地处理官方demo中有
    NSAssert(0, @"服务器处理订单之后返回的可发起支付的订单编号");
    
    [self aliPayWithOrderString:@""];
}

- (IBAction)wechatpay:(UIButton *)sender {
    NSLog(@"wechatpay-------- %s",__func__);
#warning 本地处理官方demo中有
    NSAssert(0, @"服务器完成统一下单之后的参数集");

    [self weChatPayWithPrepayInfo:@{}];
}

#pragma mark - 分享

- (void)shareWithType:(TPPlatformType)type scene:(int)scene {
    [ThreepartiesHelper shareMessageWithType:type title:@"啥啥啥？" description:@"瓦特阿U弄啥呢？！" imageName:@"测试" shareUrl:@"https://www.baidu.com" scene:scene shareStateChanged:^(TPResponseState state, NSString *message) {
        NSLog(@" shareMessage --> state = %ld \n message = %@ ",state, message);
    }];
}

#pragma mark - 登录





@end
