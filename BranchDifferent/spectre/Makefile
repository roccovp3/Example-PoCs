FLAGS=

default: FLAGS+=-isysroot /var/sdk
default: spectre
default:

all: spectre
spectre:
	clang ${FLAGS} -I. -I../common -lpthread -pthread -lm ../common/*.c *.c -o spectre

clean:
	rm spectre

