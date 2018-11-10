	.db "LOAD SCREEN"
LoadingScreenMain:
	;(Be sure to eventually, for each area, have a table of which CHR data is needed, and update the CHR RAM accordingly)
	
	;If the player was in the middle of walking during a screen transition, set his state to standing so he's not still in the middle of walking when the screen is loaded
	;Sometimes it does look weird if the player was in the middle of walking, and then for example gets notified that the cave they just entered is pitch black, but I don't think it's a huge deal right now
	;Maybe move this code to the end of the fade-out state instead
	;lda #0					;standing
	;tax						;set ent index to player
	;sta ent_state+0
	;sta ent_anim_timer+0
	;sta ent_anim_frame+0
	;jsr FindEntAnimLengthsAndFrames
	
	;load the metatiles for the screen
	lda #%00000110				;Have this here just to make sure it'll always happen
	sta $2001
	sta soft_2001				;nmi has to be enabled for palette updates, but PPU should still be turned off
	
	jsr SetUpPalettes			;re-draw player, misc, and status board sub-palettes, in case a fade-out happened
	
	;move the player to the opposite side of the screen depending on which direction he left
MovePlayer:
	lda door_transition
	bne @door
	lda left_first_screen
	beq MovePlayerDone
	bne @normal
@door:
	;set where the player should be from a door transition
	dec door_transition
	lda door_tr_x
	sta ent_x+0
	clc
	adc ent_width+0
	sta ent_hb_x+0
	lda door_tr_y
	sta ent_y+0
	clc
	adc ent_height+0
	sta ent_hb_y+0
	jmp MovePlayerDone
@normal:
	lda screen_leave_dir
	beq @up
	cmp #1
	beq @down
	cmp #2
	beq @left
@right:
	lda #3
	sta ent_x+0
	clc
	adc ent_width+0
	sta ent_hb_x+0
	bne MovePlayerDone		;will always branch
@up:
	lda #(240 - PLAYERHEIGHT)						;bottom boundary of the screen
	sta ent_y+0
	clc
	adc ent_height+0
	sta ent_hb_y+0
	bne MovePlayerDone
@down:
	lda #48
	sta ent_y+0
	clc
	adc ent_height+0
	sta ent_hb_y+0
	bne MovePlayerDone
@left:
	lda #(256 - 3 - PLAYERWIDTH)
	sta ent_x+0
	clc
	adc ent_width+0
	sta ent_hb_x+0
MovePlayerDone:
	
	;I believe that whenever a new screen is loaded, the ent bank should be loaded in
	;If the game ever just crashes after a screen transition, look here first
	;lda prg_bank
	;pha
	lda #BANK_METATILES
	jsr SetPRGBank
	
	;get the area and difficulty (packed as the low and high nibbles of a byte) for the screen
	lda in_cave_new
	sta in_cave
	bne @cave
	;Explained in LoadMetaTiles
	lda #<(IslandAreasDifficulties)
	sta ptr1+0
	lda #>(IslandAreasDifficulties)
	sta ptr1+1
	bne @continue			;will always branch
@cave:
	lda cave_level
	asl
	tax
	lda CaveAreasDifficulties+0,x
	sta ptr1+0
	lda CaveAreasDifficulties+1,x
	sta ptr1+1
@continue:
	ldy screen
	lda (ptr1),y
	pha							;Accumulator gets altered and its current value (the thing literally right above us) needs to be dealt with a second time
	and #%00001111
	sta area
	pla
	lsr
	lsr
	lsr
	lsr
	sta difficulty
	
	;Since the NES is a quirky motherfucker, we have to load the palettes during vblank, through a buffer
	;Background palettes for screens can never change, so we don't have to worry about preserving this and can just load it with every screen
LoadPalette:
	lda in_cave
	bne @cave
	lda #<(IslandScreens)
	sta mt_ptr1+0
	lda #>(IslandScreens)
	sta mt_ptr1+1
	lda screen
	asl
	tay
	lda (mt_ptr1),y
	sta ptr1+0		;will be used as the pointer for screen data
	iny
	lda (mt_ptr1),y
	sta ptr1+1
	bne @continue		;will always branch
@cave:
	lda cave_level
	asl
	tax
	lda CaveScreens+0,x
	sta mt_ptr1+0
	lda CaveScreens+1,x
	sta mt_ptr1+1
	lda screen
	asl
	tay
	lda (mt_ptr1),y
	sta ptr1+0		;will be used as the pointer for screen data
	iny
	lda (mt_ptr1),y
	sta ptr1+1
	;if the player doesn't have any torches, don't light the caves
	lda #ITEM_TORCH
	jsr GetItemCount
	bne @continue
@notorches:
	ldy #2
	sty temp0		;position in screen data (Shouldn't be reset until all the screen loading is done)
	ldx vram_buffer_pos
	lda #$3F
	sta vram_buffer+0,x
	lda #$00
	sta vram_buffer+1,x
	lda #<(Copy12Bytes-1)
	sta vram_buffer+2,x
	lda #>(Copy12Bytes-1)
	sta vram_buffer+3,x
	ldy #0
	lda #$0F				;blackness
@darkness:
	sta vram_buffer+4,x
	inx
	iny
	cpy #12
	bne @darkness
	txa
	clc
	adc #4
	sta vram_buffer_pos
	lda frame_counter
	jmp @waitframe
	;everything after this part works as intended
@continue:
	ldy #0			;position in screen data (Shouldn't be reset until all the screen loading is done)
	;get the palette address
	lda (ptr1),y
	sta mt_ptr1+0
	iny
	lda (ptr1),y
	sta mt_ptr1+1
	iny
	sty temp0
	;indirectly unload the palette data from the pointer to the VRAM buffer
	ldx vram_buffer_pos
	lda #$3F
	sta vram_buffer+0,x
	lda #$00
	sta temp1				;used to keep track of position in the palette buffer
	sta vram_buffer+1,x
	tay
	lda #<(Copy12Bytes-1)
	sta vram_buffer+2,x
	lda #>(Copy12Bytes-1)
	sta vram_buffer+3,x
	txa
	clc
	adc #4
	sta vram_buffer_pos
@loop:	
	ldx vram_buffer_pos
	lda (mt_ptr1),y
	sta vram_buffer,x
	inc vram_buffer_pos
	ldx temp1
	sta palette_buffer,x
	inc temp1
	iny
	cpy #12
	bne @loop
	lda frame_counter
@waitframe:				;wait for VBlank to update palette. This is to prevent the PPU registers from potentially getting corrupted during NMI if, say CHR RAM updates are happening during the main frame
	cmp frame_counter
	beq @waitframe
	;Even if no enemies appear on the screen, an enemy sprite palette is still loaded, so the VRAM buffer gets closed up at the end of the routine
	
	;Now that that's done, we need to actually disable NMIs
	lda #0
	sta nmi_enabled
	sta screen_special	;reset whether or not special events can happen
	
	jsr ClearOAM		;ensures that any enemies still on the screen won't be on the next screen for a frame
	
	;CHR data for the background gets loaded depending on what area we're in. Since we just got the area of this new screen, fetch new background tiles and put them in CHR RAM
LoadBackgroundCHR:
	lda #BANK_GRAPHICS
	jsr SetPRGBank
	lda area
	asl
	tax
	lda CHR_Banks_BG+0,x
	sta mt_ptr1+0
	lda CHR_Banks_BG+1,x
	sta mt_ptr1+1
	lda #$15
	sta temp1
	lda #$00
	sta temp2
	sta temp3
	lda #$0B
	sta temp4
	jsr LoadCHR
	lda #BANK_METATILES
	jsr SetPRGBank
	
	
	;get whether or not special events happen on this screen
CheckSpecialEvent:
	ldy temp0
	lda (ptr1),y
	beq CheckSpecialEventDone
	;it's a special event
	tax
	dex
	stx special_event
	lda #1
	sta screen_special
	;iny
	;sty temp4					;explained below
	bne GetScreenTerrainDone	;will always branch
CheckSpecialEventDone
	iny
	
	;get the type of terrain
GetScreenTerrain:
	lda (ptr1),y
	sta screen_terrain
GetScreenTerrainDone:
	iny

	;get the address of where to load door ents
GetDoorsAddress:
	lda (ptr1),y
	sta door_ptr+0
	iny
	lda (ptr1),y
	sta door_ptr+1
	iny
	sty temp4				;save temp0 as it'll get overwritten when enemies are loaded/reloaded (Stack is used to much here already, temp4 was just added for this purpose, so no other routine uses it)
GetDoorsAddressDone:
	
	;(This was originally where hard-coded snake ents were spawned)
	;load new enemies / screen data or reload old enemies / screen data
SetUpEnemies:
	ldx #0
	stx num_active_enemies		;this needs to be cleared and then re-initialized
	inx
	stx num_active_ents			;the player is the only ent active when first setting up a screen
	;here we'll either reload enemies from another screen, or generate all new enemies
	jsr CheckIfPreviousScreen
	stx temp0			;we might need whatever was returned from the above call, so we gotta save it
	cpx #$FF
	beq @newscreen
	;this is a screen we've recently visited
	;(set a flag indicating that this is a screen that's recently been visited (will be needed after a new map's been loaded into RAM, to make any changes necessary))
	lda enemy_palette_index
	sta prev_enemy_palette_index
	lda prev_screen_enemy_palettes,x
	sta enemy_palette_index
	lda temp0			;the backed-up value needs to be in X for this next call
	pha					;SwapEntData uses all the temp variables, so we need to push temp0 to the stack
	jsr BringNthScreenEntDataPtrToTop
	pla
	tax
	pha
	jsr BringNthScreenScreenDataPtrToTop
	jsr SwapEntData
	lda #BANK_METATILES
	jsr SetPRGBank
	jsr SwapScreenData				;merge some of these subroutines together
	jsr ReloadMetaTiles				;try moving this up and loading it first, since we're already in the metatile bank, it could save a bankswitch (remember that the play init state uses this routine too, but bank switches before calling it)
	pla
	tax
	;re-order the screen IDs so that they're back to being in the correct order as when they were visited
	pha						;need to re-save it, as it gets re-clobbered
	beq @loopdone
@loop:
	lda prev_screen_ids-1,x
	sta prev_screen_ids,x
	dex
	bne @loop
@loopdone:
	lda previous_screen
	sta prev_screen_ids+0
	;same with the enemy palette
	pla
	tax
	beq @loop2done
@loop2:
	lda prev_screen_enemy_palettes-1,x
	sta prev_screen_enemy_palettes,x
	dex
	bne @loop2
@loop2done:
	lda prev_enemy_palette_index
	sta prev_screen_enemy_palettes+0
	jmp SetUpEnemiesDone
@newscreen:
	;this isn't a screen we've recently visited
	;don't wanna change anything if the game is just initializing.
	;(set a flag indicating that this is a new screen (see comment in parentheses above))
	lda left_first_screen
	bne @inc
	inc left_first_screen
	;jsr SpawnNewEnts					;The idea is that, since the player can only save once all the enemies have been cleared from the screen, he should come back to an empty screen when loading a file (Or when first starting a new file to add to the tone of the game)
		;(Or when entering / leaving a cave? Maybe have another flag that gets set when a game is started / loaded, and then not manipulated after)
	lda temp4
	sta temp0					;this can be moved into the start of the metatile routine to save a couple bytes
	jsr LoadMetaTiles
	lda screen_special
	bne @special
	jmp SetUpEnemiesDone
@special:
	lda #BANK_EVENTS
	jsr SetPRGBank
	jsr SpecialEvent				;again, make see if this can be changed to a branch
	jmp SetUpEnemiesDone
@inc:
	ldx num_previous_screens
	cpx #4
	bcs @fourscreensvisited
	;lda #BANK_ENTS
	;jsr SetPRGBank
	;simply add the next pointer to the list, since 4 unique screens haven't been visited yet
	jsr InsertNewPrevScreenEntDataPtr
	jsr InsertNewPrevScreenScreenDataPtr		;try and merge some of these subroutines together
	jsr OverwriteEntData				;try and see if you can tail-call optimize these at all (Or turn them into macros, even if the code'll get ugly)
	jsr OverwriteScreenData					;try moving this up and loading it first, since we're already in the metatile bank, it could save a bankswitch (be sure to remove it from the LoadMetaTiles routine)
		;Also, if this is the only place that LoadMetaTiles is called, just back the temp4->temp0 transfer into the routine
	inc num_previous_screens
	jsr InsertNewPreviousScreen
	jmp SetUpEnemiesDone				;I can't remember if INC/DEC affects the Z flag; but if it does, change JMP to BNE
@fourscreensvisited:
	;bring the last pointer to the top of the list
	ldx #3
	jsr BringNthScreenEntDataPtrToTop
	ldx #3
	jsr BringNthScreenScreenDataPtrToTop
	jsr OverwriteEntData
	jsr OverwriteScreenData
	jsr InsertNewPreviousScreen
SetUpEnemiesDone:
	;send the respective enemy sprite palette to the buffer (I'm not quite 100% sure if this is the best place to put this, so if the game ever breaks for some weird reason, look into this)
	lda screen_special
	beq +
	lda #BANK_EVENTS
	jsr SetPRGBank
	lda special_event
	asl
	tax
	lda SpecialEvents+0,x
	sta ptr1+0
	lda SpecialEvents+1,x
	sta ptr1+1					;see if we can use a different pointer so we don't have to re-set it again, to cut down on a bit of this redundant code
	ldx vram_buffer_pos			;load the special event's sprite palette
	lda #$3F
	sta vram_buffer+0,x
	lda #$19
	sta vram_buffer+1,x
	lda #<(Copy3Bytes-1)
	sta vram_buffer+2,x
	lda #>(Copy3Bytes-1)
	sta vram_buffer+3,x
	ldy #3
	lda (ptr1),y
	sta vram_buffer+4,x
	iny
	lda (ptr1),y
	sta vram_buffer+5,x
	iny
	lda (ptr1),y
	sta vram_buffer+6,x
	txa
	clc
	adc #7
	sta vram_buffer_pos
	bne ++						;will always branch
+	lda enemy_palette_index		;load the regular enemies' sprite palette
	asl
	tay
	lda EnemySpritePalettes+0,y
	sta ptr1+0
	lda EnemySpritePalettes+1,y
	sta ptr1+1
	ldx vram_buffer_pos
	lda #$3F
	sta vram_buffer+0,x
	lda #$19
	sta temp1
	sta vram_buffer+1,x
	lda #<(Copy3Bytes-1)
	sta vram_buffer+2,x
	lda #>(Copy3Bytes-1)
	sta vram_buffer+3,x
	txa
	clc
	adc #4
	sta vram_buffer_pos
	ldy #0
-	ldx vram_buffer_pos
	lda (ptr1),y
	sta vram_buffer,x
	inc vram_buffer_pos
	ldx temp1
	sta palette_buffer,x
	inc temp1
	iny
	cpy #3
	bne -
	
++	;pla
	;sta temp0			;in case things come afterwords
	
	;load doors if there were any
SetUpDoors:
	lda #BANK_METATILES
	jsr SetPRGBank
	lda door_ptr+1		;if high byte is 0, there are no doors on this screen
	beq SetUpDoorsDone
	ldy #0
	lda (door_ptr),y	;the first byte says how many doors are on the screen
	sta door_count
	iny
@loop:
	jsr FindFreeEntSlot	;There should always be a free slot
	lda #1
	sta ent_active,x
	lda (door_ptr),y	;X
	sta ent_x,x
	iny
	lda (door_ptr),y	;Y
	sta ent_y,x
	tya
	pha					;we have enough info to spawn the ent, but Y will get clobbered, and we still need to set direction and other things
	lda #ENT_DOOR
	sta ent_id,x
	lda #BANK_ENTS
	jsr SetPRGBank
	jsr InitEnt
	pla
	tay
	iny
	lda #BANK_METATILES
	jsr SetPRGBank
	lda (door_ptr),y	;dir
	sta ent_dir,x		;don't have to worry about metasprites for direction, since this ent has no graphics
	iny
	lda (door_ptr),y	;screen #
	sta ent_timer1,x	;just use this as a placeholder, since it wouldn't be general enough to have it as its own variable
	iny
	lda (door_ptr),y	;player x
	sta ent_xvel,x
	iny
	lda (door_ptr),y	;player y
	sta ent_yvel,x
	iny
	lda (door_ptr),y	;in cave?
	sta ent_phi_timer,x
	beq @skipcavelevel
	iny
	lda (door_ptr),y	;cave level
	sta ent_phi_time,x
@skipcavelevel:
	iny
	dec door_count
	bne @loop
SetUpDoorsDone:
	
	;pla
	;jsr SetPRGBank
	lda #BANK_ENTS
	jsr SetPRGBank
	
	;if the area has been changed, play new music
	lda area
	cmp area_old
	beq @musicchangedone
	tax						;area_old will get updated at the end
	ldy GameAreaSongs,x
	jsr PlaySound
@musicchangedone:

	;close up the VRAM buffer
	lda #%00011110
	sta soft_2001
	lda #1
	sta nmi_enabled
	ldx vram_buffer_pos
	lda #0
	sta vram_buffer,x
	inx
	sta vram_buffer,x
	inx
	lda #<(RestoreSP-1)
	sta vram_buffer,x
	inx
	lda #>(RestoreSP-1)
	sta vram_buffer,x
	;inx
	;stx vram_buffer_pos
	inc vram_update
	lda frame_counter
@waitFrame:
	;wait until Vblank to unload the buffer updates and finally change the palette
	cmp frame_counter
	beq @waitFrame
	
	;If we're in a cave, and we have no torches, let the player know what's happening
		;As far as I know, this works as intended for the current situation and isn't what's breaking the game. Uncomment once screen transition bugs are fixed.
	;eventually, add logic so that this only happens when first entering a cave. Should be similar to the logic used for stopping the music.
	lda in_cave
	beq @notincave
	lda area
	cmp area_old			;update area
	beq @notincave
	sta area_old
	lda #ITEM_TORCH
	jsr GetItemCount
	bne @notincave
	lda #MSG_CAVEPITCHBLACK
	sta message
	lda #STATE_DRAWINGMBOX
	sta game_state
	sta game_state_old		;uncomment this if the uncommented code doesn't work
	rts
	
@notincave:
	lda area
	sta area_old			;update area
	lda #STATE_PLAY
	sta game_state
	sta game_state_old				;The init state for play is only used for redrawing the screen from RAM when returning from the inventory screen
	rts