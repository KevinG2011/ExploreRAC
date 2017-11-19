//
//  Created by Colin Eberhardt on 26/04/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

#import "RWTSearchResultsTableViewCell.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "RWTFlickrPhoto.h"
#import "RWTFlickrSearchResultsItemViewModel.h"

@interface RWTSearchResultsTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageThumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *favouritesLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *commentsIcon;
@property (weak, nonatomic) IBOutlet UIImageView *favouritesIcon;

@end

@implementation RWTSearchResultsTableViewCell
-(void)bindViewModel:(id)viewModel {
  RWTFlickrSearchResultsItemViewModel *itemViewModel = (RWTFlickrSearchResultsItemViewModel*)viewModel;
  self.titleLabel.text = itemViewModel.title;
  self.imageThumbnailView.contentMode = UIViewContentModeScaleToFill;
  [self.imageThumbnailView sd_setImageWithURL:itemViewModel.url];
  
  [RACObserve(itemViewModel, favorites) subscribeNext:^(NSNumber *x) {
    self.favouritesIcon.hidden = (x == nil);
    self.favouritesLabel.text = x.stringValue;
  }];
  [RACObserve(itemViewModel, comments) subscribeNext:^(NSNumber *x) {
    self.commentsLabel.text = x.stringValue;
    self.commentsIcon.hidden = (x == nil);
  }];
  itemViewModel.visible = YES;
  [self.rac_prepareForReuseSignal subscribeNext:^(id x) {
    itemViewModel.visible = NO;
  }];
}

- (void)setParallax:(CGFloat)value {
  self.imageThumbnailView.transform = CGAffineTransformMakeTranslation(0, value);
}
@end
