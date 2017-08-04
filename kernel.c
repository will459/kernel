#include "kernel.h"

void _start() {
  char* video_memory = (char*) 0xb8000;
  //Char pointer to start of video memory
  *video_memory = 'X';
  //Prints an X
}

int clearscreen() {
  //0xB8000 + 2 * (row * 80 + col)
  //Max is 80x25

  int max = 0xB8000 + 2 * (80 * 25);
  char* video_memory = (char*) 0xb8000;
  for(int i = 0; i < max; i++)
  {
    *video_memory = ' ';
    video_memory = video_memory + 2;
  }
}
