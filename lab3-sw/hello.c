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

unsigned long int combine(unsigned short int a, unsigned short int b) {
    unsigned long int x = 0;

    // Combine the values using bitwise OR and bit shifting
    x |= ((unsigned long int)a) << 24;
    x |= ((unsigned long int)b);
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
    for (unsigned short int row = 0; row < 30; row++){
        for(unsigned short int column = 0; column < 40; column+=4){
            for(unsigned short int it = column; it < column+4; it++){
                if((column+4)-it) {
                    if(row == 10 && it == 10){
                        printf("apple if statement\n");
                        a = 1;
                    }
                    else if (row == 15+j && it == 10){
                        a = 2;
                    }
                    else a = 0;
                }
                if((column+3)-it) {
                    if(row == 10 && it == 10){
                        b = 1;
                    }
                    else if (row == 15+j && it == 10){
                        b = 2;
                    }
                    else b = 0;
                }
                if((column+2)-it) {
                    if(row == 10 && it == 10){
                        c = 1;
                    }
                    else if (row == 15+j && it == 10){
                        c = 2;
                    }
                    else c = 0;
                }
                if((column+1)-it) {
                    if(row == 10 && it == 10){
                        d = 1;
                    }
                    else if (row == 15+j && it == 10){
                        d = 2;
                    }
                    else d = 0;

                }
            }
            vla.grid.data = combine(a,b,c,d);
            set_ball_coordinate(&vla.grid);
        }
    }*/
    int count = 0;
    // vla.grid.offset = 0;
    // for (int i = 0; i < 27; i++){
    //     vla.grid.data = combine(0,0,1,1);  
    //     vla.grid.offset = count;  
    //     set_ball_coordinate(&vla.grid);
    //     count += 40;
    //     printf("count: %d\n", count);
    // }
    
    // count = 36;   
    // for (int i = 0; i < 26; i++){
    //     vla.grid.data = combine(1,1,0,0);  
    //     vla.grid.offset = count;  
    //     set_ball_coordinate(&vla.grid);
    //     count += 40;
    //     printf("count: %d\n", count);
    // }
    

   vla.grid.data = 1;
   int temp = 11;
   for (int i = 0; i < 15; i++){
        vla.grid.offset = combine(11, temp + i);
        set_ball_coordinate(&vla.grid);

   }



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

    if (direction == start){
        while(1){

        }
    }
    */

  return 0;
}
