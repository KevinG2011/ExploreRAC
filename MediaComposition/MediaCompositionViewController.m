//
//  MediaCompositionViewController.m
//  AVMediaBlend
//
//  Created by lijia on 2018/1/4.
//  Copyright © 2018年 Colin Eberhardt. All rights reserved.
//

#import "MediaCompositionViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import "PhotoUtils.h"
#import "AVFVideoCompositionEditor.h"
#import "GPUImageVideoCompositionEditor.h"

//TODO gpu mix
//TODO watermark

@interface MediaCompositionViewController ()
@property (nonatomic, strong) AVPlayerLayer         *playerLayer;
@property (nonatomic, strong) AVPlayer        *player;
@property (nonatomic, strong) VideoCompositionEditor         *videoEditor;
@property (nonatomic, copy) NSArray<NSURL*>         *assetURLs;
@property (nonatomic, strong) id         timeObserverToken;
@end

@implementation MediaCompositionViewController
- (void)exportVideo {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDir = [paths objectAtIndex:0];
    NSString *exportPath = [cacheDir stringByAppendingPathComponent:@"movie.m4v"];
    [self.videoEditor exportAsyncToPath:exportPath completionHandler:^{
        [PhotoUtils saveVideoToPhotoAlbum:[NSURL fileURLWithPath:exportPath] alertInViewController:self];
    }];
}

- (void)observePlayEnded {
    AVFVideoCompositionEditor *editor = (AVFVideoCompositionEditor*)self.videoEditor;
    AVAsset *movAsset = [editor.assets firstObject];
    if (!movAsset) return;
    
    [movAsset loadValuesAsynchronouslyForKeys:@[@"duration"] completionHandler:^{
        NSError *error = nil;
        AVKeyValueStatus status = [movAsset statusOfValueForKey:@"duration" error:&error];
        switch (status) {
            case AVKeyValueStatusLoaded: {
                NSArray *times = @[[NSValue valueWithCMTime:movAsset.duration]];
                __weak __typeof(self) wself = self;
                _timeObserverToken = [self.player addBoundaryTimeObserverForTimes:times
                                                                            queue:dispatch_get_main_queue()
                                                                        usingBlock:^{
                                                                            __strong typeof(wself) sself = wself;
                                                                            [sself exportVideo];
                                                                        }];
                break;
            }
            case AVKeyValueStatusFailed:
            case AVKeyValueStatusCancelled:
            default:
                break;
        }
    }];
}

- (void)avComposition {
    self.playerLayer = [[AVPlayerLayer alloc] init];
    self.playerLayer.backgroundColor = [UIColor blackColor].CGColor;
    [self.view.layer addSublayer:self.playerLayer];
    self.playerLayer.frame = self.view.bounds;
    
    self.videoEditor = [[AVFVideoCompositionEditor alloc] initWithURLs:_assetURLs];
    AVFVideoCompositionEditor *editor = (AVFVideoCompositionEditor*)self.videoEditor;
    self.player = [[AVPlayer alloc] initWithPlayerItem:editor.playerItem];
    self.playerLayer.player = self.player;
    [self.player play];
    
    [self observePlayEnded];
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

- (void)dealloc {
    [self.player removeTimeObserver:self.timeObserverToken];
}
@end
