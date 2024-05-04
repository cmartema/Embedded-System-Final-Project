#ifndef _SONY_H
#define _SONY_H

#include <libusb-1.0/libusb.h>



struct usb_sony_packet {
  uint8_t keycode[64];
};

/* Find and open a USB keyboard device.  Argument should point to
   space to store an endpoint address.  Returns NULL if no keyboard
   device was found. */
extern struct libusb_device_handle *opensony(uint8_t *);

#endif
