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
;
;       Test printing Hex numbers
;

                LD              HL,text1
                CALL            PRSTR
                LD              A,MB
                CALL            Print_Hex8
                PRT_CRLF
                
                LD              HL,text2
                CALL            PRSTR
                LD              HL,0
                ADD             HL,SP
                CALL            Print_Hex16
                PRT_CRLF
                PRT_CRLF

                LD              HL,text3
                CALL            PRSTR
                LD              A,'S'
                PRT_CHR
                PRT_CRLF

                LD              HL,text2
                CALL            PRSTR
                LD              HL,0
                ADD             HL,SP
                CALL            Print_Hex16
                PRT_CRLF



                PUSH.LIS        DE
                LD              HL,text2
                CALL            PRSTR
                LD              HL,0
                ADD             HL,SP
                CALL            Print_Hex16
                PRT_CRLF

                PUSH            DE
                LD              HL,text2
                CALL            PRSTR
                LD              HL,0
                ADD             HL,SP
                CALL            Print_Hex16
                PRT_CRLF

                POP             DE
                LD              HL,text2
                CALL            PRSTR
                LD              HL,0
                ADD             HL,SP
                CALL            Print_Hex16
                PRT_CRLF

                POP.LIS         DE
                LD              HL,text2
                CALL            PRSTR
                LD              HL,0
                ADD             HL,SP
                CALL            Print_Hex16
                PRT_CRLF

                


                LD              HL,0                    ;return zero to MOS
		RET
	
; Sample text
;
text1:          .DB             "MB is: ",0
text2:          .DB             "SPS is: ",0
text3:          .DB             "Pushing DE to SP",0
