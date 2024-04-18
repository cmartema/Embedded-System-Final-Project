#ifndef _VGA_SNAKE_H
#define _VGA_SNAKE_H

#include <linux/ioctl.h>

typedef struct {
	unsigned char red, green, blue;
} vga_snake_color_t;
  

typedef struct {
  vga_snake_color_t background;
} vga_snake_arg_t;

#define VGA_SNAKE_MAGIC 'q'

/* ioctls and their arguments */
#define VGA_SNAKE_WRITE_BACKGROUND _IOW(VGA_SNAKE_MAGIC, 1, vga_snake_arg_t *)
#define VGA_SNAKE_READ_BACKGROUND  _IOR(VGA_SNAKE_MAGIC, 2, vga_snake_arg_t *)

#endif
