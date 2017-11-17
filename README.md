# TPShare
支付宝、微信、微博、QQ平台的登录分享及支付

11.17 -- `更新完成QQ登录与分享回调`

 DEMO 主要是把每一个三方平台独立为一个helper，关于三方的注册，分享，登录，以及`openURL`的调用，全是在helper中实现的，个别独立参数通过传值实现，而helper中实现的上述方法通过协议`TPPlatformProtocol`定义，回调完成的参数返回通过协议`TPPlatformStateDelegate`实现，个人觉得这样的好处是板块独立，方便以后添加新的三方平台，或者移除某些平台。`ThreepartiesHelper`用于外部调用注册、回调URL、登录及分享

############ 使用方法 ##############
``` 回调URL
/**
    Appdelegate 
 */
+ (void)openWithURL:(NSURL *)url;

```

```
/**
 注册三方平台appkey

 @param activePlatforms 需要注册平台的TPPlatformType
 @param importHandler 回调平台TPPlatformType, 且返回值为appkey
 */
+ (void)registerActivePlatforms:(NSArray *)activePlatforms
                 onImportAppKey:(NSString *(^)(TPPlatformType platformType))importHandler;

```

```
/**
 三方分享

 @param type 平台类型
 @param title 标题
 @param description 描述
 @param imageName 图片名字／url
 @param shareUrl 链接
 @param scene 该平台下的场景 qq/wechat is need
  */
+ (void)shareMessageWithType:(TPPlatformType)type
                       title:(NSString *)title
                 description:(NSString *)description
                   imageName:(NSString *)imageName
                    shareUrl:(NSString *)shareUrl
                       scene:(int)scene
           shareStateChanged:(TPShareHandler)stateChangedHandler;

```

```
/**
 三方登录

 @param type 三方类型
 @param stateChangedHandler 登录状态回调
 */
+ (void)loginWithType:(TPPlatformType)type
       platformAccont:(TPAccountModel *)platformAccont
    loginStateChanged:(TPGetUserHandler)stateChangedHandler;

```

