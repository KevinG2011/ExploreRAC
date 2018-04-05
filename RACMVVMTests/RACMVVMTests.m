//
//  RACMVVMTests.m
//  RACMVVMTests
//
//  Created by Loriya on 2018/4/1.
//  Copyright © 2018年 Colin Eberhardt. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RWPerson.h"

@interface RACMVVMTests : XCTestCase

@end

@implementation RACMVVMTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testRLMAdd {
    RWDog *dog = [[RWDog alloc] initWithValue:@{@"name": @"Sam", @"age": @6}];
}

- (void)testCompactOnLaunch {
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    config.shouldCompactOnLaunch = ^BOOL(NSUInteger totalBytes, NSUInteger bytesUsed) {
        NSUInteger oneHundredMB = 100 * 1024 * 1024;
        return (totalBytes > oneHundredMB) && (bytesUsed / totalBytes) < 0.5;
    };
    NSError *error = nil;
    // 如果配置条件满足，那么 Realm 就会在首次打开时被压缩
    RLMRealm *realm = [RLMRealm realmWithConfiguration:config error:&error];
    if (error) {
        // 处理打开 Realm 或者压缩时产生的错误
    }
}

- (void)testRLMConfig {
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [docPath firstObject];
    NSString *databaseName = @"RWMVVM";
    NSString *filePath = [path stringByAppendingPathComponent:databaseName];
    
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    config.fileURL = [[[config.fileURL URLByDeletingLastPathComponent]
                       URLByAppendingPathComponent:databaseName]
                      URLByAppendingPathExtension:@"realm"];
    //        config.objectClasses = @[MyClass.class, MyOtherClass.class];
    NSLog(@"数据库目录 = %@",config.fileURL);
    config.readOnly = NO;
    int currentVersion = 1.0;
    config.schemaVersion = 1.0;

    config.migrationBlock = ^(RLMMigration *migration , uint64_t oldSchemaVersion) {
        // 这里是设置数据迁移的block
        if (oldSchemaVersion < currentVersion) {
            
        }
    };
//    [RLMRealmConfiguration setDefaultConfiguration:config];
    //类的子集限定
    config.objectClasses = @[RWDog.class, RWPerson.class];
    NSError *error = nil;
    RLMRealm *realm = [RLMRealm realmWithConfiguration:config error:&error];
    if (!realm) {
        //错误处理
    }
}


- (void)testRLMQuery {
    RLMResults<RWDog *> *puppies = [RWDog objectsWhere:@"name == 'Jam'"];
    RWDog *dog = [puppies firstObject];
    NSLog(@"dog age :%zd",dog.age);
}

- (void)testRLMStore {
    RWDog *mydog = [[RWDog alloc] init];
    mydog.name = @"Jam";
    mydog.age = 1;
    mydog.picture = nil; // 该属性是可空的
    NSLog(@"Name of dog: %@", mydog.name);
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        [realm addObject:mydog];
    }];
}

- (void)testInsert {
    dispatch_async(dispatch_queue_create("background", 0), ^{
        @autoreleasepool {
            RWDog *theDog = [[RWDog objectsWhere:@"name == 'Jam'"] firstObject];
            RLMRealm *realm = [RLMRealm defaultRealm];
            [realm beginWriteTransaction];
            theDog.age = 12;
            [realm commitWriteTransaction];
        }
    });
    sleep(1);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
