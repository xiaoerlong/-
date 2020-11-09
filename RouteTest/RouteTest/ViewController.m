//
//  ViewController.m
//  RouteTest
//
//  Created by kim on 2020/11/9.
//  Copyright © 2020 kim. All rights reserved.
//

#import "ViewController.h"
#import "JYBRoute.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"start");
    [self testB];
}

- (void)testA {
    [JYBRoute registerRouterPattern:@"jyb://testA" handler:^(NSDictionary * _Nonnull params) {
        NSLog(@"params:%@", params);
    }];
    
    [JYBRoute openUrl:@"jyb://testA"];
}

- (void)testB {
    [JYBRoute registerRouterPattern:@"jyb://testA/:id" handler:^(NSDictionary * _Nonnull params) {
        NSLog(@"params:%@", params);
    }];
    
    [JYBRoute openUrl:@"jyb://testA/2"];
}

@end
