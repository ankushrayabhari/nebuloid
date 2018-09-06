MACOS_MIN_VERSION := 10.10
EXECUTABLENAME = Nebuloid

# Source Directories
SRCDIR := src/
INCLUDEDIR := include/
SHADERDIR := shaders/
ASSETSDIR := assets/

# Build Directories
BUILDDIR := build/
EXECDIR := build/bin/
EXECUTABLE = $(EXECDIR)$(EXECUTABLENAME)
SHADERBUILDDIR = $(EXECDIR)$(SHADERDIR)
ASSETSBUILDDIR = $(EXECDIR)$(ASSETSDIR)

CXX := g++
LINKER := g++
CXXFLAGS := -std=c++11 -mmacosx-version-min=$(MACOS_MIN_VERSION) -Wall -I$(INCLUDEDIR) -I$(SRCDIR) -MMD -MP
LDFLAGS := -mmacosx-version-min=$(MACOS_MIN_VERSION)
LDLIBS := -lglfw -framework Cocoa -framework OpenGL -framework IOKit -framework CoreVideo

# C++ Object/Dependency Files
SRC := $(wildcard $(SRCDIR)*.cpp $(SRCDIR)**/*.cpp)
OBJ := $(SRC:$(SRCDIR)%.cpp=$(BUILDDIR)%.o)
DEP := $(OBJ:%.o=%.d)

# Shader Files
SHADERSRC := $(wildcard $(SHADERDIR)* $(SHADERDIR)**/*)
SHADEROBJ := $(SHADERSRC:$(SHADERDIR)%=$(SHADERBUILDDIR)%)

# Asset files
ASSETSSRC := $(wildcard $(ASSETSDIR)* $(ASSETSDIR)**/*)
ASSETSOBJ := $(ASSETSSRC:$(ASSETSDIR)%=$(ASSETSBUILDDIR)%)

$(EXECUTABLE): $(OBJ)
	@mkdir -p $(dir $@)
	$(LINKER) $(OBJ) $(LDLIBS) $(LDFLAGS) -o $@

$(OBJ): $(BUILDDIR)%.o: $(SRCDIR)%.cpp
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) $< -c -o $@

$(SHADEROBJ): $(SHADERBUILDDIR)%: $(SHADERDIR)%
	@mkdir -p $(dir $@)
	cp $< $@

$(ASSETSOBJ): $(ASSETSBUILDDIR)%: $(ASSETSDIR)%
	@mkdir -p $(dir $@)
	cp $< $@

default: $(EXECUTABLE) $(SHADEROBJ) $(ASSETSOBJ)
.DEFAULT_GOAL := default

clean:
	rm -rf $(BUILDDIR)

run:
	cd $(EXECDIR) && ./$(EXECUTABLENAME) > $(EXECUTABLENAME).log

.PHONY: clean, run, default
-include $(DEP)
