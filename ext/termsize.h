#ifndef TERMSIZE_H
#define TERMSIZE_H

struct termsize {
  unsigned short ws_row;
  unsigned short ws_col;
  unsigned short ws_xpixel;
  unsigned short ws_ypixel;
};

struct cellsize {
  unsigned int ws_cwidth;
  unsigned int ws_cheight;
};

int get_termsize(struct termsize *sz);
int get_kitty_termsize(struct termsize *sz, struct cellsize *cz);

#endif
