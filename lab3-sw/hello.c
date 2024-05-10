/*
 * Userspace program that communicates with the vga_ball device driver
 * through ioctls
 *
 * Stephen A. Edwards
 * Columbia University
 */

#include <stdio.h>
#include "vga_ball.h"
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>
#include <unistd.h>
// we added these libraries
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "sony.h"


int direction;

// int direction_flag = 0;

int vga_ball_fd;

pthread_t sony_thread;
void *sony_thread_f(void *);


//set the ball position
void set_ball_coordinate(const vga_ball_coordinate_and_map *coordinate_and_map)
{
    vga_ball_arg_t vla;
    vla.coordinate_and_map = *coordinate_and_map;
    if (ioctl(vga_ball_fd, VGA_BALL_WRITE_COORDINATE, &vla)) {
        perror("ioctl(VGA_BALL_WRITE_COORDINATE) failed");
        return;
    }
}


// Define a structure to hold the arguments
struct ThreadArgs {
    // Define the arguments here
    struct libusb_device_handle *sony;
    uint8_t endpoint_address;
    // Add more arguments as needed
};

// Function to be executed in the new thread
void *sony_thread_f(void *args) {
    // Cast the argument pointer to the correct type
    struct ThreadArgs *threadArgs = (struct ThreadArgs *)args;
    
    // Now you can use the arguments
    struct libusb_device_handle *sony = threadArgs->sony;
    uint8_t endpoint_address = threadArgs->endpoint_address;
    // Use the arguments as needed
    
    // Don't forget to free the memory allocated for args if necessary
    struct usb_sony_packet packet;
    int transferred;
    for(;;){
        libusb_interrupt_transfer(sony, endpoint_address,
                (unsigned char *) &packet, sizeof(packet),
                &transferred, 0);

        if (transferred > 0 && packet.keycode[8] != 0x08 ) {
            printf("%02x \n", packet.keycode[8]);
            direction = packet.keycode[8];
            //direction_flag = 1;
        } //else direction_flag = 0;
  }

  return NULL;
}



int main()
{
    struct ThreadArgs args; 
    vga_ball_arg_t vla;

    printf("VGA ball Userspace program started\n");
  
    // opening and connecting to controller
    uint8_t endpoint_address_temp;
    struct libusb_device_handle *sony_temp;
    if ((sony_temp = opensony(&endpoint_address_temp)) == NULL ) {
        fprintf(stderr, "Did not find sony\n");
        exit(1);
    }	
    
    args.sony = sony_temp;
    args.endpoint_address = endpoint_address_temp;
    
    // Cast the argument pointer to the correct type
    // pthread_create(&sony_thread, NULL, sony_thread_f, NULL);
    pthread_create(&sony_thread, NULL, sony_thread_f, (void *)&args);
    printf("After pthread create\n");

    static const char filename[] = "/dev/vga_ball";
    if ( (vga_ball_fd = open(filename, O_RDWR)) == -1) {
        fprintf(stderr, "could not open %s\n", filename);
        return -1;
    }
    
    
/*
    unsigned short int x = 5;
    unsigned short int y = 5;
    unsigned short int map = 1;

    vla.coordinate_and_map.x = x;
    vla.coordinate_and_map.y = y;
    vla.coordinate_and_map.map = map;
    set_ball_coordinate(&vla);
    usleep(1);
*/

    unsigned short int mapSprites[40][30];
    //this is for testing
    for (unsigned short int i = 0; i < 40; i++){
        for (unsigned short int j = 0; j < 30; j++){
            if(i == 20 && j == 15){
                vla.coordinate_and_map.x = i;
                vla.coordinate_and_map.y = j;
                vla.coordinate_and_map.map = 1;
                set_ball_coordinate(&vla);
                usleep(20);
            }
            if(i == 10 && j == 10){
                vla.coordinate_and_map.x = i;
                vla.coordinate_and_map.y = j;
                vla.coordinate_and_map.map = 2;
                set_ball_coordinate(&vla);
                usleep(20);
            }
        }
    }

    //actual game logic
    unsigned short int x_pos = 0; //30 columns
    unsigned short int y_pos = 0; //40 rows

    while(1){

        if(not new value to controller keep the same){
            dont let it update the value if its not up, down, left or right
            - also we cant go from right to left directly vice versa for left to right
            - also we cant go from up to down directly vice versa for down to up 
        }
        //right button means x_pos should increase
        if (controller right button || start button){

        }
        //left button means x_pos should decrease
        else if (controller left button){

        }
        //up button means y_pos should decrease
        else if (controller up button){
        
        }
        //down button means y_pos should increase
        else if (controller down button){

        }

        set_ball_coordinate(&vla);

        //game over scenario
        if(x_pos < 0 || x_pos > 39 || y_pos < 0 || y_pos > 29){
            send some data for gameover screen;
            break;
        }
    }

  return 0;
}
