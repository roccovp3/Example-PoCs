.IGNORE: clean

all: 
	gcc -O0 -g -Werror -I.. -Wall -Wno-unused-variable -Wno-unused-parameter -Wextra -pthread -o test.bin main.c eviction_set.c timer.c

clean:
	rm *.bin
	rm -rf *.bin.dSYM

run:
	make clean
	make all
	./test.bin

