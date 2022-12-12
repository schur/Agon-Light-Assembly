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
                PUSH.LIL        HL                      ; preserve HL
                LD              HL,You_entered          ; print message
                CALL            PRSTR
                POP.LIL         HL                      ; recall HL

                LD              DE,Buffer1              ; set DE to point to buffer
                CALL            READ_ARG                ; read argument
                JR              NC,noargs               ; exit if no arguments

                PUSH.LIL        HL                      ; preserve HL
                LD              HL,Arg                  ; print message
                CALL            PRSTR
                LD              A,'1'
                PRT_CHR
                LD              A,':'
                PRT_CHR
                LD              A,' '
                PRT_CHR
                LD              H,D                     ; Print argument in Buffer DE
                LD              L,E
                CALL            PRSTR
                PRT_CRLF

                POP.LIL         HL                      ; recall HL
                LD              DE,Buffer1
                CALL            READ_ARG                ; read next argument
                JR              NC,main_end             ; no more arguments, finish
                LD              HL,Arg
                CALL            PRSTR
                LD              A,'2'
                PRT_CHR
                LD              A,':'
                PRT_CHR
                LD              A,' '
                PRT_CHR
                LD              H,D                     ; Print argument in Buffer DE
                LD              L,E
                CALL            PRSTR
                PRT_CRLF

                JR              main_end

noargs:         LD              HL,Nothing
                CALL            PRSTR

main_end:       LD              HL,0                    ;return zero to MOS
		RET


You_entered:    .DB     "You entered:\n\r",0
Nothing:        .DB     "Nothing\n\r",0
Arg:            .DB     "Argument ",0


Buffer1:       
