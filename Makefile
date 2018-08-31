MACOS_MIN_VERSION := 10.10

BUILDDIR := build/
EXECDIR := build/bin/
SRCDIR := src/
INCLUDEDIR := include/
SHADERDIR := shaders/

EXECUTABLENAME = Nebuloid
EXECUTABLE = $(EXECDIR)$(EXECUTABLENAME)

CXX := g++
LINKER := ld
CXXFLAGS := -std=c++11 -mmacosx-version-min=$(MACOS_MIN_VERSION) -Wall -I$(INCLUDEDIR) -I$(SRCDIR)
LDFLAGS := -macosx_version_min $(MACOS_MIN_VERSION)
LDLIBS := -lglfw -lc++ -lpthread -ldl -framework Cocoa -framework OpenGL -framework IOKit -framework CoreVideo

SRC := $(wildcard $(SRCDIR)*.cpp $(SRCDIR)**/*.cpp)
OBJ := $(SRC:$(SRCDIR)%.cpp=$(BUILDDIR)%.o)

SHADERSRC := $(wildcard $(SHADERDIR)*.vert $(SHADERDIR)*.frag)
SHADEROBJ := $(SHADERSRC:$(SHADERDIR)%=$(EXECDIR)%)

$(EXECUTABLE): $(OBJ) $(SHADEROBJ)
	mkdir -p $(dir $@) && $(LINKER) $(OBJ) $(LDLIBS) $(LDFLAGS) -o $@

$(OBJ): $(BUILDDIR)%.o: $(SRCDIR)%.cpp
	mkdir -p $(dir $@) && $(CXX) $(CXXFLAGS) $< -c -o $@

$(SHADEROBJ): $(EXECDIR)%: $(SHADERDIR)%
	mkdir -p $(dir $@) && cp $< $@

clean:
	rm -rf $(BUILDDIR)

run:
	cd $(EXECDIR) && ./$(EXECUTABLENAME)

.PHONY: clean, run
