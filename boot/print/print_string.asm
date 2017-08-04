print_string:
  mov ah, 0x0e  ;BIOS teletype output
  pusha ;Store registers on the stack

  jmp print_loop

print_loop:
  mov al, [bx] ;Get the next char to print (bx)

  cmp al, 0 ;If it is the null character
  je _return ;End function execution
  int 0x10 ;else, call interupt routine
  add bx, 1 ;Move forward
  jmp print_loop ;Go to top of loop

_return:
  popa
  ret
