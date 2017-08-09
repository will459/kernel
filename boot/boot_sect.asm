[org 0x7c00]

KERNEL_OFFSET equ 0x1000 ;Memory offset to load in kernel

mov [BOOT_DRIVE], dl ;Store the boot drive for later

mov bp, 0x9000 ;Stack origin point
mov sp, bp ;Stack pointer

mov bx, MSG_REAL_MODE
call print_string

call load_kernel

call switch_to_pm ;Never return from here

jmp $

;Include my created functions
%include "boot/print/print_string.asm"
%include "boot/print/print_hex.asm"
%include "boot/disk/disk_load.asm"
%include "boot/pm/print_string_pm.asm"
%include "boot/pm/switch_to_pm.asm"
%include "boot/pm/gdt.asm"
%include "boot/pm/idt.asm"

[bits 16]
load_kernel:
  mov bx, MSG_LOAD_KERNEL
  call print_string

  mov bx, KERNEL_OFFSET ;Set up parameters for switching
  mov dh, 15            ;Load 15 sectors
  mov dl, [BOOT_DRIVE]  ;From the boot drive
  call disk_load

  ret

[bits 32]
;This is where we arrive after sitching to protected mode
BEGIN_PM:
  mov ebx, MSG_PROT_MODE
  call print_string_pm ;use the 32 bit routine

  call KERNEL_OFFSET ;Jump to start of kernel code

  jmp $ ;Hang

; Global variables
BOOT_DRIVE:
  db 0
MSG_REAL_MODE:
  db "started in 16 bit real mode",0
MSG_PROT_MODE:
  db "Successfully started 32-bit protected mode",0
MSG_LOAD_KERNEL:
  db "Loading kernel into memory",0

;Closing section
times 510-($-$$) db 0 ;Pad up to byte 510 with 0's
dw 0xaa55
