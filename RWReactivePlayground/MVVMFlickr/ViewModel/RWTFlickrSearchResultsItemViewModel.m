//
//  RWTSearchResultsItemViewModel.m
//  RWReactivePlayground
//
//  Created by Loriya on 2017/11/17.
//  Copyright © 2017年 Colin Eberhardt. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>
#import "RWTFlickrSearchResultsItemViewModel.h"
#import "RWTFlickrPhotoMetadata.h"

@interface RWTFlickrSearchResultsItemViewModel ()
@property (weak, nonatomic) id<RWTFlickrViewModelService> service;
@property (strong, nonatomic) RWTFlickrPhoto *photo;
@end

@implementation RWTFlickrSearchResultsItemViewModel
- (instancetype) initWithPhotos:(RWTFlickrPhoto*)photo
                        service:(id<RWTFlickrViewModelService>)service {
  self = [super init];
  if (self) {
    _photo = photo;
    _service = service;
    _title = photo.title;
    _url = photo.url;
    [self setup];
  }
  return self;
}

- (void)setup {
  @weakify(self)
  [[RACObserve(self, visible)
    filter:^BOOL(NSNumber *value) {
      return [value boolValue];
    }]
    subscribeNext:^(id x) {
      @strongify(self);
      [[[self.service getFlickrSearchService]
        flickrImageMetadata:self.photo.identifier]
        subscribeNext:^(RWTFlickrPhotoMetadata *x) {
          self.favorites = @(x.favorites);
          self.comments = @(x.comments);
        }];
    }];
}

@end
