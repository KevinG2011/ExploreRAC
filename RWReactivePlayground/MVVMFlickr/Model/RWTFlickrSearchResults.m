//
//  RWTFlickrSearchResults.m
//  RWReactivePlayground
//
//  Created by lijia on 2017/11/14.
//  Copyright © 2017年 Colin Eberhardt. All rights reserved.
//

#import "RWTFlickrSearchResults.h"

@implementation RWTFlickrSearchResults
- (NSString *)description {
  return [NSString stringWithFormat:@"searchString=%@, totalresults=%lU, photos=%@",
          self.searchString, self.totalResults, self.photos];
}
@end
