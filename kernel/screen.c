#include "screen.h"

#define VIDEOMEMHEAD 0xb8000

char* video_memory = (char*) VIDEOMEMHEAD;

int clearscreen() {
  //0xB8000 + 2 * (row * 80 + col)
  //Max is 80x25

  int max = VIDEOMEMHEAD + 2 * (80 * 25);
  for(int i = 0; i < max; i++)
  {
    *video_memory = 0x00;
    video_memory = video_memory + 2;
  }
  video_memory = (char*) VIDEOMEMHEAD;
}

void writechar(char c) {
  *video_memory = c;
  video_memory = video_memory + 2;
}

void backspace() {
  *video_memory = 0x00;
  video_memory = video_memory - 2;
}
