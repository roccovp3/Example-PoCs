.IGNORE: clean

all: 
	clang -O3 -DNDEBUG -pthread -o test.bin main.c timer.c

clean:
	rm *.bin
	rm -rf *.bin.dSYM

run:
	make clean
	make all
	./test.bin

