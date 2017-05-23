objects = boot_sect.bin kernel.bin kernel.o os-image
nonfinalobjects = boot_sect.bin kernel.bin kernel.o
nasmflags = -f bin -o

os-image : boot_sect.bin kernel.bin
	cat boot_sect.bin kernel.bin > os-image

boot_sect.bin : boot_sect.asm
	nasm boot_sect.asm $(nasmflags) boot_sect.bin

kernel.bin : kernel.c
	gcc -ffreestanding -c kernel.c -o kernel.o
	ld -o kernel.bin -Ttext 0x1000 kernel.o --oformat binary

softclean:
	rm $(nonfinalobjects)

clean:
	rm $(objects)
