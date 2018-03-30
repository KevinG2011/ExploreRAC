//
//  RWFlickrSearchResultsViewModel.m
//  RWReactivePlayground
//
//  Created by lijia on 2017/11/15.
//  Copyright © 2017年 Colin Eberhardt. All rights reserved.
//
#import <BlocksKit/BlocksKit.h>
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
        __weak typeof(self) wself = self;
        _searchResults = [results.photos bk_map:^id(RWTFlickrPhoto* photo) {
            __strong typeof(self) sself = wself;
            return [[RWTFlickrSearchResultsItemViewModel alloc] initWithPhotos: photo service: sself.service];
        }];
    }
    return self;
}

@end
