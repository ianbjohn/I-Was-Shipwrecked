TITLEPALETTELENGTH = 20
TITLESPRITELENGTH = 160


TitleInit:
	lda #%10010000
	sta $2000
	lda #%00000110
	sta $2001
	lda #0
	sta nmi_enabled
	
	;load title CHR data
	lda #BANK_OTHER
	jsr SetPRGBank
	lda #<CHR_Title
	sta mt_ptr1+0
	lda #>CHR_Title
	sta mt_ptr1+1
	lda #$10
	sta temp1
	lda #$00
	sta temp2
	sta temp3
	lda #16
	sta temp4
	jsr LoadCHR
	lda #<CHR_TitleSprites
	sta mt_ptr1+0
	lda #>CHR_TitleSprites
	sta mt_ptr1+1
	lda #$00
	sta temp1
	sta temp2
	lda #0
	sta temp3
	lda #2
	sta temp4
	jsr LoadCHR
	
	lda #1
	sta nmi_enabled
	
	;load title palette
	ldx vram_buffer_pos
	lda #$3F
	sta vram_buffer+0,x
	lda #$00
	sta vram_buffer+1,x
	lda #<(Copy20Bytes-1)
	sta vram_buffer+2,x
	lda #>(Copy20Bytes-1)
	sta vram_buffer+3,x
	ldy #0
@paletteloop:
	lda TitlePalette,y
	sta vram_buffer+4,x
	inx
	iny
	cpy #TITLEPALETTELENGTH
	bne @paletteloop
	lda #0
	sta vram_buffer+4,x
	sta vram_buffer+5,x
	lda #<(RestoreSP-1)
	sta vram_buffer+6,x
	lda #>(RestoreSP-1)
	sta vram_buffer+7,x
	txa
	clc
	adc #9
	sta vram_buffer_pos
	inc vram_update
	lda frame_counter
@waitframe:
	cmp frame_counter
	beq @waitframe
	
	lda #0
	sta nmi_enabled

LoadTitleScreen:
	lda $2002
	lda #$20
	sta $2006
	lda #$00
	sta $2006
	tay
	ldx #4
	lda #<TitleScreen
	sta ptr1+0
	lda #>TitleScreen
	sta ptr1+1
@loop:
	lda (ptr1),y
	sta $2007
	iny
	bne @loop
	inc ptr1+1
	dex
	bne @loop
	
LoadTitleSprites:
	ldx #TITLESPRITELENGTH
@loop:
	lda TitleScreenSprites-1,x
	sta $01FF,x				;page-crosses every time adding a cycle, but counting up and comparing every time will add more
	dex
	bne @loop
	
	lda #%00011110
	sta soft_2001
	lda #1
	sta nmi_enabled
	
	;set the old area to #$FF so that once the game starts, the correct music will appropriately play
	lda #$FF
	sta area_old
	
	ldy #SONG_TITLE
	jmp PlaySound
	
	
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
	;Kinda confusing since a lot of stuff happens in the FileSelect state after starting a new / loading an old file
		;But the rule of thumb is that general non-file-specific stuff can happen here
	lda #%00000110
	sta $2001
	lda #0
	sta nmi_enabled
	
	;load main CHR data
	lda #BANK_GRAPHICS
	jsr SetPRGBank
	lda #<CHR_GlobalBG
	sta mt_ptr1+0
	lda #>CHR_GlobalBG
	sta mt_ptr1+1
	lda #$10
	sta temp1
	lda #$00
	sta temp2
	sta temp3
	lda #$05
	sta temp4
	jsr LoadCHR
	lda #<CHR_Sprites
	sta mt_ptr1+0
	lda #>CHR_Sprites
	sta mt_ptr1+1
	lda #$00
	sta temp1
	sta temp2
	sta temp3
	lda #$10
	sta temp4
	jsr LoadCHR
	
	jsr SetUpPalettes	;set up main palettes
	lda frame_counter
@waitframe:
	cmp frame_counter
	beq @waitframe
	

	;activate player
	;If it's a new game, initialize all these to 0 (or whatever their respective initial values should be)
	;Once we get to the file select state, if a save is loaded, these values will get overwritten
	lda #BANK_ENTS
	jsr SetPRGBank
++	lda #1
	sta ent_active+0
	lda #128
	sta ent_x+0
	lda #112
	sta ent_y+0
	;Set up player animation / hitbox data here (Animation data isn't super necessary, but set it up here just in case)
	ldx #0
	jsr FindEntAnimLengthsAndFrames
	
	lda #255
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
	lda #>TORCH_TIME		;set torch countdown time
	sta torch_timer+1
	lda #<TORCH_TIME
	sta torch_timer+0
	
	
	;start shuffling sprites based on ent slot #2
	lda #2
	sta ent_draw_index
	
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