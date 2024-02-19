CXX      := g++ -std=c++20
CXXFLAGS := -fstack-reuse=none -Wstack-protector -fstack-protector-all -fcf-protection=full -fstack-clash-protection  -Wall -Wextra -Wformat -Wformat-security -Wvla -Wswitch -Wredundant-decls -Wunused-variable -Wdate-time -Wsign-compare -Wduplicated-branches -Wduplicated-cond -Wlogical-op -Woverloaded-virtual -Wsuggest-override  -Wno-unused-parameter -Wno-implicit-fallthrough -Wno-deprecated-copy -Wno-psabi   -g -O2 -fno-extended-identifiers
LDFLAGS  := -lpthread  -Wl,-z,relro -Wl,-z,now -Wl,-z,separate-code -pie -lssl -lcrypto
BUILD    := ./build
OBJ_DIR  := $(BUILD)/objects
APP_DIR  := ./
TARGET   := genc
INCLUDE  := -I /user/projects/genc/crypto/ -I/usr/include
SRC      :=                      \
   $(wildcard crypto/*.cpp) \
   $(wildcard *.cpp)         \

OBJECTS  := $(SRC:%.cpp=$(OBJ_DIR)/%.o)
DEPENDENCIES \
         := $(OBJECTS:.o=.d)

all: build $(APP_DIR)/$(TARGET)

$(OBJ_DIR)/%.o: %.cpp
	@mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) $(INCLUDE) -c $< -MMD -o $@

$(APP_DIR)/$(TARGET): $(OBJECTS)
	@mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) -o $(APP_DIR)/$(TARGET) $^ $(LDFLAGS)

-include $(DEPENDENCIES)

.PHONY: all build clean debug release info

build:
	@mkdir -p $(APP_DIR)
	@mkdir -p $(OBJ_DIR)

debug: CXXFLAGS += -DDEBUG -g
debug: all

release: CXXFLAGS += -O2
release: all

clean:
	-@rm -rvf $(OBJ_DIR)/*
	-@rm -rvf $(APP_DIR)/*

info:
	@echo "[*] Application dir: ${APP_DIR}     "
	@echo "[*] Object dir:      ${OBJ_DIR}     "
	@echo "[*] Sources:         ${SRC}         "
	@echo "[*] Objects:         ${OBJECTS}     "
	@echo "[*] Dependencies:    ${DEPENDENCIES}"