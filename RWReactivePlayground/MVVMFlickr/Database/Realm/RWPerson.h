//
//  RWPerson.h
//  RACMVVM
//
//  Created by Loriya on 2018/4/1.
//  Copyright © 2018年 Colin Eberhardt. All rights reserved.
//

#import <Realm/Realm.h>
#import "RWDog.h"

RLM_ARRAY_TYPE(RWDog)
@interface RWPerson : RLMObject
@property NSString             *name;
@property RLMArray<RWDog>      *dogs;
@end
