//
//  GCDVC.m
//  multithreading
//
//  Created by HChong on 2017/11/23.
//  Copyright © 2017年 HChong. All rights reserved.
//

#import "GCDVC.h"

@interface GCDVC ()

@end

@implementation GCDVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"GCD";
    self.view.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.5 alpha:1];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
    });
    
    [self groupTest1];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//用异步函数向并行队列中添加任务
- (void)test1 {
    //获取系统提供的全局队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //向队列中添加异步任务
    dispatch_async(queue, ^{
        NSLog(@"下载图片1----%@", [NSThread currentThread]);
        sleep(5);
    });
    
    //向队列中添加异步任务
    dispatch_async(queue, ^{
        NSLog(@"下载图片2----%@", [NSThread currentThread]);
    });
    
    //向队列中添加异步任务
    dispatch_async(queue, ^{
        NSLog(@"下载图片3----%@", [NSThread currentThread]);
    });
}

//向串行队列中添加异步任务
- (void)test2 {
    
    //创建串行队列, 第一个参数为串行队列的名称, 第二个参数为队列的属性, NULL或者0表示是串行队列
    dispatch_queue_t queue = dispatch_queue_create("test2", NULL);
    
    //向队列中添加异步任务
    dispatch_async(queue, ^{
        NSLog(@"下载图片1----%@", [NSThread currentThread]);
        sleep(5);
    });
    
    //向队列中添加异步任务
    dispatch_async(queue, ^{
        NSLog(@"下载图片2----%@", [NSThread currentThread]);
    });
    
    //向队列中添加异步任务
    dispatch_async(queue, ^{
        NSLog(@"下载图片3----%@", [NSThread currentThread]);
    });
}

//并行队列中添加同步任务
- (void)test3 {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //向队列中添加异步任务
    dispatch_sync(queue, ^{
        NSLog(@"下载图片1----%@", [NSThread currentThread]);
        sleep(5);
    });
    
    //向队列中添加异步任务
    dispatch_sync(queue, ^{
        NSLog(@"下载图片2----%@", [NSThread currentThread]);
    });
    
    //向队列中添加异步任务
    dispatch_sync(queue, ^{
        NSLog(@"下载图片3----%@", [NSThread currentThread]);
    });
}

//串行队列中添加异步任务
- (void)test4 {
    dispatch_queue_t queue = dispatch_queue_create("test4", NULL);
    
    //向队列中添加异步任务
    dispatch_async(queue, ^{
        NSLog(@"下载图片1----%@", [NSThread currentThread]);
        sleep(5);
    });
    
    //向队列中添加异步任务
    dispatch_async(queue, ^{
        NSLog(@"下载图片2----%@", [NSThread currentThread]);
    });
    
    //向队列中添加异步任务
    dispatch_async(queue, ^{
        NSLog(@"下载图片3----%@", [NSThread currentThread]);
    });
}

- (void)groupTest1 {
    //获取全局队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //创建一个队列组
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"--- 1 开始--- %@", [NSThread currentThread]);
        //延时5秒 模仿堵塞子线程
        [NSThread sleepForTimeInterval:5];
        NSLog(@"--- 1 --- 完成 %@", [NSThread currentThread]);
    });
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"--- 2 开始--- %@", [NSThread currentThread]);
        //延时5秒 模仿堵塞子线程
        [NSThread sleepForTimeInterval:5];
        NSLog(@"--- 2 --- 完成 %@", [NSThread currentThread]);
    });
    
    //在这个队列组里面，会等group中的全部代码执行完毕再去执行其它的操作
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 等前面的异步操作都执行完毕后，回到主线程...
        NSLog(@"全部完成");
    });
}

- (void)groupTest2 {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        sleep(2); //这里线程睡眠1秒钟，模拟异步请求
        NSLog(@"%@ one finish", [NSThread currentThread]);
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        sleep(2); //这里线程睡眠1秒钟，模拟异步请求
        NSLog(@"%@ two finish", [NSThread currentThread]);
        dispatch_group_leave(group);
    });
    
    dispatch_group_notify(group, queue, ^{
        NSLog(@"group finished");
    });
}

- (void)afterTest {
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t) (delayInSeconds * NSEC_PER_SEC));
    //第一个参数代表时间, 第二各参数代表要在哪个线程执行接下来的任务, 第三个参数就是任务block
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSLog(@"%@", [NSThread currentThread]);
    });
}

+ (UIColor *)boringColor {
    static UIColor *color;
    //只运行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        color = [UIColor colorWithRed:0.380f green:0.376f blue:0.376f alpha:1.000f];
    });
    return color;
}

@end
