//
//  ViewController.m
//  AVMediaBlend
//
//  Created by lijia on 2017/12/27.
//  Copyright © 2017年 Colin Eberhardt. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "GPUImage.h"

@interface ViewController () {
    //capture
    GPUImageVideoCamera *_videoCamera;
    //movie
    GPUImageMovie *_movieFile;
    //blend filter
    GPUImageOutput<GPUImageInput> *_filter;
    //watermark filter
    GPUImageOutput<GPUImageInput> *_watermarkfilter;
    //write file
    GPUImageMovieWriter *_movieWriter;
    //file path
    NSURL *_movieURL;
    //process label
    UILabel  *_label;
}
@end

@implementation ViewController

- (void)loadView {
    GPUImageView *view = [[GPUImageView alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupBasePipeline];
//    [self buildVideoWatermarkPipeline];
//    [self buildImageWatermarkPipeline];
    [self buildVideoImageWatermarkPipeline];
//    [self buildVideoComposition];
    [self setupDisplayLink];
}

- (void)setupView {
    _label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 100, 100)];
    _label.textColor = [UIColor redColor];
    [self.view addSubview:_label];
}

- (void)setupBasePipeline {
    _videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480
                                                       cameraPosition:AVCaptureDevicePositionBack];
    _videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    
    NSURL *sampleURL = [[NSBundle mainBundle] URLForResource:@"abc" withExtension:@"mp4"];
    _movieFile = [[GPUImageMovie alloc] initWithURL:sampleURL];
    _movieFile.runBenchmark = YES;
    _movieFile.playAtActualSpeed = YES;
    
    GPUImageDissolveBlendFilter *filter = [[GPUImageDissolveBlendFilter alloc] init];
    [filter setMix:0.5];
    _filter = filter;
    
    GPUImageDissolveBlendFilter *watermarkFilter = [[GPUImageDissolveBlendFilter alloc] init];
    [watermarkFilter setMix:0.5];
    _watermarkfilter = watermarkFilter;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDir = [paths objectAtIndex:0];
    NSString *moviePath = [cacheDir stringByAppendingPathComponent:@"movie.m4v"];
    unlink([moviePath UTF8String]);
    _movieURL = [NSURL fileURLWithPath:moviePath];
    _movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:_movieURL size:CGSizeMake(640, 480)];
}

- (void)setupDisplayLink {
    CADisplayLink* dlink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateProgress)];
    [dlink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [dlink setPaused:NO];
}

- (void)buildVideoWatermarkPipeline {
    _movieWriter.audioProcessingCallback = ^(SInt16 **samplesRef, CMItemCount numSamplesInBuffer) {
        //        SInt16 *samples = *samplesRef;
        //        NSLog(@"sample %d, %ld",*samples,numSamplesInBuffer);
    };
    
    BOOL audioFromFile = NO;
    if (audioFromFile) {
        [_movieFile addTarget:_filter];
        [_videoCamera addTarget:_filter];
        _videoCamera.audioEncodingTarget = _movieWriter;
        _movieWriter.shouldPassthroughAudio = YES;
        [_movieFile enableSynchronizedEncodingUsingMovieWriter:_movieWriter];
        
    } else {
        [_videoCamera addTarget:_filter];
        [_movieFile addTarget:_filter];
        _videoCamera.audioEncodingTarget = _movieWriter;
        _movieWriter.shouldPassthroughAudio = NO;
        _movieWriter.encodingLiveVideo = YES;
    }
    
    [_filter addTarget:(GPUImageView*)self.view];
    [_filter addTarget:_movieWriter];
    
    [_movieFile startProcessing];
    [_videoCamera startCameraCapture];
    [_movieWriter startRecording];
    
    __weak __typeof(self) wself = self;
    [_movieWriter setCompletionBlock:^{
        __strong typeof(wself) sself = wself;
        [sself->_filter removeTarget:sself->_movieWriter];
        [sself->_movieFile endProcessing];
        [sself->_videoCamera stopCameraCapture];
        [sself->_movieWriter finishRecording];
        [sself saveVideoToPhotoAlbum:sself->_movieURL];
    }];
}

- (GPUImageUIElement*)createWatermarkUIElement {
    //水印
    CGSize size = self.view.bounds.size;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    label.text = @"我是水印";
    label.font = [UIFont systemFontOfSize:30];
    label.textColor = [UIColor redColor];
    [label sizeToFit];
    UIImage *image = [UIImage imageNamed:@"watermark.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    subView.backgroundColor = [UIColor clearColor];
    imageView.center = CGPointMake(subView.bounds.size.width / 2, subView.bounds.size.height / 2);
    [subView addSubview:imageView];
    [subView addSubview:label];
    GPUImageUIElement *uielement = [[GPUImageUIElement alloc] initWithView:subView];
    return uielement;
}

- (void)buildImageWatermarkPipeline {
    GPUImageFilter* progressFilter = [[GPUImageFilter alloc] init];
    [_movieFile addTarget:progressFilter];
    [progressFilter addTarget:_filter];
    
    GPUImageUIElement *uielement = [self createWatermarkUIElement];
    [uielement addTarget:_filter];
    
    _movieWriter.shouldPassthroughAudio = YES;
    _movieFile.audioEncodingTarget = _movieWriter;
    [_movieFile enableSynchronizedEncodingUsingMovieWriter:_movieWriter];
    
    [_filter addTarget:(GPUImageView*)self.view];
    [_filter addTarget:_movieWriter];
 
    [_movieWriter startRecording];
    [_movieFile startProcessing];
    
    [progressFilter setFrameProcessingCompletionBlock:^(GPUImageOutput *output, CMTime time) {
        [uielement updateWithTimestamp:time];
    }];
    
    __weak __typeof(self) wself = self;
    [_movieWriter setCompletionBlock:^{
        __strong typeof(wself) sself = wself;
        [sself->_filter removeTarget:sself->_movieWriter];
        [sself->_movieFile endProcessing];
        [sself->_movieWriter finishRecording];
        [sself saveVideoToPhotoAlbum:sself->_movieURL];
    }];
}

- (void)buildVideoImageWatermarkPipeline {
    [_videoCamera addTarget:_filter];
    [_movieFile addTarget:_filter];
    
    GPUImageFilter* progressFilter = [[GPUImageFilter alloc] init];
    [_filter addTarget:progressFilter];
    [progressFilter addTarget:_watermarkfilter];
    
    GPUImageUIElement *uielement = [self createWatermarkUIElement];
    [uielement addTarget:_watermarkfilter];

    [progressFilter setFrameProcessingCompletionBlock:^(GPUImageOutput *output, CMTime time) {
        [uielement updateWithTimestamp:time];
    }];
    
    _videoCamera.audioEncodingTarget = _movieWriter;
    _movieWriter.shouldPassthroughAudio = NO;
    _movieWriter.encodingLiveVideo = YES;
    
    [_watermarkfilter addTarget:(GPUImageView*)self.view];
    [_watermarkfilter addTarget:_movieWriter];
    
    [_movieFile startProcessing];
    [_videoCamera startCameraCapture];
    [_movieWriter startRecording];
    
    __weak __typeof(self) wself = self;
    [_movieWriter setCompletionBlock:^{
        __strong typeof(wself) sself = wself;
        [sself->_watermarkfilter removeTarget:sself->_movieWriter];
        [sself->_videoCamera stopCameraCapture];
        [sself->_movieFile endProcessing];
        [sself->_movieWriter finishRecording];
        [sself saveVideoToPhotoAlbum:sself->_movieURL];
    }];
}

- (void)updateProgress {
    _label.text = [NSString stringWithFormat:@"Progress:%d%%", (int)(_movieFile.progress * 100)];
    [_label sizeToFit];
}

- (void)saveVideoToPhotoAlbum:(NSURL*)movieURL {
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(movieURL.path)) {
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
