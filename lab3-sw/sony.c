#include "sony.h"

#include <stdio.h>
#include <stdlib.h> 

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
#define VENDOR_ID 0x054c  // Sony Corporation
#define PRODUCT_ID_1 0x0ce6  // Product ID for the first controller


struct libusb_device_handle *opensony(uint8_t *endpoint_address) {
  libusb_device **devs;
  struct libusb_device_handle *sony = NULL;
  struct libusb_device_descriptor desc;
  ssize_t num_devs, d;
  uint8_t i, k;
  
  /* Start the library */
  if ( libusb_init(NULL) < 0 ) {
    fprintf(stderr, "Error: libusb_init failed\n");
    exit(1);
  }

  /* Enumerate all the attached USB devices */
  if ( (num_devs = libusb_get_device_list(NULL, &devs)) < 0 ) {
    fprintf(stderr, "Error: libusb_get_device_list failed\n");
    exit(1);
  }

  /* Look at each device, remembering the first HID device that speaks
     the sony protocol */

  for (d = 0 ; d < num_devs ; d++) {
    libusb_device *dev = devs[d];
    if ( libusb_get_device_descriptor(dev, &desc) < 0 ) {
      fprintf(stderr, "Error: libusb_get_device_descriptor failed\n");
      exit(1);
    }

    //search for device
    if (desc.idVendor == VENDOR_ID && (desc.idProduct == PRODUCT_ID_1)) {
      printf("device found\n");
      struct libusb_config_descriptor *config;
      if (libusb_get_config_descriptor(dev, 0, &config) < 0) {
          fprintf(stderr, "Error: libusb_get_config_descriptor failed\n");
          continue;  // Skip to the next device
      }
    

      if (desc.bDeviceClass == LIBUSB_CLASS_PER_INTERFACE) {
        struct libusb_config_descriptor *config;
        libusb_get_config_descriptor(dev, 0, &config);
        for (i = 0 ; i < config->bNumInterfaces ; i++)	{       
          for ( k = 0 ; k < config->interface[i].num_altsetting ; k++ ) {
            const struct libusb_interface_descriptor *inter =
              config->interface[i].altsetting + k ;
            if ( inter->bInterfaceClass == LIBUSB_CLASS_HID) {
              int r;
              printf("found HID at configuration %d\n", i);
              if ((r = libusb_open(dev, &sony)) != 0) {
                fprintf(stderr, "Error: libusb_open failed: %d\n", r);
                exit(1);
              }
              if (libusb_kernel_driver_active(sony,i)){
                libusb_detach_kernel_driver(sony, i);
                libusb_set_auto_detach_kernel_driver(sony, i);
              }
              if ((r = libusb_claim_interface(sony, i)) != 0) {
                fprintf(stderr, "Error: libusb_claim_interface failed: %d\n", r);
                exit(1);
              }

              *endpoint_address = inter->endpoint[0].bEndpointAddress;
              goto found;
            }
          }
        }
      }
    
	  
	
    }
  }

  found:
  libusb_free_device_list(devs, 1);

  return sony;
}



// int main() {
// 	uint8_t endpoint_address;
// 	struct libusb_device_handle *sony;
// 	if ((sony = opensony(&endpoint_address)) == NULL ) {
// 		fprintf(stderr, "Did not find sony\n");
// 		exit(1);
// 	}	
//   struct usb_sony_packet packet;
//   int transferred;
//   // char keystate[12];

//   for(;;){
//     libusb_interrupt_transfer(sony, endpoint_address,
//            (unsigned char *) &packet, sizeof(packet),
//            &transferred, 0);
//     if (transferred > 0) {
//       printf("%02x \n", packet.keycode[8]);
//       /*for(int i = 0; i < transferred ; i++){
//         printf("%02x ",packet.keycode[i]);
//       }
//       */
     
//       //printf("\n");
//     }
//   }
// 	return 0;
// }


