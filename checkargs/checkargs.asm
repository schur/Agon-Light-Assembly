;
; Title:	Checkargs - Main
; Author:	Reinhard Schu
; Created:	12/12/2022
; Last Updated:	12/12/2022

; define or undefine ADL (24-bit) mode
	#undefine ADL
;	#undefine ADL

#include "../include/init.inc"
#include "../include/helper_functions.asm"
#include "../include/mos_api.inc"

; The main routine
;
; Reads up to 2 arguments from the command line, strips whitespaces and prints the arguments
;
MAIN:	        
                LD              IX,You_entered          ; print message
                CALL            PRSTR

		LD		B,1			; initialise counter
_main1:
                LD              DE,Buffer1              ; set DE to point to buffer
                CALL            READ_ARG                ; read argument (from HL to DE)
                JR              NC,_noargs               ; exit if no arguments

                LD              IX,Arg                  ; print message
                CALL            PRSTR
                LD              A,B			; B is the count of arguments 
		CALL		Print_Hex8		; print it
                LD              A,':'
                PRT_CHR
                LD              A,' '
                PRT_CHR
                LD              IXH,D			; Print argument in Buffer DE
                LD              IXL,E
                CALL            PRSTR
                PRT_CRLF

		INC		B			; increment number of arguments
                JR              _main1			; loop to next argument

_noargs:	LD		A,1			; if B still 1, then
		CP		B			; no arguments were parsed
		JR		NZ,_main_end

		LD              IX,Nothing		; print nothing was entered
		CALL            PRSTR

_main_end:	LD		HL,0			;return zero to MOS
		RET


You_entered:    .DB     "You entered:\n\r",0
Nothing:        .DB     "Nothing\n\r",0
Arg:            .DB     "Argument ",0


Buffer1:       
