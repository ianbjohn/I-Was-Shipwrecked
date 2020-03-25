WritingMSGInit:
	lda prg_bank
	pha
	lda #2
	sta prg_bank
	jsr SetPRGBank
	;use message index to set up pointer
	ldx message
	;see how many responses the message has
	lda MessageResponses,x
	sta mbox_responses
	txa
	asl
	tax
	lda Messages+0,x
	sta message_ptr+0
	lda Messages+1,x
	sta message_ptr+1
	pla
	sta prg_bank
	jmp SetPRGBank


WritingMsgMain:
	;only draw ents if we're in the play state
	lda in_inventory_state
	bne @skipplaystatestuff
	jsr DrawEnts
@skipplaystatestuff:
	
	lda prg_bank
	pha
	lda #2
	sta prg_bank
	jsr SetPRGBank
@main:
	ldy mbox_pos
	lda (message_ptr),y
	;check if end of message
	cmp #$FF
	bne @checknewline
	;if there are responses, go to the response state
	lda mbox_responses
	bne @responses
	;no responses, read the next byte saying the message index, redraw the message box and go from there
	iny
	lda (message_ptr),y
	sta message
	lda #STATE_DRAWINGMBOX
	sta game_state
	rts
@responses:
	lda #STATE_MBOXRESPONSE
	sta game_state
	pla
	sta prg_bank
	jmp SetPRGBank
@checknewline:
	;check if new line
	cmp #$FE
	bne @checkspace
	;reset X, inc Y
	lda mbox_screen_pos
	and #%11100000
	clc
	adc #%00100000
	sta mbox_screen_pos
	inc mbox_pos
	pla
	sta prg_bank
	jmp SetPRGBank
@checkspace:
	;check if space
	cmp #SPA
	bne @normal
	;just advance the screen position by 1
	inc mbox_screen_pos
	inc mbox_pos
	jmp @main			;save a frame and read what's after the space
@normal:
	;otherwise, data and not code
	sta temp0
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
	lda temp0
	sta vram_buffer,x		;the tile
	inx
	stx vram_buffer_pos
	inc mbox_screen_pos
	inc mbox_pos
	pla
	sta prg_bank
	jmp SetPRGBank