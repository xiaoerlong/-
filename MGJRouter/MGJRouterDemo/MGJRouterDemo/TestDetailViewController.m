//
//  TestDetailViewController.m
//  MGJRouterDemo
//
//  Created by kim on 2020/11/3.
//  Copyright © 2020 juangua. All rights reserved.
//

#import "TestDetailViewController.h"
#import "MGJRouter.h"

@interface TestDetailViewController ()

@end

@implementation TestDetailViewController

+ (void)load {
    [MGJRouter registerURLPattern:@"mgj://detail?id=:id" toHandler:^(NSDictionary *routerParameters) {
        NSLog(@"routerParameters:%@", routerParameters);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%ld", self.identifier);
}



@end
