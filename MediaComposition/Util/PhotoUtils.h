//
//  PhotoUtils.h
//  MediaComposition
//
//  Created by lijia on 2018/1/4.
//  Copyright © 2018年 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PhotoUtils : NSObject
+ (void)saveVideoToPhotoAlbum:(NSURL*)movieURL
        alertInViewController:(UIViewController*)controller;
@end
