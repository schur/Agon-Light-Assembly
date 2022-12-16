;
; Title:	Helper Macros
; Author:	Reinhard Schu
; Created:	13/12/2022
; Last Updated:	13/12/2022
;

; Print character in A
;
#MACRO  PRT_CHR
#ifdef ADL
		RST.LIL	$10
#else
		RST	$10
#endif
#ENDMACRO

; Print LF+CR
;
#MACRO  PRT_CRLF
                LD      A,'\n'
                PRT_CHR
                LD      A,'\r'
                PRT_CHR
#ENDMACRO

