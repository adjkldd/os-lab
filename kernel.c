/**
 * gcc -ffreestanding -c kernel.c -o kernel.o
 *
 * # tell the linker that the origin of our code once loaded into memory will be 0x1000,
 * # so it knows to offset local address references from this origin, just like we use
 * # [org 0x7c00] in boot sector code. 
 *
 * ld -o kernel.bin -Ttext 0x1000 kernel.o --oformat binary
 */
#include "screen.h"
void main() {
  // char* video_memory = (char *)0xb8000;
  // *((char *)0xb8000) = 'A';
  // *((char *)0xb8001) = 0x0f;
  // *((char *)0xb8002) = 'B';
  // *((char *)0xb8003) = 0x0f;
  // *((int*)0xb8000)=0x07690748;
  // index to video_memory only works with i386-elf-gcc compiler
  // video_memory[4] = 'C';
  // video_memory[5] = 0x0f;

  clear_screen();
  print("Hello World");
  print_at("http://a.ldd.cool", 32, 12);
}
