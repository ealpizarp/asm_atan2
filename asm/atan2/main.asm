
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
include atan2.inc
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

Q DWORD ?
I DWORD ?
angle DWORD ?


.code

main PROC

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

INVOKE atan2

mov angle, eax

CALL WriteInt


INVOKE ExitProcess,0

main ENDP

; (insertar procesos adicionales aqui)

END main