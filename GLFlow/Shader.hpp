//
//  Shader.hpp
//  GLFlow
//
//  Created by lijia on 2018/1/16.
//  Copyright © 2018年 Colin Eberhardt. All rights reserved.
//

#ifndef Shader_H
#define Shader_H

#include <glad/glad.h>
#include <stdio.h>
#include <string>
#include <fstream>
#include <sstream>
#include <iostream>

class Shader {
public:
    unsigned int ID;
public:
    Shader(const GLchar *vertexPath, const GLchar *fragmentPath);
    void use();
    void setBool(const std::string &name, bool value) const;
    void setInt(const std::string &name, int value) const;
    void setFloat(const std::string &name, float value) const;
};

#endif /* Shader_H */
