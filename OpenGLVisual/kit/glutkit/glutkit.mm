//
//  glutkit.c
//  OpenGLVisual
//
//  Created by Loriya on 2018/2/4.
//  Copyright © 2018年 Colin Eberhardt. All rights reserved.
//

#include "glutkit.h"
#include "GLTools.h"
#include <glut/glut.h>

void glutkitSetup();
void glutkitRenderScene();
void glutkitFramebufferSizeCallback(int w, int h);

GLBatch triangleBatch;
GLShaderManager shaderManager;


int glutkitRun(int argc,const char *argv[]) {
    //设置当前工作目录，针对MAC OS X
    gltSetWorkingDirectory(argv[0]);
    //初始化GLUT库
    
    glutInit(&argc, (char**)argv);
    
    /*初始化双缓冲窗口，其中标志GLUT_DOUBLE、GLUT_RGBA、GLUT_DEPTH、GLUT_STENCIL分别指
     双缓冲窗口、RGBA颜色模式、深度测试、模板缓冲区*/
    glutInitDisplayMode(GLUT_DOUBLE|GLUT_RGBA|GLUT_DEPTH|GLUT_STENCIL);
    
    //GLUT窗口大小，标题窗口
    glutInitWindowSize(800,600);
    glutCreateWindow("Triangle");
    
    //注册回调函数
    glutReshapeFunc(glutkitFramebufferSizeCallback);
    glutDisplayFunc(glutkitRenderScene);
    
    //驱动程序的初始化中没有出现任何问题。
    GLenum err = glewInit();
    if(GLEW_OK != err) {
        
        fprintf(stderr,"glew error:%s\n",glewGetErrorString(err));
        
        return 1;
        
    }
    glutkitSetup();
    glutMainLoop();
    return 0;
}

void glutkitSetup() {
    //设置背影颜色
    glClearColor(0.0f,0.0f,1.0f,1.0f);
    
    //初始化着色管理器
    shaderManager.InitializeStockShaders();
    
    //设置三角形，其中数组vVert包含所有3个顶点的x,y,笛卡尔坐标对。
    GLfloat vVerts[] = {
        
        -0.5f,0.0f,0.0f,
        
        0.5f,0.0f,0.0f,
        
        0.0f,0.5f,0.0f,
        
    };
    
    //批次处理
    triangleBatch.Begin(GL_TRIANGLES,3);
    triangleBatch.CopyVertexData3f(vVerts);
    triangleBatch.End();
}

void glutkitRenderScene() {
    //清除一个或一组特定的缓冲区
    glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT|GL_STENCIL_BUFFER_BIT);
    
    //设置一组浮点数来表示红色
    GLfloat vRed[] = {1.0f,0.0f,0.0f,1.0f};
    
    //传递到存储着色器，即GLT_SHADER_IDENTITY着色器，这个着色器只是使用指定颜色以默认笛卡尔坐标第在屏幕上渲染几何图形
    shaderManager.UseStockShader(GLT_SHADER_IDENTITY,vRed);
    
    //提交着色器
    triangleBatch.Draw();
    
    //将在后台缓冲区进行渲染，然后在结束时交换到前台
    glutSwapBuffers();
}

void glutkitFramebufferSizeCallback(int w, int h) {
    glViewport(0, 0, w, h);
}
