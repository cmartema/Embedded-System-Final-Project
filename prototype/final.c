#include <time.h>
#include <libusb-1.0/libusb.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <unistd.h>
#include <pthread.h>
#include <string.h>
#include "vga_ball.h"
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

#define UP 0
#define RIGHT 2
#define DOWN 4
#define LEFT 6
#define ROWS 79
#define COLS 79

struct libusb_device_handle *f310;
uint8_t endpoint_address;

struct coordinate *bodies;
struct coordinate apple;
int len;
struct f310_packet packet;
int transferred;
int vga_ball_fd;
static const char filename[] = "/dev/vga_ball";
vga_ball_pos position;
int game_pause;
int level;
int can_change;
struct coordinate *buf;

struct f310_packet {
  uint8_t modifiers;
  uint8_t reserved;
  uint8_t keycode[6];
};

struct head {
    int x;
    int y;
    int direction;
} head;

struct coordinate {
    int x;
    int y;
};

struct libusb_device_handle *open_f310(uint8_t *endpoint_address) {
    libusb_device **devs;
    struct libusb_device_handle *f310 = NULL;
    struct libusb_device_descriptor desc;
    ssize_t num_devs, d;
    uint8_t i, k;

    if (libusb_init(NULL) < 0) {
        fprintf(stderr, "Error: libusb_init failed\n");
        exit(1);
    }

    if ((num_devs = libusb_get_device_list(NULL, &devs)) < 0) {
        fprintf(stderr, "Error: libusb_get_device_list failed\n");
        exit(1);
    }

    for (d = 0; d < num_devs; d++) {
        libusb_device *dev = devs[d];
        if (libusb_get_device_descriptor(dev, &desc) < 0) {
            fprintf(stderr, "Error: libusb_get_device_descriptor failed\n");
            exit(1);
        }

        if (desc.idVendor == 0x046d && desc.idProduct == 0xc216) {
            struct libusb_config_descriptor *config;
            libusb_get_config_descriptor(dev, 0, &config);
            for (i = 0; i < config->bNumInterfaces; i++) {
                for (k = 0; k < config->interface[i].num_altsetting; k++) {
                    const struct libusb_interface_descriptor *inter = config->interface[i].altsetting + k;
                    if (inter->bInterfaceClass == 0x03 && inter->bInterfaceProtocol == 0x00) {
                        int r;
                        if ((r = libusb_open(dev, &f310)) != 0) {
                            fprintf(stderr, "Error: libusb_open failed: %d\n", r);
                            exit(1);
                        }
                        if (libusb_kernel_driver_active(f310, i)) libusb_detach_kernel_driver(f310, i);
                        libusb_set_auto_detach_kernel_driver(f310, 1);
                        if ((r = libusb_claim_interface(f310, i)) != 0) {
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

found:
    libusb_free_device_list(devs, 1);

    return f310;
}

void set_pos(const vga_ball_pos *c) {
    vga_ball_arg_t vla;
    vla.position = *c;
    if (ioctl(vga_ball_fd, VGA_BALL_WRITE_BACKGROUND, &vla)) {
        perror("ioctl(VGA_BALL_SET_BACKGROUND) failed");
        return;
    }
}

void draw() {
    int i, j;

    for (i = 0; i <= ROWS; i++) {
        for (j = 0; j <= COLS; j++) {
            if (i == 0 || j == 0 || i == ROWS || j == COLS) {
                printf("#");
            } else if (i == head.x && j == head.y) {
                printf("O");
            } else if (i == apple.x && j == apple.y) {
                printf("A");
            } else {
                printf(" ");
            }
        }
        printf("\n");
    }
}

int hit_body() {
    int i;

    for (i = 0; i < len; i++) if (head.x == bodies[i].x && head.y == bodies[i].y) return 1;

    return 0;
}

/*
int consume() {
    if (head.x == apple.x && head.y == apple.y) return 1;

    return 0;
}
*/

void regen_apple() {
    int i, x, y;

x_gen:
    x = rand() % COLS;
    if (x == head.x || x == 0) goto x_gen;
    for (i = 0; i < len; i++) if (x == bodies[i].x) goto x_gen;
y_gen:
    y = rand() % ROWS;
    if (y == head.y || y == 0 ) goto y_gen;
    for (i = 0; i < len; i++) if (y == bodies[i].y) goto y_gen;

    apple.x = x;
    apple.y = y;

    position.ax = x;
    position.ay = y;

    return;
}

void *get_direction(void *arg) {
    int threadID = *((int *)arg);
    // printf("Thread ID: %d\n", threadID);
    // Perform thread-specific operations here
    for (;;) {
        libusb_interrupt_transfer(f310, endpoint_address, (unsigned char *) &packet, sizeof(packet), &transferred, 0);
        if (transferred == sizeof(packet)) {
            if (can_change) {
                    if (packet.keycode[2] == 0 && head.direction != DOWN) {
                        head.direction = UP;
                    } else if (packet.keycode[2] == 2 && head.direction != LEFT) {
                        head.direction = RIGHT;
                    } else if (packet.keycode[2] == 4 && head.direction != UP) {
                        head.direction = DOWN;
                    } else if (packet.keycode[2] == 6 && head.direction != RIGHT) {
                        head.direction = LEFT;
                    }
                }
                can_change = 0;

                if (packet.keycode[3] == 32) {
                    game_pause = !game_pause;
                }

                if (game_pause) {
                    if (packet.keycode[2] == 24) {
                        level = 1;
                    } else if (packet.keycode[2] == 136) {
                        level = 2;
                    } else if (packet.keycode[2] == 72) {
                        level = 3;
                    } else if (packet.keycode[2] == 40) {
                        level = 4;
                    }
                }
            }
    }
    pthread_exit(NULL);
}

int main() {
    int i, input, threadID;
    pthread_t thread;

    srand(time(NULL));

    if ((f310 = open_f310(&endpoint_address)) == NULL) {
        fprintf(stderr, "Did not find f310\n");
        exit(1);
    }

    if ((vga_ball_fd = open(filename, O_RDWR)) == -1) {
        fprintf(stderr, "could not open %s\n", filename);
        return -1;
    }

    bodies = malloc(200 * sizeof(struct coordinate));
    buf = malloc(200 * sizeof(struct coordinate));

    head.x = COLS / 2;
    head.y = ROWS / 2;
    head.direction = RIGHT;

    position.x = head.x;
    position.y = head.y;

    level = 1;
    game_pause = 1;
    can_change = 0;

    pthread_create(&thread, NULL, get_direction, &threadID);

start:
    game_pause = 1;
    can_change = 1;

    head.x = COLS / 2;
    head.y = ROWS / 2;
    head.direction = RIGHT;
    position.x = head.x;
    position.y = head.y;

    regen_apple();

    len = 1;
    position.length = len + 1;

    bodies[0].x = head.x - 1;
    bodies[0].y = head.y;

logic:
    for (;;) {
        if (game_pause) goto logic;

        memcpy(buf, bodies, len * sizeof(struct coordinate));
        memcpy(bodies + 1, buf, len * sizeof(struct coordinate));
        bodies[0].x = head.x;
        bodies[0].y = head.y;

        switch (head.direction) {
            case UP:
                head.y--;
                position.y--;
                if (head.y <= 0 || hit_body()) {
                    goto start;
                }
                break;

            case DOWN:
                head.y++;
                position.y++;
                if (head.y >= ROWS || hit_body()) {
                    goto start;
                }
                break;

            case LEFT:
                head.x--;
                position.x--;
                if (head.x <= 0 || hit_body()) {
                    goto start;
                }
                break;

            case RIGHT:
                head.x++;
                position.x++;
                if (head.x >= COLS || hit_body()) {
                    goto start;
                }
                break;
        }

        if (head.x == apple.x && head.y == apple.y) {
            len++;
            position.length++;
            regen_apple();
        }

        set_pos(&position);

        can_change = 1;

        switch (level) {
            case 1:
                usleep(100000);
                break;

            case 2:
                usleep(65000);
                break;

            case 3:
                usleep(25000);
                break;

            case 4:
                usleep(10000);
                break;
        }
    }
    pthread_join(thread, NULL);
    free(bodies);
    free(buf);
}
