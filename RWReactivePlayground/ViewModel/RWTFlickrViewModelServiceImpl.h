//
//  RWTFlickrViewModelServiceImpl.h
//  RWReactivePlayground
//
//  Created by lijia on 2017/11/14.
//  Copyright © 2017年 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RWTFlickrViewModelService.h"
@interface RWTFlickrViewModelServiceImpl : NSObject <RWTFlickrViewModelService>
-(id<RWTFlickrSearch>)getFlickrSearchService;
@end
