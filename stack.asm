mov ah, 0x0e
mov al, 'A'
int 0x10

mov bp, 0x8000
mov sp, bp

push 'A'
push 'B'
push 'C'

pop bx

mov al, bl
int 0x10	; 'C'

mov al, [bp-2]	; 16-bit mode
int 0x10	; 'A'

pop bx

mov al, bl
int 0x10	; 'B'

jmp $

times 510 - ($-$$) db 0

dw 0xaa55
