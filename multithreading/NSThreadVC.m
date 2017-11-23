//
//  NSThreadVC.m
//  multithreading
//
//  Created by HChong on 2017/11/22.
//  Copyright © 2017年 HChong. All rights reserved.
//

#import "NSThreadVC.h"

@interface NSThreadVC ()

@end

@implementation NSThreadVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"NSThread";
    self.view.backgroundColor = [UIColor colorWithRed:0.6 green:0.8 blue:0.5 alpha:1];
    
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
    [thread start];
    
    [NSThread detachNewThreadSelector:@selector(run) toTarget:self withObject:nil];
    
    [self performSelectorInBackground:@selector(run) withObject:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)run {
    NSLog(@"%@", [NSThread currentThread]);
}


@end
