//
//  RWTFlickrSearchImpl.m
//  RWReactivePlayground
//
//  Created by lijia on 2017/11/14.
//  Copyright © 2017年 Colin Eberhardt. All rights reserved.
//

#import "RWTFlickrSearchImpl.h"

@implementation RWTFlickrSearchImpl
-(RACSignal*)flickrSearchSignal:(NSString*)searchText {
  return [[[[RACSignal empty] logAll] delay:2] logAll];
}
@end
