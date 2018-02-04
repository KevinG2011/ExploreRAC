//
//  main.m
//  OpenGLVisual
//
//  Created by lijia on 2018/1/8.
//  Copyright © 2018年 Colin Eberhardt. All rights reserved.
//

#import <Foundation/Foundation.h>
#define USE_GLUT 1

#if USE_GLUT
#include "glutkit.h"
#else
#include "glfwkit.h"
#endif


int main(int argc, const char * argv[]) {
    @autoreleasepool {
#if USE_GLUT
        glutkitRun(argc, argv);
#else
        glfwkitRun(argc, argv);
#endif
    }
    return 0;
}


