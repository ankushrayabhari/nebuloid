#ifndef SHADERLOADER_H
#define SHADERLOADER_H

#include <string>

class ShaderLoader {
public:
  static unsigned int loadFileShader(const std::string& filename, unsigned int type);
};

#endif
