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

int vga_ball_fd;

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
void set_ball_coordinate(const vga_ball_coordinate *c)
{
  vga_ball_arg_t vla;
  vla.coordinate = *c;
  if (ioctl(vga_ball_fd, VGA_BALL_WRITE_COORDINATE, &vla)) {
      perror("ioctl(VGA_BALL_SET_BACKGROUND) failed");
      return;
  }
}


int main()
{
  vga_ball_arg_t vla;
  int i;
  static const char filename[] = "/dev/vga_ball";

  static const vga_ball_color_t colors[] = {
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
  
  #define COLORS 9

  printf("VGA ball Userspace program started\n");

  if ( (vga_ball_fd = open(filename, O_RDWR)) == -1) {
    fprintf(stderr, "could not open %s\n", filename);
    return -1;
  }

  printf("initial state: ");
  print_background_color();
  /*
  for (i = 0 ; i < 24 ; i++) {
    //set_background_color(&colors[i % COLORS ]);
    //print_background_color();
    usleep(400000);
  }
  vla.coordinate.x = 20;
  vla.coordinate.y = 20;
  for (i = 0 ; i < 2 ; i++) {
    set_ball_coordinate(&vla.coordinate);
    //print_background_color();
    usleep(400000);
    vla.coordinate.x = 280;
    vla.coordinate.y = 280;
  }*/
  //vla.coordinate.x = 600;
  //vla.coordinate.y = 0;
  //set_ball_coordinate(&vla.coordinate);

  while(1){
    set_ball_coordinate(&vla.coordinate);
  
    vla.coordinate.x += 1;
    vla.coordinate.y += 1;
    //printf("x: %d\n", vla.coordinate.x);
    //printf("y: %d\n", vla.coordinate.y);
    usleep(30000);

  }

  printf("VGA BALL Userspace program terminating\n");
  return 0;
}