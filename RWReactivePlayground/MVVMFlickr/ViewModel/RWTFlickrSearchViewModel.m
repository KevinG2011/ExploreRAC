//
//  RWTFlickrSearchViewModel.m
//  RWReactivePlayground
//
//  Created by lijia on 2017/11/13.
//  Copyright © 2017年 Colin Eberhardt. All rights reserved.
//

#import "RWTFlickrSearchViewModel.h"
#import "RWTFlickrSearchResultsViewModel.h"

@interface RWTFlickrSearchViewModel ()
@property (nonatomic, weak) id<RWTFlickrViewModelService>         service;
@end

@implementation RWTFlickrSearchViewModel
- (instancetype)initWithService:(id<RWTFlickrViewModelService>)service
{
  self = [super init];
  if (self) {
    _service = service;
    [self setup];
  }
  return self;
}

- (void)setup {
  self.title = @"Flickr Search";
  self.searchText = @"airport";
  RACSignal* validSearchSigal = [[RACObserve(self, searchText) map:^id _Nullable(NSString* text) {
    return @(text.length > 3);
  }] distinctUntilChanged]; //emits when the state changes;
  [validSearchSigal subscribeNext:^(NSNumber*  _Nullable x) {
    NSLog(@"search text is valid: %@",x);
  }];
  self.executeSearch = [[RACCommand alloc]
                        initWithEnabled:validSearchSigal
                            signalBlock:^RACSignal * _Nonnull(id input) {
    return [self signalForExecuteSearch];
  }];
}

-(RACSignal*)signalForExecuteSearch {
    return [[[self.service getFlickrSearchService] flickrSearchSignal:self.searchText]
        doNext:^(id  _Nullable result) {
            RWTFlickrSearchResultsViewModel* rvm = [[RWTFlickrSearchResultsViewModel alloc] initWithSearchResults:result service:self.service];
            [self.service pushViewModel:rvm];
        }];
}

@end

