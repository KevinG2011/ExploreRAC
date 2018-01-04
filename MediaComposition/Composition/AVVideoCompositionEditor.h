//
//  AVVideoCompositionEditor.h
//  MediaComposition
//
//  Created by lijia on 2018/1/4.
//  Copyright © 2018年 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface VideoCompositionEditor : NSObject
@property (nonatomic, strong, readonly) AVPlayerItem         *playerItem;
@property (nonatomic, strong, readonly) NSArray<AVAsset*>            *assets;

-(instancetype)initWithURLs:(NSArray<NSURL*>*)urls;
@end
