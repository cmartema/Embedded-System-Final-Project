/*
 * Userspace program that communicates with the vga_ball device driver
 * through ioctls
 *
 * Stephen A. Edwards
 * Columbia University
 */

#include <stdio.h>
#include "vga_snake.h"
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>
#include <unistd.h>

int vga_snake_fd;

/* Read and print the background color */
void print_background_color() {
  vga_snake_arg_t vla;
  
  if (ioctl(vga_snake_fd, VGA_SNAKE_READ_BACKGROUND, &vla)) {
      perror("ioctl(VGA_SNAKE_READ_BACKGROUND) failed");
      return;
  }
  printf("%02x %02x %02x\n",
	 vla.background.red, vla.background.green, vla.background.blue);
}

/* Set the background color */
void set_background_color(const vga_snake_color_t *c)
{
  vga_snake_arg_t vla;
  vla.background = *c;
  if (ioctl(vga_snake_fd, VGA_SNAKE_WRITE_BACKGROUND, &vla)) {
      perror("ioctl(VGA_SNAKE_SET_BACKGROUND) failed");
      return;
  }
}

int main()
{
  vga_snake_arg_t vla;
  int i;
  static const char filename[] = "/dev/vga_snake";

  static const vga_snake_color_t colors[] = {
    { 0xff, 0x00, 0x00 }, /* Red */
    { 0x00, 0xff, 0x00 }, /* Green */
    { 0x00, 0x00, 0xff }, /* Blue */
    { 0xff, 0xff, 0x00 }, /* Yellow */
    { 0x00, 0xff, 0xff }, /* Cyan */
    { 0xff, 0x00, 0xff }, /* Magenta */
    { 0x80, 0x80, 0x80 }, /* Gray */
    { 0x00, 0x00, 0x00 }, /* Black */
    { 0xff, 0xff, 0xff }  /* White */
  };

# define COLORS 9

  printf("VGA snake Userspace program started\n");

  if ( (vga_snake_fd = open(filename, O_RDWR)) == -1) {
    fprintf(stderr, "could not open %s\n", filename);
    return -1;
  }

  printf("initial state: ");
  print_background_color();

  for (i = 0 ; i < 24 ; i++) {
    set_background_color(&colors[i % COLORS ]);
    print_background_color();
    usleep(400000);
  }
  
  printf("VGA SNAKE Userspace program terminating\n");
  return 0;
}
