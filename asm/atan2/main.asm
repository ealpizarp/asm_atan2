include C:\Irvine\Irvine32.inc
includelib C:\Irvine\Irvine32.lib
includelib C:\Irvine\Kernel32.lib
includelib C:\Irvine\user32.lib

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

octant BYTE ?

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



	push ebx
	xor eax, eax
	xor ebx, ebx

	mov eax, real_part
	mov ebx, imag_part

	cmp ebx, 0
	jle octant_2
	cmp ebx,eax
	jg octant_2
	mov octant, 1
	jmp _end

	; IF it doesnt work, try clearing flags

	octant_2:

	cmp eax, 0
	jle octant_3
	cmp eax, ebx
	jge octant_3
	mov octant, 2
	jmp _end

	octant_3:
	push eax
	cmp eax, 0
	jns octant_4
	neg eax
	cmp ebx, eax
	jle octant_4
	mov octant, 3
	jmp _end

	octant_4:
							;eax ya viene negado
	cmp ebx, 0
	jle octant_5
	cmp ebx, eax
	jg octant_5
	mov octant, 4
	jmp _end

	octant_5:

	pop eax
	cmp ebx, 0
	jns octant_6
	cmp ebx, eax
	jl octant_6			;en este momento los dos estan negados
	mov octant, 5
	jmp _end

	octant_6:
	cmp eax, 0
	jns octant_7
	push eax
	neg eax
	cmp eax, ebx
	pop eax
	jle octant_7
	mov octant, 6
	
	jmp _end
	
	
	octant_7:
	cmp eax, 0
	jle octant_8
	push ebx
	neg ebx
	cmp eax, ebx
	pop ebx
	jge octant_8
	mov octant, 7
	jmp _end


	octant_8:
	cmp ebx, 0
	jns _end
	neg ebx
	cmp eax, ebx
	jle _end
	mov octant, 8
	neg ebx

	_end:
	; Place code here for clearing all flags

	pop eax
	pop ebx



xor eax, eax
xor ebx, ebx

mov eax, real_part
mov ebx, imag_part

push eax
movzx eax, octant
call WriteInt
call Crlf
pop eax

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


xor eax, eax
xor ebx, ebx

mov eax, numerator
cdq
mov ebx, denominator
idiv ebx
mov theta, eax


mov edx, OFFSET prompt_3
call WriteString
CALL WriteInt














CALL CrLf










 INVOKE ExitProcess,0

main ENDP

; (insertar procesos adicionales aqui)

END main