GameOverInit:
	jsr ClearOAM
	
	;clear nametable
	lda #%00000110
	sta $2001
	lda #0
	sta nmi_enabled

	lda $2002
	lda #$20
	sta $2006
	lda #$00
	sta $2006
	tax
	lda #$24
	ldy #4
-	sta $2007
	inx
	bne -
	dey
	bne -
	
	;clear attributes
	lda $2002
	lda #$23
	sta $2006
	lda #$C0
	sta $2006
	ldx #64
	lda #$FF
--	sta $2007
	dex
	bne --
	
	;write "GAME OVER" in the middle of the screen
	;maybe make this data rather than hard code
	lda $2002
	lda #$21
	sta $2006
	lda #$8B
	sta $2006
	ldx #0
---	lda GameOver,x
	sta $2007
	inx
	cpx #10
	bne ---
	
	DeleteFileData		;delete the data from the file the player was using
	
	lda #%00011110
	sta soft_2001
	lda #1
	sta nmi_enabled
	
	
GameOverMain:
	;wait until start is pressed, then reset the game.
		;Eventually, we'll just go back to the title state, but we can't do this yet since there's some stuff (palette buffering mainly) that needs to be done first
GameOver_ReadStart:
	lda buttons_pressed
	and #BUTTONS_START
	beq GameOverMainDone
	jmp RESET
GameOverMainDone:
	rts