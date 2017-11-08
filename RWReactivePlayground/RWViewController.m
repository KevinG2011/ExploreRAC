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
  
  // initially hide the failure message
  self.signInFailureText.hidden = YES;
  
  RACSignal* usernameValidSignal = [self.usernameTextField.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
    return @([self isValidUsername:value]);
  }];
  RAC(self.usernameTextField, backgroundColor) = [usernameValidSignal map:^id _Nullable(NSNumber* value) {
    return [value boolValue] ? [UIColor clearColor] : [UIColor yellowColor];
  }];
  
  RACSignal* passwordValidSignal = [self.passwordTextField.rac_textSignal map:^id _Nullable(NSString * _Nullable value) {
    return @([self isValidPassword:value]);
  }];
  RAC(self.passwordTextField, backgroundColor) = [passwordValidSignal map:^id _Nullable(NSNumber*  _Nullable value) {
    return [value boolValue] ? [UIColor clearColor] : [UIColor yellowColor];
  }];
  
  RACSignal* signUpActiveSignal = [RACSignal combineLatest:@[usernameValidSignal, passwordValidSignal]
                                                    reduce:^id(NSNumber* usernameValid, NSNumber* passwordValid){
                                                      return @(usernameValid.boolValue && passwordValid.boolValue);
                                  }];
  [signUpActiveSignal subscribeNext:^(NSNumber*  _Nullable signUpActive) {
    self.signInButton.enabled = signUpActive.boolValue;
  }];
  
  RACSignal* signUpSignal = [self.signInButton rac_signalForControlEvents:UIControlEventTouchUpInside];
  [[signUpSignal flattenMap:^id(id value) {
    return [self signInSignal];
  }] subscribeNext:^(NSNumber* x) {
    NSLog(@"%@", x);
  }];
}

- (BOOL)isValidUsername:(NSString *)username {
  return username.length > 3;
}

- (BOOL)isValidPassword:(NSString *)password {
  return password.length > 3;
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


// updates the enabled state and style of the text fields based on whether the current username
// and password combo is valid


@end
