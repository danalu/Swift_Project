//
//  ViewController.m
//  OCBridgeSwift
//
//  Created by DanaLu on 2018/4/27.
//  Copyright © 2018年 gh. All rights reserved.
//

#import "ViewController.h"
#import "OCBridgeSwift-Swift.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    TestOne *testOne = [[TestOne alloc] init];
    [testOne desc];
    
    TestTwo *testTwo = [[TestTwo alloc] init];
//    [testTwo setObject:1 atIndexedSubscript:0];
//    [testTwo setObject:2 atIndexedSubscript:0];
    [testTwo push:1];
    [testTwo push:2];
    NSLog(@"%@", testTwo.items);
    [testTwo pop];
    NSLog(@"%d", [testTwo objectAtIndexedSubscript:0]);
    
    NSError *error;
    [TestTwo testThrowAndReturnError:&error];
    NSLog(@"%@", error);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
