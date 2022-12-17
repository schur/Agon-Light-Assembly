;
; Title:	Memory Dump - Parsing Functions
; Author:	Dean Belfield
; Ported to spasm-ng: Reinhard Schu
; Created:	15/11/2022
; Last Updated:	11/12/2022
;
				
; Read a number and convert to binary
; If prefixed with &, will read as hex, otherwise decimal
;   Inputs: HL: Pointer in string buffer
;  Outputs: HL: Updated text pointer
;           DE: Value
;            A: Terminator (spaces skipped)
;            F: Carry set if valid number, otherwise reset
; Destroys: A,D,E,H,L,F
;
ASC_TO_NUMBER:	LD.LIL		DE, 0			; Initialise DE
		CALL		SKIPSP			; Skip whitespace
		LD.LIL		A, (HL)			; Read first character
		OR		A			; Check for end of string
		RET		Z			; Return with no carry if not
		PUSH.LIL	BC			; Preserve BC
		CP		'&'			; Is it prefixed with '&' (HEX number)?
		JR		NZ, ASC_TO_NUMBER3	; Jump to decimal parser if not
		INC.LIL		HL			; Otherwise fall through to ASC_TO_HEX
;
ASC_TO_NUMBER1:	LD.LIL		A, (HL)			; Fetch the character
		CALL   	 	UPPRC			; Convert to uppercase  
		SUB		'0'			; Normalise to 0
		JR 		C, ASC_TO_NUMBER4	; Return if < ASCII '0'
		CP 		10			; Check if >= 10
		JR 		C, ASC_TO_NUMBER2	; No, so skip next bit
		SUB 		7			; Adjust ASCII A-F to nibble
		CP 		16			; Check for > F
		JR 		NC, ASC_TO_NUMBER4	; Return if out of range
;
ASC_TO_NUMBER2:	PUSH.LIL	HL			; Stack HL
		PUSH.LIL	DE			; LD HL, DE
		POP.LIL		HL
		ADD.LIL		HL, HL	
		ADD.LIL		HL, HL	
		ADD.LIL		HL, HL	
		ADD.LIL		HL, HL	
		PUSH.LIL	HL			; LD DE, HL
		POP.LIL		DE
		POP.LIL		HL			; Restore HL			
		OR      	E			; OR the new digit in to the least significant nibble
		LD      	E, A
;			
		INC.LIL		HL			; Onto the next character
		JR      	ASC_TO_NUMBER1		; And loop
;
ASC_TO_NUMBER3:	LD.LIL		A, (HL)
		SUB		'0'			; Normalise to 0
		JR		C, ASC_TO_NUMBER4	; Return if < ASCII '0'
		CP		10			; Check if >= 10
		JR		NC, ASC_TO_NUMBER4	; Return if >= 10
;
		PUSH.LIL	HL			; Stack HL
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
		POP.LIL		HL			; Restore HL
;						
		INC.LIL		HL
		JR		ASC_TO_NUMBER3
ASC_TO_NUMBER4:	POP.LIL		BC 			
		SCF					; We have a valid number so set carry
		RET

