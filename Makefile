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
CXXFLAGS := -std=c++11 -mmacosx-version-min=$(MACOS_MIN_VERSION) -Wall -I$(INCLUDEDIR)
LDFLAGS := -macosx_version_min $(MACOS_MIN_VERSION)
LDLIBS := -lglfw -lc++ -lpthread -ldl -framework Cocoa -framework OpenGL -framework IOKit -framework CoreVideo

SRC := $(wildcard $(SRCDIR)*.cpp) \
			 $(wildcard $(SRCDIR)**/*.cpp)
OBJ := $(SRC:$(SRCDIR)%.cpp=$(BUILDDIR)%.o)

SHADERSRC := $(wildcard $(SHADERDIR)*.vert) \
						 $(wildcard $(SHADERDIR)*.frag)
SHADEROBJ := $(SHADERSRC:$(SHADERDIR)%=$(EXECDIR)%)

$(EXECUTABLE): $(OBJ) $(SHADEROBJ)
	mkdir -p $(dir $@) && $(LINKER) $(OBJ) $(LDLIBS) $(LDFLAGS) -o $@
.PHONY: $(EXECUTABLE)

$(OBJ): $(BUILDDIR)%.o: $(SRCDIR)%.cpp
	mkdir -p $(dir $@) && $(CXX) $(CXXFLAGS) $< -c -o $@

$(SHADEROBJ): $(EXECDIR)%: $(SHADERDIR)%
	mkdir -p $(dir $@) && cp $< $@

clean:
	rm -rf $(BUILDDIR)

run:
	cd $(EXECDIR) && ./$(EXECUTABLENAME)

.PHONY: clean, run
