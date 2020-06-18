DrawingMBoxInit:
	;Originally, when a message needed to be drawn, the status board would be cleareed one blank tile at a time
	;What we do instead now is send all 90 of these blank tiles to the VRAM buffer in one go, so the whole board get's cleared at once, and the message is ready to be drawn typewriter-style next frame
	;This speeds the text up significantly, and just looks better overall. So don't let the now-misnomerous name confuse you

	;First, we need to set everything up
	lda #0
	sta mbox_screen_pos
	sta mbox_pos
	sta mbox_responses
	sta message_response

	;only draw ents if we were in the play state
	lda in_inventory_state
	bne @skipplaystatestuff
	jsr DrawEnts
@skipplaystatestuff:

	;Our buffer system is designed to only handle 32 bytes/tiles in one pass, so we'll have to do this 3 times to copy all 3 rows
	ldx vram_buffer_pos
	lda #>MBOX_START		;VRAM system and PPU both use big-endian for addresses
	sta vram_buffer,x
	lda #<MBOX_START
	sta vram_buffer+1,x
	lda #<(Copy30Bytes-1)
	sta vram_buffer+2,x
	lda #>(Copy30Bytes-1)
	sta vram_buffer+3,x
	ldy #30
	lda #SPA
@loop1:
	sta vram_buffer+4,x
	inx
	dey
	bne @loop1

	lda #>(MBOX_START + 32)
	sta vram_buffer+4,x
	lda #<(MBOX_START + 32)
	sta vram_buffer+5,x
	lda #<(Copy30Bytes-1)
	sta vram_buffer+6,x
	lda #>(Copy30Bytes-1)
	sta vram_buffer+7,x
	ldy #30
	lda #SPA
@loop2:
	sta vram_buffer+8,x
	inx
	dey
	bne @loop2

	lda #>(MBOX_START + 64)
	sta vram_buffer+8,x
	lda #<(MBOX_START + 64)
	sta vram_buffer+9,x
	lda #<(Copy30Bytes-1)
	sta vram_buffer+10,x
	lda #>(Copy30Bytes-1)
	sta vram_buffer+11,x
	ldy #30
	lda #SPA
@loop3:
	sta vram_buffer+12,x
	inx
	dey
	bne @loop3
	txa
	clc
	adc #12
	sta vram_buffer_pos


DrawingMBoxMain:
	;Now that the cleared status board has been sent to the VRAM buffer, we can change the state and start drawing our message on the next frame
	lda #STATE_WRITINGMSG
	sta game_state
	rts