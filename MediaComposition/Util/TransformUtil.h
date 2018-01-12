//
//  TransformUtil.h
//  MediaComposition
//
//  Created by lijia on 2018/1/10.
//  Copyright © 2018年 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface TransformUtil : NSObject
+(CATransform3D)transformForRollAngle:(CGFloat)rollAngle;
+(CATransform3D)transformForYawAngle:(CGFloat)yawAngle;
@end
