CC=cc -Wall -Wstrict-prototypes -g -O0 -I./

all: libconfig.a

configfile.o: configfile.c configfile.h
	$(CC) -c configfile.c

config-array.o: config-array.c config-array.h
	$(CC) -c config-array.c

config-queue.o: config-queue.c config-queue.h
	$(CC) -c config-queue.c

libconfig.a: configfile.o config-array.o config-queue.o
	ar rc libconfig.a configfile.o config-array.o config-queue.o
	ranlib libconfig.a

test: test-array test-queue

test-array: test-array.c configfile.h configfile.o config-array.h config-array.o
	$(CC) -o test-array test-array.c libconfig.a
	./test-array

test-queue: test-queue.c configfile.h configfile.o config-queue.h config-queue.o
	$(CC) -o test-queue test-queue.c libconfig.a
	./test-queue

clean:
	rm -f libconfig.a *.o *.core test-queue test-array
