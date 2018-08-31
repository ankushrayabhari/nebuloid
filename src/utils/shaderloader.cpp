#include <glad/glad.h>
#include <iostream>
#include <fstream>
#include <stdexcept>
#include <string>
#include <sstream>
#include <utils/shaderloader.h>

unsigned int Utils::ShaderLoader::LoadFileShader(const std::string& filename) {
  std::ifstream fin(filename);

  if(!fin.good()) {
    throw std::runtime_error("File error: " + filename);
  }

  std::stringstream file;
  file << fin.rdbuf();
  char * data = const_cast<char*>(file.str().data());

  const int extensionStartIndex = filename.rfind(".") + 1;
  if (extensionStartIndex == 0) {
    throw std::runtime_error("Invalid file name (lacks .): " + filename);
  }

  const std::string extension = filename.substr(extensionStartIndex);
  unsigned int type;
  if (extension == "vert") {
    type = GL_VERTEX_SHADER;
  } else if (extension == "frag") {
    type = GL_FRAGMENT_SHADER;
  } else {
    throw std::runtime_error("Invalid file extension: " + filename);
  }

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
