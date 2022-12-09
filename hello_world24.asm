;
; Title:	Hello World - Main
; Author:	Dean Belfield
; Created:	06/11/2022
; Last Updated:	06/11/2022
;
; Modinfo:

			.ASSUME	ADL = 1				

#include "init.asm"

; The main routine
;
MAIN:		LD	HL, HELLO_WORLD
			CALL	PRSTR
            LD	HL, 0
            RET.L
	
; Print a zero-terminated string
;
PRSTR:		LD	A,(HL)
			OR	A
			RET	Z
			RST.LIL	10h
			INC	HL
			JR	PRSTR

; Sample text
;
HELLO_WORLD:		.DB 	"Hello World\n\r",0

