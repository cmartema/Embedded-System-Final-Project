CFLAGS = -Wall

OBJECTS = sony.o

TARFILES = Makefile sony.c sony.h
	

lab2 : $(OBJECTS)
	cc $(CFLAGS) -o sony $(OBJECTS) -lusb-1.0 -pthread


sony.o : sony.c sony.h

.PHONY : clean
clean :
	rm -rf *.o sony
