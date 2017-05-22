objects = boot_sect.bin
nasmflags = -f bin -o

boot_sect.bin : boot_sect.asm print_string.asm disk_load.asm
	nasm boot_sect.asm $(nasmflags) boot_sect.bin

clean:
	rm $(objects)
