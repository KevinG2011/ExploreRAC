//
//  RWTSearchResultsItemViewModel.h
//  RWReactivePlayground
//
//  Created by Loriya on 2017/11/17.
//  Copyright © 2017年 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RWTFlickrPhoto.h"
#import "RWTFlickrViewModelService.h"

@interface RWTFlickrSearchResultsItemViewModel : NSObject
- (instancetype) initWithPhotos:(RWTFlickrPhoto*)photo service:(id<RWTFlickrViewModelService>)service;
@property (nonatomic, assign,getter=isVisible) BOOL         visible;
@property (nonatomic, copy) NSString         *title;
@property (nonatomic, strong) NSURL         *url;
@property (nonatomic, strong) NSNumber         *comments;
@property (nonatomic, strong) NSNumber         *favorites;
@end
