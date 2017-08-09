; IDT
idt_start:

idt_end:

idt_descriptor:
  dw idt_end - idt_start - 1 ;Size of the idt
  dd idt_start ;Start of idt
