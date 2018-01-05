//
//  AVVideoCompositionEditor.m
//  MediaComposition
//
//  Created by lijia on 2018/1/4.
//  Copyright © 2018年 Colin Eberhardt. All rights reserved.
//

#import "AVFVideoCompositionEditor.h"

@implementation AVFVideoCompositionEditor

-(instancetype)initWithURLs:(NSArray<NSURL*>*)urls {
    self = [super init];
    if (self) {
        self.urls = urls;
        [self setupEditor];
    }
    return self;
}

- (void)setupEditor {
    //轨道合成
    AVMutableComposition *composition = [AVMutableComposition composition];
    //视频合成指令
    AVMutableVideoComposition *videoComposition = [AVMutableVideoComposition videoComposition];
    
    NSMutableArray *assets = [NSMutableArray arrayWithCapacity:self.urls.count];
    NSMutableArray *layerInstructions = [NSMutableArray arrayWithCapacity:self.urls.count];
    
    for (NSURL *url in self.urls) {
        AVMutableCompositionTrack *compVideoTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        AVAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    
        //视频轨道
        AVAssetTrack *videoTrack = [asset tracksWithMediaType:AVMediaTypeVideo].firstObject;
        [compVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoTrack.timeRange.duration) ofTrack:videoTrack atTime:kCMTimeZero error:nil];
        compVideoTrack.preferredTransform = asset.preferredTransform;
        
        //音频轨道
        AVMutableCompositionTrack *compAudioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        AVAssetTrack *audioTrack = [asset tracksWithMediaType:AVMediaTypeAudio].firstObject;
        [compAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, audioTrack.timeRange.duration) ofTrack:audioTrack atTime:kCMTimeZero error:nil];
        
        AVMutableVideoCompositionLayerInstruction *layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:compVideoTrack];
        [layerInstruction setOpacity:0.5f atTime:kCMTimeZero];
        
//        CGAffineTransform transformScale = CGAffineTransformMakeScale( 0.5f, 0.5f );
//        CGAffineTransform transformTransition = CGAffineTransformMakeTranslation( videoComposition.renderSize.width / 2,  videoComposition.renderSize.height / 2 );
//        [layerInstruction setTransform:CGAffineTransformConcat(transformScale, transformTransition) atTime:kCMTimeZero ];
        
        [layerInstructions addObject:layerInstruction];
        [assets addObject:asset];
    }
    self.assets = [assets copy];
    
    AVAsset *firstAsset = self.assets.firstObject;

    videoComposition.frameDuration = CMTimeMake(1, 30); // 30 fps
    CGSize videoSize = [firstAsset naturalSize];
    videoComposition.renderSize = videoSize;
    
    AVMutableVideoCompositionInstruction *compInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    compInstruction.timeRange = CMTimeRangeMake( kCMTimeZero, firstAsset.duration);
    compInstruction.layerInstructions = layerInstructions;
    
    videoComposition.instructions = @[compInstruction];
    
    self.playerItem = [[AVPlayerItem alloc] initWithAsset:composition];
    self.playerItem.videoComposition = videoComposition;
}

-(void)exportAsyncToPath:(NSString*)path completionHandler:(void (^)(void))handler {
    NSURL *outputURL = [NSURL fileURLWithPath:path];
    if (!outputURL) {
        if (handler) {
            handler();
        }
        return;
    }
    if (!self.exportSession) {
        self.exportSession = [[AVAssetExportSession alloc] initWithAsset:self.playerItem.asset
                                                              presetName:AVAssetExportPresetMediumQuality];
        self.exportSession.outputFileType = AVFileTypeQuickTimeMovie;
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    }
    
    self.exportSession.videoComposition = self.playerItem.videoComposition;
    self.exportSession.outputURL = outputURL;
    self.exportSession.shouldOptimizeForNetworkUse = YES;
    
    [self.exportSession exportAsynchronouslyWithCompletionHandler:^{
        self.exportSession = nil;
        if (handler) {
            handler();
        }
    }];
}

@end
