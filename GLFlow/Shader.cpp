//
//  Shader.cpp
//  GLFlow
//
//  Created by lijia on 2018/1/16.
//  Copyright © 2018年 Colin Eberhardt. All rights reserved.
//

#include "Shader.hpp"
Shader::Shader(const char* vertexPath, const char* fragmentPath) {
    
}

void Shader::use() {
    glUseProgram(ID);
}

void Shader::setBool(const std::string &name, bool value) const {
    
}

void Shader::setInt(const std::string &name, int value) const {
    
}

void Shader::setFloat(const std::string &name, float value) const {
    
}
