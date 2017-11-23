//
//  PthreadsVC.m
//  multithreading
//
//  Created by HChong on 2017/11/22.
//  Copyright © 2017年 HChong. All rights reserved.
//

#import "PthreadsVC.h"
#import <pthread.h>

@interface PthreadsVC ()

@end

@implementation PthreadsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Pthreads";
    self.view.backgroundColor = [UIColor colorWithRed:0.6 green:1 blue:0.5 alpha:1];
    [self pthreadsDoTask];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pthreadsDoTask {
    /*
     pthread_t：线程指针
     pthread_attr_t：线程属性
     pthread_mutex_t：互斥对象
     pthread_mutexattr_t：互斥属性对象
     pthread_cond_t：条件变量
     pthread_condattr_t：条件属性对象
     pthread_key_t：线程数据键
     pthread_rwlock_t：读写锁
     //
     pthread_create()：创建一个线程
     pthread_exit()：终止当前线程
     pthread_cancel()：中断另外一个线程的运行
     pthread_join()：阻塞当前的线程，直到另外一个线程运行结束
     pthread_attr_init()：初始化线程的属性
     pthread_attr_setdetachstate()：设置脱离状态的属性（决定这个线程在终止时是否可以被结合）
     pthread_attr_getdetachstate()：获取脱离状态的属性
     pthread_attr_destroy()：删除线程的属性
     pthread_kill()：向线程发送一个信号
     pthread_equal(): 对两个线程的线程标识号进行比较
     pthread_detach(): 分离线程
     pthread_self(): 查询线程自身线程标识号
     //
     *创建线程
     int pthread_create(pthread_t _Nullable * _Nonnull __restrict, //指向新建线程标识符的指针
     const pthread_attr_t * _Nullable __restrict,  //设置线程属性。默认值NULL。
     void * _Nullable (* _Nonnull)(void * _Nullable),  //该线程运行函数的地址
     void * _Nullable __restrict);  //运行函数所需的参数
     *返回值：
     *若线程创建成功，则返回0
     *若线程创建失败，则返回出错编号
     */
    
    //声明一个线程
    pthread_t thread = NULL;
    NSString *params = @"Hello World";
    //创建一个线程
    int result = pthread_create(&thread, NULL, threadTask, (__bridge void *)(params));
    result == 0 ? NSLog(@"creat thread success") : NSLog(@"creat thread failure");
    //设置子线程的状态设置为detached,则该线程运行结束后会自动释放所有资源
    pthread_detach(thread);
}

void *threadTask(void *params) {
    NSLog(@"%@ - %@", [NSThread currentThread], (__bridge NSString *)(params));
    return NULL;
}

@end
