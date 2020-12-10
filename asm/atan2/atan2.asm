; ==========Costa Rica Institute of Technology===========
; Authors: Eric Alpizar
;		   Rodrigo Espinach
;		   Jimmy Salas
; Last date modified: 12/08/2020



;-----------------------------------------------------------------------------
; OCTANT PROC
; Calculates the multiplication of to given 8 bit numbers
; Recieves: 
;			eax = number real part
;			ebx = number imaginary part
; Returns:	The octant in wich the comlex number is located
;-----------------------------------------------------------------------------

include octant.inc

.data

real_part DWORD ?						; DWORD (32bit) data allocations are instantiated for real and imaginary numbers
imag_part DWORD ?
theta DWORD ?							; the resulting angle is gint to be stored in theta

numerator DWORD ?						; data allocation for the numerator used in our formula
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


.code

atan2 PROC

mov real_part, eax						;The real part of the number is moved to eax
mov imag_part, ebx						;The imaginary part is moved to ebx
mov theta, 0

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

jmp end_if

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
cmp ebx, 0
je adjustment
idiv ebx
mov theta, eax


adjustment:

xor eax, eax
xor ebx, ebx
OR AL, 1
CLC
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

xor eax, eax
mov eax, theta

RET

atan2 ENDP

; (insertar procesos adicionales aqui)

END