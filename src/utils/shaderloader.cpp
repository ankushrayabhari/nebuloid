#include <glad/glad.h>
#include <GLFW/glfw3.h>
#include <iostream>
#include <fstream>
#include <stdexcept>
#include <string>
#include <sstream>
#include "shaderloader.h"

unsigned int ShaderLoader::loadFileShader(const std::string& filename, unsigned int type) {
  std::ifstream fin(filename);

  if(!fin.good()) {
    throw std::runtime_error("File error: " + filename);
  }

  std::stringstream file;
  file << fin.rdbuf();
  char * data = const_cast<char*>(file.str().data());

  unsigned int shader = glCreateShader(type);
  glShaderSource(shader, 1, &data, NULL);
  glCompileShader(shader);

  int success;
  char infoLog[512];
  glGetShaderiv(shader, GL_COMPILE_STATUS, &success);
  if(!success) {
      glGetShaderInfoLog(shader, 512, NULL, infoLog);
      throw std::runtime_error("Shader Compile Error: " + std::string(infoLog));
  }

  return shader;
}
