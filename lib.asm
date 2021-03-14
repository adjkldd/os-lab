; al as parameter
print_char:
  pusha
  mov ah, 0x0e
  int 0x10	; al as parameter
  popa
  ret

; bx as parameter
print_string:
 pusha		; save all registers' state
 loop:
  mov al, [bx]
  cmp al, 0
  je loop_done
  call print_char
  add bx, 1
  jmp loop
loop_done:
  ; mov al, 0x0a
  ; call print_char
  ; mov al, 0x0d
  ; call print_char
  popa		; restore all registers' stat
  ret


; load DH sectors to ES:BX from drive DL
disk_load:
  pusha
  mov [SECTORS], dh
next_group:
  mov di, 5
again:
  mov al, [SECTORS]	; Read DH sectors
  mov ah, 0x02	; BIOS read sector function
  mov ch, 0x00	; Select cylinder 0
  mov dh, 0x00	; Select head 0
  mov cl, 0x02	; Start reading from second sector (i.e.
		; after the boot sector)
  int 0x13	; BIOS interrupt

  jc maybe_retry	; Jump if error (i.e. carry flag set)

  cmp [SECTORS], al	; al = count of sectors actually read
  je ready		; dh = expected count of sectors

  add al, 0x30
  call print_char
  sub al, 0x30

  sub [SECTORS], al	; count of remaining sectors to read

  mov cl, 0x01		; read from the first sector
  xor dh, 1		; switch platter surface
  jnz next_group
  inc ch		; next cylinder
  jmp next_group
  
ready:
  popa
  ret

maybe_retry:
  push ax
  mov al, 'x'
  call print_char
  pop ax

  mov ah, 0
  int 0x13
  dec di
  jnz again
  jmp disk_error 

disk_error:

  mov bx, DISK_ERROR_MSG
  call print_string
  jmp $

; Variables
DISK_ERROR_MSG:	db "Disk read error!", 0
SECTORS: db 0
