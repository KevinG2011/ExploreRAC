//
//  RWTFlickrPhoto.h
//  RWReactivePlayground
//
//  Created by lijia on 2017/11/14.
//  Copyright © 2017年 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RWTFlickrPhoto : NSObject
@property (nonatomic, strong) NSString         *title;
@property (nonatomic, strong) NSURL            *url;
@property (nonatomic, strong) NSString         *identifier;
@end
