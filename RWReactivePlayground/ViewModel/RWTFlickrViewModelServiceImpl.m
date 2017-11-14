//
//  RWTFlickrViewModelServiceImpl.m
//  RWReactivePlayground
//
//  Created by lijia on 2017/11/14.
//  Copyright © 2017年 Colin Eberhardt. All rights reserved.
//

#import "RWTFlickrViewModelServiceImpl.h"
#import "RWTFlickrSearchImpl.h"

@interface RWTFlickrViewModelServiceImpl ()
@property (nonatomic, strong) RWTFlickrSearchImpl*         searchService;
@end


@implementation RWTFlickrViewModelServiceImpl
- (instancetype)init
{
  self = [super init];
  if (self) {
    _searchService = [[RWTFlickrSearchImpl alloc] init];
  }
  return self;
}

-(id<RWTFlickrSearch>)getFlickrSearchService {
  return self.searchService;
}
@end
