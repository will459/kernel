#include "util.h"

void memcpy(const char *src, char *dest, int size_bytes) {
  for(int i = 0; i < size_bytes; i = i + 1) {
    *(dest + i) = *(src + i);
  }
}
