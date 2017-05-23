nasmflags = -f bin -o

os-image : boot_sect.bin kernel.bin
	cat boot_sect.bin kernel.bin > os-image

boot_sect.bin : boot_sect.asm
	nasm boot_sect.asm $(nasmflags) boot_sect.bin

kernel.bin : kernel.c kernel_entry.asm
	gcc -m32 -ffreestanding -c kernel.c -o kernel.o
	nasm kernel_entry.asm -f elf -o kernel_entry.o
	ld -m elf_i386 -o kernel.bin -Ttext 0x1000 kernel_entry.o kernel.o --oformat binary

softclean:
	rm *.bin *.o

clean:
	rm *.bin *.o os-image
