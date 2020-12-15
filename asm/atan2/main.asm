
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

;includelib C:\masm32\lib\masm32.lib

;include C:\masm32\include\windows.inc
;include C:\masm32\include\masm32.inc

include ac_atan2.inc
include octant.inc
include io_functions.inc
include ascii_parsing.inc

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
prompt_5 BYTE "Bytes written to file [output.txt]",0

Q DWORD ?
I DWORD ?
angle DWORD ?



buffer_data DWORD 848 DUP (0)
angle_data DWORD 848 DUP (0)
out_buffer BYTE 1000 DUP(0)
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

INVOKE read_values, ADDR buffer_data


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

cmp ecx, 584
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


push ecx
push eax


xor edx, edx
mov ecx, buffer_counter



mov edx, OFFSET out_buffer
add edx, ecx

xor ecx, ecx
INVOKE to_ascii, ADDR result


mov ebx, OFFSET result

_repeat_process:

mov al, [ebx]
mov [edx], al
add temp_counter, 1
add ebx, 1
add edx, 1
cmp temp_counter, ecx
je _end_process

jmp _repeat_process

_end_process:


mov temp_counter, 0

mov buffer_counter, ecx

pop eax
pop ecx

mov alternate_state, 0

jmp _iterate


_start:


add edx, buffer_counter
CALL WriteString
mov al, 0
mov [edx], al
mov edx, OFFSET out_buffer
CALL WriteString

;--------CREATE FILE-----------

mov edx, OFFSET out_buffer
CALL WriteString

mov ecx, buffer_counter
INVOKE write_values, ADDR out_buffer





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


program_end:

INVOKE ExitProcess,0

main ENDP

END main