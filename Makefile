# Crow Platform Makefile


# ===== Directories =====
SRC_DIR := src
INC_DIR := inc
BUILD_DIR := build
INSTALL_DIR = /usr/local/bin

# ===== Output Binary =====
TARGET := Crow
TARGET_APP := $(BUILD_DIR)/$(TARGET)

# ===== Output Binary =====
CC = gcc
CFLAGS := -Wall -Werror -I$(INC_DIR)
LDFLAGS := -lpthread -lmosquitto 

# Files
SRCS := $(wildcard $(SRC_DIR)/*.c)
OBJS := $(patsubst $(SRC_DIR)/%.c, $(BUILD_DIR)/%.o, $(SRCS))


.PHONY: all clean install uninstall

all: $(TARGET_APP)

# Create build directory if it doesn't exist
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)


# Link objects into final binary
$(TARGET_APP): $(OBJS)
	$(CC) $^ -o $@ $(LDFLAGS)
	rm -f $(OBJS)  

# Compile source files into object files
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c | $(BUILD_DIR)
	$(CC) $(CFLAGS) -c $< -o $@



# Install the program system-wide
install: $(TARGET_APP)
	install -m 755 $(TARGET_APP) $(INSTALL_DIR)

# Uninstall the program
uninstall:
	rm -f $(INSTALL_DIR)/$(TARGET)

# Clean up
clean:
	rm -rf $(BUILD_DIR)
