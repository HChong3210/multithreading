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
    
    [self timerDemo];
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

- (void)threadTest {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        //在这里执行耗时的操作
        dispatch_async(dispatch_get_main_queue(), ^{
            //在主线程使用上面操作的结果
        });
    });
}

- (void)targetQueeuTest {
    dispatch_queue_t queue = dispatch_queue_create("test", NULL);
    dispatch_queue_t queue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //把第一个参数的执行优先级设置的和第二个参数的优先级一致.
    dispatch_set_target_queue(queue, queue1);
}

- (void)applyTest {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_apply(10, queue, ^(size_t index) {
        //并行处理10次任务
        NSLog(@"%zu", index);
    });
    
    /*
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //在全局并行队列中异步执行
    dispatch_async(queue, ^{
        //等待函数中操作全部执行完毕
        dispatch_apply(10, queue, ^(size_t index) {
            //并行处理10次任务
            sleep(2);
            NSLog(@"%zu", index);
        });
        
        //dispatch_apply中的处理全部结束, 在主线程异步执行
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Done");
        });
    });
     */
}

- (void)barrierTest {
    
    //此处的队列只能使用自定义的并行队列, 系统提供的全局队列不行
    dispatch_queue_t queue = dispatch_queue_create("barrierTest", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        NSLog(@"1");
    });
    dispatch_async(queue, ^{
        NSLog(@"2");
    });
    dispatch_async(queue, ^{
        NSLog(@"3");
    });
    dispatch_barrier_async(queue, ^{
        sleep(3);
        NSLog(@"插入执行");
    });
    dispatch_async(queue, ^{
        NSLog(@"4");
    });
    dispatch_async(queue, ^{
        NSLog(@"5");
    });
}

- (void)dispatchSemaphoreDemo {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    NSMutableArray *array = [NSMutableArray array];
    
    //设置信号量初始值, 当信号量为0时, 所有任务等待, 信号量越大, 允许可并行执行的任务数量越多. 并发的线程由系统调配, 不一定一直是同样的两条, 但是最多只能同时存在两条.
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(2);
    for (int i = 0; i < 100; i++) {
        
        //当信号量大于等于设定的初始值时就继续执行, 否则一直等待
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        dispatch_async(queue, ^{
            //执行到这里就代表信号量大于等于设定的初始值, 所以在这里信号量要减1
            NSLog(@"%d+++++%@", i, [NSThread currentThread]);
            [array addObject:@(i)];
            //到这里的时候, 因为异步任务已经将要结束, 要将信号量加1. 如果前面有等待的线程, 最先等待的线程先执行
            dispatch_semaphore_signal(semaphore);
        });
    }
}

- (void)timerDemo {
    NSLog(@"%@", [NSThread currentThread]);
    //指定DISPATCH_SOURCE_TYPE_TIMER类型, 作成Dispatch Source
    
    //在定时器经过指定时间, 把任务追加到main queue
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    
    //定时器的相关设置, 将定时器设置为5s后, 不指定为重复, 允许延迟1s
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, 5ull * NSEC_PER_SEC), DISPATCH_TIME_FOREVER, 1ull * NSEC_PER_SEC);
    
    //指定定时器指定时间内执行的处理
    dispatch_source_set_event_handler(timer, ^{
        NSLog(@"wake up");
        dispatch_source_cancel(timer);
    });
    
    //取消定时器时的处理
    dispatch_source_set_cancel_handler(timer, ^{
        NSLog(@"canceled");
    });
    
    //定时器启动
    dispatch_resume(timer);
}

- (void)case1 {
    NSLog(@"之前 - %@", [NSThread currentThread]);
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"sync - %@",[NSThread currentThread]);
    });
    NSLog(@"之后 - %@", [NSThread currentThread]);
}

- (void)case2 {
    NSLog(@"1");
    //3会等2，因为2在全局并行队列里，不需要等待3，这样2执行完回到主队列，3就开始执行
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSLog(@"2");
    });
    NSLog(@"3");
}

- (void)case3 {
    dispatch_queue_t serialQueue = dispatch_queue_create("com.starming.gcddemo.serialqueue", DISPATCH_QUEUE_SERIAL);
    NSLog(@"1");
    dispatch_async(serialQueue, ^{
        NSLog(@"2");
        //串行队列里面同步一个串行队列就会死锁
        dispatch_sync(serialQueue, ^{
            NSLog(@"3");
        });
        NSLog(@"4");
    });
    NSLog(@"5");
}



@end
