FadeOutInit:
	lda in_cave_new
	cmp #1
	bne @silence
	lda in_cave
	cmp #1
	bne @silence
	rts
@silence
	ldy #SILENCE
	jsr PlaySound

	
FadeOutMain:
	;Standard "Naive" way of fading out - every 15 frames decrease the brightness of the colors, until they're black
	;if (++fadeout_timer >= 15)
		;if (++fadeout_state < 8)
			;for each palette byte
				;if (palette byte & 0xF0 >= (0x30 - (fadeout_state << 4)))
					;palette_byte -= fadeout_state << 4;
				;else
					;palette_byte = 0x0F;
		;else
			;game_state = STATE_LOADINGSCREEN;
	jsr DrawEnts
	lda fadeout_timer
	clc
	adc #1
	cmp #15
	bcs @continue
	jmp @done
@continue:
	lda fadeout_state
	clc
	adc #1
	cmp #8
	bcc @fade
	jmp @loadscreen
@fade:
	sta fadeout_state
	asl
	asl
	asl
	asl
	sta temp0
	lda #$30
	sec
	sbc temp0
	sta temp1
	ldx vram_buffer_pos
	lda #$3F
	sta vram_buffer+0,x
	lda #$00
	sta vram_buffer+1,x
	lda #<(Copy32Bytes-1)
	sta vram_buffer+2,x
	lda #>(Copy32Bytes-1)
	sta vram_buffer+3,x
	ldy #0
@fadeloop:
	lda palette_buffer,y
	and #%11110000
	cmp temp0
	bcs @continue1
	lda #$0F				;palette_buffer,y
	jmp @store
@continue1:
	lda palette_buffer,y
	sec
	sbc temp0
	sta palette_buffer,y
@store:
	sta vram_buffer+4,x
	inx
	iny
	cpy #32
	bne @fadeloop
	txa
	clc
	adc #4
	sta vram_buffer_pos
	lda #0
	beq @done
@loadscreen:
	lda #STATE_LOADINGSCREEN
	sta game_state
@done2:
	lda #0
	sta fadeout_state
@done:
	sta fadeout_timer
	rts