	;This happens at the start of every frame, when the TV/screen isn't drawing anything. This is the only time when we can update graphics
NMI:
	pha
	txa
	pha
	tya
	pha					;save registers
	
	lda nmi_enabled		;If we've disabled graphics updates, skip all this
	bne @continue
	jmp SkipNMI
	
@continue:
	lda #$00
	sta $2003
	lda #$02
	sta $4014			;update sprites via DMA
	
	;VRAM Updates
	;swap stack pointers
	lda vram_update
	bne @continue2
	jmp UpdateVRAMDone
@continue2:
	tsx
	stx sp_temp
	ldx #0
	txs
	
	;If anything was in our buffer, draw it to the PPU
	;Special thanks to Tokumaru for this code
UpdateVRAM:
	;set output address and jump to byte copy code
	lda $2002
	pla
	sta $2006
	pla
	sta $2006
	rts
	

Copy32Bytes:
	pla
	sta $2007
Copy31Bytes:
	pla
	sta $2007
Copy30Bytes:
	pla
	sta $2007
Copy29Bytes:
	pla
	sta $2007
Copy28Bytes:
	pla
	sta $2007
Copy27Bytes:
	pla
	sta $2007
Copy26Bytes:
	pla
	sta $2007
Copy25Bytes:
	pla
	sta $2007
Copy24Bytes:
	pla
	sta $2007
Copy23Bytes:
	pla
	sta $2007
Copy22Bytes:
	pla
	sta $2007
Copy21Bytes:
	pla
	sta $2007
Copy20Bytes:
	pla
	sta $2007
Copy19Bytes:
	pla
	sta $2007
Copy18Bytes:
	pla
	sta $2007
Copy17Bytes:
	pla
	sta $2007
Copy16Bytes:
	pla
	sta $2007
Copy15Bytes:
	pla
	sta $2007
Copy14Bytes:
	pla
	sta $2007
Copy13Bytes:
	pla
	sta $2007
Copy12Bytes:
	pla
	sta $2007
Copy11Bytes:
	pla
	sta $2007
Copy10Bytes:
	pla
	sta $2007
Copy9Bytes:
	pla
	sta $2007
Copy8Bytes:
	pla
	sta $2007
Copy7Bytes:
	pla
	sta $2007
Copy6Bytes:
	pla
	sta $2007
Copy5Bytes:
	pla
	sta $2007
Copy4Bytes:
	pla
	sta $2007
Copy3Bytes:
	pla
	sta $2007
Copy2Bytes:
	pla
	sta $2007
Copy1Byte:
	pla
	sta $2007
CopyNothing:
	jmp UpdateVRAM
	
	
RestoreSP:
	ldx sp_temp
	txs
	dec vram_update
	lda #0
	sta vram_buffer_pos
UpdateVRAMDone:

	lda $2002
	lda #$00
	sta $2006
	sta $2006
	sta $2005
	sta $2005			;These registers control scrolling, which (As of right now at least) isn't used

	lda #%10010000
	sta $2000
	lda soft_2001
	sta $2001			;Turn the PPU back on
	
SkipNMI:
	inc frame_counter
	
	;randomize the random seed for the next frame
	lda random
	clc
	adc frame_counter
	adc buttons
	;(add any more variables deemed necessary to entropy-ize the random counter better. Don't use too many obviously)
	jsr RandomLFSR			;generate a pseudorandom number each frame
	
	;when making the music engine (which'll likely need to use the temp variables), back up temp0-2, since they'll all be used in the load screen routine, which'll likely take several frames
	lda #1
	sta nmi_bankswitch
	lda #%10000000
	sta $8000			;reset MMC1 (in case there was a bank-switch going on in the main thread)
	lda prg_bank
	pha
	lda #BANK_MUSIC
	;sta prg_bank
	sta $E000
	lsr
	sta $E000
	lsr
	sta $E000
	lsr
	sta $E000
	lsr
	sta $E000
	SoundPlayFrame
	pla
	sta prg_bank
	sta $E000
	lsr
	sta $E000
	lsr
	sta $E000
	lsr
	sta $E000
	lsr
	sta $E000
	
	pla
	tay
	pla
	tax
	pla					;restore the registers
	rti