//
//  RWFlickrSearchResultsViewModel.m
//  RWReactivePlayground
//
//  Created by lijia on 2017/11/15.
//  Copyright © 2017年 Colin Eberhardt. All rights reserved.
//
#import <LinqToObjectiveC/NSArray+LinqExtensions.h>
#import "RWTFlickrSearchResultsViewModel.h"
#import "RWTFlickrSearchResultsItemViewModel.h"

@interface RWTFlickrSearchResultsViewModel()
@property (nonatomic, weak) id<RWTFlickrViewModelService>     service;
@end

@implementation RWTFlickrSearchResultsViewModel
-(instancetype)initWithSearchResults:(RWTFlickrSearchResults*)results
                             service:(id<RWTFlickrViewModelService>)service {
    self = [super init];
    if (self) {
        _title = results.searchString;
        _service = service;
        _searchResults = [results.photos linq_select:^id(RWTFlickrPhoto* photo) {
          return [[RWTFlickrSearchResultsItemViewModel alloc] initWithPhotos: photo service: _service];
        }];
    }
    return self;
}

@end
