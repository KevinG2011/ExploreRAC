//
//  ViewController.m
//  AVMediaBlend
//
//  Created by lijia on 2017/12/27.
//  Copyright © 2017年 Colin Eberhardt. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "GPUImage.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface ViewController () {
    //capture
    GPUImageVideoCamera *_videoCamera;
    //movie
    GPUImageMovie *_movieFile;
    //blend filter
    GPUImageOutput<GPUImageInput> *_filter;
    //file
    GPUImageMovieWriter *_movieWriter;
}
@end

@implementation ViewController

- (void)loadView {
    GPUImageView *view = [[GPUImageView alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initPipeline];
}

- (void)initPipeline {
    _videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480
                                                  cameraPosition:AVCaptureDevicePositionBack];
    _videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    
    NSURL *sampleURL = [[NSBundle mainBundle] URLForResource:@"abc" withExtension:@"mp4"];
    _movieFile = [[GPUImageMovie alloc] initWithURL:sampleURL];
    
    GPUImageDissolveBlendFilter *filter = [[GPUImageDissolveBlendFilter alloc] init];
    [filter setMix:0.5f];
    _filter = filter;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDir = [paths objectAtIndex:0];
    NSString *moviePath = [cacheDir stringByAppendingPathComponent:@"assets/movie.m4v"];
    unlink([moviePath UTF8String]);
    NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
    _movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(640, 480)];
    _movieWriter.audioProcessingCallback = ^(SInt16 **samplesRef, CMItemCount numSamplesInBuffer) {
        
    };
    BOOL audioFromFile = NO;
    if (audioFromFile) {
        [_videoCamera addTarget:_filter];
        [_movieFile addTarget:_filter];
        _videoCamera.audioEncodingTarget = _movieWriter;
        _movieWriter.encodingLiveVideo = YES;
        _movieWriter.shouldPassthroughAudio = NO;
    }
    [_filter addTarget:(GPUImageView*)self.view];
    [_filter addTarget:_movieWriter];
    
    [_movieWriter startRecording];
    [_movieFile startProcessing];
    [_videoCamera startCameraCapture];
    
    __weak __typeof(self) wself = self;
    [_movieWriter setCompletionBlock:^{
        __strong typeof(wself) sself = wself;
        [sself->_filter removeTarget:sself->_movieWriter];
        [sself->_movieWriter finishRecording];
        [sself saveVideoToPhotoAlbum:movieURL];
    }];
}

- (void)saveVideoToPhotoAlbum:(NSURL*)movieURL {
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([movieURL absoluteString])) {
        [library writeVideoAtPathToSavedPhotosAlbum:movieURL completionBlock:^(NSURL *assetURL, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *title = @"视频保存成功";
                if (error) {
                    title = @"视频保存失败";
                }
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                               message:nil
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action) {}];
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
            });
        }];
    }
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
