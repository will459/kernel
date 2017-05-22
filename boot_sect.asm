[org 0x7c00]

mov bp, 0x9000 ;Stack origin point
mov sp, bp ;Stack pointer

mov bx, MSG_REAL_MODE
call print_string

call switch_to_pm ;Never return from here

jmp $

%include "../print/print_string.asm"
%include "../print/print_hex.asm"
%include "../disk/disk_load.asm"
%include "../print/print_string_pm.asm"
%include "switch_to_pm.asm"
%include "gdt.asm"

[bits 32]
;This is where we arrive after sitching to protected mode
BEGIN_PM:
  mov ebx, MSG_PROT_MODE
  call print_string_pm ;use the 32 bit routine

  jmp $ ;Hang

; Global variables
MSG_REAL_MODE:
  db "started in 16 bit real mode",0
MSG_PROT_MODE:
  db "Successfully started 32-bit protected mode",0

;Closing section
times 510-($-$$) db 0 ;Pad up to byte 510 with 0's
dw 0xaa55
