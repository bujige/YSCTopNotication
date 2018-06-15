//
//  ViewController.m
//  YSCTopNotication
//
//  Created by WalkingBoy on 2018/6/15.
//  Copyright © 2018年 Walking Boy. All rights reserved.
//

#import "ViewController.h"
#import "YSCTopNotication.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [YSCTopNotication showMessage:@"hahaha"];
}


@end
