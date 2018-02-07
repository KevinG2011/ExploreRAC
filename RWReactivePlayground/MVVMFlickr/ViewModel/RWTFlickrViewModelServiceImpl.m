//
//  RWTFlickrViewModelServiceImpl.m
//  RWReactivePlayground
//
//  Created by lijia on 2017/11/14.
//  Copyright © 2017年 Colin Eberhardt. All rights reserved.
//

#import "RWTFlickrViewModelServiceImpl.h"
#import "RWTFlickrSearchImpl.h"
#import "RWTFlickrSearchResultsViewModel.h"
#import "RWTFlickrSearchResultsViewController.h"

@interface RWTFlickrViewModelServiceImpl ()
@property (nonatomic, weak) UINavigationController*        navigationController;
@property (nonatomic, strong) RWTFlickrSearchImpl*         searchService;
@end

@implementation RWTFlickrViewModelServiceImpl
- (instancetype)initWithNavigationController:(UINavigationController*)navigationController
{
  self = [super init];
  if (self) {
    _searchService = [[RWTFlickrSearchImpl alloc] init];
    _navigationController = navigationController;
  }
  return self;
}

-(void)pushViewModel:(id)viewModel {
  id viewController;
  if ([viewModel isKindOfClass:RWTFlickrSearchResultsViewModel.class]) {
    viewController = [[RWTFlickrSearchResultsViewController alloc] initWithViewModel:viewModel];
  }
  [self.navigationController pushViewController:viewController animated:YES];
}

-(id<RWTFlickrSearch>)getFlickrSearchService {
  return self.searchService;
}
@end
