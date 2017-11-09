//
//  UIViewController+WeChatAndAliPayMethod.h


#import <UIKit/UIKit.h>

@protocol WeChatAndAliPayMethodDelegate <NSObject>

- (void)handlePaymentResult:(BOOL)isSuccess message:(NSString *)message;

@end

@interface UIViewController (WeChatAndAliPayMethod)

/**
 *  微信支付－－－服务器统一支付
 *
 *  @param prepayInfo 参数
 */
- (void)weChatPayWithPrepayInfo:(NSDictionary *)prepayInfo;

/**
 *  支付宝支付－－－服务器
 *
 *  @param orderString 参数
 */
- (void)aliPayWithOrderString:(NSString *)orderString;




@end
