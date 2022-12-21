;
; Title:	Memory Dump - Main
; Author:	Dean Belfield
; Ported to spasm-ng: Reinhard Schu
; Created:	15/11/2022
; Last Updated:	20/12/2022
;
; define or undefine ADL (24-bit) mode
; this program will run as a MOS command, so we use 16-bit mode
	#undefine ADL

#include "../include/init.inc"
#include "../include/helper_functions.asm"
#include "../include/mos_api.inc"



_variables:	.DL	$040000		; start address (default $40000)
		.DL	256		; number of bytes to print (default 256)

; The main routine
; HLU: Address to parameters in string buffer (or 0 if no parameters)
; Returns:
;  HL: Error code
;
MAIN:		LD		IX,_variables		; use IX to address variables in RAM
		PUSH.LIL	IX			; push lower 16-bit of _variables address 
		LD		A,MB			; fetch MB register (upper byte of address page we are running in)
		LD.LIL		IY,0
		ADD.LIL		IY,SP
		LD.LIL		(IY+2),A		; write MB to upper byte on stack
		POP.LIL		IX			; retrieve full 24-bit address of _variables into IXU
		PUSH.LIL	IX			; preserve IXU for later

		LD		B,2			; execute loop 2 times

_main1:		LD		DE,Buffer		; set DE to point to buffer
		CALL		READ_ARG		; read argument (from HL to DE)
		JR		NC,_main2		; if no argument read, jump ahead 

		PUSH.LIL	HL			; preserve HL (argument buffer)
		EX		DE,HL			; move DE (ptr to string) to HL (input for AtoI)
		CALL		AtoI			; Convert, result in DEU
		POP.LIL		HL			; recover HL (argument buffer)
		JR		Z,_invalid		; exit if invalid number
		LD.LIL		(IX),DE			; save argument
		LEA.LIL		IX,IX+3			; advance IX to next argument

		DJNZ		_main1			; loop

_main2:		
		POP.LIL		IX			; recover full 24-bit variable address
		LD.LIL		HL,(IX)			; load start address
		LD.LIL		DE,(IX+3)		; load number of bytes
		CALL		Memory_Dump			
		LD		HL, 0			; Return with OK
		RET

; Error: Invalid parameter
;
_invalid:	POP.LIL		IX			; readjust SPL stack
		LD		HL,19			; return invalid param to MOS
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
			LD		IX, Buffer
			CALL		PRSTR
			RET
		
; RAM
; 
Buffer:
