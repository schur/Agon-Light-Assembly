;
; Title:	Hello World - Initialisation Code
; Author:	Dean Belfield
; Created:	06/11/2022
; Last Updated:	06/11/2022
;
; Modinfo:

			.ASSUME	ADL = 1
		
;
; Start in ADL mode
;
			JP		_START		; Jump to start			
;
; The header stuff is from byte 64 onwards
;
            .BLOCK  60
            .DB		"MOS"		; Flag for MOS - to confirm this is a valid MOS command
			.DB		00h		; MOS header version 0
			.DB		01h		; Flag for run mode (0: Z80, 1: ADL)
;
; And the code follows on immediately after the header
;
_START:			EI				; Enable the MOS interrupts
			JP	MAIN			; Start user code
