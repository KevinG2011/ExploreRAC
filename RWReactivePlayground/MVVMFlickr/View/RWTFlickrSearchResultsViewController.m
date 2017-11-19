//
//  Created by Colin Eberhardt on 23/04/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

#import "RWTFlickrSearchResultsViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "RWTSearchResultsTableViewCell.h"
#import "CETableViewBindingHelper.h"
#import "RWTFlickrPhoto.h"

@interface RWTFlickrSearchResultsViewController () <UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *searchResultsTable;
@property (strong, nonatomic) CETableViewBindingHelper *bindingHelper;
@end

@implementation RWTFlickrSearchResultsViewController

-(instancetype)initWithViewModel:(RWTFlickrSearchResultsViewModel*)viewModel {
    self = [super init];
    if (self) {
        _viewModel = viewModel;
    }
    return self;
}

-(void)viewDidLoad {
  [super viewDidLoad];
  [self bindViewModel];
}

- (void)bindViewModel {
  self.title = self.viewModel.title;
  UINib* nib = [UINib nibWithNibName:@"RWTSearchResultsTableViewCell" bundle:nil];
  self.bindingHelper =
  [CETableViewBindingHelper bindingHelperForTableView:self.searchResultsTable
                                         sourceSignal:RACObserve(self.viewModel, searchResults)
                                     selectionCommand:nil
                                         templateCell:nib];
  self.bindingHelper.delegate = self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  NSArray *cells = [self.searchResultsTable visibleCells];
  for (RWTSearchResultsTableViewCell *cell in cells) {
    CGFloat value = -40 + (cell.frame.origin.y - self.searchResultsTable.contentOffset.y) / 5;
    [cell setParallax:value];
  }
}

















@end
