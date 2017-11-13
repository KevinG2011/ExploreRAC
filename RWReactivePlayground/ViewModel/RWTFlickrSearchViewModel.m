//
//  RWTFlickrSearchViewModel.m
//  RWReactivePlayground
//
//  Created by lijia on 2017/11/13.
//  Copyright © 2017年 Colin Eberhardt. All rights reserved.
//

#import "RWTFlickrSearchViewModel.h"


@interface RWTFlickrSearchViewModel ()

@end

@implementation RWTFlickrSearchViewModel
- (instancetype)init
{
  self = [super init];
  if (self) {
    [self setup];
  }
  return self;
}

- (void)setup {
  self.title = @"Flickr Search";
  self.searchText = @"search text";
  RACSignal* validSearchSigal = [[RACObserve(self, searchText) map:^id _Nullable(NSString* text) {
    return @(text.length > 3);
  }] distinctUntilChanged]; //emits when the state changes;
  [validSearchSigal subscribeNext:^(NSNumber*  _Nullable x) {
    NSLog(@"search text is valid: %@",x);
  }];
  self.executeSearch = [[RACCommand alloc]
                        initWithEnabled:validSearchSigal
                            signalBlock:^RACSignal * _Nonnull(NSString* input) {
    return [self signalForExcuteSearch];
  }];
}

-(RACSignal*)signalForExcuteSearch {
  return [[[[RACSignal empty] logAll] delay:2] logAll];
}

@end

