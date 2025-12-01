# Makefile for Spectre PoC
# Target binary: spectre

CC = gcc
CFLAGS = -g -O1 -std=c11

# Target binary name (note: you asked for spectre.c but that's the source file,
# so the binary will be named 'spectre')
TARGET = spectre

# Source files
SRCS = spectre.c timer.c evict.c

# Object files
OBJS = $(SRCS:.c=.o)

# Header files (for dependency tracking)
HEADERS = timer.h evict.h

# Default target
all: $(TARGET)

# Link object files to create the binary
$(TARGET): $(OBJS)
	$(CC) $(OBJS) -o $(TARGET) $(LDFLAGS)

# Compile source files to object files
%.o: %.c $(HEADERS)
	$(CC) $(CFLAGS) -c $< -o $@

# Clean build artifacts
clean:
	rm -f $(OBJS) $(TARGET)

# Rebuild everything
rebuild: clean all

# Phony targets (not actual files)
.PHONY: all clean rebuild
