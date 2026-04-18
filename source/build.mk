ARCH := $(shell uname -m)
OUT := OhAPinger-1.0-$(ARCH)-UNOFFICIAL-Compiled

CPP := $(shell command -v clang++ 2>/dev/null || command -v g++ 2>/dev/null)

ifeq ($(CPP),)
$(error No compiler available (clang++ or g++))
endif

CXXFLAGS := -O2 -std=c++17

all:
	$(CPP) ohapinger-latest.cpp $(CXXFLAGS) -o $(OUT)
	chmod +x $(OUT) || chmod 755 $(OUT)
	@echo "[OhAPinger] Build completed: $(OUT)"
