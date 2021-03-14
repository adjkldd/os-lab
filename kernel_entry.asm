; nasm kernel_entry.asm -f elf64 -o kernel_entry.o
; ld -o kernel.bin -Ttext 0x1000 kernel_entry.o kernel.o --oformat binary
; Ensures that we jump straight into the kernel’s entry function.
[bits 32]       ; We’re in protected mode by now, so use 32-bit instructions.
[extern main]   ; Declate that we will be referencing the external symbol ’main’,
                ; so the linker can substitute the final address

call main       ; invoke main() in our C kernel
jmp $           ; Hang forever when we return from the kernel
