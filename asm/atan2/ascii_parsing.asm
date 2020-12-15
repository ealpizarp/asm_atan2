; Descripcion del Programa:
; Autor:
; Dia:

include ascii_parsing.inc

.data

is_signed BYTE 0
number DWORD ?
num_bytes DWORD 0

.code

to_ascii PROC result: PTR BYTE

 push edx

 xor ecx, ecx
 mov number, eax

 test eax, eax
 js s_adjustment

 _repeat:

 cdq 
 mov ebx, 10
 idiv ebx
 push dx
 add ecx, 1
 cmp eax, 0
 je _decode_number

 jmp _repeat

 s_adjustment:

 mov is_signed, 1
 neg eax

 jmp _repeat


_decode_number:

mov ebx, result

mov al, is_signed
cmp al, 1
je add_sign
jmp _iterate

add_sign:

mov al, 45
mov [ebx], al
add num_bytes, 1
inc ebx
jmp _iterate


_iterate:

cmp ecx, 0
je _end
pop dx
add dl, 48
mov [ebx], dl
add num_bytes, 1
inc ebx
sub ecx, 1
jmp _iterate


_end:

mov ah, 10
mov [ebx], ah
add num_bytes, 1
mov ecx, num_bytes
pop edx


RET

to_ascii ENDP

END