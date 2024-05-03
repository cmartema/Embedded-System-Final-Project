/*
 *
 * CSEE 4840 Lab 2 for 2019
 *
 */

#include "fbputchar.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <unistd.h>
#include "usbkeyboard.h"
#include <pthread.h>

/* Update SERVER_HOST to be the IP address of
 * the chat server you are connecting to
 */
/* arthur.cs.columbia.edu */
#define SERVER_HOST "128.59.19.114"
#define SERVER_PORT 42000

#define BUFFER_SIZE 128
#define ROW_SIZE 24
#define COLUMN_SIZE 64
#define START_INPUT_ROW 22


int sockfd; /* Socket file descriptor */

libusb_context *ctx = NULL;
libusb_device **devs;
int r;
ssize_t cnt;

struct libusb_device_handle *keyboard;
uint8_t endpoint_address;

pthread_t network_thread;
void *network_thread_f(void *);
char convert_keycode_to_ASCII(unsigned char modifier, unsigned char scancode);
int special_keypress_process(unsigned char modifier, unsigned char scancode, int cursor_column);


int main()
{
  int err, col;
  int row = 22;
  struct sockaddr_in serv_addr;

  struct usb_keyboard_packet packet;
  int transferred;
  char keystate[12];
/*
  if ((err = fbopen()) != 0) {
    fprintf(stderr, "Error: Could not open framebuffer: %d\n", err);
    exit(1);
  }
*/

printf("test1\n");

  /* Draw rows of asterisks across the top and bottom of the screen */
  for (col = 0 ; col < 64 ; col++) {
    //fbputchar('-', 20, col);
  }
  printf("test2\n");

  if ((keyboard = openkeyboard(&endpoint_address)) == NULL ) {
   fprintf(stderr, "Did not find a keyboard\n");
   exit(1);
 }



  //fbputs("Hello CSEE 4840 World!", 4, 10);
  
//   /* Open the keyboard */
//   r = libusb_init(&ctx);      // initialize a library session
//   	if (r < 0)
//   	{
//     	printf("%s  %d\n", "Init Error", r); // there was an error
//     	return 1;
//   	}
//   	libusb_set_debug(ctx, 3);                 // set verbosity level to 3, as suggested in the documentation
//   	cnt = libusb_get_device_list(ctx, &devs); // get the list of devices
//   	if (cnt < 0)
//   	{
//     	printf("%s\n", "Get Device Error"); // there was an error
//   	}
// 	//Address Here for controller
// 	//libusb_set_debug(ctx, LIBUSB_LOG_LEVEL_DEBUG);
//   	keyboard = libusb_open_device_with_vid_pid(ctx, 0x054c, 0x0ce6);
// 	if (keyboard == NULL)
// 	{
// 		printf("%s\n", "Cannot open device");
// 		//libusb_set_debug(ctx, LIBUSB_LOG_LEVEL_DEBUG);
// 		libusb_free_device_list(devs, 1); // free the list, unref the devices in it
// 		libusb_exit(ctx);                 // close the session
// 		return 0;
// 	}
// 	else
// 	{
// 		printf("%s\n", "Device opened");
// 		libusb_free_device_list(devs, 1); // free the list, unref the devices in it
// 		if (libusb_kernel_driver_active(keyboard, 0) == 1)
// 		{ // find out if kernel driver is attached
// 			printf("%s\n", "Kernel Driver Active");
// 		  	if (libusb_detach_kernel_driver(keyboard, 0) == 0) // detach it
// 		    printf("%s\n", "Kernel Driver Detached!");
// 		}
// 		r = libusb_claim_interface(keyboard, 0); // claim interface 0 (the first) of device (mine had just 1)
// 		if (r < 0)
// 		{
// 		  	printf("%s\n", "Cannot Claim Interface");
// 		  	return 1;
// 		}
// 	}
// 	printf("%s\n", "Claimed Interface");

//   r = libusb_reset_device(keyboard);
//     if (r != 0) {
//         fprintf(stderr, "Failed to reset device: %s\n", libusb_error_name(r));
//         libusb_exit(ctx);
//         return 1;
//     }
// //}


  
//   /* Create a TCP communications socket */
//   if ( (sockfd = socket(AF_INET, SOCK_STREAM, 0)) < 0 ) {
//     //fprintf(stderr, "Error: Could not create socket\n");
//     exit(1);
//   }

//   //Get the server address 
//   memset(&serv_addr, 0, sizeof(serv_addr));
//   serv_addr.sin_family = AF_INET;
//   serv_addr.sin_port = htons(SERVER_PORT);
//   if ( inet_pton(AF_INET, SERVER_HOST, &serv_addr.sin_addr) <= 0) {
//     fprintf(stderr, "Error: Could not convert host IP \"%s\"\n", SERVER_HOST);
//     exit(1);
//   }

 
//   /* Connect the socket to the server */
//   if ( connect(sockfd, (struct sockaddr *) &serv_addr, sizeof(serv_addr)) < 0) {
//     // fprintf(stderr, "Error: connect() failed.  Is the server running?\n");
//     exit(1);
//   }

//   /* Start the network thread */
//   pthread_create(&network_thread, NULL, network_thread_f, NULL);
//  col=0;
// clear_screen();
// char copy_stored_characters[129];
// //horiz_line(700);
//   for (col = 0 ; col < 64 ; col++) {
//     //fbputchar('-', 22, col);
//   }

// scroll_display_area();
//   /* Look for and handle keypresses */
// char empty_row[65];
//   memset(empty_row, ' ', sizeof(empty_row));
//   empty_row[64] = '\0';


//   char stored_characters[129];
//   for (int i = 0; i < 129; i++){
//     stored_characters[i] = ' ';
//   }
//   // what the variable we need
//   // cursor_row, cursor_column, characters_size
//   int last_character_position = 0;
//   col = 0;
//   //left arrow and right arrow does not works now.
//   //int cursor_column = 0;
  
  for (;;) {
    unsigned char buff[64];
    transferred = 8;
    
    printf("\nKeyboard: \n");
    printf( "%p", (void*)keyboard);
    printf("\nEndpoint addr: %u", endpoint_address);
    printf("\nPacket:\n");
    printf("Modifiers: %u\n", packet.modifiers);
    printf("Keycode[0]: %u\n", packet.keycode[0]);
    printf("Keycode[1]: %u\n", packet.keycode[1]);

    libusb_interrupt_transfer(keyboard, endpoint_address,
           (unsigned char *) &packet, sizeof(packet),
           &transferred, 0);
   if (transferred == sizeof(packet)) {
     sprintf(keystate, "%02x %02x %02x", packet.modifiers, packet.keycode[0],
       packet.keycode[1]);
     printf("%s\n", keystate);
    
   // libusb_interrupt_transfer(keyboard, 0x083,
	//	      buff, 0x0040,
	//		      &transferred, 0);


      //printf("test\n");

      
    if (transferred == sizeof(packet)) {
      printf("in in statement\n");
sprintf(keystate, "%02x %02x %02x", packet.modifiers, packet.keycode[0],
        packet.keycode[1]);     
printf("%s\n", keystate);
/*unsigned char character;
if (packet.keycode[1] == 0x00){
  character = convert_keycode_to_ASCII(packet.modifiers, packet.keycode[0]);
} else{
  character = convert_keycode_to_ASCII(packet.modifiers, packet.keycode[1]);
}
*/
    }
  }
}
}



// if (row == 23 && col == 64){
//    // do nothing.
//    printf("if you go here.\n");
// }

// erase_cursor(row, col);
// //fbputchar('_', row, col);
//  draw_cursor(row, col);
//  if(packet.modifiers == 0x00 && packet.keycode[0] == 0x00 && packet.keycode[1] == 0x00){ 
  
// }else {
//    if (packet.keycode[0] == 0x00 && packet.keycode[1] == 0x00){

//    }else{
//     printf("go character\n");
//     if (packet.keycode[0] == 0x2A){
//       // delete
//       //clear the previous character and update the cursor.
//       //stored_characters[index] = ' ';
//       printf("row is: %d\n", row);
//       printf("col is: %d\n", col);

//       if (row == 22 && col == 0){
//         continue; 
//       }

//       last_character_position--;
//       col--;
//       if ((last_character_position % 64) == col){
//         if (row == 22){
//           stored_characters[col] = ' ';
//         } else if (row == 23){
//           stored_characters[64 + col] = ' ';
//         }
//       } else{
//         if (row == 22){
//           for (int i = col; i < last_character_position; i++){
//             stored_characters[i] = stored_characters[i+1];
//           }
//         } else if (row == 23){
//           for (int i = col + 64; i < last_character_position; i++){
//             stored_characters[i] = stored_characters[i+1];
//           }
//         }

//         stored_characters[last_character_position] = ' ';
        
//       }
      
      
//       for (int i = 0; i < 64; i++){
//         //fbputchar(stored_characters[i], 22, i);
//       }

//       if (last_character_position >= 64){
//         for (int i = 64; i < 128; i++){
//           //fbputchar(stored_characters[i], 23, i - 64);
//         }
//       }

//       if (row == 23 && col == 0){
//         row = 22;
//         col = 64;
//       }

//       //clear the previous character, assume the cursor will replace the previous character.
//       //fbputchar('_', row, col);
//     }else if (packet.keycode[0] == 0x28){
//       //printf("The stored characters: %s\n", stored_characters);

//      // send(sockfd, &stored_characters, 64, 0);
//       stored_characters[last_character_position] = '\0';
//       write(sockfd, &stored_characters, sizeof(stored_characters)); //Added
//       if (last_character_position >= 64){
         
//       }

//       row = 22;
//       col = 0;
//       last_character_position = 0;
//       //printf("seg fault.\n");
//       memset(stored_characters, ' ', sizeof(stored_characters));
//       printf("seg fault.1\n");
//       //fbputs(empty_row, 22, 0);
//       printf("seg fault.2\n");
//       //fbputs(empty_row, 23, 0);
//       printf("seg fault.3\n");
//     } else if (packet.keycode[0] == 0x4F){
//       //right arrow
//       printf("I am in the right key else if statement\n");
//       printf("col is: %d\n", col);
//       printf("last_character position: %d", last_character_position);
//       if (col == (last_character_position % 64)){
//         printf("I am in the right key modulus statment\n");
//         // the cursor already reach to the end of character, it can not move to right.
//       }


//       else{
//           printf("I am in the right key exec part");
//           //erase_cursor(row, col);
//           erase_cursor(row, col);
//           printf("last char position is %d", last_character_position);
//         //last_character_position = last_character_position + 1; //Added
//         printf("last char position after increment is %d", last_character_position);
//        //draw_cursor(row,last_character_position); //Added
//         col++;   
//       }
//     } else if (packet.keycode[0] == 0x50){
//       //left arrow works fine
//       printf("It enter the left arrow.\n");
//       printf("col is: %d\n", col);
//       printf("last_character position: %d\n", last_character_position);
//       if (row == 22 && col == 0){
          
//       }else{ 
//          //last_character_position = last_character_position - 1; //Added
//         erase_cursor(row, col);
//         col--;
//       }
//     }
//     else{
//       //len = strlen(stored_characters);
//       //printf("segmentation fail %d?\n", 1);
//       if (row == 22 && col == 64){
//         printf("we are here, change col to 0.\n");
//         row++;
//         col = 0;
//       }
//       printf("The last character position is: %d\n", last_character_position);
//       printf("The col is :%d\n", col);

//      if(last_character_position == 128)
//      {
//             //do nothing
//      }

//      else
//      {
//       if ((last_character_position % 64) == col){
//         if (row == 22){
//           stored_characters[col] = character;
//           printf("seg fault.1\n");
//         } else if (row == 23){
//           stored_characters[64 + col] = character;
//           printf("seg fault.2\n");
//         }
//       } else{
//         printf("The seg fault.\n");
//         for (int i = 0; i < 129; i++){
//           copy_stored_characters[i] = stored_characters[i];
//         }
        
//         printf("The copy stored characters are %s after\n", copy_stored_characters);
//         printf("The stored characters are: %s after\n", stored_characters);
//         printf("seg fault.3\n");
//         printf("The copy stored characters are %s\n", copy_stored_characters);
//         printf("The stored characters are: %s", stored_characters);
//         printf("seg fault.4\n");
//         if (row == 22){
//           stored_characters[col] = character;
//           printf("seg fault.5\n");
//           for (int i = col; i < last_character_position; i++){
//             stored_characters[i + 1] = copy_stored_characters[i];
//           }
//         } else if (row == 23){
//           printf("seg fault.6\n");
//           stored_characters[col + 64] = character;
//           for (int i = col + 64; i < last_character_position; i++){
//             stored_characters[i + 1] = copy_stored_characters[i];
//           }
//         }
//         printf("The copy stored characters are %s after\n", copy_stored_characters);
//         printf("The stored characters are: %s after\n", stored_characters);
//       }
      

//       //printf("segmentation fail %d?\n", 2);
//       last_character_position++;
//       }

//       for (int i = 0; i < 64; i++){
//         //fbputchar(stored_characters[i], 22, i);
//       }
//       //printf("segmentation fail %d?\n", 3);
//       if (last_character_position >= 64){
//         for (int i = 64; i < 128; i++){
//           //fbputchar(stored_characters[i], 23, i - 64);
//         }
//       }

//       //printf("segmentation fail %d?\n", 4);
//       //fbputchar(character, row, col);
//       //printf("segmentation fail %d?\n", 5);     
//       col++;
//       printf("col is: %d\n", col);
//       //fbputchar('_', row, col);

//     } 
	  
//    }

// }
// //fbputs("abc",22, 0);

//   //draw_cursor(row, col); 
// 	if (packet.keycode[0] == 0x29) { /* ESC pressed? */
// 	break;
//       }
//     }
//   }
//   /* Terminate the network thread */
//   pthread_cancel(network_thread);

//   /* Wait for the network thread to finish */
//   pthread_join(network_thread, NULL);

//   return 0;
// }
char convert_keycode_to_ASCII(unsigned char modifier, unsigned char scancode){
  static const unsigned char offset = 0x04;
  //solve for num, 31 -39 is 1-9, keycode 1E - 26
  if (scancode >= 0x04 && scancode <= 0x1D) {
      // Convert scancode to ASCII by adding the offset.
      // if the modifier is left shift or right shift.
      if (modifier == 0x01 || modifier == 0x02){
        return 'A' + (scancode - offset);
      }
      return 'a' + (scancode - offset);
  } 

  else if (scancode >= 0x1E && scancode <= 0x27 && modifier == 0x00){
      // Return 0 for non-alphabetic keys or invalid scancodes
      unsigned char num_offset = 0x1E;
      if (scancode >= 0x1E && scancode <= 0x26){
        return '1' + (scancode - num_offset);
      }
      return '0';
  } 

  else if (scancode == 0x1E && (modifier == 0x01 || modifier == 0x02)){
    return '!';
  }

  else if (scancode == 0x1F && (modifier == 0x01 || modifier == 0x02)){
    return '@';
  }

  else if (scancode == 0x20 && (modifier == 0x01 || modifier == 0x02)){
    return '#';
  }

  else if (scancode == 0x21 && (modifier == 0x01 || modifier == 0x02)){
    return '$';
  }

  else if (scancode == 0x22 && (modifier == 0x01 || modifier == 0x02)){
    return '%';
  }

  else if (scancode == 0x23 && (modifier == 0x01 || modifier == 0x02)){
    return '^';
  }

  else if (scancode == 0x24 && (modifier == 0x01 || modifier == 0x02)){
    return '&';
  }

  else if (scancode == 0x25 && (modifier == 0x01 || modifier == 0x02)){
    return '*';
  }

  else if (scancode == 0x26 && (modifier == 0x01 || modifier == 0x02)){
    return '(';
  }

  else if (scancode == 0x27 && (modifier == 0x01 || modifier == 0x02)){
    return ')';
  }

  else if (scancode == 0x35 && (modifier == 0x01 || modifier == 0x02)){
    return '~';
  }

  else if (scancode == 0x36 && (modifier == 0x01 || modifier == 0x02)){
    return '<';
  } 
  else if (scancode == 0x37 && (modifier == 0x01 || modifier == 0x02)){
    return '>';
  }

  else if (scancode == 0x38 && (modifier == 0x01 || modifier == 0x02)){
    return '?';
  }

  else if (scancode == 0x33 && (modifier == 0x01 || modifier == 0x02)){
    return ':';
  }

  else if (scancode == 0x34 && (modifier == 0x01 || modifier == 0x02)){
    return '"';
  }

  else if (scancode == 0x2F && (modifier == 0x01 || modifier == 0x02)){
    return '{';
  }

  else if (scancode == 0x30 && (modifier == 0x01 || modifier == 0x02)){
    return '}';
  }
  
  else if (scancode == 0x2E && (modifier == 0x01 || modifier == 0x02)){
    return '+';
  }

  else if (scancode == 0x2D && (modifier == 0x01 || modifier == 0x02)){
    return '_';
  }
    
  else if (scancode == 0x31 && (modifier == 0x01 || modifier == 0x02)){
    return '|';
  }

  else
  {
      switch(scancode)
      {
          case 0x2C: return ' ';
          case 0x36: return ',';
          case 0x37: return '.';
          case 0x38: return '/';
          case 0x2D: return '-';
          case 0x2E: return '=';
          case 0x2F: return '[';
          case 0x30: return ']';
          case 0x31: return '\\';
          case 0x33: return ';';
          case 0x35: return '`';
          case 0x34: return '\'';
      }
  }

}


// void *network_thread_f(void *ignored)
// { 
//   int receive_row = 0;
//   char recvBuf[BUFFER_SIZE];
//   int n;
//   char empty_row[65];
//   memset(empty_row, ' ', sizeof(empty_row));
//   empty_row[64] = '\0';
//   /* Receive data */
//   while ( (n = read(sockfd, &recvBuf, BUFFER_SIZE - 1)) > 0 ) {
//     //recvBuf[n] = '\0';
//     printf("%s", recvBuf);
//     int col = 0;
//     for (int i = 0; i < n; i++){
//       if (recvBuf[i] == '\0'){
//         col = 0;
//         receive_row++;
//         break;
//       }
//       //fbputchar(recvBuf[i], receive_row, col);
//       col++;
//       if (col == 64){
//         receive_row++;
//         col = 0;
//       }
//     }
//     //fbputs(recvBuf, receive_row, 0);
//     //receive_row++;
//     if (receive_row == 21){
//       receive_row = 0;
//     }
//     //fbputs(empty_row, receive_row, 0);
    
//   }

//   return NULL;
// }
