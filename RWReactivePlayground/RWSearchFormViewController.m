//
//  RWSearchFormViewController.m
//  TwitterInstant
//
//  Created by Colin Eberhardt on 02/12/2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "RWSearchFormViewController.h"
#import "RWSearchResultsViewController.h"

typedef NS_ENUM(NSInteger, RWTwitterInstantError) {
  RWTwitterInstantErrorAccessDenied,
  RWTwitterInstantErrorNoTwitterAccounts,
  RWTwitterInstantErrorInvalidResponse
};

static NSString * const RWTwitterInstantDomain = @"TwitterInstant";

@interface RWSearchFormViewController () <UISplitViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *searchText;
@property (strong, nonatomic) RWSearchResultsViewController *resultsViewController;
@property (strong, nonatomic) ACAccountStore *accountStore;
@property (strong, nonatomic) ACAccountType *twitterAccountType;
@property (nonatomic, strong) RACSignal*         searchSignal;
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
  @weakify(self)
  RAC(self.searchText, backgroundColor) = [self.searchText.rac_textSignal
                                           map:^id (NSString *value) {
                                             @strongify(self)
                                             return [self isValidSearchText:value] ? [UIColor whiteColor] : [UIColor yellowColor];
                                           }];
  self.accountStore = [[ACAccountStore alloc] init];
  self.twitterAccountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
  
  [[self requestAccessToTweetSignal] subscribeNext:^(NSNumber* result) {
    NSLog(@"Access granted");
  } error:^(NSError * _Nullable error) {
    NSLog(@"An error occur: %@", [error localizedDescription]);
  }];
}

- (RACSignal*)requestAccessToTweetSignal {
  //create the signal
  return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
    [self.accountStore requestAccessToAccountsWithType:self.twitterAccountType
                                               options:nil
                                            completion:^(BOOL granted, NSError *error) {
                                              if (granted) {
                                                [subscriber sendNext:@(granted)];
                                                [subscriber sendCompleted];
                                              } else {
                                                //define an error
                                                NSError *accessError = [NSError errorWithDomain:RWTwitterInstantDomain
                                                                                           code:RWTwitterInstantErrorAccessDenied
                                                                                       userInfo:nil];
                                                [subscriber sendError:accessError];
                                              }
                                            }];
    return nil;
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
