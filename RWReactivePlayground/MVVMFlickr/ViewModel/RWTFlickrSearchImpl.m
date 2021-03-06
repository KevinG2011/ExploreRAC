//
//  RWTFlickrSearchImpl.m
//  RWReactivePlayground
//
//  Created by lijia on 2017/11/14.
//  Copyright © 2017年 Colin Eberhardt. All rights reserved.
//

#import <BlocksKit/BlocksKit.h>
#import "RWTFlickrSearchImpl.h"
#import "ObjectiveFlickr.h"
#import "RWTFlickrSearchResults.h"
#import "RWTFlickrPhoto.h"
#import "RWTFlickrPhotoMetadata.h"

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

-(RACSignal*)signalForAPIMethod:(NSString*)method
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
    
    // 4. Handle the response success
    [[[successSignal
       map:^id _Nullable(RACTuple* tuple) {
         return tuple.second;
       }]
       map:block]
       subscribeNext:^(id  _Nullable x) {
         [subscriber sendNext:x];
         [subscriber sendCompleted];
       }];
    // 5. Handle the response error
    RACSignal *failSignal = [self rac_signalForSelector:@selector(flickrAPIRequest:didFailWithError:) fromProtocol:@protocol(OFFlickrAPIRequestDelegate)];
    [[[failSignal map:^id _Nullable(RACTuple* tuple) {
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
  NSDictionary *args = @{ @"text": searchText, @"sort": @"interestingness-desc" };
  return [self signalForAPIMethod:@"flickr.photos.search"
                           arguments:args
                           transform:^id(NSDictionary *response) {
    RWTFlickrSearchResults *results = [RWTFlickrSearchResults new];
    results.searchString = searchText;
    if ([response isKindOfClass:NSDictionary.class]) {
      results.totalResults = [[response valueForKeyPath:@"photos.total"] integerValue];
      
      NSArray *photos = [response valueForKeyPath:@"photos.photo"];
      results.photos = [photos bk_map:^id(NSDictionary* jsonPhoto) {
        RWTFlickrPhoto* photo = [[RWTFlickrPhoto alloc] init];
        photo.title = jsonPhoto[@"title"];
        photo.identifier = jsonPhoto[@"id"];
        photo.url = [self.flickrContext photoSourceURLFromDictionary:jsonPhoto size:OFFlickrSmallSize];
        return photo;
      }];
    } else {
      results.totalResults = 0;
      results.photos = @[];
    }
    return results;
  }];
}

-(RACSignal*)flickrImageMetadata:(NSString*)photoId {
  NSDictionary *args = @{@"photo_id": photoId};
  RACSignal *favourites = [self signalForAPIMethod:@"flickr.photos.getFavorites"
                                         arguments:args
                                         transform:^id(NSDictionary *response) {
                                           NSString* total = [response valueForKeyPath:@"photo.total"];
                                           return total;
                                         }];
  RACSignal *comments = [self signalForAPIMethod:@"flickr.photos.getInfo"
                                       arguments:args
                                       transform:^id(NSDictionary *response) {
                                         NSString* total = [response valueForKeyPath:@"photo.comments._text"];
                                         return total;
                                       }];
  return [RACSignal combineLatest:@[favourites, comments]
                           reduce:^id (NSString *favs, NSString *coms){
                             RWTFlickrPhotoMetadata *meta = [[RWTFlickrPhotoMetadata alloc] init];
                             meta.favorites = favs.integerValue;
                             meta.comments = coms.integerValue;
                             return meta;
                           }];
}













@end
