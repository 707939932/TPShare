//
//  TPPlatformStateDelegate.h
//  SearchNet
//
//  Created by Me on 2017/11/8.
//  Copyright © 2017年 Me. All rights reserved.
//

#import <Foundation/Foundation.h>

// 状态变化协议

@protocol TPPlatformStateDelegate <NSObject>

@property (nonatomic, weak) id<TPPlatformStateDelegate> delegate;

@optional

- (void)platformLoginStateChanged:(TPResponseState)state message:(NSString *)message user:(TPUserInfoModel *)user;

- (void)platformShareStateChanged:(TPResponseState)state message:(NSString *)message;


@end
