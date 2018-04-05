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
        
    }
    return self;
}
@end
