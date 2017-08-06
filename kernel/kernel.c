#include "kernel.h"

#include "../drivers/screen.h"
#include "test.h"

void _start() {
  test();

  for(;;) {}
}
