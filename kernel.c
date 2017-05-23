void main() {
  char* video_memory = (char*) 0xb8000;
  //Char pointer to start of video memory
  *video_memory = 'X';
  //Prints an X
}
