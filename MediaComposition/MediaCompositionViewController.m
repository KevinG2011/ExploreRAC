//
//  MediaCompositionViewController.m
//  AVMediaBlend
//
//  Created by lijia on 2018/1/4.
//  Copyright © 2018年 Colin Eberhardt. All rights reserved.
//

#import "MediaCompositionViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "VideoCompositionEditor.h"

@interface MediaCompositionViewController ()
@property (nonatomic, strong) AVPlayerLayer         *playerLayer;
@property (nonatomic, strong) AVPlayer        *player;
@property (nonatomic, strong) VideoCompositionEditor         *videoEditor;
@end

@implementation MediaCompositionViewController
- (void)setupPlayer {
    self.playerLayer = [[AVPlayerLayer alloc] init];
    self.playerLayer.backgroundColor = [UIColor blackColor].CGColor;
    [self.view.layer addSublayer:self.playerLayer];
    self.playerLayer.frame = self.view.bounds;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupPlayer];
    
    NSURL *movieURL1 = [[NSBundle mainBundle] URLForResource:@"qwe" withExtension:@"mp4"];
    NSURL *movieURL2 = [[NSBundle mainBundle] URLForResource:@"abc" withExtension:@"mp4"];
    
    NSArray *urls = @[movieURL1,movieURL2];
    self.videoEditor = [[VideoCompositionEditor alloc] initWithURLs:urls];
    
    self.player = [[AVPlayer alloc] initWithPlayerItem:self.videoEditor.playerItem];
    self.playerLayer.player = self.player;
    [self.player play];
}


@end
