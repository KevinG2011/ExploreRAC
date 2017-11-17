//
//  RWTFlickrPhotoMetadata.m
//  RWReactivePlayground
//
//  Created by Loriya on 2017/11/17.
//  Copyright © 2017年 Colin Eberhardt. All rights reserved.
//

#import "RWTFlickrPhotoMetadata.h"

@implementation RWTFlickrPhotoMetadata
- (NSString *)description {
  return [NSString stringWithFormat:@"metadata: comments=%lU, faves=%lU",
          self.comments, self.favorites];
}
@end
