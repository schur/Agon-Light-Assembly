;
; Title:	Hello World - Main
; Author:	Dean Belfield, Reinhard Schu
; Created:	06/11/2022
; Last Updated:	11/12/2022

; define or undefine ADL (24-bit) mode
	#undefine ADL
;	#undefine ADL

#include "../include/init.inc"
#include "../include/helper_functions.asm"

; The main routine
;
MAIN:	        
                LD	HL, HELLO_WORLD
		CALL	PRSTR
                LD      HL,$07
;
;       Test printing Hex numbers
;
		LD	A,$A7
                CALL    Print_Hex8
                PRT_CRLF
                LD      HL,$E39F
                CALL    Print_Hex16
                PRT_CRLF
                LD.L    HL,$6A9BF4
                CALL    Print_Hex24
                PRT_CRLF
                LD      HL,0                    ;return zero to MOS
		RET
	
; Sample text
;
HELLO_WORLD:	.DB	"Hello World\n\r",0
