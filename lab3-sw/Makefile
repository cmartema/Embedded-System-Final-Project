CFLAGS = -Wall
KERNEL_SOURCE := /usr/src/linux-headers-$(shell uname -r)
PWD := $(shell pwd)

OBJECTS = sony.o hello.o

TARFILES = Makefile sony.c hello.c vga_ball.c sony.h vga_ball.h README

ifneq (${KERNELRELEASE},)
	# KERNELRELEASE defined: we are being compiled as part of the Kernel
	obj-m := vga_ball.o
else
	# We are being compiled as a module: use the Kernel build system
	default: module combined_executable

	module:
		${MAKE} -C ${KERNEL_SOURCE} SUBDIRS=${PWD} modules

	hello : $(OBJECTS)
		cc $(CFLAGS) -o hello $(OBJECTS) -lusb-1.0 -pthread

	sony.o : sony.c sony.h
		cc $(CFLAGS) -c -o sony.o sony.c

	hello.o : hello.c
		cc $(CFLAGS) -c -o hello.o hello.c

	clean:
		${MAKE} -C ${KERNEL_SOURCE} SUBDIRS=${PWD} clean
		rm -rf *.o combined_executable

	tar : $(TARFILES)
		tar zcvf lab3-sw.tar.gz $(TARFILES)

endif
