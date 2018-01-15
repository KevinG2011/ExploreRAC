//
//  TransformUtil.m
//  MediaComposition
//
//  Created by lijia on 2018/1/10.
//  Copyright © 2018年 Colin Eberhardt. All rights reserved.
//

#import "TransformUtil.h"
#import <GLKit/GLKit.h>

@implementation TransformUtil
+(CATransform3D)transformForRollAngle:(CGFloat)rollAngle {
    CGFloat rollRadians = GLKMathDegreesToRadians(rollAngle);
    return CATransform3DMakeRotation(rollRadians, 0, 0, 1);
}

+(CATransform3D)transformForYawAngle:(CGFloat)yawAngle {
    CGFloat yawRadians = GLKMathDegreesToRadians(yawAngle);
    return CATransform3DMakeRotation(yawRadians, 0, 1, 0);
}

+(CGRect)covertMetaObjectRect:(CGRect)bounds toView:(UIView*)view {
    //摄像头坐标, 横屏左上角开始.
    CGRect screen = UIScreen.mainScreen.bounds;
    CGRect metaRect = CGRectMake(bounds.origin.y * screen.size.width,
                                 bounds.origin.x * screen.size.height,
                                 bounds.size.width * screen.size.height, bounds.size.height * screen.size.width);
    if (view) {
        metaRect = [view convertRect:metaRect fromView:nil];
    }
    return metaRect;
}
@end
