; ==========Costa Rica Institute of Technology===========
; Authors: Eric Alpizar
;		   Rodrigo Espinach
;		   Jimmy Salas
; Last date modified: 12/09/2020



;-----------------------------------------------------------------------------
; ATAN2 PROC
; Calculates angle with the coordinates of a given imaginary number
; Recieves: 
;			eax = number real part
;			ebx = number imaginary part
; Returns:	The angle in Q15 fixed point representation
;-----------------------------------------------------------------------------

include octant.inc

.data

real_part DWORD ?						; DWORD (32bit) data allocations are instantiated for real and imaginary numbers
imag_part DWORD ?
theta DWORD ?							; the resulting angle is gint to be stored in theta

numerator DWORD ?						; data allocation for the numerator used in our formula
imag_square DWORD ?
real_square DWORD ?

half_pi DWORD 51472						; The value of half pi in Q15 representation is stored here
pi DWORD 102944							; same representation here but for the whole pi

real_two_right_bitshift DWORD ?			; All four data allocations instantiaded here are for the formula required to make calculation
imag_two_right_bitshift DWORD ?
real_five_right_bitshift DWORD ?
imag_five_right_bitshift  DWORD ?

denominator DWORD ?						; 32 bit allocation data allocation for the denominator as well
alternate_denominator DWORD ?			; this one contains a variation of the denominator for certain cases 


.code

atan2 PROC angle:PTR DWORD

mov real_part, eax						;The real part of the number is moved to eax
mov imag_part, ebx						;The imaginary part is moved to ebx
mov theta, 0

push eax								;eax register is pushed to the stack

imul ebx								;Imul esta mal utilizado! cambiar esto
mov numerator, eax						;Assign to the numerator the multiplication of Q * I

pop eax									; eax register is poped from the stack

push eax								; the same push-pop operations are used constantly to backup and restore the value of eax

xor ebx, ebx							;the eax and ebx registers are cleaned
xor eax, eax
mov eax, imag_part						; imaginary part of the numeber is moved to eax
mov ebx, eax							; the values of eax is moved to ebx in order to multiply
imul ebx								; the square of the imaginary part is calculated here
mov imag_square, eax					; the result is stored in the imag_square data allocation

pop eax									; the value of eax is restored

mov ebx, eax							; the same process of lines 62-64 is applied here
imul ebx
mov real_square, eax
push eax

sar eax, 2								; the square of the real_part is shifted to the right by two
mov real_two_right_bitshift, eax		; the result is moved to the propper data aloocation

pop eax									; original value of the square of the real_part is restored
sar eax, 5								; arithmetic shift to the right by 5 time wich is 2^-5
mov real_five_right_bitshift, eax		; result is moved to the corresponding data allocation


xor eax, eax							; the eax and ebx registers are cleaned
xor ebx, ebx


mov ebx, imag_square					; the imaginary part square is moved to ebx
push ebx

sar ebx, 2								; arithmetic shift to the right by 2 is applied here
mov imag_two_right_bitshift, ebx		; result is saved

pop ebx

sar ebx, 5								; similar process of lines 76-78 but this time with the imaginary part
mov imag_five_right_bitshift, ebx		




xor eax, eax							; eax register is cleaned
mov eax, real_square					; the real_square is moved to eax
add eax, imag_two_right_bitshift		; the imaginary square right shifted to the right two times is added to eax
add eax, imag_five_right_bitshift		; same process as above but with the imaginary square shifted to the right five times
sar eax, 15								; the result of all operation above is shifted to the right 15 times
mov denominator, eax					; the result for the first denominator is stored
										; demonimator = ((real_part)^2 + ((imag_part)^2 >> 2) + ((imag_part)^2 >> 5)) >> 15



xor eax, eax							; the eax register is cleaned
	
mov eax, imag_square					; the imaginary part square is moved to eax
add eax, real_two_right_bitshift		; real_part square shifted to the right two times is added to eax
add eax, real_five_right_bitshift		; the real_part square shifted five time to the right is added to eax as well
sar eax, 15								; the result of all operations above are shifted to the right 15 times
mov alternate_denominator, eax			; value of eax is stored in the alternate denominator
										; demonimator = ((imag_part)^2 + ((real_part)^2 >> 2) + ((real_part)^2 >> 5)) >> 15



xor eax, eax							; Both registers eax and ebx are cleaned 
xor ebx, ebx
mov eax, real_part						; The real part of the number is moved to eax
mov ebx, imag_part						; The imaginary part is moved to ebx

INVOKE octant							; Octant procedure is called with eax = real_part and ebx = imag_part

cmp eax, 2								; compares the octant of the number in eax to 2
je second_third							; if the octant is 2 jump to second third label
cmp eax, 3								; compares eax to three
je second_third							; if eax equals to three then jump to the second_third label
jmp next								; if none of conditions avobe are met then jump to the next segment 

second_third:

	xor eax, eax						; both eax anb ebx registers are cleaned
	xor ebx, ebx
	mov eax, numerator					; numerator is moved to eax
	cdq									; eax double word is converted to qword in order to have enough dynamic range in our division
	mov ebx, alternate_denominator		; alternate denominator is moved to ebx
	idiv ebx							; a signed integer division is applyed here (eax/ebx)
	mov theta, eax						; the result of this operation is moved to theta
	xor eax, eax						; register eax is cleaned again
	mov eax, half_pi					; half pi in Q15 fixed point representation in moved to eax
	sub eax, theta						; theta is substracted from eax
	mov theta, eax						; the result is stored in theta

	jmp end_if							; jump to the end

next:

	cmp eax, 6							; compares the value of eax to six
	je six_seven						; if eax equals to six then jump to the six_seven label
	cmp eax, 7							; compares the value of eax to seven
	je six_seven						; jump to six_seven label if eax equals to seven

	jmp other_octants					; if none of conditions above are met, then jump to other_octants label

six_seven:

	xor eax, eax						; the eax and ebx registers are cleaned
	xor ebx, ebx
	mov eax, numerator					; the value of numerator is moved to eax
	cdq									; eax double word is converted to qword in order to have enough dynamic range in our division
	mov ebx, alternate_denominator		; the divisor wich is in the alternate denominator data allocation is moved to ebx 
	idiv ebx							; a intager division is applied
	mov theta, eax						; the result of this division is stored in theta
	xor eax, eax						; eax register is cleaned
	mov eax, half_pi					; fixed point Q15 half_pi representation in moved to eax
	neg eax								; the value of eax is negated
	sub eax, theta						; theta is substracted from eax
	mov theta, eax						; the result is stored in theta

	jmp end_if							; jump to the end


; OCTANTS 1 AND 8

other_octants:

xor eax, eax							; the eax and ebx registers are cleaned once again
xor ebx, ebx

mov eax, numerator						; numerator value is moved to eax
cdq										; eax double word is converted to qword in order to have enough dynamic range in our division
mov ebx, denominator					; the normal denominator is moved to ebx
cmp ebx, 0								; compare ebx to 0
je adjustment							; if ebx equals to cero jump to the adjustment label, this is done to prevent undefined division
idiv ebx								; performs a signed integer division (eax/ebx)
mov theta, eax							; the result of these operations is stored in theta


adjustment:

xor eax, eax							; registers are cleaned again
xor ebx, ebx
OR AL, 1								; flags are cleared
CLC
mov eax, real_part						; the real_part of the number is moved to eax
mov ebx, imag_part						; the imaginary part of the number is moved to ebx

cmp ebx, 0								; compares ebx to cero
jl second_condition						; if ebx is less than cero then jump to secod_condition label
cmp eax, 0								; eax register is compared to cero
jge second_condition					; if eax os greater or equal to cero then jump to second_condition label
mov eax, theta							; theta is moved to eax
add eax, pi								; the Q15 fixed point pi is added to eax
mov theta, eax							; result is stored in theta
jmp end_if								; jump to the end

second_condition:

cmp ebx, 0								; compared ebx to cero
jge third_condition						; jumps to third_condition label if ebx is greater or equal to cero
cmp eax, 0								; eax is compared to cero
jge third_condition						; same condition as in line 213
mov eax, theta							; if none of the conditions above are met, then theta is moved to eax
sub eax, pi								; the value of pi is substracted to eax
mov theta, eax							; result is stored in theta
jmp end_if								; jumps to the end

third_condition:

cmp ebx, 0								; ebx registed is compared to cero
jle fourth_condition					; if ebx is less or equal than cero then jump to the fourth condition label
cmp eax,0								; compares eax to cero
jne fourth_condition					; if eax is not equal to cero then jump to fourth condition label
xor eax, eax							; eax register is cleaned
mov eax, half_pi						; half_pi fixed Q15 representation in moved to eax
mov theta, eax							; the value of eax is moved to theta
jmp end_if								; jumps to the end

fourth_condition:

cmp ebx, 0								; compares ebx to cero
jge end_if								; if ebx is greater or equal than cero then jump to the end
cmp eax,0								; compare eax to cero
jne end_if								; if eax is not eauql to cero then jump to the end
xor eax, eax							; eax register is cleaned
mov eax, half_pi						; the fixed representation of half_pi is moved to eax
neg eax									; value of eax is negated (sign bit is changed)
mov theta, eax							; the value of eax register is moved to theta

end_if:			

xor eax, eax							; eax register is cleaned
mov eax, theta							; theta is moved to eax 
mov esi, angle
mov DWORD PTR [esi], eax

RET

atan2 ENDP

END