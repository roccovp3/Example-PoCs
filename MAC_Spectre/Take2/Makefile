# Makefile for the ARM-port Flush+Reload demo
# Put attacker_arm.c, timer.c (and timer.h) in the same directory.
# Usage:
#   make        # build
#   make run    # build then run ./attacker
#   make clean  # remove objects and binary

CC ?= clang
CFLAGS ?= -O2 -g -std=gnu11 -D_GNU_SOURCE -Wall -Wextra
LDFLAGS ?= -pthread

SOURCES := spectre.c timer.c
OBJS    := $(SOURCES:.c=.o)
TARGET  := attacker

.PHONY: all clean run

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

run: $(TARGET)
	./$(TARGET)

clean:
	@rm -f $(OBJS) $(TARGET)
	@echo "cleaned"