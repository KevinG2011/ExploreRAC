//
//  RWTFlickrSearchResults.h
//  RWReactivePlayground
//
//  Created by lijia on 2017/11/14.
//  Copyright © 2017年 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RWTFlickrSearchResults : NSObject
@property (nonatomic, strong) NSString          *searchString;
@property (nonatomic, strong) NSArray           *photos;
@property (nonatomic, assign) NSUInteger        totalResults;
@end
