//
//  RWTFlickrViewModelService.h
//  RWReactivePlayground
//
//  Created by lijia on 2017/11/14.
//  Copyright © 2017年 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RWTFlickrSearch.h"
@protocol RWTFlickrViewModelService <NSObject>
-(void)pushViewModel:(id)viewModel;
-(id<RWTFlickrSearch>)getFlickrSearchService;
@end
