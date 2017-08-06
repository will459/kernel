#include "screen.h"

void clearscreen() {
  //0xB8000 + 2 * (row * 80 + col)
  //Max is 80x25

  char* video_memory = (char*) VIDEOMEMHEAD;

  int max = VIDEOMEMHEAD + 2 * (80 * 25);
  for(int i = 0; i < max; i++)
  {
    *video_memory = BLANK;
    video_memory = video_memory + 2;
  }
  set_cursor(get_screen_offset(0, 0)); //Reset the cursor to top left
}

int get_screen_offset(int row, int col) {
  int screen_offset;
  screen_offset = ((row * COLUMNS) + col) * 2;
  return screen_offset;
}

int get_cursor() {
  port_byte_out(REG_SCREEN_CTRL, 14);
  int offset = port_byte_in(REG_SCREEN_DATA) << 8;
  port_byte_out(REG_SCREEN_CTRL, 15);
  offset = offset + port_byte_in(REG_SCREEN_DATA);

  return offset * 2; //Offset * 2 because every 2 bytes is 1 character
}

void set_cursor(int offset) {
  offset = offset / 2;

  port_byte_out(REG_SCREEN_CTRL, 14);
  port_byte_out(REG_SCREEN_DATA, (unsigned char) (offset >> 8));
  port_byte_out(REG_SCREEN_CTRL, 15);
}

//TODO: Handle scrolling
int handle_scrolling(int offset) {
  return offset;
}

void writechar(char c, int col, int row, char attribute) {
  unsigned char *vidmem = (unsigned char *) VIDEOMEMHEAD;

  //If no style was set assume white on black
  if(!attribute) {
    attribute = WHITE_ON_BLACK;
  }

  int offset;

  if(col >= 0 && row >= 0) {
    offset = get_screen_offset(col, row);
  } else {
    offset = get_cursor();
  }
  if(c == 'n') {
    int rows = offset / (2*COLUMNS);
    offset = get_screen_offset(79, rows); //End of column, i.e. behave like newline
  } else {
    *(vidmem + offset) = c; //Lower half is the char
    *(vidmem + offset + 1) = attribute; //Upper half is the attribute
  }

  offset = offset + 2;

  offset = handle_scrolling(offset);

  set_cursor(offset);
}

void print_at(char* string, int col, int row) {
  if (col >= 0 && row >= 0) {
    set_cursor(get_screen_offset(col, row)); //Update cursor
  }
  int i = 0;
  while(*(string + i) != 0) { //Not end of string
    writechar(*(string + i), col, row, WHITE_ON_BLACK);
    i = i + 1;
  }
}
