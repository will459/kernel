#include "kernel.h"

#include "../drivers/screen.h"

void _start() {
  writechar('X', 5, 5, WHITE_ON_BLACK);
}
