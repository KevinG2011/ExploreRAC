//
//  FaceImageObject.m
//  MediaComposition
//
//  Created by lijia on 2018/1/10.
//  Copyright © 2018年 Colin Eberhardt. All rights reserved.
//

#import "FaceImageObject.h"

@implementation FaceImageObject
-(instancetype)initWithFaceImage:(UIImage*)image width:(CGFloat)width height:(CGFloat)height {
    self = [super init];
    if (self) {
        _faceImage = image;
        _width = width;
        _height = height;
    }
    return self;
}

@end
