;
; Title:	Stacktest
; Author:	Reinhard Schu
; Created:	06/11/2022
; Last Updated:	17/12/2022

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
;       PUSH and POP values to the SPS and SPL and report the SPS and SPL values
;

		LD		IX,text1	; print info message
		CALL		PRSTR
		LD		A,MB		; load MB
		CALL		Print_Hex8	; and print
		PRT_CRLF
		PRT_CRLF

		CALL		PRTSP		; print SPS and SPL

                LD              IX,text3	; print info message
                CALL            PRSTR
                LD              IX,text4	
                CALL            PRSTR
		LD		A,$27		; ASCII code for '
		PRT_CHR
                PRT_CRLF

		PUSH		DE		; push DE to SPS

		CALL		PRTSP		; print SPS and SPL

                LD		IX,text3	; print info message
                CALL		PRSTR
                LD		IX,text4
                CALL		PRSTR
                LD		IX,text6
                CALL		PRSTR
		PRT_CHR
                PRT_CRLF

		PUSH.LIS	DE		; push DE to SPL

		CALL		PRTSP		; print SPS and SPL

                LD              IX,text3	; print info message
                CALL            PRSTR
                LD              IX,text5	
                CALL            PRSTR
		LD		A,$27		; ASCII code for '
		PRT_CHR
                PRT_CRLF

		POP		DE		; retrieve DE from SPS

		CALL		PRTSP		; print SPS and SPL

                LD		IX,text3	; print info message
                CALL		PRSTR
                LD		IX,text5
                CALL		PRSTR
                LD		IX,text6
                CALL		PRSTR
		PRT_CHR
                PRT_CRLF

		POP.LIS		DE		; retrieve DE from SPL

		CALL		PRTSP		; print SPS and SPL

		LD		HL,0		; return zero to MOS
		RET
	
; print SP and SPL
;
PRTSP:		LD		IX,text2
		LD		(IX+2),'S'	; modify text2 to say "SPS"
		CALL		PRSTR
		LD		HL,0		; load SPS into HL
		ADD		HL,SP
		CALL		Print_Hex16	; and print
		PRT_CRLF

		LD		IX,text2
		LD		(IX+2),'L'	; modify text2 to say "SPL"
		CALL		PRSTR
		LD.LIL		HL,0		; load SPL into HL
		ADD.LIL		HL,SP
		CALL		Print_Hex24	; and print
		PRT_CRLF
		PRT_CRLF

		RET

; text output
;
text1:          .DB             "MB: ",0
text2:          .DB             "SPx: ",0
text3:          .DB             "Executing 'P",0
text4:          .DB             "USH",0
text5:          .DB             "OP",0
text6:		.DB		".LIS'",0
