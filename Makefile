MACOS_MIN_VERSION := 10.10

BUILDDIR := build/
EXECDIR := build/bin/
SRCDIR := src/
INCLUDEDIR := include/

EXECUTABLE = $(EXECDIR)Nebuloid

CXX := g++
LINKER := ld
CXXFLAGS := -std=c++11 -mmacosx-version-min=$(MACOS_MIN_VERSION) -Wall -I$(INCLUDEDIR)
LDFLAGS := -macosx_version_min $(MACOS_MIN_VERSION)
LDLIBS := -lglfw -lc++ -lpthread -ldl -framework Cocoa -framework OpenGL -framework IOKit -framework CoreVideo

SRC := $(wildcard $(SRCDIR)*.cpp)
OBJ := $(SRC:$(SRCDIR)%.cpp=$(BUILDDIR)%.o)

$(EXECUTABLE): $(OBJ) $(EXECDIR)
	$(LINKER) $(OBJ) $(LDLIBS) $(LDFLAGS) -o $@

$(OBJ): $(BUILDDIR)%.o: $(SRCDIR)%.cpp $(BUILDDIR)
	$(CXX) $(CXXFLAGS) $< -c -o $@

$(BUILDDIR) $(EXECDIR):
	mkdir -p $@

clean:
	rm -rf $(BUILDDIR)
.PHONY: clean