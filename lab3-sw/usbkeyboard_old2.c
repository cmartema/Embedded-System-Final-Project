#include "usbkeyboard.h"


#include <stdio.h>
#include <stdlib.h> 
#define VENDOR_ID 0x054c  // Sony Corporation
#define PRODUCT_ID_1 0x0ce6  // Product ID for the first controller
#define USB_HID_KEYBOARD_PROTOCOL 0


/* References on libusb 1.0 and the USB HID/keyboard protocol
 *
 * http://libusb.org
 * https://web.archive.org/web/20210302095553/https://www.dreamincode.net/forums/topic/148707-introduction-to-using-libusb-10/
 *
 * https://www.usb.org/sites/default/files/documents/hid1_11.pdf
 *
 * https://usb.org/sites/default/files/hut1_5.pdf
 */

/*
 * Find and return a USB keyboard device or NULL if not found
 * The argument con
 * 
 */
struct libusb_device_handle *openkeyboard(uint8_t *endpoint_address) {
  libusb_device **devs;
  struct libusb_device_handle *keyboard = NULL;
  struct libusb_device_descriptor desc;
  ssize_t num_devs, d;
  uint8_t i, k;
  
  /* Start the library */
  if ( libusb_init(NULL) < 0 ) {
    fprintf(stderr, "Error: libusb_init failed\n");
    exit(1);
  }
  printf("test line 38\n");

  /* Enumerate all the attached USB devices */
  if ( (num_devs = libusb_get_device_list(NULL, &devs)) < 0 ) {
    fprintf(stderr, "Error: libusb_get_device_list failed\n");
    exit(1);
  }

  printf("test line 46\n");

  /* Look at each device, remembering the first HID device that speaks
     the keyboard protocol */
      for (d = 0; d < num_devs; d++) {
        libusb_device *dev = devs[d];
        if (libusb_get_device_descriptor(dev, &desc) < 0) {
            fprintf(stderr, "Error: libusb_get_device_descriptor failed\n");
            exit(1);
        }
        printf("VID: %d\n ", desc.idVendor);
        printf("PID: %d\n ", desc.idProduct);
        if (desc.idVendor == VENDOR_ID && (desc.idProduct == PRODUCT_ID_1)) {
            printf("debug line 53\n");
            struct libusb_config_descriptor *config;
            if (libusb_get_config_descriptor(dev, 0, &config) < 0) {
                fprintf(stderr, "Error: libusb_get_config_descriptor failed\n");
                continue;  // Skip to the next device
            }
            printf("Debugging: line60\n");
            for (i = 0; i < config->bNumInterfaces; i++) {
                printf("debugg: line62\n");
                for (k = 0; k < config->interface[i].num_altsetting; k++) {
                    printf("debugging: line 64\n");
                    const struct libusb_interface_descriptor *inter = config->interface[i].altsetting + k;
                    printf("debugging: line 68\n");
                    printf("%d %d %d\n", inter->bInterfaceClass, inter->bInterfaceProtocol, LIBUSB_CLASS_HID);
                    if (inter->bInterfaceClass == 3 && inter->bInterfaceProtocol == USB_HID_KEYBOARD_PROTOCOL) {
                        printf("debugging: line 67\n");
                        int r;
                        if ((r = libusb_open(dev, &keyboard)) != 0) {
                            fprintf(stderr, "Error: libusb_open failed: %d\n", r);
                            continue;  // Skip to the next device
                        }
                        if (libusb_kernel_driver_active(keyboard, i))
                            libusb_detach_kernel_driver(keyboard, i);
                        printf("Debugg line 72\n");
                        libusb_set_auto_detach_kernel_driver(keyboard, 1);
                        if ((r = libusb_claim_interface(keyboard, i)) != 0) {
                            fprintf(stderr, "Error: libusb_claim_interface failed: %d\n", r);
                            libusb_close(keyboard);
                            continue;  // Skip to the next device
                        }
                        *endpoint_address = inter->endpoint[0].bEndpointAddress;
                        libusb_free_config_descriptor(config);
                        printf("Debugg print line 80\n");
                        goto found;
                    }
                }
            }
            libusb_free_config_descriptor(config);
        }
    }

 found:
  libusb_free_device_list(devs, 1);

  return keyboard;
}
