//
//  RWFlickrSearchResultsViewModel.m
//  RWReactivePlayground
//
//  Created by lijia on 2017/11/15.
//  Copyright © 2017年 Colin Eberhardt. All rights reserved.
//

#import "RWTFlickrSearchResultsViewModel.h"

@interface RWTFlickrSearchResultsViewModel()
@property (nonatomic, weak) id<RWTFlickrViewModelService>     service;
@end

@implementation RWTFlickrSearchResultsViewModel
-(instancetype)initWithSearchResults:(RWTFlickrSearchResults*)results
                             service:(id<RWTFlickrViewModelService>)service {
    self = [super init];
    if (self) {
        _title = results.searchString;
        _results = results.photos;
        _service = service;
        [self setup];
    }
    return self;
}

- (void)setup {
    
}

@end
