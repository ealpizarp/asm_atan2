; ==========Costa Rica Institute of Technology===========
; Authors: Eric Alpizar
;		   Rodrigo Espinach
;		   Jimmy Salas
; Last date modified: 11/13/2020

.NOLIST

.model flat,STDCALL
.stack 4096
.386

octant PROTO 

read_values PROTO:PTR BYTE 80 DUP(0)

.LIST