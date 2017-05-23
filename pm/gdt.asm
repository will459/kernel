; GDT
gdt_start:

gdt_null:   ;Mandatory NULL descriptor (8 bytes of 0)
dd 0x0      ;Double word (4 bytes)
dd 0x0

gdt_code:   ;Code segment descriptor
  ;Base=0x0, limit=0xffffffff
  ;1st flags: (present)1 (priviledge)00 (descriptor type)1 -> 1001b
  ;type flags: (code)1 (conforming)0 (readable)1 (accessed)0 ->1010b
  ;2nd flags: (granularity)1 (32-bit default)1 (64-bit seg)0 (AVL)0 -> 1100b

  dw 0xffff   ;Limit (bits 0-15)
  dw 0x0      ;Base (bits 0-15)
  db 0x0      ;Base (bits 16-23)
  db 10011010b;1st flags, type flags
  db 11001111b;2nd flags, limit (bits 16-19)
  db 0x0      ;Base (bits 24-31)

gdt_data:   ;Data segment descriptor
    ;Same as code segment except for the type flags:
    ;Type flags: (code)0 (expand down)0 (writable)1 (accessed)0 -> 0010b
  dw 0xffff   ;Limit (bits 0-15)
  dw 0x0      ;Base (bits 0-15)
  db 0x0      ;Base (bits 16-23)
  db 10010010b;1st flags, type flags
  db 11001111b;2nd flags, Limit (bits 16-19)
  db 0x0      ;Base(bits 24-31)

gdt_end:        ;The reason for putting a label at the end of the
                ;GDT is so we can have the assembler calculate
                ;the size of the GDT for the GDT descriptor (below)

;GDT descriptor
gdt_descriptor:
  dw gdt_end - gdt_start - 1  ;Size of our GDT, always less one than the true size
  dd gdt_start                ;Start address of our GDT

;Some handy constants for GDT descriptor offsets.
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start
