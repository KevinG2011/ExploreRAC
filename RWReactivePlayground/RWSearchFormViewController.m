//
//  RWSearchFormViewController.m
//  TwitterInstant
//
//  Created by Colin Eberhardt on 02/12/2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>
#import "RWSearchFormViewController.h"
#import "RWSearchResultsViewController.h"

@interface RWSearchFormViewController () <UISplitViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *searchText;
@property (strong, nonatomic) RWSearchResultsViewController *resultsViewController;
@end

@implementation RWSearchFormViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.title = @"Twitter Instant";
  
  [self styleTextField:self.searchText];
  
//  self.resultsViewController = self.splitViewController.viewControllers[1];
  NSDictionary* attributes = @{NSForegroundColorAttributeName: [UIColor blackColor]};
  self.navigationController.navigationBar.titleTextAttributes = attributes;
  [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
  self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
  
  self.navigationController.splitViewController.delegate = self;
  RAC(self.searchText, backgroundColor) = [self.searchText.rac_textSignal map:^id (NSString *value) {
    return [self isValidSearchText:value] ? [UIColor whiteColor] : [UIColor yellowColor];
  }];
  
}

- (BOOL)isValidSearchText:(NSString*)text {
  return text.length > 2;
}

- (void)styleTextField:(UITextField *)textField {
  CALayer *textFieldLayer = textField.layer;
  textFieldLayer.borderColor = [UIColor grayColor].CGColor;
  textFieldLayer.borderWidth = 2.0f;
  textFieldLayer.cornerRadius = 0.0f;
}

@end
