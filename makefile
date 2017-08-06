#Compile the kernel from sources

#Get list of all c sources and their corresponding headers
C_SOURCES = $(wildcard kernel/*.c drivers/*.c)
HEADERS = $(wildcard kernel/*.h drivers/*.h)

#Produce list of output files from C_SOURCES
OBJ = ${C_SOURCES:.c=.o}

#Flags for NASM assembler to use
nasmflags = -f bin -o

#Default entry point, compiles the binary kernel in entirety
#Append kernel.bin after boot_sect.bin
os-image : boot_sect.bin kernel.bin
	cat $^ > os-image

boot_sect.bin : boot/boot_sect.asm
	nasm $^ $(nasmflags) boot_sect.bin

kernel.bin : kernel/kernel.c boot/kernel_entry.asm ${OBJ}
	gcc -m32 -O0 -ffreestanding -c kernel/kernel.c -o kernel.o
	nasm boot/kernel_entry.asm -f elf -o kernel_entry.o
	ld -m elf_i386 -o kernel.bin -Ttext 0x1000 kernel_entry.o ${OBJ} --oformat binary

#Generic rule for compiling C sources.  Note each C file depends on its header
%.o : %.c ${HEADERS}
	gcc -m32 -O0 -ffreestanding -c $< -o $@

softclean:
	rm *.bin *.o */*.o

clean: softclean
	rm os-image
