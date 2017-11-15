//
//  Created by Colin Eberhardt on 23/04/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

@import UIKit;
#import "RWTFlickrSearchResultsViewModel.h"

@interface RWTFlickrSearchResultsViewController : UIViewController
@property (nonatomic, strong) RWTFlickrSearchResultsViewModel         *viewModel;
-(instancetype)initWithViewModel:(RWTFlickrSearchResultsViewModel*)viewModel;
@end
