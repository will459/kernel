objects = boot_sect.bin
nasmflags = -f bin -o

os-image : boot_sect.bin kernel.binary
	cat boot_sect.bin kernel.bin > os-image

boot_sect.bin : boot_sect.asm
	nasm boot_sect.asm $(nasmflags) boot_sect.bin

kernel.bin : kernel.c
	gcc -ffreestanding -c kernel.c -o kernel.o
	ld -o kernel.bin -Ttext 0x1000 kernel.o --oformat binary

clean:
	rm $(objects)
