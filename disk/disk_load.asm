; load DH sectors to ES:BX from drive DL
disk_load:
  push dx ;Store requested number of sectors on stack

  mov ah, 0x02 ;BIOS read sector function
  mov al, dh  ;Read DH sectors
  mov ch ,0x00 ;Cylinder 0
  mov dh, 0x00 ;Head 0
  mov cl, 0x02 ;Sector 2 (after boot sector)

  int 0x13 ;BIOS interupt

  jc disk_error ;Jump if carry flag set (i.e. error happened in reading)

  pop dx ;Restore dx since it was changed
  cmp dh, al ;If AL (sectors read, as set by the ISR) != DH (sectors asked for)
  jne disk_error
  ret

disk_error:
  mov bx, DISK_ERR_MSG
  call print_string
  jmp $

;Variables
DISK_ERR_MSG:
  db "Disk read error!",0
