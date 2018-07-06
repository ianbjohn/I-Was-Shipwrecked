TitleInit:
InitPalette:
	;start the game off by loading a simple black and white palette for the background (This will cause the status board to be the colors it should be, and when new screens are loaded it'll stay the same)
	lda #%10010000
	sta $2000
	lda #%00000110
	sta $2001
	lda #1
	sta nmi_enabled
	jsr SetUpPalettes
	lda frame_counter
@waitframe:
	cmp frame_counter
	beq @waitframe
	
	;draw title screen
	
	;clear nametable
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
-	sta $2007
	dex
	bne -
	
	;write the title in the middle of the screen
	lda $2002
	lda #$21
	sta $2006
	lda #$88
	sta $2006
	ldx #0
WriteTitle:
	lda Title,x
	sta $2007
	inx
	cpx #17
	bne WriteTitle

	lda $2002
	lda #$22
	sta $2006
	lda #$A6
	sta $2006
	ldx #0
WritePressStart:
	lda PressStart,x
	sta $2007
	inx
	cpx #20
	bne WritePressStart

	lda $2002
	lda #$23
	sta $2006
	lda #$45
	sta $2006
	ldx #0
WriteBonaFideGames:
	lda BonaFideGames,x
	sta $2007
	inx
	cpx #21
	bne WriteBonaFideGames
	
	lda $2002
	lda #$23
	sta $2006
	lda #$66
	sta $2006
	ldx #0
WriteAllRightsReserved:
	lda AllRightsReserved,x
	sta $2007
	inx
	cpx #19
	bne WriteAllRightsReserved

	lda #%00011110
	sta soft_2001
	lda #1
	sta nmi_enabled
	
	;set the old area to #$FF so that once the game starts, the correct music will appropriately play
	lda #$FF
	sta area_old
	
	ldy #SONG_TITLE
	jmp PlaySound
	rts
	
	
TitleMain:
	;wait until the start button is pressed
	;the time from program start until start button being pressed will be the seed for the RNG
Title_ReadStart:
	lda buttons_pressed
	and #BUTTONS_START
	bne @continue
	jmp Title_ReadStartDone
@continue:
	
	;initialize everything for a new game
	lda #%00000110
	sta $2001
	lda #0
	sta nmi_enabled
	
	;init status board attributes
	lda $2002
	lda #$23
	sta $2006
	lda #$C0
	sta $2006
	ldx #8
	lda #%11111111
-	sta $2007
	dex
	bne -
	beq ++
	
	.db "LOAD PLAYER"
	
	;activate player
	;If it's a new game, initialize all these to 0 (or whatever their respective initial values should be)
	;Once we get to the file select state, if a save is loaded, these values will get overwritten
++	lda #1
	sta ent_active+0
	lda #128
	sta ent_x+0
	lda #112
	sta ent_y+0
	clc					;yes, the hitbox sizes are defined elsewhere, but they're initialized here as hard-coded instead of going through the effort of indirectly loading them
	adc #15
	sta ent_hb_x+0
	adc #8
	sta ent_hb_y+0
	
	lda #100
	sta ent_health+0
	;lsr					;thirst and hunger start out half full
	sta hunger
	sta thirst
	;lda #0				;index to "NORMAL" string
	;sta status
	inc player_still_alive
	lda #WEAPON_KNIFE
	sta weapon			;initialize weapon to knife
	;since the player starts out with the knife, set this item to obtained
	;lda #ITEM_KNIFE		;0, like WEAPON_KNIFE
	jsr SetItemAsObtained
	inc num_obtained_items
	lda #ITEM_GUN
	jsr SetItemAsObtained
	inc num_obtained_items
	lda #30
	sta rounds
	
	;make sure the game knows the player is activated
	lda #1
	sta num_active_ents
	
	lda #$3F	;(Start at far bottom right corner in real version)
	sta screen
	
	lda #STATE_FILESELECT
	sta game_state
	
	;test to see if I understand how data gets saved
	;lda #$42
	;sta $6200		;good, I do
	
	ldy #SILENCE
	jmp PlaySound
Title_ReadStartDone:
	rts