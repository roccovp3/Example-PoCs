CC := clang
CFLAGS := -O3 -std=c11 -Wall -Wextra -pthread
LDLIBS :=

TARGET := bench.bin

all: $(TARGET)

$(TARGET): bench.c timer.c timer.h
	$(CC) $(CFLAGS) bench.c timer.c -o $(TARGET) $(LDLIBS)

clean:
	rm -f $(TARGET)
