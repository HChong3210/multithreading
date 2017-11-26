//
//  OperationVC.m
//  multithreading
//
//  Created by HChong on 2017/11/25.
//  Copyright © 2017年 HChong. All rights reserved.
//

#import "OperationVC.h"

@interface OperationVC ()

@end

@implementation OperationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"GCD";
    self.view.backgroundColor = [UIColor colorWithRed:0.8 green:0.6 blue:0.8 alpha:1];
    
//    [self NSBlockOperationRun];
//    [self NSInvocationOperationRun];
    [self NSOperationQueueRun];
    
    [self NSOperationQueueRun2];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
- (void)NSBlockOperationRun {
    NSBlockOperation *blockOper = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"NSBlockOperationRun_%@_%@", [NSOperationQueue currentQueue], [NSThread currentThread]);
    }];
    [blockOper start];
}
*/

- (void)NSBlockOperationRun {
    NSBlockOperation *blockOper = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"NSBlockOperationRun_1_%@", [NSThread currentThread]);
    }];
    [blockOper addExecutionBlock:^{
        NSLog(@"NSBlockOperationRun_2_%@", [NSThread currentThread]);
    }];
    [blockOper addExecutionBlock:^{
        NSLog(@"NSBlockOperationRun_3_%@", [NSThread currentThread]);
    }];
    [blockOper addExecutionBlock:^{
        NSLog(@"NSBlockOperationRun_4_%@", [NSThread currentThread]);
    }];
    [blockOper start];
}

- (void)NSInvocationOperationRun {
    NSInvocationOperation *invocationOper = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(invocationOperSel) object:nil];
    [invocationOper start];
    NSLog(@"----------------");
}
- (void)invocationOperSel {
    NSLog(@"NSInvocationOperationRun_%@", [NSThread currentThread]);
}

- (void)NSOperationQueueRun {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//    queue.maxConcurrentOperationCount = 3;
    NSInvocationOperation *invocationOper = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(invocationOperSel) object:nil];
    invocationOper.queuePriority = NSOperationQueuePriorityVeryLow;
    [queue addOperation:invocationOper];
    NSBlockOperation *blockOper = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"NSBlockOperationRun_%@", [NSThread currentThread]);
        sleep(5);
    }];
    [queue addOperation:blockOper];
    [queue addOperationWithBlock:^{
        NSLog(@"QUEUEBlockOperationRun_%@", [NSThread currentThread]);
    }];
}

- (void)NSOperationQueueRun2 {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//    queue.maxConcurrentOperationCount = 2;
    NSBlockOperation *blockOper_1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"blockOper_1_%@_%@",@(1),[NSThread currentThread]);
    }];
    
    NSBlockOperation *blockOper_2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"blockOper_2_%@_%@",@(2),[NSThread currentThread]);
    }];
    
//    blockOper_1.queuePriority = NSOperationQueuePriorityVeryHigh;
    [blockOper_1 addDependency:blockOper_2];
    [queue addOperation:blockOper_1];
    [queue addOperation:blockOper_2];
}



@end
