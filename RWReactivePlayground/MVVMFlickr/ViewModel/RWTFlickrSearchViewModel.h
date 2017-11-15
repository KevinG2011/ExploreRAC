//
//  RWTFlickrSearchViewModel.h
//  RWReactivePlayground
//
//  Created by lijia on 2017/11/13.
//  Copyright © 2017年 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "RWTFlickrViewModelService.h"

@interface RWTFlickrSearchViewModel : NSObject
@property (nonatomic, strong) NSString         *searchText;
@property (nonatomic, strong) NSString         *title;
@property (nonatomic, strong) RACCommand       *executeSearch;
- (instancetype)initWithService:(id<RWTFlickrViewModelService>)service;
@end
