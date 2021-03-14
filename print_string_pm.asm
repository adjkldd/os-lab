[bits 32]
; define some constants

VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0x0f

; prints a null-terminated string pointed to by EBX
; in 32-bit protected mode, screen device is a memory-mapped hardware
print_string_pm:
  pusha
  mov edx, VIDEO_MEMORY		; set edx to the start of video mem
print_string_pm_loop:
  mov al, [ebx]			; store the char at EBX in AL
  mov ah, WHITE_ON_BLACK	; store the attribute in AH

  cmp al, 0
  jz print_string_pm_done

  mov [edx], ax		; store char and attributes at current character cell

  add ebx, 1
  add edx, 2		; mov to next character cell in video mem.
  jmp print_string_pm_loop

print_string_pm_done:
  popa
  ret
  
