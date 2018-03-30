//
//  RWDatabaseManager.m
//  RACMVVM
//
//  Created by lijia on 2018/3/30.
//  Copyright © 2018年 Colin Eberhardt. All rights reserved.
//

#import "RWDatabaseManager.h"
#import <Realm/Realm.h>
@implementation RWDatabaseManager

+(instancetype)defaultManager {
    static RWDatabaseManager *manager;
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
//        NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *path = [docPath objectAtIndex:0];
//        NSString *databaseName = @"";
//        NSString *filePath = [path stringByAppendingPathComponent:databaseName];
//        NSLog(@"数据库目录 = %@",filePath);
//
//        RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
//        config.fileURL = [NSURL URLWithString:filePath];
//        config.objectClasses = @[MyClass.class, MyOtherClass.class];
//        config.readOnly = NO;
//        int currentVersion = 1.0;
//        config.schemaVersion = currentVersion;
//
//        config.migrationBlock = ^(RLMMigration *migration , uint64_t oldSchemaVersion) {
//            // 这里是设置数据迁移的block
//            if (oldSchemaVersion < currentVersion) {
//            }
//        };
//
//        [RLMRealmConfiguration setDefaultConfiguration:config];
    }
    return self;
}
@end
