#ifndef SHADERLOADER_H
#define SHADERLOADER_H

#include <string>

namespace Utils {
  class ShaderLoader {
  public:
    static unsigned int LoadFileShader(const std::string& filename);
    static unsigned int LoadFilesShaderProgram(const std::vector<std::string>& files);
  };
};

#endif
