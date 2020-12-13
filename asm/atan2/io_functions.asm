include C:\Irvine\Irvine32.inc
include C:\Irvine\macros.inc
includelib C:\Irvine\Irvine32.lib
includelib C:\Irvine\Kernel32.lib
includelib C:\Irvine\user32.lib
BUFFER_SIZE = 5000

.data

buffer BYTE BUFFER_SIZE DUP (?)
filename BYTE 80 DUP(0)
fileHandle HANDLE ?
file_size DWORD ?

.code

read_values PROC:PTR BYTE 80 DUP(0)

mWrite "Enter and input filename: "
mov edx, OFFSET filename
mov ecx, SIZEOF filename
CALL ReadString

mov edx, OFFSET filename
call openInputFile
mov fileHandle, eax

cmp eax, INVALID_HANDLE_VALUE
jne file_ok
mWrite<"Cannot open file", 0dh, 0ah>
jmp quit

file_ok:

mov edx, OFFSET buffer
mov ecx, BUFFER_SIZE
call ReadFromFile
jnc check_buffer_size
mWrite "Error reading file. "
call WriteWindowsMsg
jmp close_file

check_buffer_size:
cmp eax, BUFFER_SIZE
jb buf_size_ok
mWrite<"Error: Buffer too small for the file", 0dh, 0ah>
jmp quit

buf_size_ok:
mov buffer[eax],0
mov file_size, eax
mWrite<"File size: ">
call WriteDec
CALL Crlf

mWrite<"Buffer:", 0dh, 0ah, 0dh, 0ah>
mov edx, OFFSET buffer
CALL WriteString
CALl Crlf

close_file:
mov eax, fileHandle
call CloseFile

RET

ENDP read_values

END

