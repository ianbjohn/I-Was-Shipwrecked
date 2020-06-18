PausedInit:
	lda #0
	sta stream_status+0
	sta stream_status+1
	sta stream_status+2
	sta stream_status+3	;silence all the BGM channels
	sta stream_status+4
	lda #59				;this is the count down for the pause jingle. Once this gets to 0, the sound will be silenced, and the user will be allowed to unpause
	sta pause_jingle_timer
	ldy #SFX_PAUSE
	jsr PlaySound


PausedMain:
	jsr DrawEnts
	
	;wait for select or start button to be pressed to resume game
Paused_CheckExit:
	lda pause_jingle_timer		;play the pause jingle. Let the player unpause once it's done
	beq @nopause
	dec pause_jingle_timer
	bne @done
	SoundDisable
@done:
	rts
	
@nopause:
	lda buttons_pressed
	and #(BUTTONS_SELECT | BUTTONS_START)
	beq Paused_CheckExitDone
	
	;go back to play state, but DON'T re-initialize it
	lda #STATE_PLAY
	sta game_state
	sta game_state_old		;prevents play state from re-initializing
	
	;re-initialize any music that was playing
	ldx #5
@loop:
	lda paused_stream_statuses-1,x
	sta stream_status-1,x
	dex
	bne @loop
	
	lda prg_bank
	pha
	lda #BANK_MUSIC
	jsr SetPRGBank
	jsr SoundInit
	pla
	jmp SetPRGBank
Paused_CheckExitDone:
	rts