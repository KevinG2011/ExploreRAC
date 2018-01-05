//
//  VideoCompositionEditor.h
//  MediaComposition
//
//  Created by lijia on 2018/1/5.
//  Copyright © 2018年 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface VideoCompositionEditor : NSObject
@property (nonatomic) AVPlayerItem         *playerItem;
@property (nonatomic) NSArray<AVAsset*>    *assets;
@property (nonatomic, copy) NSArray<NSURL*>         *urls;
@property (nonatomic, strong) AVAssetExportSession    *exportSession;

-(instancetype)initWithURLs:(NSArray<NSURL*>*)urls;
-(void)exportAsyncToPath:(NSString*)path completionHandler:(void (^)(void))handler;
@end
