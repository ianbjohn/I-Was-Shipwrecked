PlayInit:
	;eventually we will return here when coming back from the inventory screen state. Then, everything will be set up, so we'll just need to
		;redraw the map
		;redraw the attributes
		;^Both of these things should be loaded from RAM, since the player will be able to alter the screen
	;So, we will only come to this state after coming from the inventory screen.
	;All other initialization (Loading the first screen from the title/save select screen, loading a new screen when the player switches screens, etc)
		;will be done in the title state, and/or in the load screen state (Via the LoadScreen routine)
		
	lda #%00000110
	sta $2001
	lda #0
	sta nmi_enabled
	
	lda prg_bank
	pha
	lda #BANK_METATILES
	jsr SetPRGBank
	
	jsr DrawStatusBoard		;need to do this because the status board may get overwritten if the player selects an item in inventory screen
	jsr ReloadMetaTiles

	pla
	jsr SetPRGBank
	
	lda #%00011110
	sta soft_2001
	lda #1
	sta nmi_enabled
	rts
	
	
	;.db "Play"
PlayMain:
	CycleSprites
	
	;process each active ent
	lda #0
	sta ent_index
@entloop:
	ldx ent_index
	lda ent_active,x
	beq @entdone
	jsr RunEnt
	lda game_state
	cmp game_state_old
	bne @entloopdone
@entdone:
	inc ent_index
	lda ent_index
	cmp #MAX_ENTS
	bne @entloop
@entloopdone:
	
	;increment clock, update day if necessary
IncrementClock:
	;increment frames, roll over and increment seconds if frames got to 60
	lda clock+0
	clc
	adc #1
	cmp #60
	bcs @updateseconds
	;not 60 yet, don't do anything else
	sta clock+0
	bne IncrementClockDone			;will always branch
@updateseconds:
	lda #0
	sta clock+0
	lda clock+1
	clc
	adc #1
	sta clock+1
	lda clock+2
	adc #0
@checkhighbyte:
	cmp #>DAY_LENGTH_REAL_TIME
	bcs @checklowbyte
	;we've determined from the high byte that a day hasn't passed yet, don't do anything else
	sta clock+2
	jmp IncrementClockDone			;since clock+2 can be any value, we have to use a jump unfortunately
@checklowbyte:
	lda clock+1
	cmp #<DAY_LENGTH_REAL_TIME
	bcc IncrementClockDone
@incrementday:
	;we've determined that a day has passed. Increment the 16-bit day variable and clear bytes 1 and 2 of clock (byte 0 was already cleared)
	lda day+0
	clc
	adc #1
	sta day+0
	lda day+1
	adc #0
	sta day+1
	lda #0
	sta clock+1
	sta clock+2
IncrementClockDone:
	
	;draw BCD health, BCD hunger, BCD thirst, BCD days to VRAM buffer
	;The weapon and status strings we don't need to worry about here, since they'll always get updated after redrawing the status board from a message / leaving the inventory screen
	;(Make this a subroutine?)
UpdateHealth:
	lda ent_health+0
	cmp health_old
	beq UpdateHunger
	sta health_old
	sta bcd_value
	jsr BCD_8
	ldx vram_buffer_pos
	lda #$20
	sta vram_buffer+0,x
	lda #$48
	sta vram_buffer+1,x
	lda #<(Copy3Bytes-1)
	sta vram_buffer+2,x
	lda #>(Copy3Bytes-1)
	sta vram_buffer+3,x
	lda bcd_hundreds
	sta vram_buffer+4,x
	lda bcd_tens
	sta vram_buffer+5,x
	lda bcd_ones
	sta vram_buffer+6,x
	txa
	clc
	adc #7
	sta vram_buffer_pos
UpdateHunger:
	lda hunger
	cmp hunger_old
	beq UpdateThirst
	sta hunger_old
	sta bcd_value
	jsr BCD_8
	ldx vram_buffer_pos
	lda #$20
	sta vram_buffer+0,x
	lda #$68
	sta vram_buffer+1,x
	lda #<(Copy3Bytes-1)
	sta vram_buffer+2,x
	lda #>(Copy3Bytes-1)
	sta vram_buffer+3,x
	lda bcd_hundreds
	sta vram_buffer+4,x
	lda bcd_tens
	sta vram_buffer+5,x
	lda bcd_ones
	sta vram_buffer+6,x
	txa
	clc
	adc #7
	sta vram_buffer_pos
UpdateThirst
	lda thirst
	cmp thirst_old
	beq UpdateDay
	sta thirst_old
	sta bcd_value
	jsr BCD_8
	ldx vram_buffer_pos
	lda #$20
	sta vram_buffer+0,x
	lda #$77
	sta vram_buffer+1,x
	lda #<(Copy3Bytes-1)
	sta vram_buffer+2,x
	lda #>(Copy3Bytes-1)
	sta vram_buffer+3,x
	lda bcd_hundreds
	sta vram_buffer+4,x
	lda bcd_tens
	sta vram_buffer+5,x
	lda bcd_ones
	sta vram_buffer+6,x
	txa
	clc
	adc #7
	sta vram_buffer_pos
	;weapon
UpdateDay:
	lda day+0
	cmp day_old
	beq UpdateDone
	sta day_old
	clc
	adc #1					;account for the fact that the first day is displayed as "DAY 1"
	sta bcd_value+0
	lda day+1
	adc #0
	sta bcd_value+1
	jsr BCD_16
	ldx vram_buffer_pos
	lda #$20
	sta vram_buffer+0,x
	lda #$95
	sta vram_buffer+1,x
	lda #<(Copy5Bytes-1)
	sta vram_buffer+2,x
	lda #>(Copy5Bytes-1)
	sta vram_buffer+3,x
	lda bcd_tenthousands
	sta vram_buffer+4,x
	lda bcd_thousands
	sta vram_buffer+5,x
	lda bcd_hundreds
	sta vram_buffer+6,x
	lda bcd_tens
	sta vram_buffer+7,x
	lda bcd_ones
	sta vram_buffer+8,x
	txa
	clc
	adc #9
	sta vram_buffer_pos
UpdateDone:


	;CHR RAM updates
	;Just waves for right now
	;I guess this could go after the ents are drawn, but whatever
	;Eventually, have a better system for CHR updates depending on things like area
UpdateWaveCHR:
	lda chr_anim_timer
	clc
	adc #1
	cmp #24				;make labels / a table in ROM for this, if more animation is needed later
	bcc UpdateWaveCHRDone
	lda chr_anim_frame
	clc
	adc #1
	cmp #6				;^
	bcc @continue
	lda #0
@continue:
	sta chr_anim_frame
	lda #0						;A should be loaded with the index of which animated tile to use (In this case 0 - waves)
	jsr LoadCHRTileToBuffer
	lda #0
UpdateWaveCHRDone:
	sta chr_anim_timer
	
	;if in a cave, and the player has a torch, decrement torch_time, when 0, decrement torch_count, when 0, set BG palette to black and display a message saying 

	;draw each active ent
	lda #0
	sta ent_index
@entdrawloop:
	jsr DrawEnt
	inc ent_index
	lda ent_index
	cmp #MAX_ENTS
	bne @entdrawloop
@entsdrawdone:
	lda #0
	sta ent_index
	
	;I don't feel like making these ents, but draw the sprites that show how many rounds you have left after shooting gun
DisplayRoundsHUD:
	lda rounds_hud_timer
	beq DisplayRoundsHUDDone
	dec rounds_hud_timer
	lda rounds
	sta bcd_value+0
	jsr BCD_8
	inc rounds_hud_x
	dec rounds_hud_y
	ldx oam_index
	lda rounds_hud_y
	sta $0200,x
	sta $0204,x
	ldy bcd_tens
	lda SpriteDigits,y
	sta $0201,x
	ldy bcd_ones
	lda SpriteDigits,y
	sta $0205,x
	lda #%00000011
	sta $0202,x
	sta $0206,x
	lda rounds_hud_x
	sta $0203,x
	clc
	adc #5
	sta $0207,x
DisplayRoundsHUDDone:
	
	;Potential status changes
StatusChangeShore:
	lda area
	cmp #AREA_SHORE
	bne StatusChangeJungle
	;If the player is walking on the sand while cut, there's a chance he can get infected
	lda status
	cmp #STATUS_CUT
	bne StatusChangeDone
	lda ent_state+0
	cmp #1					;walking
	bne StatusChangeDone
	lda random
	jsr RandomLFSR
	cmp #$1F				;random hard-coded 16-bit value
	bcs StatusChangeDone
	lda frame_counter
	cmp #$D5
	bne StatusChangeDone
	lda #STATUS_INFECTED
	sta status
	jsr FetchStatusRecoveryTime
	ldy #SFX_OHSHIT
	jsr PlaySound
	lda #MSG_INFECTED
	sta message
	lda #STATE_DRAWINGMBOX
	sta game_state
	rts
StatusChangeJungle:
	;If the player is in the jungle and is walking, there's a chance he can get cut
	lda area
	cmp #AREA_JUNGLE
	bne StatusChangeDone
	lda status
	cmp #STATUS_CUT
	beq StatusChangeDone
	cmp #STATUS_INFECTED
	beq StatusChangeDone
	lda ent_state+0
	cmp #1
	bne StatusChangeDone
	lda random
	jsr RandomLFSR
	cmp #$1F
	bcs StatusChangeDone
	lda frame_counter
	cmp #$D5
	bne StatusChangeDone
	lda #STATUS_CUT
	sta status
	jsr FetchStatusRecoveryTime
	ldy #SFX_OHSHIT
	jsr PlaySound
	lda #MSG_CUT
	sta message
	lda #STATE_DRAWINGMBOX
	sta game_state
	;rts
StatusChangeDone:
	
	;.db "STARE"
StatusRecover:
	;recover back to normal if the player has waited a given number of frames
	ldx status
	lda StatusRecoverable
	and PowersOfTwo,x
	beq StatusRecoverDone	;not all statuses are recoverable
	lda status_recovery_time+0
	sec
	sbc #1
	bcs @done
	pha
	lda status_recovery_time+1
	sec
	sbc #1
	bcc @recovered
	sta status_recovery_time+1
	pla
	bcs @done					;should always branch
@recovered:
	lda #STATUS_NORMAL
	sta status
	lda #MSG_RECOVERED
	sta message
	ldy #SFX_RECOVERY
	jsr PlaySound 
	lda #STATE_DRAWINGMBOX
	sta game_state
	pla
@done:
	sta status_recovery_time+0
StatusRecoverDone:

	;if in a cave or a dark area, and torch count is > 0, count down torch timer
CountDownTorchTimer:
	lda area
	cmp #AREA_CAVE
	bne CountDownTorchTimerDone
	lda #ITEM_TORCH
	jsr GetItemCount
	beq CountDownTorchTimerDone
	;decrement seconds
	lda clock+0
	bne CountDownTorchTimerDone
	lda torch_timer+0
	sec
	sbc #1
	bcs @continue
	lda torch_timer+1
	sec
	sbc #1
	bcc @dectorchcount
	sta torch_timer+1
	lda #59
	bne @continue		;w.a.b
@dectorchcount:
	lda #>TORCH_TIME			;reset torch timer
	sta torch_timer+1
	lda #<TORCH_TIME
	sta torch_timer+0
	lda #ITEM_TORCH
	ldy #1
	jsr SubtractFromItemCount
	ldy #SFX_OHSHIT
	jsr PlaySound
	lda #ITEM_TORCH				;if count is still > 0, let the player know their torch went out
	jsr GetItemCount			;otherwise, let the player know that they're out of torches
	beq @outoftorches
@torchwentout:
	lda #MSG_TORCHWENTOUT
	sta message
	lda #STATE_DRAWINGMBOX
	sta game_state
	rts		
@outoftorches:
	;we need to buffer palette changes to make the cave pitch black
	;code better documented in loadingscreen.asm
	jsr LoadDarkness
	lda #MSG_OUTOFTORCHES
	sta message
	lda #STATE_DRAWINGMBOX
	sta game_state
	rts
@continue:
	sta torch_timer+0
CountDownTorchTimerDone:
PlayDone:
	rts