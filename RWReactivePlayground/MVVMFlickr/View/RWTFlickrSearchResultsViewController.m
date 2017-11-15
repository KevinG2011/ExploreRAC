//
//  Created by Colin Eberhardt on 23/04/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

#import "RWTFlickrSearchResultsViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface RWTFlickrSearchResultsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *searchResultsTable;
@end

@implementation RWTFlickrSearchResultsViewController

-(instancetype)initWithViewModel:(RWTFlickrSearchResultsViewModel*)viewModel {
    self = [super init];
    if (self) {
        _viewModel = viewModel;
    }
    return self;
}

@end
