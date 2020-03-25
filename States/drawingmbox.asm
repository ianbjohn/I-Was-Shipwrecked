DrawingMBoxInit:
ErasingMBoxInit:
	lda #0
	sta mbox_screen_pos
	sta mbox_pos
	sta mbox_responses
	sta message_response
	rts


DrawingMBoxMain:
	;only draw ents if we were in the play state
	lda in_inventory_state
	bne @skipplaystatestuff
	jsr DrawEnts
@skipplaystatestuff:

	;90 tiles need to be replaced with blank ones. These get loaded into the VRAM buffer, along with where on the screen they should be drawn,
		;and are then drawn next vblank
	;mbox_screen_pos is reset when the message is erased, should be at 0 when starting
	;-
	;mbox_screen_pos is used a bit strangely. The low 5 bytes represent the X position (in tiles, 0-30), while the high 3 bytes represent the Y position (0-2)
	;once the the low 5 bytes reach 30, the high 3 bytes are incremented and the low 5 bytes are reset to 0. Once the high 3 bytes are 3, the message box has been drawn.
	lda mbox_screen_pos
	and #%00011111
	cmp #30
	bne @continue		;no new line
	lda mbox_screen_pos
	and #%11100000		;reset X position to 0
	clc
	adc #%00100000		;inc Y position
	sta mbox_screen_pos
	cmp #%01100000
	bne @continue		;message box still not fully drawn
	;time to draw the message
	ldy #0
	sty mbox_screen_pos
	sty mbox_pos			;skip over the first byte since we already know the type
	lda #STATE_WRITINGMSG
	sta game_state
	rts
@continue:
	;manipulate mbox_screen_pos to get the right PPU address of what to send to the VRAM buffer
	;the address for the buffer is big endian, so the high byte (Always $20 here) is sent first
	;low byte is all that needs to be changed
	ldx vram_buffer_pos
	lda #>MBOX_START
	sta vram_buffer,x
	inx
	lda mbox_screen_pos
	clc
	adc #<MBOX_START
	sta vram_buffer,x
	inx
	lda #<(Copy1Byte-1)
	sta vram_buffer,x
	inx
	lda #>(Copy1Byte-1)
	sta vram_buffer,x
	inx
	;here, the tile is always blank, so this can be hard-coded as well
	lda #SPA
	sta vram_buffer,x
	inx
	stx vram_buffer_pos
	inc mbox_screen_pos
	rts