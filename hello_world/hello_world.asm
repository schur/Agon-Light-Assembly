;
; Title:	Hello World - Main
; Author:	Dean Belfield, Reinhard Schu
; Created:	06/11/2022
; Last Updated:	09/12/2022

; define or undefine ADL (24-bit) mode
	#define ADL
;	#undefine ADL

#include "../include/init.asm"
#include "../include/helper_functions.asm"

; The main routine
;
MAIN:	        LD	HL, HELLO_WORLD
		CALL	PRSTR
		LD	HL, 0
		RET
	
; Sample text
;
HELLO_WORLD:	.DB	"Hello World\n\r",0

