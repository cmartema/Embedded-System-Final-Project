#ifndef _VGA_BALL_H
#define _VGA_BALL_H

#include <linux/ioctl.h>


// this will set the coordinates for any sprites 
typedef struct {
  unsigned long int data;
} grid;


typedef struct {
	unsigned char red, green, blue;
  //vga_ball_coordinate coordinate;
} vga_ball_color_t;

/*
typedef struct {
  vga_ball_color_t background;
  vga_ball_coordinate coordinate;
  sv_map data;
} vga_ball_arg_t;
*/

typedef struct {
  // vga_ball_color_t background;
  // vga_ball_coordinate_and_map coordinate_and_map;
  // unsigned short int data
  grid data;
} vga_ball_arg_t;


#define VGA_BALL_MAGIC 'q'

/* ioctls and their arguments */
#define VGA_BALL_WRITE_COORDINATE _IOW(VGA_BALL_MAGIC, 1, vga_ball_arg_t *)
// #define VGA_HEAD_UP_WRITE_COORDINATE _IOW(VGA_BALL_MAGIC, 2, vga_ball_arg_t *)
// #define VGA_FRUIT_WRITE_COORDINATE _IOW(VGA_BALL_MAGIC, 3, vga_ball_arg_t *)


#endif