;
; Title:	Checkargs - Main
; Author:	Reinhard Schu
; Created:	12/12/2022
; Last Updated:	20/12/2022

; define or undefine ADL (24-bit) mode
	#undefine ADL
;	#undefine ADL

#include "../include/init.inc"
#include "../include/helper_functions.asm"
#include "../include/mos_api.inc"

; The main routine
;
; Reads arguments from the command line, converts them to hex and prints them
;
MAIN:	        
		LD		B,1			; initialise counter
_main1:
                LD              DE,Buffer1              ; set DE to point to buffer
                CALL            READ_ARG                ; read argument (from HL to DE)
                JR              NC,_noargs              ; exit if no more arguments

		PUSH.LIL	HL			; preserve HL (argument buffer)
		LD		H,D			; LD HL,DF
		LD		L,E
		CALL		AtoI			; Convert, result in DEU
                JR              Z,_invalid		; exit if invalid number

		PUSH.LIL	DE			; LD HL,DE
		POP.LIL		HL
		CALL		Print_Hex24		; Print the number
                PRT_CRLF

		POP.LIL		HL			; recover HL (argument buffer)

		INC		B			; increment number of arguments
                JR              _main1			; loop to next argument

_noargs:	LD		A,1			; if B still 1, then
		CP		B			; no arguments were parsed
		JR		NZ,_main_end

		LD              IX,Nothing		; print nothing was entered
		CALL            PRSTR

_main_end:	LD		HL,0			;return zero to MOS
		RET

_invalid:	POP.LIL		HL			; recover HL (argument buffer)
		LD		HL,19			;return invalid param to MOS
		RET



Nothing:        .DB     "Nothing entered\n\r",0


Buffer1:       
