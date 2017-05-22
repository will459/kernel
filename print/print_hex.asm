print_hex:
  pusha

  mov ch, 0 ;Counter
  mov cl, 12 ; Shift counter

hex_print_loop:
  cmp ch, 4
  jz _hex_return ;Return if all chars read

  ;Else
  mov bx, [MASK]
  shl bx, cl
  and bx, dx
  shr bx, cl

  add bx, TABLE
  mov al, [bx]

  movzx bx, ch
  add bx, OUTPUT_STRING
  add bx, 2
  mov [bx], al

  inc ch
  sub cl, 4
  jmp hex_print_loop

_hex_return:
  mov bx, OUTPUT_STRING
  call print_string
  popa
  ret


;Data section

MASK:
  dw 0x000f

OUTPUT_STRING:
  db '0x0000',0

TABLE:
  db '0123456789ABCDEF',0
