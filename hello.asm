[org 0x7c00]
  mov bx, HELLO_MSG
  call print_string

  mov bx, GOODBYE_MSG
  call print_string

  jmp $		; Hang

%include "lib.asm"

HELLO_MSG:
  db 'hello, world!', 0x0a, 0x0d, 0

GOODBYE_MSG:
  db 'goodbye!', 0x0a, 0x0d, 0

times 510-($-$$) db 0
dw 0xaa55
