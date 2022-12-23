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
#include "../include/mos_api.inc"

; The main routine
;
MAIN:
                LD.L            HL,$6A9BF4
		LD.L		DE,$ABCDFE

		EX.L		DE,HL

                CALL            Print_Hex24
                PRT_CRLF

                LD              HL,0                    ;return zero to MOS
		RET

