;
; Title:	Basic Routines
; Author:	Dean Belfield, Reinhard Schu
; Created:	06/11/2022
; Last Updated:	10/12/2022
;

; Print a zero-terminated string pointed to by HL
;
PRSTR:		LD	A,(HL)
		OR	A
		RET	Z
#ifdef ADL
		RST.LIL	$10
#else
		RST	$10
#endif
		INC	HL
		JR	PRSTR
