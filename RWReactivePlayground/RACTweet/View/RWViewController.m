//
//  RWViewController.m
//  RWReactivePlayground
//
//  Created by Colin Eberhardt on 18/12/2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import "RWViewController.h"
#import "RWDummySignInService.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface RWViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UILabel *signInFailureText;

@property (strong, nonatomic) RWDummySignInService *signInService;

@end

@implementation RWViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.signInService = [RWDummySignInService new];
  self.signInFailureText.hidden = YES;
  
  RACSignal* usernameSignal =
    [self.usernameTextField.rac_textSignal
       map:^id _Nullable(NSString * _Nullable value) {
           return @(value.length > 3);
       }];
    RAC(self.usernameTextField, backgroundColor) = [usernameSignal map:^id _Nullable(NSNumber  *_Nullable value) {
        return [value boolValue] ? [UIColor clearColor] : [UIColor yellowColor];
    }];
  
    RACSignal* passwordSignal =
    [self.passwordTextField.rac_textSignal
    map:^id _Nullable(NSString * _Nullable value) {
      return @(value.length > 3);
    }];
    RAC(self.passwordTextField, backgroundColor) = [passwordSignal map:^id _Nullable(id  _Nullable value) {
        return [value boolValue] ? [UIColor clearColor] : [UIColor yellowColor];
    }];
  
  RAC(self.signInButton, enabled) =
    [RACSignal combineLatest:@[usernameSignal, passwordSignal]
      reduce:^id(NSNumber* usernameValid, NSNumber* passwordValid){
        return @(usernameValid.boolValue && passwordValid.boolValue);
    }];
  
  RACSignal* signUpSignal = [self.signInButton rac_signalForControlEvents:UIControlEventTouchUpInside];
  [[[signUpSignal
    doNext:^(id  _Nullable x) {
      self.signInButton.enabled = NO;
      self.signInFailureText.hidden = YES;
    }]
    flattenMap:^id(id value) {
      return [self signInSignal];
    }]
    subscribeNext:^(NSNumber* signIn) {
      BOOL success = [signIn boolValue];
      self.signInButton.enabled = YES;
      self.signInFailureText.hidden = success;
      if (success) {
        [self performSegueWithIdentifier:@"signInSuccess" sender:self];
      }
  }];
}

- (RACSignal*)signInSignal {
  return [RACSignal createSignal:^RACDisposable * (id<RACSubscriber> subscriber) {
    [self.signInService signInWithUsername:self.usernameTextField.text
                                  password:self.passwordTextField.text
                                  complete:^(BOOL success) {
                                    [subscriber sendNext:@(success)];
                                    [subscriber sendCompleted];
    }];
    return nil;
  }];
}

- (IBAction)signInButtonTouched:(id)sender {
  // disable all UI controls
  self.signInButton.enabled = NO;
  self.signInFailureText.hidden = YES;
  
  // sign in
  [self.signInService signInWithUsername:self.usernameTextField.text
                            password:self.passwordTextField.text
                            complete:^(BOOL success) {
                              self.signInButton.enabled = YES;
                              self.signInFailureText.hidden = success;
                              if (success) {
                                [self performSegueWithIdentifier:@"signInSuccess" sender:self];
                              }
                            }];
}

@end
