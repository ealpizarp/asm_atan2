; ==========Costa Rica Institute of Technology===========
; Authors: Eric Alpizar
;		   Rodrigo Espinach
;		   Jimmy Salas
; Last date modified: 12/15/2020



;-----------------------------------------------------------------------------
; ASCII_PARSING PROC
; Converts an integer to the equivalent number with ascii codes and adds
; a newline character at the end.
; Recieves: result:PTR BYTE = the pointer of an array of bytes with the size of 16
;			eax = number to be converted
; Returns:	The equivalent number in an array of bytes in the array of bytes passed by parameter
;			number of bytes used to represent that number with ascii codes in eax
;-----------------------------------------------------------------------------
include ascii_parsing.inc

.data

is_signed BYTE 0
number DWORD ?
num_bytes DWORD 0

.code

to_ascii PROC result: PTR BYTE

 push edx								; The edx register is pushed to the stack

 xor ecx, ecx							; the counter register is cleaned
 mov number, eax						; eax register wich contains the number to be converted is moved to the number data allocation

 test eax, eax							; the number in eax is tested with itself
 js s_adjustment						; jumps to s_adjustemnt label if the number is not signed

 _repeat:

 cdq									; an extention of eax into edx is made in order to have enough dynamic range
 mov ebx, 10							; the divisor is moved to ebx
 idiv ebx								; a division of the number in eax with the value of ebx is made
 push dx								; dx register is pushed to the stack
 add ecx, 1								; An addition of one is made to the ecx register
 cmp eax, 0								; compares if the number is equal to cero

 je _decode_number						; if the number equals to cero then jump to the decode_number label

 jmp _repeat							; unconditional jump to repeat label

 s_adjustment:

 mov is_signed, 1						; the value of one is added to is_signed data allocation
 neg eax								; the sign bit of eax is changed or negated

 jmp _repeat							; unconditional jump to repeat label


_decode_number:

mov ebx, result							; the result pointer wich is the offset is moved to ebx

mov al, is_signed						; the value of is_signed byte allocation is moved to al
cmp al, 1								; compares value of al to 1
je add_sign								; if it equals to 1 then jump to the add_sign label
jmp _iterate							; unconditional jump to _iterate label

add_sign:

mov al, 45								; the value of 45 is moved to the al register
mov [ebx], al							; al is moved to the value of the offset in ebx
add num_bytes, 1						; an addition is made to the num_bytes allocation
inc ebx									; the ebx register is incremented
jmp _iterate							; unconditional jump to _iterate


_iterate:

cmp ecx, 0								; compares the counter register to cero
je _end									; jumps if the ecx register is equal to cero to the _end label
pop dx									; the dx register is popped from the stack
add dl, 48								; the number 48 is added to the value of dl register
mov [ebx], dl							; the value of the dl register is moved to the address of ebx
add num_bytes, 1						; an addition is made to the num_bytes allocation
inc ebx									; the ebx register is incremented
sub ecx, 1								; a substraction of 1 is made to the counter register
jmp _iterate							; unconditional jump to the _iterate label


_end:

mov ah, 10								; the value of 10 is moved to eax (10 is the ascii code for new_line)
mov [ebx], ah							; the value of ah register is moved to the value of the offset in ebx
add num_bytes, 1						; an addition of one is made to num_bytes
mov ecx, num_bytes						; the num_bytes are moved to the ecx register
pop edx									; the edx register is popped from the stack

RET

to_ascii ENDP

END