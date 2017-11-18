//
//  RWTFlickrSearchImpl.h
//  RWReactivePlayground
//
//  Created by lijia on 2017/11/14.
//  Copyright © 2017年 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RWTFlickrSearch.h"

@interface RWTFlickrSearchImpl : NSObject <RWTFlickrSearch>
-(RACSignal*)flickrSearchSignal:(NSString*)searchText;
-(RACSignal*)flickrImageMetadata:(NSString*)photoId;
@end
