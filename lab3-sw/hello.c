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

/*

#define MAX_SIZE 1200

typedef struct {
    unsigned short int x_pos;
    unsigned short int y_pos;
    unsigned short int map;
} Map;

typedef struct {
    Map arr[MAX_SIZE];
    int front;
    int rear;
} Deque;

void initializeDeque(Deque* dq) {
    dq->front = -1;
    dq->rear = 0;
}

bool isFull(const Deque* dq) {
    return (dq->front == 0 && dq->rear == MAX_SIZE - 1) || (dq->front == dq->rear + 1);
}

bool isEmpty(const Deque* dq) {
    return dq->front == -1;
}


void insertFront(Deque* dq, Map pos) {
    if (isFull(dq)) {
        printf("Deque is full. Cannot insert.\n");
        return;
    }
    if (dq->front == -1) {
        dq->front = dq->rear = 0;
    } else if (dq->front == 0) {
        dq->front = MAX_SIZE - 1;
    } else {
        dq->front--;
    }
    dq->arr[dq->front] = pos;
}

void insertRear(Deque* dq, Map pos) {
    if (isFull(dq)) {
        printf("Deque is full. Cannot insert.\n");
        return;
    }
    if (dq->front == -1) {
        dq->front = dq->rear = 0;
    } else if (dq->rear == MAX_SIZE - 1) {
        dq->rear = 0;
    } else {
        dq->rear++;
    }
    dq->arr[dq->rear] = pos;
}

Map removeFront(Deque* dq) {
    Map removed;
    if (isEmpty(dq)) {
        printf("Deque is empty. Cannot remove.\n");
        removed.x_pos = removed.y_pos = removed.map = 0; // Default values
        return removed;
    }
    removed = dq->arr[dq->front];
    if (dq->front == dq->rear) {
        dq->front = dq->rear = -1;
    } else if (dq->front == MAX_SIZE - 1) {
        dq->front = 0;
    } else {
        dq->front++;
    }
    return removed;
}
Map removeRear(Deque* dq) {
    Map removed;
    if (isEmpty(dq)) {
        printf("Deque is empty. Cannot remove.\n");
        removed.x_pos = removed.y_pos = removed.map = 0; // Default values
        return removed;
    }
    removed = dq->arr[dq->rear];
    if (dq->front == dq->rear) {
        dq->front = dq->rear = -1;
    } else if (dq->rear == 0) {
        dq->rear = MAX_SIZE - 1;
    } else {
        dq->rear--;
    }
    return removed;
}
*/

int direction;
int vga_ball_fd;

pthread_t sony_thread;
void *sony_thread_f(void *);

//set the ball position
void set_ball_coordinate(const grid *grid)
{
    vga_ball_arg_t vla;
    vla.grid = *grid;
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

unsigned long int combine(unsigned short int a, unsigned short int b, unsigned short int c, unsigned short int d) {
    unsigned long int x = 0;

    // Combine the values using bitwise OR and bit shifting
    x |= ((unsigned long int)a) << 24;
    x |= ((unsigned long int)b) << 16;
    x |= ((unsigned long int)c) << 8;
    x |= (unsigned long int)d;
    //printf("%lu\n", x);
    return x;
}


int main()
{
    struct ThreadArgs args; 

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
    

    unsigned short int mapSprites[40][30];
    /*
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
    */

    unsigned short int a = 0;
    unsigned short int b = 0;
    unsigned short int c = 0;
    unsigned short int d = 0;

    vga_ball_arg_t vla;
    printf("before for look\n");

    unsigned short j = 0;

/*
    int count = 160;
    for (int i = 0; i < 1000; i++){
        if (i % 2 == 0){
            vla.grid.data = combine(0,0,1,0);  
            vla.grid.offset = count;
            set_ball_coordinate(&vla.grid); 
        }
        else{
            vla.grid.data = combine(0,0,0,0);  
            vla.grid.offset = count;
            set_ball_coordinate(&vla.grid); 
        }
        sleep(5);
    } 
*/
    // vla.grid.data = combine(0,0,0,0);  
    // vla.grid.offset = count;
    // set_ball_coordinate(&vla.grid); 

    // count = 1120;
    // vla.grid.data = combine(0,0,0,0);  
    // vla.grid.offset = count;
    // set_ball_coordinate(&vla.grid); 

    // count = 1080;
    // vla.grid.data = combine(0,0,1,0);  
    // vla.grid.offset = count;
    // set_ball_coordinate(&vla.grid); 




    // 0-> background
    // 1-> apple
    // 2-> head_up
    // 3-> head_down
    // 4-> 
    /*
    Deque dq;
    Map right_head = {10, 10, 5};
    Map horizontal = {9, 10, 7};
    //actual game logic
    unsigned short int x_pos = 0; //30 columns
    unsigned short int y_pos = 0; //40 rows
    */
   int offset = 0;
   for(int i = 0; i < 2; i++){
    for(int r = 0; r < 30; r++, offset+=40){
        for(int c = 0; c < 40; c+=4){
            if(i == 0){
                vla.grid.data = combine(0,0,1,0);  
                vla.grid.offset = offset+c;
                set_ball_coordinate(&vla.grid); 
            }
            else{
                vla.grid.data = combine(0,0,0,0);  
                vla.grid.offset = offset+c;
                set_ball_coordinate(&vla.grid); 
            }
            usleep(10);
        }
    }
   }
  return 0;
}