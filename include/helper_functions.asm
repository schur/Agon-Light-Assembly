;
; Title:	Helper Functions
; Author:	Dean Belfield, Reinhard Schu
; Created:	06/11/2022
; Last Updated:	11/12/2022
;

; Print a zero-terminated string pointed to by HL
;
#MACRO  PRT_CHR
#ifdef ADL
		RST.LIL	$10
#else
		RST	$10
#endif
#ENDMACRO

#MACRO  PRT_CRLF
                LD      A,'\n'
                PRT_CHR
                LD      A,'\r'
                PRT_CHR
#ENDMACRO


PRSTR:		LD	A,(HL)
		OR	A
		RET	Z
                PRT_CHR
		INC	HL
		JR	PRSTR
; Print a zero-terminated string
;
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
