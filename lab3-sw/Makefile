ifneq (${KERNELRELEASE},)

        obj-m := vga_ball.o

else

    KERNEL_SOURCE := /usr/src/linux-headers-$(shell uname -r)
    PWD := $(shell pwd)

    CFLAGS = -Wall

    OBJECTS = lab2.o fbputchar.o usbkeyboard.o

    TARFILES = Makefile README vga_ball.h vga_ball.c hello.c lab2.c \
        fbputchar.h fbputchar.c usbkeyboard.h usbkeyboard.c

    default: module hello lab2

    module:
        ${MAKE} -C ${KERNEL_SOURCE} SUBDIRS=${PWD} modules

    lab2 : $(OBJECTS)
        cc $(CFLAGS) -o lab2 $(OBJECTS) -lusb-1.0 -pthread

    lab2.tar.gz : $(TARFILES)
        rm -rf lab2
        mkdir lab2
        cp $(TARFILES) lab2
        tar zcf lab2.tar.gz lab2
        rm -rf lab2

    lab2.o : lab2.c fbputchar.h usbkeyboard.h
    fbputchar.o : fbputchar.c fbputchar.h
    usbkeyboard.o : usbkeyboard.c usbkeyboard.h

    clean:
        ${MAKE} -C ${KERNEL_SOURCE} SUBDIRS=${PWD} clean
        #rm -rf *.o hello lab2 lab2.tar.gz

    TARFILE = lab3-sw.tar.gz
    .PHONY : tar
    tar : $(TARFILE)

    $(TARFILE) : $(TARFILES)
        tar zcfC $(TARFILE) .. $(TARFILES:%=lab3-sw/%)

endif

