[bits 32]

VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0x000f

print_string_pm:
  pusha
  mov edx, VIDEO_MEMORY ;Set edx to start of video memory

print_string_pm_loop:
  mov al, [ebx] ;Store char at ebx in AL
  mov ah, WHITE_ON_BLACK ;Store the attribute in AH

  cmp al, 0
  je done ;If al is 0 (end of string) jump to done

  mov [edx], ax ;Store char and att at current character cell

  add ebx, 1 ;Move to next char in string
  add edx, 2 ;Move to next character cell in video memory

  jmp print_string_pm_loop

done:
  popa
  ret
