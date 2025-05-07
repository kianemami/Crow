# Makefile for compiling C program and installing it

# Compiler settings
CC = gcc
CFLAGS = -Wall -Wextra -g

# Program name (based on the .c file name)
SOURCE = Crow_pf.c
TARGET = Crow_pf

# Build directory
BUILD_DIR = build

# Installation directory (user application path)
INSTALL_DIR = /usr/local/bin

.PHONY: all clean install uninstall

all: $(BUILD_DIR)/$(TARGET)

# Create build directory if it doesn't exist
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# Compile the program and put it in build directory
$(BUILD_DIR)/$(TARGET): $(TARGET).c | $(BUILD_DIR)
	$(CC) $(CFLAGS) $< -o $@

# Install the program system-wide
install: $(BUILD_DIR)/$(TARGET)
	install -m 755 $(BUILD_DIR)/$(TARGET) $(INSTALL_DIR)

# Uninstall the program
uninstall:
	rm -f $(INSTALL_DIR)/$(TARGET)

# Clean up
clean:
	rm -rf $(BUILD_DIR)
