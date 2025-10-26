.IGNORE: clean

all: 
	gcc -g -O0 -o test.bin main.c timer.c

clean:
	rm *.bin
	rm -rf *.bin.dSYM

run:
	make clean
	make all
	./test.bin

