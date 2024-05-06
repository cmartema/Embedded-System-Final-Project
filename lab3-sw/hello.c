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

// customized hashmap
/*

#define TABLE_SIZE 100

typedef struct HashNode {
    int key;
    int value;
    struct HashNode* next;
} HashNode;

typedef struct HashMap {
    HashNode* buckets[TABLE_SIZE];
} HashMap;

// Function to create a hash node
HashNode* createHashNode(int key, int value) {
    HashNode* newNode = (HashNode*) malloc(sizeof(HashNode));
    newNode->key = key;
    newNode->value = value;
    newNode->next = NULL;
    return newNode;
}

// Hash function to convert a key into an index
unsigned int hashFunction(int key) {
    return key % TABLE_SIZE;
}

// Function to create a hashmap
HashMap* createHashMap() {
    HashMap* map = (HashMap*) malloc(sizeof(HashMap));
    for (int i = 0; i < TABLE_SIZE; i++) {
        map->buckets[i] = NULL;
    }
    return map;
}

// Function to insert a key-value pair into the hashmap
void insertHashMap(HashMap* map, int key, int value) {
    unsigned int index = hashFunction(key);
    HashNode* newNode = createHashNode(key, value);
    if (map->buckets[index] == NULL) {
        map->buckets[index] = newNode;
    } else {
        HashNode* current = map->buckets[index];
        while (current->next != NULL) {
            if (current->key == key) {
                current->value = value; // Update value if key already exists
                free(newNode);
                return;
            }
            current = current->next;
        }
        if (current->key == key) {
            current->value = value; // Update value if key already exists
            free(newNode);
        } else {
            current->next = newNode; // Insert new node at the end of the list
        }
    }
}

// Function to search for a value by key in the hashmap
int searchHashMap(HashMap* map, int key) {
    unsigned int index = hashFunction(key);
    HashNode* current = map->buckets[index];
    while (current != NULL) {
        if (current->key == key) {
            return current->value;
        }
        current = current->next;
    }
    return -1; // Return -1 if the key is not found
}

// Function to delete a hashmap and free its memory
void deleteHashMap(HashMap* map) {
    for (int i = 0; i < TABLE_SIZE; i++) {
        HashNode* current = map->buckets[i];
        while (current != NULL) {
            HashNode* temp = current;
            current = current->next;
            free(temp);
        }
    }
    free(map);
}
*/

// random number coordinate generator for fruit
/*
// Function to generate a random coordinate within the specified range
Coordinate generateRandomCoordinate(int minX, int maxX, int minY, int maxY) {
    Coordinate randomCoord;
    randomCoord.x = minX + rand() % (maxX - minX + 1);
    randomCoord.y = minY + rand() % (maxY - minY + 1);
    return randomCoord;
}
*/

// Queue to keep track of snake body
/*
#define MAX_SIZE 100

// Structure defining a pair of coordinates
typedef struct {
    int x;
    int y;
} Coordinate;

// Structure defining a queue
typedef struct {
    Coordinate items[MAX_SIZE];
    int front;
    int rear;
} Queue;

// Function to create a new empty queue
Queue* createQueue() {
    Queue* queue = (Queue*)malloc(sizeof(Queue));
    queue->front = -1;
    queue->rear = -1;
    return queue;
}

// Function to check if the queue is empty
int isEmpty(Queue* queue) {
    return (queue->front == -1 && queue->rear == -1);
}

// Function to check if the queue is full
int isFull(Queue* queue) {
    return (queue->rear == MAX_SIZE - 1);
}

// Function to add an item to the rear of the queue
void enqueue(Queue* queue, Coordinate value) {
    if (isFull(queue)) {
        printf("Queue is full, cannot enqueue!\n");
        return;
    } else if (isEmpty(queue)) {
        queue->front = 0;
        queue->rear = 0;
    } else {
        queue->rear++;
    }
    queue->items[queue->rear] = value;
}

// Function to remove an item from the front of the queue
Coordinate dequeue(Queue* queue) {
    Coordinate item;
    if (isEmpty(queue)) {
        printf("Queue is empty, cannot dequeue!\n");
        item.x = -1;
        item.y = -1;
        return item;
    }
    item = queue->items[queue->front];
    if (queue->front == queue->rear) {
        queue->front = -1;
        queue->rear = -1;
    } else {
        queue->front++;
    }
    return item;
}

// Function to display the elements of the queue
void display(Queue* queue) {
    if (isEmpty(queue)) {
        printf("Queue is empty!\n");
        return;
    }
    printf("Queue elements: ");
    for (int i = queue->front; i <= queue->rear; i++) {
        printf("{%d, %d} ", queue->items[i].x, queue->items[i].y);
    }
    printf("\n");
}

// Function to get the front element of the queue without removing it
Coordinate peek(Queue* queue) {
    Coordinate item;
    if (isEmpty(queue)) {
        printf("Queue is empty!\n");
        item.x = -1;
        item.y = -1;
        return item;
    }
    return queue->items[queue->front];
}

// Function to delete the queue and free memory
void deleteQueue(Queue* queue) {
    free(queue);
    printf("Queue deleted and memory freed.\n");
}
*/

int direction;

int vga_ball_fd;

pthread_t sony_thread;
void *sony_thread_f(void *);

/* Read and print the background color */
void print_background_color() {
  vga_ball_arg_t vla;
  
  if (ioctl(vga_ball_fd, VGA_BALL_READ_BACKGROUND, &vla)) {
      perror("ioctl(VGA_BALL_READ_BACKGROUND) failed");
      return;
  }
  printf("%02x %02x %02x\n",
	 vla.background.red, vla.background.green, vla.background.blue);
}

/* Set the background color */
void set_background_color(const vga_ball_color_t *c)
{
  vga_ball_arg_t vla;
  vla.background = *c;
  if (ioctl(vga_ball_fd, VGA_BALL_WRITE_BACKGROUND, &vla)) {
      perror("ioctl(VGA_BALL_SET_BACKGROUND) failed");
      return;
  }
}

/*
//print the ball

*/


//set the ball position
void set_ball_coordinate(const vga_ball_coordinate *c, const vga_ball_coordinate *a, const vga_ball_coordinate *b)
{
  vga_ball_arg_t vla;
  vga_ball_arg_t fruit;
  vga_ball_arg_t head_up;
  vla.coordinate = *c;
  fruit.coordinate = *a;
  head_up.coordinate = *b;
  if (ioctl(vga_ball_fd, VGA_BALL_WRITE_COORDINATE, &vla)) {
      perror("ioctl(VGA_BALL_WRITE_COORDINATE) failed");
      return;
  }
    
  if (ioctl(vga_ball_fd, VGA_FRUIT_WRITE_COORDINATE, &fruit)){
    perror("ioctl(VGA_FRUIT_WRITE_COORDINATE) failed");
    return;
  }

  if (ioctl(vga_ball_fd, VGA_HEAD_UP_WRITE_COORDINATE, &head_up)) {
      perror("ioctl(VGA_HEAD_UP_WRITE_COORDINATE) failed");
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
        }
  }

  return NULL;
}



int main()
{
  struct ThreadArgs args;
  vga_ball_arg_t vla;
  vga_ball_arg_t fruit;
  vga_ball_arg_t head_up;
  int i;
  static const char filename[] = "/dev/vga_ball";

  printf("VGA ball Userspace program started\n");
  
  // opening and connecting to keyboard
  
  uint8_t endpoint_address_temp;
  struct libusb_device_handle *sony_temp;
  if ((sony_temp = opensony(&endpoint_address_temp)) == NULL ) {
    fprintf(stderr, "Did not find sony\n");
    exit(1);
  }	
  

  args.sony = sony_temp;
  args.endpoint_address = endpoint_address_temp;
  

  

  // Cast the argument pointer to the correct type

//   pthread_create(&sony_thread, NULL, sony_thread_f, NULL);
  pthread_create(&sony_thread, NULL, sony_thread_f, (void *)&args);
  printf("After pthread create\n");

   if ( (vga_ball_fd = open(filename, O_RDWR)) == -1) {
     fprintf(stderr, "could not open %s\n", filename);
     return -1;
   }
    fruit.coordinate.x = 10;
    fruit.coordinate.y = 10;

    vla.coordinate.x = 10;
    vla.coordinate.y = 20;
    set_ball_coordinate(&vla.coordinate, &fruit.coordinate, &head_up.coordinate);

   while(1){
    set_ball_coordinate(&vla.coordinate, &fruit.coordinate, &head_up.coordinate);
    //fruit.coordinate.y += 1;
    if (direction == 0x02) {
        vla.coordinate.x += 1;
    } else if (direction == 0x06){
        vla.coordinate.x -= 1;
    } else if (direction == 0x00) {
        head_up.coordinate.y = vla.coordinate.y;
        head_up.coordinate.x = vla.coordinate.x;
        vla.coordinate.y = -1;
        vla.coordinate.x = -1;
    } else if (direction == 0x04) {
        vla.coordinate.y += 1;
    }
    if (fruit.coordinate.x == vla.coordinate.x && fruit.coordinate.y == vla.coordinate.y){
        printf("same coordinates\n");
    }
    if (vla.coordinate.x == 38 || vla.coordinate.x == 1 || vla.coordinate.y == 3 || vla.coordinate.y == 28){
        break;
    }

    usleep(300000);
   }
  printf("GAME OVER\n");
  pthread_join(sony_thread, NULL);
  printf("thread killed\n");
  return 0;
}

