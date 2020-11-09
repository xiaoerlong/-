//
//  JYBRoute.h
//  RouteTest
//
//  Created by kim on 2020/11/9.
//  Copyright © 2020 kim. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^JYBRouterHandler)(NSDictionary *params);

@interface JYBRoute : NSObject
// 注册
+ (void)registerRouterPattern:(NSString *)urlPattern handler:(JYBRouterHandler)handler;

// 查找
+ (void)openUrl:(NSString *)urlPattern;
@end

NS_ASSUME_NONNULL_END
