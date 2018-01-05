//
//  VideoCompositionEditor.m
//  MediaComposition
//
//  Created by lijia on 2018/1/5.
//  Copyright © 2018年 Colin Eberhardt. All rights reserved.
//

#import "VideoCompositionEditor.h"
@interface VideoCompositionEditor ()
-(void)setupEditor;
@end

@implementation VideoCompositionEditor
-(instancetype)initWithURLs:(NSArray<NSURL*>*)urls {
    self = [super init];
    if (self) {
        self.urls = urls;
        [self setupEditor];
    }
    return self;
}

-(void)setupEditor {
    NSAssert(NO, @"subclass implements");
}

-(void)exportAsyncToPath:(NSString*)path completionHandler:(void (^)(void))handler {
    NSAssert(NO, @"subclass implements");
}
@end
