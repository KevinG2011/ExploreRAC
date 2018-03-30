//
//  AppDelegate.m
//  IAPTest
//
//  Created by lijia on 2018/2/8.
//  Copyright © 2018年 Colin Eberhardt. All rights reserved.
//

#import "AppDelegate.h"
#include <pthread.h>

static pthread_mutex_t theLock;

@interface AppDelegate ()
@property (nonatomic, copy) NSString         *name;
@end

@implementation AppDelegate


void *threadMethord1() {
    pthread_mutex_lock(&theLock);
    printf("线程1\n");
    sleep(2);
    pthread_mutex_unlock(&theLock);
    printf("线程1解锁成功\n");
    return 0;
}

void *threadMethord2() {
    sleep(1);
    pthread_mutex_lock(&theLock);
    printf("线程2\n");
    pthread_mutex_unlock(&theLock);
    return 0;
}

static dispatch_queue_t q = nil;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSString *str = @"Alice";
    self.name = str;
    NSString *str2 = self.name;
    NSLog(@"%p", str);
    NSLog(@"%p", _name);
    NSLog(@"%p", str2);
//    q = dispatch_queue_create("com.iaptest", DISPATCH_QUEUE_SERIAL);
//    dispatch_async(q, ^{
//        NSLog(@"222");
//    });
//    dispatch_async(q, ^{
//        NSLog(@"333");
//    });
//    NSLog(@"1");
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        NSLog(@"run2");
//    });

//    dispatch_semaphore_t signal = dispatch_semaphore_create(1);
//    dispatch_time_t overTime = dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC);
//    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        dispatch_semaphore_wait(signal, overTime);
//        sleep(2);
//        NSLog(@"线程1");
//        dispatch_semaphore_signal(signal);
//    });
//    
//    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        sleep(1);
//        dispatch_semaphore_wait(signal, overTime);
//        NSLog(@"线程2");
//        dispatch_semaphore_signal(signal);
//    });
    
//    pthread_mutex_init(&theLock, NULL);
//
//    pthread_t thread;
//    pthread_create(&thread, NULL, threadMethord1, NULL);
//
//    pthread_t thread2;
//    pthread_create(&thread2, NULL, threadMethord2, NULL);
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
