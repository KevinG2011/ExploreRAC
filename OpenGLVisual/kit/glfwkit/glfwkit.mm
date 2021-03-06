//
//  glfwkit.c
//  OpenGLVisual
//
//  Created by Loriya on 2018/2/4.
//  Copyright © 2018年 Colin Eberhardt. All rights reserved.
//

#include "glfwkit.h"
#import <Foundation/Foundation.h>
#include <iostream>
#include <glad/glad.h>
#include <glfw3.h>
#include "Shader.hpp"

void glfwFramebufferSizeCallback(GLFWwindow* window, int width, int height);
void glfwProcessInput(GLFWwindow* window);

int glfwkitRun(int argc,const char *argv[]) {
    // glfw: initialize and configure
    // ------------------------------
    if (!glfwInit())
        return -1;
    
    glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
    glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
    glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
#ifdef __APPLE__
    glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE);
#endif
    
    GLFWwindow* window = glfwCreateWindow(800, 600, "LearnOpenGL", NULL, NULL);
    if (window == NULL)
    {
        std::cout << "Failed to create GLFW window" << std::endl;
        glfwTerminate();
        return -1;
    }
    glfwMakeContextCurrent(window);
    glfwSetFramebufferSizeCallback(window, glfwFramebufferSizeCallback);
    
    // glad: load all OpenGL function pointers
    // ---------------------------------------
    if (!gladLoadGLLoader((GLADloadproc)glfwGetProcAddress))
    {
        std::cout << "Failed to initialize GLAD" << std::endl;
        return -1;
    }
    
    // build and compile our shader program
    // ------------------------------------
    // vertex shader
    NSString *verPath = [[NSBundle mainBundle] pathForResource:@"shader" ofType:@"vs"];
    NSString *fragPath = [[NSBundle mainBundle] pathForResource:@"shader" ofType:@"fs"];
    Shader shader(verPath.UTF8String, fragPath.UTF8String);
    
    // set up vertex data (and buffer(s)) and configure vertex attributes
    // ------------------------------------------------------------------
    float vertices[] = {
        //位置            //颜色
        0.5f, 0.5f, 0, 1.0f, 0.0f, 0.0f,
        -0.5f, 0.5f, 0, 0.0f, 1.0f, 0.0f,
        0.0f,  -0.5f, 0, 0.0f, 0.0f, 1.0f,
    };
    
    unsigned int VBO, VAO;
    glGenBuffers(1, &VBO);
    glGenVertexArrays(1, &VAO);
    glBindVertexArray(VAO);
    
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), (void*)0);
    glEnableVertexAttribArray(0);
    
    glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), (void*)(3 * sizeof(float)));
    glEnableVertexAttribArray(1);
    
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindVertexArray(0);
    
#ifdef DEBUG
    int nrAttributes;
    glGetIntegerv(GL_MAX_VERTEX_ATTRIBS, &nrAttributes);
    std::cout << "Maximum nr of vertex attributes supported: " << nrAttributes << std::endl;
#endif
    double lastTimeValue = glfwGetTime();
    int sign = 1;
    /* Loop until the user closes the window */
    while (!glfwWindowShouldClose(window))
    {
        /* Render here */
        glClearColor(0.2f, 0.3f, 0.3f, 1.0f);
        glClear(GL_COLOR_BUFFER_BIT);
        glfwProcessInput(window);
        
        
        double timeInterval = glfwGetTime() - lastTimeValue;
        double sinValue = sin(timeInterval);
        float offsetValue = sign * 1.6f * sinValue;
        //            NSLog(@"sinValue : %f, offsetValue: %f",sinValue, offsetValue);
        if (sinValue > 0.99) {
            sign = -1;
        } else if (sinValue < -0.99) {
            sign = 1;
        }
//        float greenValue = sin(timeValue) / 2.f + 0.5f;
//        int vertexColorLocation = glGetUniformLocation(shaderProgram, "ourColor");
        shader.use();
        int vertexOffsetLocation = glGetUniformLocation(shader.ID, "xOffset");
        if (vertexOffsetLocation != -1) {
            /*set uniform must use program first */
//            glUniform4f(vertexColorLocation, 0.0f, greenValue, 0.0f, 1.0f);
            glUniform1f(vertexOffsetLocation, offsetValue);
        }
        
        glBindVertexArray(VAO);
        glDrawArrays(GL_TRIANGLES, 0, 3);
        
        /* Swap front and back buffers */
        glfwSwapBuffers(window);
        /* Poll for and process events */
        glfwPollEvents();
    }
    // optional: de-allocate all resources once they've outlived their purpose:
    // ------------------------------------------------------------------------
    glDeleteVertexArrays(1, &VAO);
    glDeleteBuffers(1, &VBO);
    
    // glfw: terminate, clearing all previously allocated GLFW resources.
    // ------------------------------------------------------------------
    glfwTerminate();
    
    return 0;
}

void glfwFramebufferSizeCallback(GLFWwindow* window, int width, int height)
{
    glViewport(0, 0, width, height);
}

void glfwProcessInput(GLFWwindow* window) {
    if(glfwGetKey(window, GLFW_KEY_ENTER) == GLFW_PRESS)
        glfwSetWindowShouldClose(window, true);
}
