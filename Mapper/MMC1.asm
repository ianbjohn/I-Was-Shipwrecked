SetPRGBank:
	sta prg_bank		;A should be loaded with the bank to be switched in
	sta $E000
	lsr
	sta $E000
	lsr
	sta $E000
	lsr
	sta $E000
	lsr
	sta $E000
	;make sure the switch wasn't corrupted by NMI code
	lda nmi_bankswitch
	beq @done
	dec nmi_bankswitch
	lda #%10000000
	sta $8000
	lda prg_bank
	sta $E000
	lsr
	sta $E000
	lsr
	sta $E000
	lsr
	sta $E000
	lsr
	sta $E000
@done:
	rts