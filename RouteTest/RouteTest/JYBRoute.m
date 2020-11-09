//
//  JYBRoute.m
//  RouteTest
//
//  Created by kim on 2020/11/9.
//  Copyright © 2020 kim. All rights reserved.
//

#import "JYBRoute.h"

@interface JYBRoute ()
@property (nonatomic, strong) NSMutableDictionary *routes;
@end

@implementation JYBRoute
+ (instancetype)shareInstance {
    static JYBRoute *route = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        route = [[JYBRoute alloc] init];
    });
    return route;
}

+ (void)registerRouterPattern:(NSString *)urlPattern handler:(JYBRouterHandler)handler {
    // 1.将pattern解析得到路径数组
    if (urlPattern.length == 0) {
        return;
    }
    NSMutableArray *pathComponents = @[].mutableCopy;
    NSArray <NSString *>* urls = [urlPattern componentsSeparatedByString:@"://"];
    if (urls.count > 0) {
        [pathComponents addObject:urls.firstObject];
        urlPattern = urls.lastObject;
        if (urlPattern.length == 0) {
            [pathComponents addObject:@"~"];
        }
    }
    
    for (NSString *pathComponent in [NSURL URLWithString:urlPattern].pathComponents) {
        if ([pathComponent isEqualToString:@"/"]) {
            continue;
        }
        if ([[pathComponent substringToIndex:1] isEqualToString:@"?"]) {
            break;
        }
        [pathComponents addObject:pathComponent];
    }
    
    // 2.存储到字典
    JYBRoute *route = [self shareInstance];
    NSMutableDictionary *subRoutes = route.routes;
    for (NSString *key in pathComponents) {
        if ([subRoutes objectForKey:key] == nil) {
            subRoutes[key] = [[NSMutableDictionary alloc] init];
        }
        subRoutes = subRoutes[key];
    }
    if (subRoutes && handler) {
        subRoutes[@"_"] = [handler copy];
    }
}

// 查找
+ (void)openUrl:(NSString *)urlPattern {
    // 1.将pattern解析得到路径数组
    if (urlPattern.length == 0) {
        return;
    }
    NSMutableArray *pathComponents = @[].mutableCopy;
    NSArray <NSString *>* urls = [urlPattern componentsSeparatedByString:@"://"];
    if (urls.count > 0) {
        [pathComponents addObject:urls.firstObject];
        urlPattern = urls.lastObject;
        if (urlPattern.length == 0) {
            [pathComponents addObject:@"~"];
        }
    }
    for (NSString *pathComponent in [[NSURL alloc] initWithString:urlPattern].pathComponents) {
        if ([pathComponent isEqualToString:@"/"]) {
            continue;
        }
        if ([pathComponent isEqualToString:@"?"]) {
            break;
        }
        [pathComponents addObject:pathComponent];
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    // 2.查找匹配的字典
    BOOL find = NO;
    JYBRoute *route = [self shareInstance];
    NSMutableDictionary *subRoutes = route.routes;
    for (NSString *pathComponent in pathComponents) {
        for (NSString *key in subRoutes.allKeys) {
            if ([key isEqualToString:pathComponent]) {
                find = YES;
                subRoutes = subRoutes[key];
                break;
            } else if ([key hasPrefix:@":"]) {
                NSString *newKey = [key substringFromIndex:1];
                NSString *newPathComponent = pathComponent;
                params[newKey] = newPathComponent;
                find = YES;
                subRoutes = subRoutes[key];
                break;
            }
        }
    }
    
    // 3.填充参数并调用handler
    
    if (subRoutes && subRoutes[@"_"]) {
        JYBRouterHandler handler = subRoutes[@"_"];
        params[@"_"] = handler;
        
        
        [params removeObjectForKey:@"_"];
        if (handler) {
            handler(params);
        }
    }
    
}

- (NSMutableDictionary *)routes {
    if (!_routes) {
        _routes = [[NSMutableDictionary alloc] init];
    }
    return _routes;
}
@end
