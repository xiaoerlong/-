//
//  StoryViewController.m
//  HHRouterExample
//
//  Created by Light on 14-3-14.
//  Copyright (c) 2014年 Huohua. All rights reserved.
//

#import "StoryViewController.h"
#import "HHRouter.h"

@interface StoryViewController ()

@end

@implementation StoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

    [[HHRouter shared] map:@"/user/add/"
                   toBlock:^id(NSDictionary* params) {
        NSLog(@"%@", params);
       dispatch_semaphore_signal(semaphore);
        return nil;
    }];

    /**
     HHRouterBlock returnBlock = ^id(NSDictionary *aParams) {
             if (routerBlock) {
                 NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:params];
                 [dic addEntriesFromDictionary:aParams];
                 return routerBlock([NSDictionary dictionaryWithDictionary:dic].copy);
             }
             return nil;
         };
     */
    HHRouterBlock block = [[HHRouter shared] matchBlock:@"/user/add/?a=1&b=2"];
    block(@{@"c": @(4)});
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW)) {
        [[NSRunLoop currentRunLoop]
               runMode:NSDefaultRunLoopMode
            beforeDate:[NSDate dateWithTimeIntervalSinceNow:5]];
    }
    [[HHRouter shared] callBlock:@"/user/add/?a=1&b=2"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
