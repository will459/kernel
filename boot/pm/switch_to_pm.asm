[bits 16]
;Switch to protected mode
switch_to_pm:

cli       ;Turn off interrupts until we set-up protected mode

lgdt [gdt_descriptor] ;Load our global descriptor defining protected mode segments
lidt [idt_descriptor]

mov eax, cr0 ;Copy value of cr0
or eax, 0x1 ;Set the last bit to 1
mov cr0, eax ;Copy back into cr0

jmp CODE_SEG:init_pm ;Make a far jump to make sure the CPU processes everything in its buffer

[bits 32]
;Initialize registers
init_pm:
  mov ax, DATA_SEG    ;In protected mode our old segments are meaningless
  mov ds, ax          ;So we point our segment registers to the data selector
  mov ss, ax          ;we defined in our GDT
  mov es, ax
  mov fs, ax
  mov gs, ax

  mov ebp, 0x90000    ;Update our stack position so it is right at the top of free space
  mov esp, ebp

  call BEGIN_PM
