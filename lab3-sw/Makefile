ifneq (${KERNELRELEASE},)

# KERNELRELEASE defined: we are being compiled as part of the Kernel
        obj-m := vga_ball.o

else

#Wee are being compiled as a module: use the Kernel build system

	KERNEL_SOURCE := /usr/src/linux-headers-$(shell uname -r)
        PWD := $(shell pwd)

    CFLAGS = -Wall

    OBJECTS = sony.o 
    TARFILES = Makefile README vga_ball.h vga_ball.c hello.c sony.c sony.h

default: module hello sony

hello:  $(OBJECTS)
	cc $(CFLAGS) -o sony $(OBJECTS) -lusb-1.0 -pthread


lab2.o : sony.c sony.h 


module:
	${MAKE} -C ${KERNEL_SOURCE} SUBDIRS=${PWD} modules

clean:
	${MAKE} -C ${KERNEL_SOURCE} SUBDIRS=${PWD} clean
	${RM} hello



endif 
