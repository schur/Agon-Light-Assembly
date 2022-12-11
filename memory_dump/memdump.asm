;
; Title:	Memory Dump - Main
; Author:	Dean Belfield
; Ported to spasm-ng: Reinhard Schu
; Created:	15/11/2022
; Last Updated:	11/12/2022
;
; define or undefine ADL (24-bit) mode
; this program will run as a MOS command, so we use 16-bit mode
	#undefine ADL

#include "../include/init.inc"
#include "../include/helper_functions.asm"
#include "../include/mos_api.inc"
#include "parse.asm"


; Error: Invalid parameter
;
ERR_INVALID_PARAM:	LD		HL, 19
			RET

; The main routine
; HLU: Address to parameters in string buffer (or 0 if no parameters)
; Returns:
;  HL: Error code
;
MAIN:			CALL		ASC_TO_NUMBER		; Fetch the first parameter
			JR		NC, ERR_INVALID_PARAM
			PUSH.LIL	DE
			CALL		ASC_TO_NUMBER		; Fetch the second parameter
			POP.LIL		HL
			JR		C, main1			
			LD.LIL		DE, 256			; Default value if not specified
main1:			CALL		Memory_Dump			
			LD		HL, 0			; Return with OK
			RET
			
; Memory Dump
; HLU: Start of memory to dump
; DE:  Number of bytes to dump out
;
Memory_Dump:		CALL		Print_Hex24
			LD		A, ':'
			PRT_CHR
			LD		A, ' '
			PRT_CHR
			LD		B, 16
			LD		IX, Buffer
			LD		(IX+0), ' '
;			
Memory_Dump_1:		LD.LIL		A, (HL)
			PUSH		AF
			CP		' '
			JR		NC, Memory_Dump_2
			LD		A, '.'
;			
Memory_Dump_2:		LD		(IX+1), A
			INC		IX
			POP		AF
			CALL		Print_Hex8
			INC.LIL		HL
			DEC		DE
			LD		A, D
			OR		E
			JR		Z, Memory_Dump_3
			DJNZ		Memory_Dump_1
			CALL		Memory_Dump_5			
			MOSCALL(mos_getkey)		; Check for ESC
			CP		1Bh
			JR 		NZ, Memory_Dump
			RET
			
Memory_Dump_3:		LD		A, B
			OR		A
			JR		Z, Memory_Dump_5
			DEC		B
			JR		Z, Memory_Dump_5
			LD		A, ' '
;
Memory_Dump_4:		PRT_CHR
			PRT_CHR
			DJNZ		Memory_Dump_4
;
Memory_Dump_5:		LD		(IX+1),0Dh
			LD		(IX+2),0Ah
			LD		(IX+3),00h
			PUSH.LIL	HL
			LD		HL, Buffer
			CALL		PRSTR
			POP.LIL		HL
			RET
		
; RAM
; 
			
Buffer:			.BLOCK	256
			