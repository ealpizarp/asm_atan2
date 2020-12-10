; ==========Costa Rica Institute of Technology===========
; Authors: Eric Alpizar
;		   Rodrigo Espinach
;		   Jimmy Salas
; Last date modified: 12/08/2020



;-----------------------------------------------------------------------------
; OCTANT PROC
; Calculates the octant of a number with two given coordinates (x and y) 
; Recieves: 
;			eax = number real part (x)
;			ebx = number imaginary part (y)
;
; Returns:	The octant in wich the number is located
;-----------------------------------------------------------------------------

include octant.inc

.data

octant_var DWORD ?					; A 32 bit octant data allocation for the resulting octant

.code



octant PROC

	mov octant_var, 0				; moves a cero value to the octant_var memory allocation
	cmp eax, 0						; compares eax register to 0
	je _end							; if this register equals to cero then jump to the end
	cmp ebx, 0						; compares ebx to cero
	je _end							; if ebx is equal to cero then jump to the end

	jmp octant_1					; unconditional jump to octant_1 label

octant_1:

	cmp ebx, 0						; compares ebx to cero
	jle octant_2					; if ebx (imaginary part) less or equal to cero then jump to octant 2
	cmp ebx,eax						; compares ebx and eax 
	jg octant_2						; if ebx wich is the imaginary part is greater than the real part (ebx) then jump to octant_2 label
	mov octant_var, 1				; if none of conditions above are met then assign  a one to octant var
	jmp _end						; unconditional jump to the end


octant_2:

	cmp eax, 0						; compares eax to cero 
	jle octant_3					; jump if eax is less or equal to cero
	cmp eax, ebx					; compares imaginary part with real part 
	jge octant_3					; jump if real part (eax) is greater or equal to cero
	mov octant_var, 2				; if none of the conditions above are met then assign a two to octant_var
	jmp _end						; makes an unconditional jump to the end

octant_3:

	cmp eax, 0						; compares real part to cero
	jns octant_4					; jumps to octant_4 is not cero
	push eax						; a backup the register eax is made
	neg eax							; the sigh bit of eax is changed
	cmp ebx, eax					; the imaginary and real part are compared
	pop eax							; the value of eax is restored
	jle octant_4					; if the imaginary part is less or equal to -real_part then jump to octant_4
	mov octant_var, 3				; if none of the conditions above are met then move 3 to octant_var
	jmp _end						; jump to the end

octant_4:

	cmp ebx, 0						; compares imaginary part to cero
	jle octant_5					; if ebx is less or equal to cero then jump to octant_5
	push eax						; backup the eax register
	neg eax							; change the sign bit of eax
	cmp ebx, eax					; compares the imaginary part to the real part (ebx and eax)
	pop eax							; restore the value of eax
	jg octant_5						; if the imaginary part is greater than the real part then jump to octant 5
	mov octant_var, 4				; if none of the above conditions are met then assign a 5 to octant_var
	jmp _end						; makes an unconditional jump to the end

octant_5:

	cmp ebx, 0						; compares the imaginary part to cero 
	jns octant_6					; jumps if ebx is not equal to cero
	cmp ebx, eax					; compares the imaginary part with the real part 
	jl octant_6						; if the imaginary part is less than the real part then jump to octant_6 label
	mov octant_var, 5				; if none of the conditions above are met then assign a 5 to octant_var
	jmp _end						; makes an unconditional jump to the end

octant_6:

	cmp eax, 0						; compares real part to cero
	jns octant_7					; jumps if real_part is not equal to cero 
	push eax						; the eax register is backed up
	neg eax							; the sign bit of eax is changed
	cmp eax, ebx					; compares the real part with the imaginary part (eax and ebx)
	pop eax							; the eax register is restored
	jle octant_7					; jumps to octqant 7 if the real part is less or equal than the imaginary part
	mov octant_var, 6				; if none of the conditions above are met then number 6 is moved to octant_var
	jmp _end						; unconditional jump to the end
	
	
octant_7:

	cmp eax, 0						; compares eax to cero
	jle octant_8					; if the real part is less or equal to cero then jump to octant_8
	push ebx						; the imaginary part register is backed up
	neg ebx							; ebx register is negated
	cmp eax, ebx					; compares the real part with the imaginary part
	pop ebx							; the ebx register is restored by popping out from the stack
	jge octant_8					; if the real part is greater or equal than the imaginary part then jump to octant_8 label
	mov octant_var, 7				; assignes to octant_var a value of seven
	jmp _end						; unconditional jump to the end


octant_8:

	cmp ebx, 0						; compares the ebx register to cero
	jns _end						; if ebx (imaginary part) is not signed then jumps to the end
	neg ebx							; the sign bit of ebx is changed
	cmp eax, ebx					; compares the real part with the imaginary part 
	jle _end						; if the real_part is less or equal to the imaginary part then jump to the end
	mov octant_var, 8				; if none of the conditions above are met, the assign a value of 8 to the octant_var data allocation
	neg ebx							; the sign bit of ebx is changed once again

_end:

mov eax, octant_var					; the value of the data allocation that determines the octant of the number is moved to eax register

RET

octant ENDP

END



