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
#import "RWTweet.h"
#import <BlocksKit/BlocksKit.h>

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
@property (nonatomic, strong) RACSignal     *searchSignal;
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
  
  self.accountStore = [[ACAccountStore alloc] init];
  self.twitterAccountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
  
  @weakify(self)
  RACSignal *searchSignal = [self.searchText.rac_textSignal filter:^BOOL(NSString * _Nullable value) {
    @strongify(self)
    BOOL isValid = [self isValidSearchText:value];
    self.searchText.backgroundColor = isValid ? [UIColor whiteColor] : [UIColor yellowColor];
    return isValid;
  }];
  [[searchSignal
    throttle:0.5]
    subscribeNext:^(NSString* text) {
     @strongify(self)
     RACSignal* searchTextSignal = [self signalForSearchText:text];
     [[searchTextSignal
       deliverOn:RACScheduler.mainThreadScheduler]
       subscribeNext:^(NSDictionary* responseDict) {
        NSLog(@"%@",responseDict);
        NSArray* statuses = responseDict[@"statuses"];
        NSArray* tweets = [statuses bk_map:^id(NSDictionary* item) {
          return [RWTweet tweetWithStatus:item];
        }];
        [self.resultsViewController displayTweets:tweets];
       } error:^(NSError * _Nullable error) {
         NSLog(@"%@", error.localizedDescription);
       }];
   }];
  
  [[self requestAccessToTweetSignal] subscribeNext:^(NSNumber* ret) {
    NSLog(@"%@", ret);
  } error:^(NSError * _Nullable error) {
    NSLog(@"%@", error.localizedDescription);
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
  return text.length > 3;
}


- (SLRequest*)requestForTwitterSearchWithText:(NSString*)text {
  NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/search/tweets.json"];
  NSDictionary *params = @{@"q" : text};
  SLRequest* request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                          requestMethod:SLRequestMethodGET
                                                    URL:url
                                             parameters:params];
  return request;
}

- (RACSignal*)signalForSearchText:(NSString*)text {
  @weakify(self)
  return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
    @strongify(self)
    NSArray *twitterAccounts = [self.accountStore accountsWithAccountType:self.twitterAccountType];
    if (twitterAccounts.count == 0) {
      NSError* error = [NSError errorWithDomain:RWTwitterInstantDomain code:RWTwitterInstantErrorNoTwitterAccounts userInfo:nil];
      [subscriber sendError:error];
    } else {
      SLRequest* request = [self requestForTwitterSearchWithText:text];
      [request setAccount:twitterAccounts.lastObject];
      [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (urlResponse.statusCode == 200) {
          NSDictionary *timelineData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
          [subscriber sendNext:timelineData];
          [subscriber sendCompleted];
        } else {
          NSError* error = [NSError errorWithDomain:RWTwitterInstantDomain code:RWTwitterInstantErrorInvalidResponse userInfo:nil];
          [subscriber sendError:error];
        }
      }];
    }

    return nil;
  }];
}

- (void)styleTextField:(UITextField *)textField {
  CALayer *textFieldLayer = textField.layer;
  textFieldLayer.borderColor = [UIColor grayColor].CGColor;
  textFieldLayer.borderWidth = 2.0f;
  textFieldLayer.cornerRadius = 0.0f;
}

@end
