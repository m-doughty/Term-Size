#include "termsize.h"
#include <fcntl.h>
#include <stdio.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/select.h>
#include <sys/time.h>
#include <termios.h>
#include <unistd.h>

// Helper to send escape sequence and parse reply of the form: ESC [ X ; A ; B t
static int kitty_query(const char *seq, int *out1, int *out2) {
  int fd = open("/dev/tty", O_RDWR | O_NOCTTY);
  if (fd == -1)
    return -1;

  struct termios oldt, newt;
  tcgetattr(fd, &oldt);
  newt = oldt;
  cfmakeraw(&newt);
  tcsetattr(fd, TCSANOW, &newt);

  write(fd, seq, strlen(seq));
  fsync(fd);

  char buf[64] = {0};

  fd_set readfds;
  FD_ZERO(&readfds);
  FD_SET(fd, &readfds);
  struct timeval tv = {0, 200000}; // 200 ms

  int ret = select(fd + 1, &readfds, NULL, NULL, &tv);
  int n = 0;
  if (ret > 0) {
    n = read(fd, buf, sizeof(buf) - 1);
  }

  tcsetattr(fd, TCSANOW, &oldt);
  close(fd);

  if (n > 0) {
    int a = 0, b = 0;
    if (sscanf(buf, "\033[%*d;%d;%dt", &a, &b) == 2) {
      *out1 = b;
      *out2 = a;
      return 0;
    }
  }
  return -1;
}

int get_kitty_termsize(struct termsize *sz, struct cellsize *cz) {
  int cols = 0, rows = 0, pxw = 0, pxh = 0, cellw = 0, cellh = 0;

  int have_cells = kitty_query("\033[18t", &cols, &rows);
  int have_pixels = kitty_query("\033[14t", &pxw, &pxh);
  int have_cellpx = kitty_query("\033[16t", &cellw, &cellh);

  // Fallbacks (optional): only populate what we get
  if (have_cells != 0 && have_pixels != 0 && have_cellpx != 0)
    return -1;

  sz->ws_col = cols;
  sz->ws_row = rows;
  sz->ws_xpixel = pxw;
  sz->ws_ypixel = pxh;

  cz->ws_cwidth = cellw;
  cz->ws_cheight = cellh;

  return 0;
}

int get_termsize(struct termsize *sz) {
  return ioctl(STDOUT_FILENO, TIOCGWINSZ, sz);
}
