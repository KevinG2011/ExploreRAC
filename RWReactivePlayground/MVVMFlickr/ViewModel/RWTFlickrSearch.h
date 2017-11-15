//
//  RWTFlickrSearch.h
//  RWReactivePlayground
//
//  Created by lijia on 2017/11/14.
//  Copyright © 2017年 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>

@protocol RWTFlickrSearch <NSObject>
-(RACSignal*)flickrSearchSignal:(NSString*)searchText;
@end
