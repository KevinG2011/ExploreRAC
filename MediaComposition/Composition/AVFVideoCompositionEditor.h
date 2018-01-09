//
//  AVVideoCompositionEditor.h
//  MediaComposition
//
//  Created by lijia on 2018/1/4.
//  Copyright © 2018年 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoCompositionEditor.h"

@interface AVFVideoCompositionEditor : VideoCompositionEditor
@property (nonatomic) AVPlayerItem         *playerItem;
@property (nonatomic) NSArray<AVAsset*>    *assets;
@property (nonatomic, strong) AVAssetExportSession    *exportSession;

-(void)exportAsyncToPath:(NSString*)path completionHandler:(void (^)(void))handler;
@end
