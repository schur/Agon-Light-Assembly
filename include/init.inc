;
; Title:	Initialisation Code
; Author:	Dean Belfield, Reinhard Schu
; Created:	06/11/2022
; Last Updated:	09/12/2022
;
#ifdef ADL
		; Start in ADL mode
		.ASSUME	ADL = 1
		; Set Code location to $40000 (MOS default user RAM)
		.ORG $40000
#else
		.ASSUME	ADL = 0
		; Set Code location to $0000 (as we are in 16-bit mode)
		.ORG $0000
#endif
		JR		_START		; Jump to start
		.BLOCK	6

#ifdef ADL
		; if in ADL (24-bit) mode, fill; with 0 up to byte $40 (MOS header)
		.BLOCK $38
#else
		; set RST vectors if in Z80 compatibility (16-bit) mode
		; which will call the "real" RST vector

RST_08:		RST.LIS	08h		; API call
		RET
		.BLOCK	5
			
RST_10:		RST.LIS	10h		; Output
		RET
		.BLOCK	5
			
RST_18:		.BLOCK	8
RST_20:		.BLOCK	8
RST_28:		.BLOCK	8
RST_30:		.BLOCK	8	
;	
; The NMI interrupt vector (not currently used by AGON)
;
RST_38:		EI
		RETI
		.BLOCK  5
#endif

; The header stuff is from byte $40 onwards

                .DB	"MOS"	; Flag for MOS - to confirm this is a valid MOS command
		.DB	0		; MOS header version 0
#ifdef ADL
		.DB	1		; Flag for run mode (0: Z80, 1: ADL)
#else
		.DB	0
#endif
;
; And the code follows on immediately after the header
;
_START:		EI				; Enable the MOS interrupts
		CALL	MAIN	; Start user Code
#ifdef ADL
		RET
#else
		RET.L
#endif
