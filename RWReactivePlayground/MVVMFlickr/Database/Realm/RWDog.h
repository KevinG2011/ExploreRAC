//
//  RWDog.h
//  RACMVVM
//
//  Created by Loriya on 2018/4/1.
//  Copyright © 2018年 Colin Eberhardt. All rights reserved.
//

#import <Realm/Realm.h>

@interface RWDog : RLMObject
@property NSString *name;
@property NSData   *picture;
@property NSInteger age;
@end
