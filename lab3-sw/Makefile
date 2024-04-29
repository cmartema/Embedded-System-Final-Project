ifneq (${KERNELRELEASE},)

# KERNELRELEASE defined: we are being compiled as part of the Kernel
        obj-m := vga_ball.o

else

# We are being compiled as a module: use the Kernel build system
    KERNEL_SOURCE := /usr/src/linux-headers-$(shell uname -r)
    PWD := $(shell pwd)

    # Added CFLAGS for compilation
    CFLAGS = -Wall

    # Define OBJECTS for lab2 executable
    OBJECTS = lab2.o fbputchar.o usbkeyboard.o

    # Updated TARFILES to include all necessary files
    TARFILES = Makefile README vga_ball.h vga_ball.c hello.c lab2.c \
        fbputchar.h fbputchar.c usbkeyboard.h usbkeyboard.c

    # Default rule to build modules and hello target (hello target needs definition)
    default: module hello lab2

    module:
        ${MAKE} -C ${KERNEL_SOURCE} SUBDIRS=${PWD} modules

    # Rule to build lab2 executable
    lab2 : $(OBJECTS)
        cc $(CFLAGS) -o lab2 $(OBJECTS) -lusb-1.0 -pthread

    # Rule for creating a tar.gz for lab2 sources
    lab2.tar.gz : $(TARFILES)
        rm -rf lab2
        mkdir lab2
        cp $(TARFILES) lab2
        tar zcf lab2.tar.gz lab2
        rm -rf lab2

    # Dependency rules for object files
    lab2.o : lab2.c fbputchar.h usbkeyboard.h
    fbputchar.o : fbputchar.c fbputchar.h
    usbkeyboard.o : usbkeyboard.c usbkeyboard.h

    # Clean rule
    clean:
        ${MAKE} -C ${KERNEL_SOURCE} SUBDIRS=${PWD} clean
        #rm -rf *.o hello lab2 lab2.tar.gz

    # Archival rules for kernel module sources
    TARFILE = lab3-sw.tar.gz
    .PHONY : tar
    tar : $(TARFILE)

    $(TARFILE) : $(TARFILES)
        tar zcfC $(TARFILE) .. $(TARFILES:%=lab3-sw/%)

endif

