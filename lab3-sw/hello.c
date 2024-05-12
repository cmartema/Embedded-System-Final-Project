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


/*----------------------------------------- Deque -----------------------------------------------*/

#define MAX_SIZE 1200

typedef struct {
    unsigned short int x_pos;
    unsigned short int y_pos;
    unsigned short int dir;
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

Map getFront(const Deque* dq) {
    Map frontMap;
    if (isEmpty(dq)) {
        printf("Deque is empty. No front element.\n");
        frontMap.x_pos = frontMap.y_pos = frontMap.dir = frontMap.map = 0; // Default values
    } else {
        frontMap = dq->arr[dq->front];
    }
    return frontMap;
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

/*----------------------------------------- Hash Map -----------------------------------------------*/
#define NUM_ROWS 30
#define NUM_COLS 40
#define HASHMAP_SIZE (NUM_ROWS * NUM_COLS)

// Define a struct for the key (row, column)
typedef struct {
    int row;
    int col;
} Key;

// Define a struct for the hashmap entry
typedef struct {
    Key key;
    int value;
} Entry;

// Define the hashmap structure
typedef struct {
    Entry *entries[HASHMAP_SIZE];
} HashMap;

// Hash function for the key
int hash(Key key) {
    return (key.row * NUM_COLS + key.col) % HASHMAP_SIZE;
}

// Function to initialize the hashmap
HashMap *createHashMap() {
    HashMap *map = (HashMap *)malloc(sizeof(HashMap));
    for (int i = 0; i < HASHMAP_SIZE; i++) {
        map->entries[i] = NULL;
    }
    return map;
}

// Function to insert a key-value pair into the hashmap
void insert(HashMap *map, Key key, int value) {
    int index = hash(key);
    Entry *entry = (Entry *)malloc(sizeof(Entry));
    entry->key = key;
    entry->value = value;
    map->entries[index] = entry;
}

// Function to retrieve the value associated with a key from the hashmap
int get(HashMap *map, Key key) {
    int index = hash(key);
    if (map->entries[index] != NULL && map->entries[index]->key.row == key.row && map->entries[index]->key.col == key.col) {
        return map->entries[index]->value;
    } else {
        return -1; // Key not found
    }
}

// Function to update the value associated with a key in the hashmap
void update(HashMap *map, Key key, int value) {
    int index = hash(key);
    if (map->entries[index] != NULL && map->entries[index]->key.row == key.row && map->entries[index]->key.col == key.col) {
        map->entries[index]->value = value;
    }
}

// Function to initialize the hashmap with all values set to 0
void initializeHashMap(HashMap *map) {
    for (int i = 0; i < NUM_ROWS; i++) {
        for (int j = 0; j < NUM_COLS; j++) {
            Key key = {i, j};
            insert(map, key, 0);
        }
    }
}

/*------------------------------------- Rest of the code ---------------------------------------*/

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
            int temp_d = packet.keycode[8];
            if (temp_d == 0x02){
                direction = 1;
            } else if (temp_d == 0x06){
                direction = 2;
            } else if (temp_d == 0x00){
                direction = 3;
            } else if (temp_d == 0x04){
                direction = 1;
            }
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

    // unsigned short int a = 0;
    // unsigned short int b = 0;
    // unsigned short int c = 0;
    // unsigned short int d = 0;

    vga_ball_arg_t vla;

    Deque snake;
    initializeDeque(&snake);

    HashMap *screen_map = createHashMap();
    // Initialize the hashmap with all values set to 0
    initializeHashMap(screen_map);

    // Map: {x_pos, y_pos, direction, spriteType}
    // direction:
    //      1->right
    //      2->left
    //      3->up
    //      4->down

    //basic snake 
    //right snake head
    Map initial_snake = {4, 4, 1, 5};
    insertFront(&snake, initial_snake);
    // horizontal snake body directed right
    Map initial_snake1 = {3, 4, 1, 7};
    insertRear(&snake, initial_snake1);
    //right snake tail
    Map initial_snake2 = {2, 4, 1, 14};
    insertRear(&snake, initial_snake2);
/*
    //testing 
    unsigned short int c = removeFront(&snake).map;
    unsigned short int d = removeFront(&snake).map;
    vla.grid.data = combine(0, 0, c, d);
    vla.grid.offset = 160;
    set_ball_coordinate(&vla.grid);
    unsigned short int a = removeFront(&snake).map;
    vla.grid.data = combine(a, 0, 0, 0);
    vla.grid.offset = 164;
    set_ball_coordinate(&vla.grid);
*/
    int offset;
    while(1){
        sleep(1);
        while(1){
            //sleep(1);
            Map temp;
            Map temp_head_up;
            Map temp_h_body;
            Map temp_tail_left;
            Map temp_head_up;
            switch (getFront(&snake).map){
                case 2:
                    temp_head_up = removeFront(&snake);
                    if (direction == 3 || direction == 4){
                        temp_head_up.y_pos -= 1;
                    }
                    else if (direction == 1){
                        temp_head_up.x_pos += 1;
                        temp_head_up.dir = direction;
                        temp_head_up.map = 5
                    } else if (direction == 2){
                        temp_head_up.x_pos -= 1;
                        temp_head_up.dir = direction;
                        temp_head_up.map = 4;
                    }
                    Key coords_head_up = {temp_head_up.x_pos, temp_head_up.y_pos};
                    update(screen_map, coords_head_up, temp_head_up.map);
                    insertRear(&snake, temp_head_up);
                    
                case 5:
                    temp = removeFront(&snake);
                    if (direction == 1 || direction == 2){ //right or left
                        temp.x_pos += 1;
                    
                    } else if (direction == 3){ // up
                        temp.y_pos -= 1;
                        temp.dir = direction;
                        temp.map = 2;
                    } 
                    Key coords = {temp.x_pos, temp.y_pos};
                    // printf("map val for head: %d\n", temp.map);
                    // printf("coords val for head: %d, %d\n", coords.col, coords.row);
                    update(screen_map, coords, temp.map);
                    // printf("mapping for head: %d\n", get(screen_map, coords));
                    insertRear(&snake, temp);

                    break;
                case 7:
                    temp_h_body = removeFront(&snake);
                    if (temp_h_body.dir == direction && direction == 1){
                        temp_h_body.x_pos += 1;
                    } else if (temp_h_body.dir == direction && direction == 2){
                        temp_h_body.x_pos -= 1;
                    }
                    Key coords_h = {temp_h_body.x_pos, temp_h_body.y_pos};
                    //printf("map val for b: %d\n", temp_h_body.map);
                    //printf("coords val for b: %d, %d\n", coords_h.col, coords_h.row);
                    update(screen_map, coords_h, temp_h_body.map);
                    //printf("mapping for body: %d\n", get(screen_map, coords_h));
                    insertRear(&snake, temp_h_body);
                    break;
                case 14:
                    temp_tail_left = removeFront(&snake);
                    Key temp_c = {temp_tail_left.x_pos, temp_tail_left.y_pos};
                    update(screen_map, temp_c, 0);
                    if (direction == 1 || direction == 2){
                        temp_tail_left.x_pos += 1;
                    } 
                    // else if (direction == 3){
                    //     temp_tail_left.y_pos -= 1;
                    //     temp_tail_left.dir = 3;
                    //     temp_tail_left.map = 13;
                    // }
                    
                    Key coords_t_l = {temp_tail_left.x_pos, temp_tail_left.y_pos};
                    //printf("map val for tail: %d\n", temp_tail_left.map);
                    //printf("coords val for tail: %d, %d\n", coords_t_l.col, coords_t_l.row);
                    update(screen_map, coords_t_l, temp_tail_left.map);
                    //printf("mapping for tail: %d\n", get(screen_map, coords_t_l));
                    insertRear(&snake, temp_tail_left);
                    goto writeScreen;
                    break;
                
            }
        }

        writeScreen:
        printf("line 405\n");
        offset = 0;
        //writing the whole screen
        for(int r = 0; r < 30; r++, offset+=40){
            for(int c = 0; c < 40; c+=4){
                //get(map, (Key){0, 0})
                unsigned short int sprite1 = get(screen_map, (Key){c, r});
                unsigned short int sprite2 = get(screen_map, (Key){c+1, r});
                unsigned short int sprite3 = get(screen_map, (Key){c+2, r});
                unsigned short int sprite4 = get(screen_map, (Key){c+3, r});
                // if(sprite1 > 0 ){
                //     printf("sprite1 %d\n", sprite1);
                // }
                // if(sprite2 > 0 ){
                //     printf("sprite2 %d\n", sprite2);
                // }
                // if(sprite3 > 0 ){
                //     printf("sprite3 %d\n", sprite3);
                // }
                // if(sprite4 > 0 ){
                //     printf("sprite4 %d\n", sprite4);
                // }
                vla.grid.data = combine(sprite1,sprite2,sprite3,sprite4);  
                vla.grid.offset = offset + c;
                set_ball_coordinate(&vla.grid);
            }

        }
    }


    // clear_Display(vla); //clear the display independently rather than depending on a for loop
    //initalize snake body and apple
 /*   
    for(int r = 0; r < 30; r++, offset+=40){
        for(int c = 0; c < 40; c+=4){
            if(r == 15 && c == 12){
                vla.grid.data = combine(0,14,7,5); // Snake head_right and tail_left placed of the first two columns of the corresponding row
                vla.grid.offset = offset+c;
                set_ball_coordinate(&vla.grid);
            } else if (r == 15 && c == 16){
                vla.grid.data = combine(0,0,0,1); // Snake head_right and tail_left placed of the first two columns of the corresponding row
                vla.grid.offset = offset+c;
                set_ball_coordinate(&vla.grid);
            }
            else {
                vla.grid.data = combine(0,0,0,0); // Snake head_right and tail_left placed of the first two columns of the corresponding row
                vla.grid.offset = offset+c;
                set_ball_coordinate(&vla.grid);
            }   
        }
    }*/
    
    return 0;   
   
}
