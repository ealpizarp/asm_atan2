
; ==========Costa Rica Institute of Technology===========
;
; Authors: Eric Alpizar
;		   Rodrigo Espinach
;		   Jimmy Salas
;
; Last date modified: 12/15/2020

include C:\Irvine\Irvine32.inc
include C:\Irvine\macros.inc
includelib C:\Irvine\Irvine32.lib
includelib C:\Irvine\Kernel32.lib
includelib C:\Irvine\user32.lib

include ac_atan2.inc
include octant.inc
include io_functions.inc
include ascii_parsing.inc

.386
.model flat,stdcall
.stack 4096
ExitProcess PROTO, dwExitCode:DWORD

.data

prompt_1 BYTE "Please enter the real part: ", 0												; Prompts are saved
prompt_2 BYTE "Please enter the imaginary part: ", 0
prompt_3 BYTE "The result is: ", 0
prompt_4 BYTE "Cannot create file",0dh, 0ah,0
prompt_5 BYTE "Bytes written to file [output.txt]",0

Q DWORD ?
I DWORD ?
angle DWORD ?


num_special_char DWORD 0
buffer_data DWORD 848 DUP (0)
angle_data DWORD 848 DUP (0)
out_buffer BYTE 1000 DUP(0)
in_file_size DWORD ?
buffer_counter DWORD 0
temp_counter DWORD 0
result BYTE 16 DUP (0)
result_size = ($ - result)
string_lenght DWORD ?
bytes_written DWORD ?

alternate_state DWORD ?
sec_counter_val DWORD ?

.code

main PROC


INVOKE read_values, ADDR buffer_data					; The read values procedure is called 
mov in_file_size, ecx									; the number of coordinates returned by the read_values procedure in ecx is copied to in_file_size data allocation
shl ecx, 2												; a logical shif to the left is done to the ecx register
mov in_file_size, ecx									; the ecx register is stored once again in the in_file_size data allocation

quit:

xor ecx, ecx											; ecx register is cleaned
mov alternate_state, ecx								; the value of ecx is copied to the alternate_state data allocation
mov sec_counter_val, ecx								; the value of ecx is copied to the sec_counter_val data allocation 

_iterate:

cmp ecx, in_file_size									; the counter register is compared to the value of in_file_size allocation
jge _start												; if the counter register is greater or equal to the ecx register then jump to the start

mov edi, OFFSET buffer_data								; moves the offset of buffer_data to the edi register
mov eax, [edi + ecx]									; 32 bits from the value of the offset edi + ecx are read and stored to the eax register

add ecx, 4												; an addition of four is made on the ecx register in becouse 32 bits equals four bytes

mov ebx, alternate_state								; the value of alternate_state allocation is moved to ebx
cmp ebx, 0												; the ebx register is compared to cero
je assign_real											; if the ebx register equals to cero then jump to assign_real label
cmp ebx, 1												; compares ebx to one 
je assign_imag											; if the ebx register equals to one then jump to the assign_imag label

jmp _iterate											; unconditional jump to _iterate label


assign_real:

mov Q, eax												; the eax register is moved to the Q data allocation
mov alternate_state, 1									; the value of one is movoved to the alternate_state data allocation
jmp _iterate											; unconditional jump to the _iterate label

assign_imag:							

mov I, eax												; the value of eax is moved to the I label
mov eax, Q												; the value of Q (real part of the number) is moved to eax
mov ebx, I												; the value of I wich is the imaginary part of the number is moved to ebx

INVOKE atan2, ADDR angle								; the atan2 function is called with the eax= real_part and ebx=imag_part

mov eax, angle											; the angle calculated in atan2 function is passed to eax


push ecx												; the ecx register is pushed to the stack
push eax												; the eax register is pushed to the stack as well


xor edx, edx											; the edx register is cleaned before its usage
mov ecx, buffer_counter									; the value of the buffer_counter data allocation is moved to ecx



mov edx, OFFSET out_buffer								; the offset of the out_buffer data allocation is moved to edx
add edx, ecx											; the counter register is added to the offset of the out_buffer data allocation

xor ecx, ecx											; the counter register is cleaned
INVOKE to_ascii, ADDR result							; procedure to_ascii is called here with eax = number to be converted


mov ebx, OFFSET result									; the offset of the calculated array of bytes (result) is moved to ebx

_repeat_process:

mov al, [ebx]											; 8 bits from the value of the offset ebx are moved to al register
mov [edx], al											; the value of the al register is moved to the value of the offset of edx register
add temp_counter, 1										; an addition of one is made to the temp_counter data allocation
add ebx, 1												; the ebx register is added by one
add edx, 1												; the edx register is added by one as well
cmp temp_counter, ecx									; the counter register is compared to the temp_counter data allocation
je _end_process											; if temp_counter and ecx are the same then jump to the _end_process label

jmp _repeat_process										; unconditional jump to the _repeat_process label

_end_process:

mov temp_counter, 0										; moves to the temp_counter allocation the value of cero

mov buffer_counter, ecx									; the value of ecx register is moved to the buffer_counter data allocation

pop eax													; the eax register is popped from the stack
pop ecx													; the ecx register is popped from the stack as well

mov	alternate_state, 0									; cero is moved to the alternate state data allocation
	
jmp _iterate											; unconditional jump to the _iterate label


_start:

mov al, 0												; moves the value of cero to the al register
mov [edx], al											; the value of al register is copied to the value of the offset that holds the edx register

mov ecx, buffer_counter									; the buffer counter is moved to the ecx register
INVOKE write_values, ADDR out_buffer					; the write_values procedure is called with the respective out_buffer to be written


; ------------DEBUG------------

;mov edx, OFFSET prompt_1

;call WriteString
;CALL ReadInt
;mov Q, eax
;xor eax, eax
;call Crlf

;mov edx, OFFSET prompt_2

;call WriteString
;CALL ReadInt
;mov I, eax


;xor eax, eax
;xor ebx, ebx

;mov eax, Q
;mov ebx, I

;INVOKE atan2, ADDR angle

;mov angle, eax

;CALL WriteInt


program_end:

INVOKE ExitProcess,0

main ENDP

END main