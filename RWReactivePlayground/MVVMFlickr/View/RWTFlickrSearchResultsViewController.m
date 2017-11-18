//
//  Created by Colin Eberhardt on 23/04/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

#import "RWTFlickrSearchResultsViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "RWTSearchResultsTableViewCell.h"
#import "RWTFlickrPhoto.h"

@interface RWTFlickrSearchResultsViewController () <UITableViewDataSource>
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

-(void)viewDidLoad {
  [super viewDidLoad];
  UINib* cellNib = [UINib nibWithNibName:@"RWTSearchResultsTableViewCell" bundle:nil];
  [self.searchResultsTable registerNib:cellNib forCellReuseIdentifier:@"searchResults"];
  self.searchResultsTable.dataSource = self;
  self.searchResultsTable.rowHeight = 206;
  [self bindViewModel];
}

- (void)bindViewModel {
  self.title = self.viewModel.title;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.viewModel.searchResults.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  RWTSearchResultsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"searchResults" forIndexPath:indexPath];
  RWTFlickrPhoto *photo = self.viewModel.searchResults[indexPath.row];
  [cell bindViewModel:photo];
  return cell;
}



















@end
