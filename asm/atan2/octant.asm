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

octant_var DWORD ?

.code

octant PROC

	cmp ebx, 0
	jle octant_2
	cmp ebx,eax
	jg octant_2
	mov octant_var, 1
	jmp _end


octant_2:

	cmp eax, 0
	jle octant_3
	cmp eax, ebx
	jge octant_3
	mov octant_var, 2
	jmp _end

octant_3:

	cmp eax, 0
	jns octant_4
	push eax
	neg eax
	cmp ebx, eax
	pop eax
	jle octant_4
	mov octant_var, 3
	jmp _end

octant_4:

	cmp ebx, 0
	jle octant_5
	push eax
	neg eax
	cmp ebx, eax
	pop eax
	jg octant_5
	mov octant_var, 4
	jmp _end

octant_5:

	cmp ebx, 0
	jns octant_6
	cmp ebx, eax
	jl octant_6
	mov octant_var, 5
	jmp _end

octant_6:

	cmp eax, 0
	jns octant_7
	push eax
	neg eax
	cmp eax, ebx
	pop eax
	jle octant_7
	mov octant_var, 6
	jmp _end
	
	
octant_7:

	cmp eax, 0
	jle octant_8
	push ebx
	neg ebx
	cmp eax, ebx
	pop ebx
	jge octant_8
	mov octant_var, 7
	jmp _end


octant_8:

	cmp ebx, 0
	jns _end
	neg ebx
	cmp eax, ebx
	jle _end
	mov octant_var, 8
	neg ebx

_end:


mov eax, octant_var

RET

octant ENDP

END



