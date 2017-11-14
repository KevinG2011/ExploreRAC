//
//  Created by Colin Eberhardt on 13/04/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

#import "RWTFlickrSearchViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "RWTFlickrSearchViewModel.h"
#import "RWTFlickrViewModelServiceImpl.h"

@interface RWTFlickrSearchViewController ()

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UITableView *searchHistoryTable;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (strong, nonatomic) RWTFlickrSearchViewModel         *searchViewModel;
@end

@implementation RWTFlickrSearchViewController


- (instancetype)initWithViewModel:(RWTFlickrSearchViewModel*)viewModel {
  self = [super init];
  if (self) {
    _searchViewModel = viewModel;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.edgesForExtendedLayout = UIRectEdgeNone;
  self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
  
  [self bindViewModel];
}

- (void)bindViewModel {
  id<RWTFlickrViewModelService> rms = [[RWTFlickrViewModelServiceImpl alloc] init];
  self.searchViewModel = [[RWTFlickrSearchViewModel alloc] initWithService:rms];
  
  self.title = self.searchViewModel.title;
  self.searchTextField.text = self.searchViewModel.searchText;
  RAC(self.searchViewModel, searchText) = self.searchTextField.rac_textSignal;
  self.searchButton.rac_command = self.searchViewModel.executeSearch;
  RAC(UIApplication.sharedApplication, networkActivityIndicatorVisible) = self.searchViewModel.executeSearch.executing;
  RAC(self.loadingIndicator, hidden) = [self.searchViewModel.executeSearch.executing not];
  @weakify(self);
  [self.searchViewModel.executeSearch.executionSignals subscribeNext:^(id  _Nullable x) {
    @strongify(self);
    [self.searchTextField resignFirstResponder];
  }];
}
@end
