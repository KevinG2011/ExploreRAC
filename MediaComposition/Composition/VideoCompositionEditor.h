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
@property (nonatomic, copy) NSArray<NSURL*>         *urls;

-(instancetype)initWithURLs:(NSArray<NSURL*>*)urls;
-(void)exportAsyncToPath:(NSString*)path completionHandler:(void (^)(void))handler;
@end
