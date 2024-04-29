ifneq (${KERNELRELEASE},)
CFLAGS = -Wall

OBJECTS = lab2.o fbputchar.o usbkeyboard.o

# KERNELRELEASE defined: we are being compiled as part of the Kernel
        obj-m := vga_ball.o

else

# We are being compiled as a module: use the Kernel build system

	KERNEL_SOURCE := /usr/src/linux-headers-$(shell uname -r)
        PWD := $(shell pwd)

lab2.o : lab2.c usbkeyboard.h

usbkeyboard.o : usbkeyboard.c usbkeyboard.h

default: module hello

lab2 : $(OBJECTS)
    cc $(CFLAGS) -o lab2 $(OBJECTS) -lusb-1.0 -pthread

module:
	${MAKE} -C ${KERNEL_SOURCE} SUBDIRS=${PWD} modules

clean:
	${MAKE} -C ${KERNEL_SOURCE} SUBDIRS=${PWD} clean
	${RM} hello

TARFILES = Makefile README vga_ball.h vga_ball.c hello.c usbkeyboard.h usbkeyboard.c lab2.c
TARFILE = lab3-sw.tar.gz
.PHONY : tar
tar : $(TARFILE)

$(TARFILE) : $(TARFILES)
	tar zcfC $(TARFILE) .. $(TARFILES:%=lab3-sw/%)

endif 
