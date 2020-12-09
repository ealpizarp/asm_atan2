
; ==========Costa Rica Institute of Technology===========
;
; Authors: Eric Alpizar
;		   Rodrigo Espinach
;		   Jimmy Salas
;
; Last date modified: 12/08/2020

include C:\Irvine\Irvine32.inc
includelib C:\Irvine\Irvine32.lib
includelib C:\Irvine\Kernel32.lib
includelib C:\Irvine\user32.lib
include octant.inc

; Descripcion del Programa:
; Autor:
; Dia:

.386
.model flat,stdcall
.stack 4096
ExitProcess PROTO, dwExitCode:DWORD

.data

prompt_1 BYTE "Please enter the real part: ", 0												; Prompts are saved
prompt_2 BYTE "Please enter the imaginary part: ", 0
prompt_3 BYTE "The result is: ", 0

real_part DWORD ?
imag_part DWORD ?
theta DWORD ?

numerator DWORD ?

imag_square DWORD ?

real_square DWORD ?

half_pi DWORD 51472
pi DWORD 102944 

real_two_right_bitshift DWORD ?
imag_two_right_bitshift DWORD ?
real_five_right_bitshift DWORD ?
imag_five_right_bitshift  DWORD ?

denominator DWORD ?
alternate_denominator DWORD ?



;declarar variables aqui

.code

main PROC
 ; Escribir codigo aqui 





mov edx, OFFSET prompt_1

call WriteString
CALL ReadInt
mov real_part, eax
xor eax, eax
call Crlf

mov edx, OFFSET prompt_2

call WriteString
CALL ReadInt
mov imag_part, eax



					



xor eax, eax
xor ebx, ebx

mov eax, real_part
mov ebx, imag_part


push eax

imul ebx								;Imul esta mal utilizado! cambiar esto
mov numerator, eax						;Assign to the numerator the multiplication of Q * I

pop eax

push eax

xor ebx, ebx							;the eax and ebx registers are cleaned
xor eax, eax
mov eax, imag_part
mov ebx, eax
imul ebx
mov imag_square, eax

pop eax
push eax

mov ebx, eax
imul ebx

mov real_square, eax
push eax

sar eax, 2
mov real_two_right_bitshift, eax

pop eax
sar eax, 5
mov real_five_right_bitshift, eax


xor eax, eax
xor ebx, ebx


mov ebx, imag_square
push ebx

sar ebx, 2
mov imag_two_right_bitshift, ebx

pop ebx

sar ebx, 5
mov imag_five_right_bitshift, ebx




xor eax, eax
mov eax, real_square
add eax, imag_two_right_bitshift
add eax, imag_five_right_bitshift
sar eax, 15 
mov denominator, eax

xor eax, eax 

mov eax, imag_square
add eax, real_two_right_bitshift
add eax, real_five_right_bitshift
sar eax, 15
mov alternate_denominator, eax



xor eax, eax				;Both registers eax and ebx are cleaned 
xor ebx, ebx
mov eax, real_part			;The real part of the number is moved to eax
mov ebx, imag_part			;The imaginary part is moved to ebx

INVOKE octant				;Octant procedure is called with eax = real_part and ebx = imag_part


cmp eax, 2
je second_third
cmp eax, 3
je second_third
jmp next

second_third:

xor eax, eax
xor ebx, ebx
mov eax, numerator
cdq
mov ebx, alternate_denominator
idiv ebx
mov theta, eax
xor eax, eax
mov eax, half_pi
sub eax, theta
mov theta, eax

jmp adjustment

next:

cmp eax, 6
je six_seven
cmp eax, 7
je six_seven

jmp other_octants

six_seven:

xor eax, eax
xor ebx, ebx
mov eax, numerator
cdq
mov ebx, alternate_denominator
idiv ebx
mov theta, eax
xor eax, eax
mov eax, half_pi
neg eax
sub eax, theta
mov theta, eax

jmp end_if

; OCTANTS 1 AND 8
other_octants:

xor eax, eax
xor ebx, ebx

mov eax, numerator
cdq
mov ebx, denominator
idiv ebx
mov theta, eax


adjustment:

xor eax, eax
xor ebx, ebx
mov eax, real_part
mov ebx, imag_part

cmp ebx, 0
jl second_condition
cmp eax, 0
jge second_condition
mov eax, theta
add eax, pi
mov theta, eax
jmp end_if

second_condition:

cmp ebx, 0
jge third_condition
cmp eax, 0
jge third_condition
mov eax, theta
sub eax, pi
mov theta, eax
jmp end_if

third_condition:

cmp ebx, 0
jle fourth_condition
cmp eax,0
jne fourth_condition
xor eax, eax
mov eax, half_pi
mov theta, eax
jmp end_if

fourth_condition:

cmp ebx, 0
jge end_if
cmp eax,0
jne end_if
xor eax, eax
mov eax, half_pi
neg eax
mov theta, eax

end_if:

mov edx, OFFSET prompt_3
call WriteString

xor eax, eax
mov eax, theta
CALL WriteInt














CALL CrLf










 INVOKE ExitProcess,0

main ENDP

; (insertar procesos adicionales aqui)

END main