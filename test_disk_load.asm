[org 0x7c00]

  mov bx, 0x1000	; buffer address pointer
  ; mov dl, 0x80	; boot drive, 0x80 first hark disk
  mov ch, 0	; cylinder
  mov dh, 0	; head
  mov cl, 2	; sector
next_group:
  mov di, 5
 again:
  mov ah, 0x02	; function id, read sectors from drive
  mov al, [SECTORS]	; sectors to read count

  ; debug
  add al, 0x30
  call print_char
  sub al, 0x30

  int 0x13
  jc maybe_retry

  sub [SECTORS], al
  ; call print_char
  jz ready

  ; mov cl, 0x01	; from the first sector
  ; xor dh, 1	; dh = 0 or 1, switch side of platter surface
  ; jnz next_group
  ; inc ch	; next cylinder
  ; jmp next_group

maybe_retry:
  mov ah, 0x00	; reset disk drive
  int 0x13
  dec di
  jnz again
  jmp disk_error
  
ready:
  jmp $

disk_error:
  mov al, 'E'
  call print_char
  jmp $

print_char:
  push ax
  mov ah, 0x0e
  int 0x10
  pop ax
  ret

BOOT_DRIVE:
  db 0
SECTORS:
  db 2

times 510-($-$$) db 0
dw 0xaa55

; the 2nd sector
times 256 dw 0xABCD
; the 3rd sector
times 256 dw 0xFACE
