#include "screen.h"

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

  port_byte_out(REG_SCREEN_CTRL, 15); //0x3d4
  port_byte_out(REG_SCREEN_DATA, (unsigned char) (offset&0xFF)); //0x3d5
  port_byte_out(REG_SCREEN_CTRL, 14);
  port_byte_out(REG_SCREEN_DATA, (unsigned char) ((offset>>8)&0xFF));
}

int handle_scrolling(int offset) {
  if(offset < ROWS * COLUMNS * 2) { //If it hasn't fallen off the end
    return offset;
  }

  //Else, move rows down one
  for(int i = 1; i < ROWS; i = i + 1) {
    memcpy((char *)get_screen_offset(i, 0) + VIDEOMEMHEAD, (char *)get_screen_offset(i - 1, 0) + VIDEOMEMHEAD, COLUMNS * 2);
  }
  //Erase contents of last line
  char* last_line = (char *)get_screen_offset(ROWS - 1, 0) + VIDEOMEMHEAD;
  for(int i = 0; i < COLUMNS*2; i = i + 1) {
    *(last_line + i) = BLANK;
  }

  offset = offset - 2*COLUMNS; //Move cursor to last line (off end at the moment)

  return offset;
}

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
  if(c == '\n') {
    int rows = offset / (2*COLUMNS);
    offset = get_screen_offset(rows, 79); //End of column, i.e. behave like newline
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
    //Note we use -1 for row and column.  This makes the writechar use the cursor
    writechar(*(string + i), -1, -1, WHITE_ON_BLACK);
    i = i + 1;
  }
}

void print(char* string) {
  for(int i = 0; *(string + i) != 0; i = i + 1) {
    writechar(*(string + i), -1, -1, WHITE_ON_BLACK);
  }
}
