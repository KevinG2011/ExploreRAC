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
#import "PhotoUtils.h"
#import "TransformUtil.h"
#import "GPUImageBeautifyFilter.h"

@interface ViewController ()<GPUImageVideoCameraDelegate, AVCaptureMetadataOutputObjectsDelegate> {
    //output view
    GPUImageView *_gpuImageView;
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
    //output
    GPUImageRawDataOutput *_rawDataOutput;
    //dataOutput
    UIImageView *_outputImageView;
    //file path
    NSURL *_movieURL;
    //process label
    UILabel  *_label;
    
    //faceu image view;
    __weak UIView *_faceuView;
    //detect queue
    dispatch_queue_t _faceDetectQueue;
    AVCaptureMetadataOutput *_metaOutput;
    NSMutableDictionary *_faces;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self setupBasePipeline];
    [self buildVideoWatermarkPipeline];
//    [self buildImageWatermarkPipeline];
//    [self buildVideoImageWatermarkPipeline];
//    [self buildVideoComposition];
//    [self buildVideOutputTexture];
//    [self buildBeautifyFaceDetector];
//    [self buildAVFaceDetector];
//    [self setupDisplayLink];
}

- (void)setupView {
    GPUImageView *view = [[GPUImageView alloc] initWithFrame:self.view.bounds];
    view.backgroundColor = [UIColor blackColor];
    _gpuImageView = view;
    [self.view addSubview:_gpuImageView];
    
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

- (UIView*)createFaceuView {
    CGSize size = self.view.bounds.size;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    view.backgroundColor = [UIColor clearColor];
    UIImage *image = [UIImage imageNamed:@"Crown"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.tag = 101;
    imageView.center = CGPointMake(view.bounds.size.width / 2, view.bounds.size.height / 2);
    [view addSubview:imageView];
    CATransform3D t = CATransform3DIdentity;
    t.m34 = -1.0 / 1000;
    view.layer.sublayerTransform = t;
    _faceuView = view;
    return view;
}

- (CIImage*)faceImageFromSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    CVPixelBufferRef pixelBuffer = (CVPixelBufferRef)CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(pixelBuffer, 0);
    CIImage *faceImage = [[CIImage alloc] initWithCVPixelBuffer:pixelBuffer];
    
//    uint8_t *lumaBuffer = (uint8_t *)CVPixelBufferGetBaseAddressOfPlane(pixelBuffer, 0);
//    size_t bytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(pixelBuffer,0);
//    size_t width  = CVPixelBufferGetWidth(pixelBuffer);
//    size_t height = CVPixelBufferGetHeight(pixelBuffer);
//
//    CGColorSpaceRef grayColorSpace = CGColorSpaceCreateDeviceGray();

//    CGContextRef context = CGBitmapContextCreate(lumaBuffer, width, height, 8, bytesPerRow, grayColorSpace,0);
//    CGImageRef cgImage = CGBitmapContextCreateImage(context);
//    UIImage *faceImage = [UIImage imageWithCGImage:cgImage];
//
//    CGImageRelease(cgImage);
//    CGContextRelease(context);
//    CGColorSpaceRelease(grayColorSpace);
    
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
    
//    FaceImageObject *faceObj = [[FaceImageObject alloc] initWithFaceImage:faceImage];
    return faceImage;
}

#pragma mark <GPUImageVideoCameraDelegate>
- (void)willOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    //TODO
}

#pragma mark <AVCaptureMetadataOutputObjectsDelegate>
- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray< AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    for (AVMetadataFaceObject *face in metadataObjects) {
//        NSLog(@"faceID :%ld, bounds :%@",(long)face.faceID, NSStringFromCGRect(face.bounds));
        UIImageView *faceuImageV = (UIImageView*)[_faceuView viewWithTag:101];
        if (faceuImageV) {
            CGRect faceBounds = face.bounds;
            CATransform3D t = CATransform3DIdentity;
//            if ([face hasRollAngle]) {
//                CATransform3D rollTransform = [TransformUtil transformForRollAngle:face.rollAngle];
//                t = CATransform3DConcat(rollTransform, t);
//            }
//            if ([face hasYawAngle]) {
//                CATransform3D yawTransform = [TransformUtil transformForYawAngle:face.yawAngle];
//                t = CATransform3DConcat(yawTransform, t);
//            }
            dispatch_async(dispatch_get_main_queue(), ^{
                CGRect faceRect = [TransformUtil covertMetaObjectRect:faceBounds toView:_faceuView];
                faceuImageV.layer.transform = t;
                faceuImageV.frame = faceRect;
            });
        }
        break;
    }
}

- (void)buildAVFaceDetector {
    _faceDetectQueue = dispatch_queue_create("com.living.faceDetect", DISPATCH_QUEUE_SERIAL);
    _videoCamera.horizontallyMirrorFrontFacingCamera = YES;
    _metaOutput = [[AVCaptureMetadataOutput alloc] init];
    if ([_videoCamera.captureSession canAddOutput:_metaOutput]) {
        [_videoCamera.captureSession addOutput:_metaOutput];
        _metaOutput.metadataObjectTypes = @[AVMetadataObjectTypeFace];
        [_metaOutput setMetadataObjectsDelegate:self queue:_faceDetectQueue];
    }

    GPUImageBeautifyFilter *beautifyFilter = [[GPUImageBeautifyFilter alloc] init];
    [_videoCamera addTarget:beautifyFilter];
    
    GPUImageAddBlendFilter *blendFilter = [[GPUImageAddBlendFilter alloc] init];
    [beautifyFilter addTarget:blendFilter];
    
    UIView *faceuView = [self createFaceuView];
    GPUImageUIElement *uiElement = [[GPUImageUIElement alloc] initWithView:faceuView];
    [uiElement addTarget:blendFilter];
    
    [beautifyFilter setFrameProcessingCompletionBlock:^(GPUImageOutput *output, CMTime time) {
        [uiElement updateWithTimestamp:time];
    }];
    
    [blendFilter addTarget:_gpuImageView];
    
    [_videoCamera rotateCamera];
    [_videoCamera startCameraCapture];
}

- (void)buildBeautifyFaceDetector {
    _videoCamera.delegate = self;
    _videoCamera.horizontallyMirrorFrontFacingCamera = YES;
    GPUImageBeautifyFilter *beautifyFilter = [[GPUImageBeautifyFilter alloc] init];
    [_videoCamera addTarget:beautifyFilter];
    
    GPUImageAddBlendFilter *blendFilter = [[GPUImageAddBlendFilter alloc] init];
    [beautifyFilter addTarget:blendFilter];
    
    UIView *faceuView = [self createFaceuView];
    GPUImageUIElement *uiElement = [[GPUImageUIElement alloc] initWithView:faceuView];
    [uiElement addTarget:blendFilter];
    
    [beautifyFilter setFrameProcessingCompletionBlock:^(GPUImageOutput *output, CMTime time) {
        [uiElement updateWithTimestamp:time];
    }];
    
    [blendFilter addTarget:_gpuImageView];
    
    [_videoCamera rotateCamera];
    [_videoCamera startCameraCapture];
}

- (void)buildVideOutputTexture {
    _outputImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_outputImageView];
    
    CGSize outputSize = CGSizeMake(640, 480);
    NSAssert(_videoCamera, @"camera not initialize");
    _videoCamera.horizontallyMirrorFrontFacingCamera = YES;
    _rawDataOutput = [[GPUImageRawDataOutput alloc] initWithImageSize:outputSize resultsInBGRAFormat:YES];
    [_videoCamera addTarget:_rawDataOutput];
    
    __weak __typeof(self) wself = self;
    __weak __typeof(_rawDataOutput) wDataOutput = _rawDataOutput;
    _rawDataOutput.newFrameAvailableBlock = ^{
        if (wself == nil) {
            return;
        }
        [wDataOutput lockFramebufferForReading];
        __strong typeof(wDataOutput) sDataOutput = wDataOutput;
        GLubyte *outputBytes = [sDataOutput rawBytesForImage];
        NSUInteger bytesPerRow = [sDataOutput bytesPerRowInOutput];
        CVPixelBufferRef pixelBuffer = NULL;
        CVReturn ret = CVPixelBufferCreateWithBytes(kCFAllocatorDefault, outputSize.width, outputSize.height, kCVPixelFormatType_32BGRA, outputBytes, bytesPerRow, nil, nil, nil, &pixelBuffer);
        if (ret != kCVReturnSuccess) {
            NSLog(@"status %d", ret);
        }
        [sDataOutput unlockFramebufferAfterReading];
        if (pixelBuffer == NULL) {
            return;
        }
        CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
        CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, outputBytes, bytesPerRow * 480, NULL);
        CGImageRef cgImage = CGImageCreate(640, 480, 8, 32, bytesPerRow, rgbColorSpace, kCGImageAlphaPremultipliedFirst|kCGBitmapByteOrder32Little, provider, NULL, true, kCGRenderingIntentDefault);
        UIImage *image = [UIImage imageWithCGImage:cgImage];
        
        __strong typeof(wself) sself = wself;
        dispatch_async(dispatch_get_main_queue(), ^{
            sself->_outputImageView.image = image;
        });
        
        CGImageRelease(cgImage);
        CGDataProviderRelease(provider);
        CGColorSpaceRelease(rgbColorSpace);
        CFRelease(pixelBuffer);
    };
    
    [_videoCamera startCameraCapture];
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
    
    [_filter addTarget:_gpuImageView];
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
        [PhotoUtils saveVideoToPhotoAlbum:sself->_movieURL alertInViewController:sself];
    }];
}

- (UIView*)createWatermarkView {
    //水印
    CGSize size = self.view.bounds.size;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    label.text = @"我是水印";
    label.font = [UIFont systemFontOfSize:30];
    label.textColor = [UIColor redColor];
    [label sizeToFit];
    UIImage *image = [UIImage imageNamed:@"watermark"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    view.backgroundColor = [UIColor clearColor];
    imageView.center = CGPointMake(view.bounds.size.width / 2, view.bounds.size.height / 2);
    [view addSubview:imageView];
    [view addSubview:label];
    return view;
}

- (void)buildImageWatermarkPipeline {
    GPUImageFilter* progressFilter = [[GPUImageFilter alloc] init];
    [_movieFile addTarget:progressFilter];
    [progressFilter addTarget:_filter];
    
    UIView *watermarkView = [self createWatermarkView];
    GPUImageUIElement *uiElement = [[GPUImageUIElement alloc] initWithView:watermarkView];
    [uiElement addTarget:_filter];
    
    _movieWriter.shouldPassthroughAudio = YES;
    _movieFile.audioEncodingTarget = _movieWriter;
    [_movieFile enableSynchronizedEncodingUsingMovieWriter:_movieWriter];
    
    [_filter addTarget:_gpuImageView];
    [_filter addTarget:_movieWriter];
 
    [_movieWriter startRecording];
    [_movieFile startProcessing];
    
    [progressFilter setFrameProcessingCompletionBlock:^(GPUImageOutput *output, CMTime time) {
        [uiElement updateWithTimestamp:time];
    }];
    
    __weak __typeof(self) wself = self;
    [_movieWriter setCompletionBlock:^{
        __strong typeof(wself) sself = wself;
        [sself->_filter removeTarget:sself->_movieWriter];
        [sself->_movieFile endProcessing];
        [sself->_movieWriter finishRecording];
        [PhotoUtils saveVideoToPhotoAlbum:sself->_movieURL alertInViewController:sself];
    }];
}

- (void)buildVideoImageWatermarkPipeline {
    [_videoCamera addTarget:_filter];
    [_movieFile addTarget:_filter];
    
    GPUImageFilter* progressFilter = [[GPUImageFilter alloc] init];
    [_filter addTarget:progressFilter];
    [progressFilter addTarget:_watermarkfilter];
    
    UIView *watermarkView = [self createWatermarkView];
    GPUImageUIElement *uiElement = [[GPUImageUIElement alloc] initWithView:watermarkView];
    [uiElement addTarget:_watermarkfilter];

    [progressFilter setFrameProcessingCompletionBlock:^(GPUImageOutput *output, CMTime time) {
        [uiElement updateWithTimestamp:time];
    }];
    
    _videoCamera.audioEncodingTarget = _movieWriter;
    _movieWriter.shouldPassthroughAudio = NO;
    _movieWriter.encodingLiveVideo = YES;
    
    [_watermarkfilter addTarget:_gpuImageView];
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
        [PhotoUtils saveVideoToPhotoAlbum:sself->_movieURL alertInViewController:sself];
    }];
}

- (void)updateProgress {
    _label.text = [NSString stringWithFormat:@"Progress:%d%%", (int)(_movieFile.progress * 100)];
    [_label sizeToFit];
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
