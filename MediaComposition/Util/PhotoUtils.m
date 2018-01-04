//
//  PhotoUtils.m
//  MediaComposition
//
//  Created by lijia on 2018/1/4.
//  Copyright © 2018年 Colin Eberhardt. All rights reserved.
//

#import "PhotoUtils.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation PhotoUtils
+ (void)saveVideoToPhotoAlbum:(NSURL*)movieURL
        alertInViewController:(UIViewController*)controller {
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(movieURL.path)) {
        [library writeVideoAtPathToSavedPhotosAlbum:movieURL completionBlock:^(NSURL *assetURL, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *title = @"视频保存成功";
                if (error) {
                    title = @"视频保存失败";
                }
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                               message:nil
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action) {}];
                [alert addAction:defaultAction];
                if (controller) {
                    [controller presentViewController:alert animated:YES completion:nil];
                }
            });
        }];
    }
}
@end
