
  mov al, 'L'
  call print_char

  jmp $

%include "lib.asm"

times 510-($-$$) db 0

dw 0xaa55
