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
    return CATransform3DMakeRotation(yawRadians, 0, -1, 0);
}

+(CGRect)covertMetaObjectRect:(CGRect)bounds toView:(UIView*)view {
    CGRect screen = UIScreen.mainScreen.bounds;
//    CGRect winFrame = CGRectMake(bounds.origin.x * screen.size.width, bounds, <#CGFloat width#>, <#CGFloat height#>)
//    
//    CATransform3D t = CATransform3DIdentity;
//    t = CATransform3DScale(t, 0, -1, 0);
//    t = CATransform3DTranslate(t, 0, -winFrame.size.height, 0);
//    
    return CGRectZero;
}
@end
