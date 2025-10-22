CC := clang
CFLAGS := -O3 -std=c11 -Wall -Wextra -pthread
LDLIBS :=

TARGET := spectre.bin

all: $(TARGET)

$(TARGET): spectre.c timer.c timer.h
	$(CC) $(CFLAGS) spectre.c timer.c -o $(TARGET) $(LDLIBS)

clean:
	rm -f $(TARGET)
