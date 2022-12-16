;
; Title:	Helper Functions
; Author:	Dean Belfield, Reinhard Schu
; Created:	06/11/2022
; Last Updated:	14/12/2022
;

        #include "../include/helper_macros.inc"

; Print a zero-terminated string
; HL: pointer to string
;
PRSTR:		LD	A,(HL)
		OR	A
		RET	Z
                PRT_CHR
		INC	HL
		JR	PRSTR

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
                