# Makefile

# Compiler and flags
CC := cc
CFLAGS := -Wall -Wextra -Os -s -ffunction-sections -fdata-sections -Wl,--gc-sections -flto -I./lib
LDFLAGS :=

# Directories
SRC_DIR := src
OBJ_DIR := obj
BIN_DIR := bin
LIB_DIR := lib

# Name of the final executable
TARGET := $(BIN_DIR)/ghostc

# Find all source files
SRCS := $(wildcard $(SRC_DIR)/*.c)

# Convert source files to object files in obj/
OBJS := $(patsubst $(SRC_DIR)/%.c,$(OBJ_DIR)/%.o,$(SRCS))

# Default target
all: $(TARGET)

# Link object files into executable
$(TARGET): $(OBJS) | $(BIN_DIR)
	$(CC) $(LDFLAGS) -o $@ $^

# Compile source files into object files
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c | $(OBJ_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

# Create bin/ directory if it doesn't exist
$(BIN_DIR):
	mkdir -p $(BIN_DIR)

# Create obj/ directory if it doesn't exist
$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

# Clean object files and executable
clean:
	rm -rf $(OBJ_DIR)/*.o $(TARGET)

.PHONY: all clean
