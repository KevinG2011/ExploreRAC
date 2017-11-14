//
//  RWTFlickrSearchImpl.m
//  RWReactivePlayground
//
//  Created by lijia on 2017/11/14.
//  Copyright © 2017年 Colin Eberhardt. All rights reserved.
//

#import <LinqToObjectiveC/LinqToObjectiveC.h>
#import "RWTFlickrSearchImpl.h"
#import "ObjectiveFlickr.h"

@interface RWTFlickrSearchImpl () <OFFlickrAPIRequestDelegate>
@property (strong, nonatomic) NSMutableSet *requests;
@property (strong, nonatomic) OFFlickrAPIContext *flickrContext;
@end

@implementation RWTFlickrSearchImpl
- (instancetype)init
{
  self = [super init];
  if (self) {
    //Exploring
    NSString *OFSampleAppAPIKey = @"e32a52b02540dd0aabca9df78f816275";
    NSString *OFSampleAppAPISharedSecret = @"2d6dd3a33abfbe9e";
    _flickrContext = [[OFFlickrAPIContext alloc] initWithAPIKey:OFSampleAppAPIKey
                                                   sharedSecret:OFSampleAppAPISharedSecret];
    _requests = [NSMutableSet new];
  }
  return self;
}

-(RACSignal*)sigalForFlickrMethod:(NSString*)method
                        arguments:(NSDictionary*)args
                        transform:(id (^)(NSDictionary* response))block {
  // 1. Create a signal for this request
  return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
    // 2. Create a Flick request object
    OFFlickrAPIRequest *flickrRequest = [[OFFlickrAPIRequest alloc] initWithAPIContext:self.flickrContext];
    flickrRequest.delegate = self;
    [self.requests addObject:flickrRequest];
    // 3. Create a signal from the delegate method
    RACSignal *successSignal = [self rac_signalForSelector:@selector(flickrAPIRequest:didCompleteWithResponse:)
                                              fromProtocol:@protocol(OFFlickrAPIRequestDelegate)];
    
    // 4. Handle the response
    [[[successSignal
       map:^id _Nullable(RACTuple* tuple) {
         return tuple.second;
       }]
       map:block]
       subscribeNext:^(id  _Nullable x) {
         [subscriber sendNext:x];
         [subscriber sendCompleted];
       }];
    [flickrRequest callAPIMethodWithGET:method arguments:args];
    return [RACDisposable disposableWithBlock:^{
      [self.requests removeObject:flickrRequest];
    }];
  }];
}

-(RACSignal*)flickrSearchSignal:(NSString*)searchText {
  return [[[[RACSignal empty] logAll] delay:2] logAll];
}
@end
