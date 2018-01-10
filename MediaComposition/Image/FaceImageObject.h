//
//  FaceImageObject.h
//  MediaComposition
//
//  Created by lijia on 2018/1/10.
//  Copyright © 2018年 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FaceImageObject : NSObject
@property (nonatomic, strong, readonly) UIImage*         faceImage;
@property (nonatomic, assign, readonly) CGFloat         width;
@property (nonatomic, assign, readonly) CGFloat         height;
-(instancetype)initWithFaceImage:(UIImage*)image width:(CGFloat)width height:(CGFloat)height;
@end
