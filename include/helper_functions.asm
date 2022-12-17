;
; Title:	Helper Functions
; Author:	Dean Belfield, Reinhard Schu
; Created:	06/11/2022
; Last Updated:	17/12/2022
;

        #include "../include/helper_macros.inc"

; Print a zero-terminated string
; IX: pointer to string
; destroys: IX, A
;
PRSTR:		LD		A,(IX)
		OR		A	
		RET		Z		; finish if zero
                PRT_CHR
		INC		IX
		JR		PRSTR		; loop around to next byte

; Print a 24-bit HEX number
; HLU: Number to print
;
Print_Hex24:	PUSH.LIL	HL
		LD.LIL		HL, 2
		ADD.LIL		HL, SP
		LD.LIL		A, (HL)
		POP.LIL		HL
		CALL		Print_Hex8			
			
; Print a 16-bit HEX number
; HL: Number to print
;
Print_Hex16:	LD	A,H
		CALL	Print_Hex8
		LD	A,L

; Print an 8-bit HEX number
; A: Number to print
;
Print_Hex8:	LD	C,A
		RRA 
		RRA 
		RRA 
		RRA 
		CALL	prtnbl 
		LD	A,C 
prtnbl:		AND	0Fh
		ADD	A,90h
		DAA
		ADC	A,40h
		DAA
		PRT_CHR
		RET

; Skip whitespaces
; HL: Pointer in string buffer
; 
SKIPSP:		LD.LIL		A, (HL)
		CP      	' '
		RET     	NZ
		INC.LIL		HL
		JR      	SKIPSP


; Read next argument from buffer 
; Inputs:   HL: Pointer in string buffer
;           DE: Pointer to Buffer where to copy argument
; Outputs:  HL: Updated pointer in string buffer
;           DE: Pointer to Buffer argument was copied to (preserved from input)
;            F: Carry set if argument read, otherwise reset
; Destroys: A,H,L,F;
; 

READ_ARG:	CALL		SKIPSP			; Skip whitespace
		LD.LIL		A,(HL)			; Read first character
		OR		A			; Check for end of string
		RET		Z			; Return with no carry if not
		PUSH    	DE			; Preserve DE

READ_ARG1:      LD.LIL		A,(HL)			; Fetch the character
                OR              A                       ; Check for end of string
                JR              Z,READ_ARG4             ; end of argument, finish
                CP              ' '                     ; if whitespace
                JR              Z,READ_ARG4             ; end of argument, finish
                LD              (DE),A                  ; store the character
		INC.LIL		HL			; next charcater 
                INC     	DE
                JR              READ_ARG1

READ_ARG4:	XOR             A
                LD              (DE),A                  ; terminate output buffer
                POP		DE 	                ; restore DE
		SCF					; We have a valid argument so set carry
		RET

; Read a number and convert to binary
; If prefixed with $, will read as hex, otherwise decimal
;   Inputs: HL: Pointer in string buffer
;  Outputs: DE: Value (24-bit)
;            F: Carry set if valid number, otherwise reset
; Destroys: A,D,E,H,L,F
;
AtoI:		PUSH.LIL	BC			; Preserve BC
		LD		A,(HL)			; Read first character
		OR		A			; Check for end of string
		JR 		Z, _AtoI_invalid	; Return with no carry if no input
		LD.LIL		DE,0			; Initialise DE
		CP		'$'			; Is it prefixed with '$' (HEX number)?
		JR		NZ, _AtoI3		; Jump to decimal parser if not
		INC		HL			; Otherwise fall through to ASC_TO_HEX
;
_AtoI1:		LD		A,(HL)			; Fetch the character
		OR		A			; Check for end of string
		JR		Z,_AtoI_valid 
		CALL   	 	UPPRC			; Convert to uppercase  
		SUB		'0'			; Normalise to 0
		JR 		C, _AtoI_invalid	; Return if < ASCII '0' (out of range)
		CP 		10			; Check if >= 10
		JR 		C, _AtoI2		; No, so skip next bit
		SUB 		7			; Adjust ASCII A-F to nibble
		CP 		16			; Check for > F
		JR 		NC, _AtoI_invalid	; Return if out of range
;
_AtoI2:		PUSH		HL			; Stack HL
		PUSH.LIL	DE			; LD HL, DE
		POP.LIL		HL
		ADD.LIL		HL, HL			; RXS: times 4? why not shift left?
		ADD.LIL		HL, HL	
		ADD.LIL		HL, HL	
		ADD.LIL		HL, HL	
		PUSH.LIL	HL			; LD DE, HL
		POP.LIL		DE
		POP		HL			; Restore HL			
		OR      	E			; OR the new digit in to the least significant nibble
		LD      	E, A
;			
		INC		HL			; Onto the next character
		JR      	_AtoI1			; And loop
;
_AtoI3:		LD		A, (HL)			; Fetch the character
		OR		A			; Check for end of string
		JR		Z,_AtoI_valid 
		SUB		'0'			; Normalise to 0
		JR		C, _AtoI_invalid	; Return if < ASCII '0'
		CP		10			; Check if >= 10
		JR		NC, _AtoI_invalid	; Return if >= 10
;
		PUSH		HL			; Stack HL
		PUSH.LIL	DE			; LD HL, DE
		POP.LIL		HL
		PUSH.LIL	HL			; LD BC, HL
		POP.LIL		BC
		ADD.LIL		HL, HL 			; x 2 
		ADD.LIL		HL, HL 			; x 4
		ADD.LIL		HL, BC 			; x 5
		ADD.LIL		HL, HL 			; x 10
		LD.LIL		BC, 0
		LD 		C, A			; LD BCU, A
		ADD.LIL		HL, BC			; Add BCU to HL
		PUSH.LIL	HL			; LD DE, HL
		POP.LIL		DE
		POP		HL			; Restore HL
;						
		INC		HL			; Onto the next character
		JR		_AtoI3			; And loop

_AtoI_invalid:	SCF
		CCF					; We have invalid input so clear carry
		JR		_AtoI6
_AtoI_valid:	SCF
_AtoI6:		POP.LIL		BC			; recover BC
		RET

; Convert a character to upper case
;  A: Character to convert
;
UPPRC:  	AND     	7FH
		CP      	'`'
		RET     	C
		AND     	5FH			; Convert to upper case
		RET
