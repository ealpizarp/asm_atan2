
; ==========Costa Rica Institute of Technology===========
;
; Authors: Eric Alpizar
;		   Rodrigo Espinach
;		   Jimmy Salas
;
; Last date modified: 12/08/2020

include C:\Irvine\Irvine32.inc
include C:\Irvine\macros.inc
includelib C:\Irvine\Irvine32.lib
includelib C:\Irvine\Kernel32.lib
includelib C:\Irvine\user32.lib
BUFFER_SIZE = 5000

;includelib C:\masm32\lib\masm32.lib

;include C:\masm32\include\windows.inc
;include C:\masm32\include\masm32.inc

include ac_atan2.inc
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
prompt_4 BYTE "Cannot create file",0dh, 0ah,0


Q DWORD ?
I DWORD ?
angle DWORD ?


buffer BYTE BUFFER_SIZE DUP (?)
buffer_data DWORD 848 DUP (0)
angle_data DWORD 848 DUP (0)
inFilename BYTE 80 DUP(0)
outFilename BYTE "output.txt",0
fileHandle HANDLE ?
file_size DWORD ?
num_dwords DWORD ?
alternate_state DWORD ?
sec_counter_val DWORD ?

.code

main PROC

xor eax, eax									; eax register is cleaned
mov num_dwords, eax
	

mWrite "Enter and input filename: "				; text in the monitor is written
mov edx, OFFSET inFilename						; the offset of inFilename wich is the name of the file to be opened is moved to edx
mov ecx, SIZEOF inFilename						; the size of inFilename is calculated and moved to ecx
CALL ReadString

mov edx, OFFSET inFilename						; the offset of infilename is moved to edx
call openInputFile								; a procedure is called from irvne32 library wich is in charge of loading the file
mov fileHandle, eax								; the file handler is moved to the file_handler data allocation

cmp eax, INVALID_HANDLE_VALUE					; if there is an error the eax register is equal to INVALID_HANDLE_VALUE constant so we compare it
jne file_ok										; jump is not equal to file_ok label
mWrite<"Cannot open file", 0dh, 0ah>			; if the file has an error then a monitor write is made
jmp quit										; unconditional jump to the quit label

file_ok:

mov edx, OFFSET buffer							; the offset of the buffer is moved to edx
mov ecx, BUFFER_SIZE							; the buffer size constant is moved to ecx
call ReadFromFile								; irvine´s library procedure is called in order to handle the read from file
jnc check_buffer_size							; jump is not carry to check_buffer_size label
mWrite "Error reading file. "					; monitor write an error if the condition above is not met
call WriteWindowsMsg							; a procedure is called in order to write in a window message the error
jmp close_file									; unconditional jump to close file

check_buffer_size:					
cmp eax, BUFFER_SIZE							; compares the actual size of the file to the size of the buffer we previously declared
jb buf_size_ok									; jumps if the size of the file is below the buffer size
mWrite<"Error: Buffer too small for the file", 0dh, 0ah>	; if the file is too big then we write it on console
jmp quit										; unconditional jump to quit label

buf_size_ok:
mov buffer[eax],0								; creates a null terminator for our buffer
mov file_size, eax								; the file_size is stored in eax
mWrite<"File size: ">							; file size is displayed on console
call WriteDec									
CALL Crlf

mWrite<"Buffer:", 0dh, 0ah, 0dh, 0ah>
mov edx, OFFSET buffer							; the offset of the buffer is moved to edx
CALL WriteString						
CALl Crlf

close_file:
mov eax, fileHandle								; the file handler is moved to eax
call CloseFile									; procedure that closes the file




; Parsing of the ASCII codes to Integers

mov edx, OFFSET buffer							; the offset of the buffer is moved to edx

CALL ParseInteger32								; the first intager in the file is parsed
CALL WriteInt									; first integer is written on screen
CALl Crlf										; endline made on screen

push ecx
mov esi, OFFSET buffer							; the offset of the buffer is moved to esi ass well
; ---------DEBUG----------
;mov al, [esi]
;movzx eax, al
;CALL WriteInt
xor ecx, ecx

jmp _add_element								; unconditional jump to add element

_repeat:

mov al, [esi]									; four bits of the memory in the offset is moved to al
cmp al, 59d										; the four bits in al register are compared to the ascii value of the semicolon
je exception									; if the byte being analyzed equals to the ascii value of semicolon then jump to excepction label
cmp al, 10d										; compares al to the ascii value of new_line character
je exception									; if the byte being analyzed equals to the ascii value of a new_line character then jump to exception label

add ecx, 1										; adds to the extended counter register the value of one
add esi, 1										; adds to esi the value of one

cmp ecx, file_size								; compares ecx to the file size
je quit											; if the counter register equals to the file size then jump to the quit label

jmp _repeat

exception:
add ecx, 1										; add to the extended count register the value of one
add edx, ecx									; an adition of edx and ecx is made an stored in edx 
CALL ParseInteger32								; the Irvine´s procedure for parsing intager is called here, this changes the ascii code to integer values
add esi, 1										; adds to extended stack index the value of one
sub edx, ecx									; substraction of edx and ecx is made here
jmp _add_element								; unconditional jump to add element is made here


_add_element:

push ecx										; the ecx register is pushed to the stack
xor ecx, ecx									; the extended counter register is cleaned
xor edi, edi									; the extended destination register is cleaned as well
mov ecx, num_dwords								; num_dwords wich holds the value of the number of dwords analyzed is moved to ecx
mov edi, OFFSET buffer_data						; the offset of the buffer_data array is moved to the edi register
mov [edi + ecx], eax							; the value of eax is assinged  to the offset loication of buffer_data plus the value of the counter register
CALL WriteInt									; a write on screen is made for debug purposes
CALl Crlf										; new_line printed on screen
add ecx, 4										; an addition to ecx is made in order to move to the next element
mov num_dwords, ecx								; the value of the counter register is stored in num_dwords
pop ecx											; the value of ecx is restored
jmp _repeat										; unconditional jump to repeat

; ---------DEBUG----------

;_iterate:

;xor ecx, ecx
;CALL Crlf
;CALL Crlf
;CALL Crlf


;_hello:

;mov edi, OFFSET buffer_data
;mov eax, [edi + ecx]
;CALL WriteInt
;CALl Crlf
;add ecx, 4

;cmp ecx, 584
;je quit

;jmp _hello





quit:


xor ecx, ecx
mov alternate_state, ecx
mov sec_counter_val, ecx
CALL Crlf
CALL Crlf
CALL Crlf


_iterate:

cmp ecx, 585
jge _start

mov edi, OFFSET buffer_data
mov eax, [edi + ecx]

add ecx, 4

mov ebx, alternate_state
cmp ebx, 0
je assign_real
cmp ebx, 1
je assign_imag

jmp _iterate


assign_real:

mov Q, eax
mov alternate_state, 1
jmp _iterate

assign_imag:

mov I, eax
mov eax, Q
mov ebx, I

INVOKE atan2, ADDR angle
mov eax, angle

CALL WriteInt
CALl Crlf

mov alternate_state, 0

jmp _iterate






_start:

mov edx, OFFSET prompt_1

call WriteString
CALL ReadInt
mov Q, eax
xor eax, eax
call Crlf

mov edx, OFFSET prompt_2

call WriteString
CALL ReadInt
mov I, eax


xor eax, eax
xor ebx, ebx

mov eax, Q
mov ebx, I

INVOKE atan2, ADDR angle

mov angle, eax

CALL WriteInt



INVOKE ExitProcess,0

main ENDP

END main