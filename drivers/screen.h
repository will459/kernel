#ifndef SCREEN_H
#define SCREEN_H

#include "../kernel/low_level.h"
//Defines
#define VIDEOMEMHEAD 0xb8000
#define ROWS 25
#define COLUMNS 80

#define WHITE_ON_BLACK 0x0f
//Totally blank character, for erasing
#define BLANK 0x00

#define REG_SCREEN_CTRL 0x3D4
#define REG_SCREEN_DATA 0x3D5

//Functions
void writechar(char c, int col, int row, char attribute);
void print_at(char* string, int col, int row);
void clearscreen();

#endif
