//
//  GPUVideoCompositionEditor.m
//  MediaComposition
//
//  Created by lijia on 2018/1/5.
//  Copyright © 2018年 Colin Eberhardt. All rights reserved.
//

#import "GPUImageVideoCompositionEditor.h"
#import "GPUImage.h"
#import <BlocksKit/BlocksKit.h>

@interface GPUImageVideoCompositionEditor ()
@property (nonatomic) NSArray<GPUImageMovie*>    *movies;
@property (nonatomic, strong) GPUImageDissolveBlendFilter         *filter;
@property (nonatomic, strong) GPUImageMovieWriter         *movieWriter;
@end

@implementation GPUImageVideoCompositionEditor

- (void)setupEditor {
    _filter = [[GPUImageDissolveBlendFilter alloc] init];
    _filter.mix = 0.5f;
    
    self.movies = [self.urls bk_map:^id(NSURL *url) {
        GPUImageMovie *movie = [[GPUImageMovie alloc] initWithURL:url];
        movie.runBenchmark = YES;
        movie.playAtActualSpeed = YES;
        return movie;
    }];
    //TODO
}

-(void)exportAsyncToPath:(NSString*)path completionHandler:(void (^)(void))handler {
    //TODO
    unlink([path UTF8String]);
}
@end
