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

#define WIDTH 40  // Width of the game area
#define HEIGHT 30 // Height of the game area

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

int checkCollision(Map head, Deque* dq) {
    // Check wall collision
    if (head.x_pos < 0 || head.x_pos >= WIDTH || head.y_pos < 0 || head.y_pos >= HEIGHT) {
        return 1; // Collision detected
    }

    // Check self collision
    for (int i = dq->front + 1; i != dq->rear; i = (i + 1) % MAX_SIZE) {
        if (dq->arr[i].x_pos == head.x_pos && dq->arr[i].y_pos == head.y_pos) {
            return 1; // Collision detected
        }
    }
    return 0; // No collision
}

void moveSnake(Deque* dq, vga_ball_arg_t *vla) {
    // Get current head position
    Map head = dq->arr[dq->front];
    Map newHead = head;

    // Determine new head position based on direction
    switch (direction) {
        case UP:
            newHead.y_pos--;
            break;
        case DOWN:
            newHead.y_pos++;
            break;
        case LEFT:
            newHead.x_pos--;
            break;
        case RIGHT:
            newHead.x_pos++;
            break;
    }

    // Check for collisions
    if (checkCollision(newHead, dq)) {
        printf("Game Over!\n");
        exit(0); // Terminate the game
    }

    // Insert new head to the front of deque
    insertFront(dq, newHead);

    // Check if the new head's position is where the apple is
    if (mapSprites[newHead.x_pos][newHead.y_pos] == 1) {
        // Eat the apple and grow
        mapSprites[newHead.x_pos][newHead.y_pos] = 0; // Remove apple from the map
        // Optionally, place a new apple on the map
    } else {
        // Remove tail and update VGA display
        Map tail = removeRear(dq);

        // Clear the VGA display where the tail was
        vla->grid.x_pos = tail.x_pos;
        vla->grid.y_pos = tail.y_pos;
        vla->grid.data = combine(0,0,0,0); // Clear this position
        set_ball_coordinate(&(vla->grid));
    }

    // Update the VGA display for the new head
    vla->grid.x_pos = newHead.x_pos;
    vla->grid.y_pos = newHead.y_pos;
    vla->grid.data = combine(0,0,14,5); // assuming snake head data
    set_ball_coordinate(&(vla->grid));
}

void displaySprites(Deque* dq, vga_ball_arg_t *vla) {
    // Clear display first
    clear_Display(*vla);

    // Display snake
    for (int i = dq->front; i != dq->rear; i = (i + 1) % MAX_SIZE) {
        vla->grid.x_pos = dq->arr[i].x_pos;
        vla->grid.y_pos = dq->arr[i].y_pos;
        vla->grid.data = combine(0,0,14,5); // assuming snake body data
        set_ball_coordinate(&(vla->grid));
    }

    // Display apples
    for (int x = 0; x < WIDTH; x++) {
        for (int y = 0; y < HEIGHT; y++) {
            if (mapSprites[x][y] == 1) {
                vla->grid.x_pos = x;
                vla->grid.y_pos = y;
                vla->grid.data = combine(0,0,0,1); // assuming apple data
                set_ball_coordinate(&(vla->grid));
            }
        }
    }
}


int isFull(const Deque* dq) {
    return (dq->front == 0 && dq->rear == MAX_SIZE - 1) || (dq->front == dq->rear + 1);
}

int isEmpty(const Deque* dq) {
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

void clear_Display( vga_ball_arg_t vla){
    int offset = 0;
     for(int r = 0; r < 30; r++, offset+=40){
            for(int c = 0; c < 40; c+=4){
                vla.grid.data = combine(0,0,0,0);  
                vla.grid.offset = offset+c;
                set_ball_coordinate(&vla.grid); 
            }
     }
}

int main()
{
    vga_ball_arg_t vla;
    Deque dq;
    initializeDeque(&dq);

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

    Map initialHead = {20, 15, 1}; // Initial position of the snake's head
    insertFront(&dq, initialHead); // Place the initial head on the deque

    // Setup initial apple position
    mapSprites[10][10] = 1; // Place an apple at position (10, 10)

    // Define game running state
    int game_running = 1;

    while (game_running) {
        moveSnake(&dq, &vla);  // Move the snake based on the current direction
        displaySprites(&dq, &vla);  // Draw all elements on the VGA display

        // Delay for better visualization, adjust as needed
        usleep(200000);

        // Other game logic...
        // Check for game over conditions
        if (checkCollision(dq.arr[dq.front], &dq)) {
            game_running = 0; // Stop the game loop if a collision occurs
            printf("Game Over! Collision detected.\n");
        }

        // Implement input handling or timer-based mechanics as required
    }

    // Clear the display once the game is over
    clear_Display(vla);

    

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

    //vga_ball_arg_t vla;
    printf("before for look\n");
    /*
    unsigned short j = 0;
    int offset = 0;
    clear_Display(vla); //clear the display independently rather than depending on a for loop
    for(int i = 0; i < 2; i++){
        for(int r = 0; r < 30; r++, offset+=40){
            for(int c = 0; c < 40; c+=4){
                if(i == 0){
                    
                    //Start: setting up the apple and the snake body 
                    if (offset == 560 &&  c < 4){  
                        vla.grid.data = combine(0,0,14,5); // Snake head_right and tail_left placed of the first two columns of the corresponding row
                        vla.grid.offset = offset+c;
                        set_ball_coordinate(&vla.grid);

                    }
                    if (offset == 560 &&  c > 15 && c < 19){  
                        vla.grid.data = combine(0,0,0,1);  // Apple
                        vla.grid.offset = offset+c;
                        set_ball_coordinate(&vla.grid); 
                    }
                }
            }
            
        }
        offset = 0;
        sleep(10);
    }
    clear_Display(vla);
    return 0;
*/
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
   
}
