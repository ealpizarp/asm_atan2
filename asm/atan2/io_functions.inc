; ==========Costa Rica Institute of Technology===========
; Authors: Eric Alpizar
;		   Rodrigo Espinach
;		   Jimmy Salas
; Last date modified: 11/13/2020

.NOLIST

.model flat,STDCALL
.stack 4096
.386

read_values PROTO:PTR DWORD

write_values PROTO:PTR BYTE

.LIST