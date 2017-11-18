//
//  RWFlickrSearchResultsViewModel.h
//  RWReactivePlayground
//
//  Created by lijia on 2017/11/15.
//  Copyright © 2017年 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RWTFlickrSearchResults.h"
#import "RWTFlickrViewModelService.h"

@interface RWTFlickrSearchResultsViewModel : NSObject
@property (nonatomic, strong) NSArray         *searchResults;
@property (nonatomic, copy) NSString*         title;
-(instancetype)initWithSearchResults:(RWTFlickrSearchResults*)results
                             service:(id<RWTFlickrViewModelService>)service;
@end
