#include "kernel.h"

#include "screen.h"

void _start() {

  clearscreen();
  writechar('X');
  writechar('X');
  backspace();
  writechar('Y');
}
