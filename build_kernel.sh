#!/bin/sh

# exit on error
set -e

# cross-compiled compiler
# https://wiki.osdev.org/GCC_Cross-Compiler for downloading Prebuilt Toolchains
GCC='/home/ldd/os/i386-elf-7.5.0-Linux-x86_64/bin/i386-elf-gcc'
LD='/home/ldd/os/i386-elf-7.5.0-Linux-x86_64/bin/i386-elf-ld'

$GCC -ffreestanding -c kernel.c -o kernel.o
$GCC -ffreestanding -c util.c -o util.o
$GCC -ffreestanding -c screen.c -o screen.o
$GCC -ffreestanding -c low_level.c -o low_level.o

nasm kernel_entry.asm -f elf -o kernel_entry.o

# for debugging
# strip '--oformat binary' for disassembing (objdump -D kernel.bin)
# $LD -o kernel.bin -Ttext 0x1000 kernel_entry.o kernel.o --oformat binary
$LD -o kernel.bin -Ttext 0x1000 kernel_entry.o util.o low_level.o screen.o kernel.o --oformat binary

kernel_size_in_bytes=`stat -c %s kernel.bin`

N=`expr $kernel_size_in_bytes / 512 + 1`


sed -i "s/KERNEL_SIZE_IN_SECTOR equ.*/KERNEL_SIZE_IN_SECTOR equ $N/g" boot_kernel.asm
nasm boot_kernel.asm -f bin -o boot_kernel.bin

echo "times $N*512-$kernel_size_in_bytes db 0" > padding.asm
nasm padding.asm -f bin -o padding.bin

cat boot_kernel.bin kernel.bin padding.bin > os-image

# qemu-system-x86_64 also works
qemu-system-i386 os-image
