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

//TODO 水印 gpu mix

@interface MediaCompositionViewController ()
@property (nonatomic, strong) AVPlayerLayer         *playerLayer;
@property (nonatomic, strong) AVPlayer        *player;
@property (nonatomic, strong) VideoCompositionEditor         *videoEditor;
@property (nonatomic, copy) NSArray<NSURL*>         *assetURLs;
@end

@implementation MediaCompositionViewController
- (void)avComposition {
    self.playerLayer = [[AVPlayerLayer alloc] init];
    self.playerLayer.backgroundColor = [UIColor blackColor].CGColor;
    [self.view.layer addSublayer:self.playerLayer];
    self.playerLayer.frame = self.view.bounds;
    
    self.videoEditor = [[VideoCompositionEditor alloc] initWithURLs:_assetURLs];
    self.player = [[AVPlayer alloc] initWithPlayerItem:self.videoEditor.playerItem];
    self.playerLayer.player = self.player;
    [self.player play];
}

- (void)gpuImageComposition {
    //TODO
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *movieURL1 = [[NSBundle mainBundle] URLForResource:@"qwe" withExtension:@"mp4"];
    NSURL *movieURL2 = [[NSBundle mainBundle] URLForResource:@"abc" withExtension:@"mp4"];
    _assetURLs = @[movieURL1,movieURL2];
    
    [self avComposition];
//    [self gpuImageComposition];
}


@end
