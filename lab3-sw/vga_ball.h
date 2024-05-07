#ifndef _VGA_BALL_H
#define _VGA_BALL_H

#include <linux/ioctl.h>

// this will set the coordinates for any sprites 
typedef struct {
  unsigned short int x;
  unsigned short int y;
} vga_ball_coordinate;

typedef struct {
  uint32_t data;
} sv_map;

typedef struct {
	unsigned char red, green, blue;
  //vga_ball_coordinate coordinate;
} vga_ball_color_t;

typedef struct {
  vga_ball_color_t background;
  vga_ball_coordinate coordinate;
  sv_map data;
} vga_ball_arg_t;


#define VGA_BALL_MAGIC 'q'

/* ioctls and their arguments */
#define VGA_BALL_WRITE_COORDINATE _IOW(VGA_BALL_MAGIC, 1, vga_ball_arg_t *)
// #define VGA_HEAD_UP_WRITE_COORDINATE _IOW(VGA_BALL_MAGIC, 2, vga_ball_arg_t *)
// #define VGA_FRUIT_WRITE_COORDINATE _IOW(VGA_BALL_MAGIC, 3, vga_ball_arg_t *)


#endif