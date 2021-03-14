; al as parameter
alpha_to_ascii:
  sub al, 0x0a
  add al, 0x61
  ret

; al as parameter
number_to_ascii:
  add al, 0x30
  ret

; print the value of DX as hex
print_hex:
  pusha
  mov cx, dx		; save DX
  and dl, 0x0f		; get lower 4 bit
  mov al, dl		; set al parameter
  mov dx, cx		; restore DX
  cmp al, 0x0a		; compare with 10
  jge _a1		; >= 10 thus it's an alpha
  call number_to_ascii  ; else it's a number
  jmp _a2
_a1:
  call alpha_to_ascii
_a2:
  mov byte [HEX_OUT+5], al	; store at loc

  shr dx, 4		; shift right 4 bits
  mov cx, dx		; save DX
  and dl, 0x0f
  mov al, dl
  mov dx, cx
  cmp al, 0x0a
  jge _a3
  call number_to_ascii 
  jmp _a4
_a3:
  call alpha_to_ascii
_a4:
  mov byte [HEX_OUT+4], al

  shr dx, 4
  mov cx, dx
  and dl, 0x0f
  mov al, dl
  mov dx, cx
  cmp al, 0x0a
  jge _a5
  call number_to_ascii 
  jmp _a6
_a5:
  call alpha_to_ascii
_a6:
  mov byte [HEX_OUT+3], al

  shr dx, 4
  mov cx, dx
  and dl, 0x0f
  mov al, dl
  mov dx, cx
  cmp al, 0x0a
  jge _a7
  call number_to_ascii 
  jmp _a8
_a7:
  call alpha_to_ascii
_a8:
  mov byte [HEX_OUT+2], al

  mov bx, HEX_OUT
  call print_string
  popa
  ret

; global variables
HEX_OUT: db '0x0000', 0

