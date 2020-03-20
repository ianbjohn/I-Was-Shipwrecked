;stuff related to the "previous screen ent reloading system"
ptr2 = message_ptr		;since we work with 2 structs here, we need 2 pointers. Message pointer isn't used here, so it can be used as something else


CheckIfPreviousScreen:
	;screen should have been stored in previous_screen, and subsequently updated to now have the ID of the new screen
	lda screen
	ldx #0
-	cmp prev_screen_ids,x
	beq @done
	inx
	cpx #4
	bne -
	ldx #$FF			;there was no match
@done:
	;if there was a match, the correct ID is in X
	rts
	
	
	;These following subroutines deal with the saved ent data system
	;The reason we do it the way we do is there's literally a page of variables we're dealing with here, and a lot of them are going to be shifted around alot when changing screens
	;The trick is to have a list of pointers, and shift these around, and leave a big bulk of the data where it is.
	;When a new room is entered, the oldest screen's pointer is brought to the front, and it's data is overwritten
	;This saves a shitton of time
InsertNewPreviousScreen:
	;Inserts previous_screen in the front of the list of screens previously visited, dropping out the last element if there was one
	;Decided to just unroll this loop since only 4 things need to happen, so it's a few more bytes but ultimately less cycles
		;(Not a huge deal but I'm trying to optimize for speed with this whole thing)
	lda prev_screen_ids+2
	sta prev_screen_ids+3
	lda prev_screen_ids+1
	sta prev_screen_ids+2
	lda prev_screen_ids+0
	sta prev_screen_ids+1
	lda previous_screen
	sta prev_screen_ids+0
InsertNewPrevScreenEnemyPaletteIndex:
	;the same old song and dance, just with different variables (Maybe see if it'd be feasible to combine this into the first routine)
	lda prev_screen_enemy_palettes+2
	sta prev_screen_enemy_palettes+3
	lda prev_screen_enemy_palettes+1
	sta prev_screen_enemy_palettes+2
	lda prev_screen_enemy_palettes+0
	sta prev_screen_enemy_palettes+1
	lda prev_enemy_palette_index
	sta prev_screen_enemy_palettes+0
	rts
	
	
InsertNewPrevScreenEntDataPtr:
	;does similar shit to the above routine
	;THIS SHOULD ONLY BE DONE IF NOT ALL 4 SCREENS HAVE BEEN FILLED UP YET
	;USE THE SUBROUTINE BELOW ONCE ALL 4 HAVE BEEN
	lda prev_screen_entdata_ptr_ids+2
	sta prev_screen_entdata_ptr_ids+3
	lda prev_screen_entdata_ptr_ids+1
	sta prev_screen_entdata_ptr_ids+2
	lda prev_screen_entdata_ptr_ids+0
	sta prev_screen_entdata_ptr_ids+1
	lda num_previous_screens
	sta prev_screen_entdata_ptr_ids+0
	rts
	
	
InsertNewPrevScreenScreenDataPtr:
	lda prev_screen_screendata_ptr_ids+2
	sta prev_screen_screendata_ptr_ids+3
	lda prev_screen_screendata_ptr_ids+1
	sta prev_screen_screendata_ptr_ids+2
	lda prev_screen_screendata_ptr_ids+0
	sta prev_screen_screendata_ptr_ids+1
	lda num_previous_screens				;prev_screendata_id
	sta prev_screen_screendata_ptr_ids+0
	rts
	
	
BringNthScreenEntDataPtrToTop:
	;once all 4 screens worth of data have been filled up, start rotating this list of pointers
	;X should have the id of which pointer to bring to the top of the list
	;All 3 registers get clobbered here
	beq @done								;break out of loop once X is 0 (or if it was to begin with)
	ldy prev_screen_entdata_ptr_ids,x		;backup the element we're bringing to the front
@loop:
	lda prev_screen_entdata_ptr_ids-1,x
	sta prev_screen_entdata_ptr_ids+0,x
	dex
	bne @loop
	sty prev_screen_entdata_ptr_ids+0
@done:
	rts
	
	
	;Similar code for enemy sprite palettes is just in the loadingscreen code for some reason
BringNthScreenScreenDataPtrToTop:
	beq @done
	ldy prev_screen_screendata_ptr_ids,x
@loop:
	lda prev_screen_screendata_ptr_ids-1,x
	sta prev_screen_screendata_ptr_ids+0,x
	dex
	bne @loop
	sty prev_screen_screendata_ptr_ids+0
@done:
	rts
	
	
	;.db "SWAP"
SwapEntData:
	;performed when re-entering a screen that's been recently visited
	;the main ent data needs to go to the saved ent data slot corresponding to the first pointer in the list,
		;and the first pointer's respective data needs to go to main ent RAM
	;so we swap them, one field at a time
	;Try and optimize this if possible. I feel kinda guilty using all 4 temp variables
	lda #BANK_ENTS
	jsr SetPRGBank
	lda prev_screen_entdata_ptr_ids+0
	;sta temp0
	asl
	tax
	lda PrevScreenEntDataAddresses+0,x
	sta ptr1+0
	sta temp1
	lda PrevScreenEntDataAddresses+1,x
	sta ptr1+1
	sta temp2
	ldx #15					;go through the data for all 14 ents (excluding the player and his weapon) (We stop once X gets to 1)
	ldy #55					;we need to indirectly manipulate 56 bytes, and since we're doing this in reverse order we start at 55
@loop:
	;if the current main-RAM ent is an enemy
		;swap
	;else
		;overwrite this main-RAM ent with whatever its corresponding WRAM data is
	lda ent_type,x
	cmp #ENT_TYPE_ENEMY
	beq @swap
	cmp #ENT_TYPE_POWERUP
	beq @swap
@overwrite
	;here, instead of swapping, we're overwriting main ent RAM with ent WRAM
	lda (ptr1),y
	sta ent_active,x
	lda #0
	sta (ptr1),y		;WRAM ent should now be deactivated
	dey
	lda (ptr1),y
	sta ent_id,x
	lda #0
	sta (ptr1),y
	dey
	lda (ptr1),y
	sta ent_y,x
	lda #0
	sta (ptr1),y
	dey
	lda (ptr1),y
	sta ent_x,x
	lda #0
	sta (ptr1),y
	
	;if the ent was active, re-activate it
	lda ent_active,x
	beq @activateentdone
	tya
	pha
	jsr InitEnt				;this clobbers Y which is why we needed to back it up
	pla
	tay
@activateentdone:
	dey
	dex
	cpx #1
	beq @done
	jmp @loop
	dey
	dex
	cpx #1
	bne @loop
	rts
@swap:
	lda ent_active,x		;check the varsandconsts file for the order of the saved ent data fields. It's basically in reverse here
	sta temp3
	lda (ptr1),y
	sta ent_active,x
	lda temp3
	sta (ptr1),y
	dey
	
	lda ent_id,x
	sta temp3
	lda (ptr1),y
	sta ent_id,x
	lda temp3
	sta (ptr1),y
	dey
	
	lda ent_y,x
	sta temp3
	lda (ptr1),y
	sta ent_y,x
	lda temp3
	sta (ptr1),y
	dey
	
	lda ent_x,x
	sta temp3
	lda (ptr1),y
	sta ent_x,x
	lda temp3
	sta (ptr1),y
	;dey
	
	;if the ent was active, re-activate it
	lda ent_active,x
	beq @activateentdone2
	lda #0
	sta ent_dir,x
	tya
	pha
	jsr InitEnt				;this clobbers Y which is why we needed to back it up
	pla
	tay
@activateentdone2:
	dey
	dex
	cpx #1
	beq @done
	jmp @loop
@done:
	rts
	
	
SwapScreenData:
	lda prev_screen_screendata_ptr_ids+0
	asl
	tax
	lda PrevScreenScreenDataAddresses+0,x
	sta ptr1+0
	;sta temp1
	lda PrevScreenScreenDataAddresses+1,x
	sta ptr1+1
	;sta temp2
	;swap the map in main RAM with the current selected map in WRAM
	ldy #0
	ldx #0
	lda (ptr1),y			;the first byte says which metatile bank is used for this screen
	sta temp3
	lda metatile_bank
	sta (ptr1),y
	lda temp3
	sta metatile_bank
	iny
@swaptiles:
	lda (ptr1),y
	sta temp3
	lda metatile_map,x
	sta (ptr1),y
	lda temp3
	sta metatile_map,x
	iny
	inx
	cpx #192
	bne @swaptiles
	ldx #0
@swapattribs:
	lda (ptr1),y
	sta temp3
	lda attribute_map,x
	sta (ptr1),y
	lda temp3
	sta attribute_map,x
	iny
	inx
	cpx #56
	bne @swapattribs
	rts
	
	
	.db "OVERWRITE"
OverwriteEntData:
	;performed when going to a new screen - main ent RAM (which was for the last screen) is copied to the ent WRAM pointed to by the first pointer in the list
	;This could probably be a macro since for right now I think its only gonna only need to be in the bigass load screen routine
	lda prev_screen_entdata_ptr_ids+0
	;sta temp0							;Check and see if this actually needs to be here
	asl
	tax
	lda PrevScreenEntDataAddresses+0,x
	sta ptr1+0
	sta temp1
	lda PrevScreenEntDataAddresses+1,x
	sta ptr1+1
	sta temp2
	ldx #15
	ldy #55					;see the above swap routine for better comments
@loop:
	lda ent_active,x		;skip ent if it wasnt active
	beq @clear
	lda ent_type,x
	cmp #ENT_TYPE_ENEMY		;skip ent if it wasnt an enemy
	beq @overwrite
	cmp #ENT_TYPE_POWERUP
	beq @overwrite
	lda #0
@erase:
@clear:
	sta (ptr1),y			;save this ent as deactivated
	sta ent_active,x		;this same logic is used for ents that are active, but shouldn't be saved. So they need to be deactivated.
	dey
	dey
	dey
	dey
	dex
	cpx #1					;stop at player and weapon
	bne @loop
	beq @done				;will always branch
@overwrite:
	lda #1			;we know the ent is active
	sta (ptr1),y
	lda #0			;deactivate the main RAM ent
	sta ent_active,x
	dey
	
	lda ent_id,x
	sta (ptr1),y
	dey
	
	lda ent_y,x
	sta (ptr1),y
	dey
	
	lda ent_x,x
	sta (ptr1),y
	dey
	dex
	cpx #1					;stop at player and weapon
	bne @loop
@done:
SpawnNewEnts:
	;initialize new enemies here based on area, difficulty, and pseudorandomness
		;originally I was gonna generate random X and Y coordinates, get the appropriate metatile from RAM, and repeat if it wasn't an appropriate type
			;but it dawned on me that this could potentially take an assload of time (even indefinitely in the absolute worst possible case), so while this method will take more space, it's necessary
		;My current plan is to have a max of 8 enemies spawn on one screen. There's also a byte of flags saying which terrains are on the screen (Water, trees, land, etc), as well as have 8 pairs of spawn coordinates for each terrain
			;There's also a table that maps enemy IDs to their terrain, so when an enemy is being spawned, we can check if its terrain is on the screen, and not spawn it if it isnt.
			;Otherwise, we also have a byte of which enemy positions have been spawned, (We use frame_counter ^ (prime number) & 7 to get a random number between 0 and 7 that's different every time), and keep regenerating until an unused slot has been found (This means that any slot in say the water is essentially the same as its corresponding slot on land)
		;We disregard all of this, however, if there's a special event for the screen.
	
	;copy the ent spawn points into RAM so we don't have to keep bankswitching
	;first we have to clear it
	ldx #0
	txa
@clear:
	sta ent_spawns,x
	inx
	cpx #48
	bne @clear			;count down?
	
	lda in_cave			;explained in LoadMetaTiles
	bne @cave
	lda #<(IslandEntSpawnData)
	sta mt_ptr1+0
	lda #>(IslandEntSpawnData)
	sta mt_ptr1+1
	bne @continue
@cave:
	lda cave_level
	asl
	tax
	lda CaveEntSpawnData+0,x
	sta mt_ptr1+0
	lda CaveEntSpawnData+1,x
	sta mt_ptr1+1
@continue:
	lda screen
	asl
	tay
	lda (mt_ptr1),y
	sta ptr2+0
	iny
	lda (mt_ptr1),y
	sta ptr2+1
	ldy #0						;is there a way to make this count down? BCS?
	sty temp0					;used to keep track of where in ent_spawns we are
	sty temp1					;where to keep track of where we're indirectly reading from
	ldx #0						;used to keep track of the terrain type
@loop:
	lda screen_terrain
	and PowersOfTwo,x
	bne @loop1				;if the current terrain isn't on the screen, don't load spawn coordinates for it (since there won't be any)
	lda temp0
	clc
	adc #16
	sta temp0
	bne @next				;will always branch
@loop1:
	ldy temp1
	lda (ptr2),y
	ldy temp0
	sta ent_spawns,y
	inc temp1
	iny
	tya
	sta temp0
	and #%00001111			;check if 16 bytes have been stored yet
	bne @loop1
@next:
	inx
	cpx #3
	bne @loop
	
	lda #BANK_EVENTS
	jsr SetPRGBank

	lda screen_special
	beq RegularEvent
	;bne SpecialEvent
	;.db "SPECIAL"
SpecialEvent:
	lda special_event
	asl
	tax
	lda SpecialEvents+0,x
	sta ptr1+0
	lda SpecialEvents+1,x
	sta ptr1+1
	ldy #0
	lda (ptr1),y			;ID (Loading the palette data will come later)
	sta temp0
	jsr CheckIfItemObtained
	beq @notobtainedyet
	rts
@notobtainedyet:
	ldy #0
	ldx temp0
	lda ItemEnts,x
	sta ent_id+2
	iny
	lda (ptr1),y			;X
	sta ent_x+2				;special event ents wer hard-coded to the last ent slot, but I don't think that's necessary
	iny
	lda (ptr1),y			;Y
	sta ent_y+2
	lda #0
	sta ent_dir+2
	lda #BANK_ENTS
	jsr SetPRGBank
	ldx #2
	jmp InitEnt
	
	;.db "REG"
RegularEvent:
	;use the spawn coordinates and event data to randomly generate enemies
	lda area			;sorted by area, then difficulty
	asl
	tax
	lda Events+0,x
	sta ptr1+0
	lda Events+1,x
	sta ptr1+1
	lda difficulty
	asl
	tay
	lda (ptr1),y
	sta event_ptr+0
	iny
	lda (ptr1),y
	sta event_ptr+1
	;next, we have to use area and difficulty to get how many different events there are
	;its a 3*n array, where n is the number of different areas (there are 3 difficulties)
	ldy area
	lda MultiplesOfThree,y
	clc
	adc difficulty
	tax
	lda EventCounts,x
	sta temp0		;how many events there are for this area and difficulty
	
	;(call random?)
	lda random
	and temp0
	asl				;we use this value to access word table
	tay
	
	lda (event_ptr),y
	sta ptr1+0
	iny
	lda (event_ptr),y
	sta ptr1+1
	;randomly pick enemy spawn coordinates from the list in RAM
	lda random
	jsr RandomLFSR
	and #%00000111
	sta spawn_prng_index		;which prime number to choose to drive how we pick coordinates
	adc random
	jsr RandomLFSR
	and #%00000111
	sta temp3					;which slot to read first
	ldx #2			;start X after player and player weapon
	ldy #0
	
	;the first byte says which enemy sprite subpalette to use
	lda enemy_palette_index
	sta prev_enemy_palette_index
	lda (ptr1),y
	sta enemy_palette_index
	iny
	
@loop2:
	;For right now, this isn't meant to be optimal. Just make sure it works, then once the coordinates are randomly selected, optimize
	;select a random prime number (call random, AND with 7, tax), generate another random number, adc Primes,x, and #%00000111
	lda (ptr1),y		;get the ent IDs, and then get coordinates for them
	cmp #$FF
	beq @loop2done
	
	sta ent_id,x
	stx temp1
	sty temp2
	tax
	lda EnemyTerrains,x		;figure out which spawn coordinates to used based on the terrain of the enemy
	tax						;if the enemy's terrain type isn't on the screen, disregard it and move on
	lda screen_terrain
	and PowersOfTwo,x
	beq @loop2end
	txa
	asl
	tax						;Now use to get the right address of where to get coordinates (based on terrain)
	lda TerrainSpawnCoordinates+0,x
	sta event_ptr+0
	lda TerrainSpawnCoordinates+1,x
	sta event_ptr+1
	lda temp3
	asl
	tay
	ldx temp1
	lda (event_ptr),y		;X
	sta ent_x,x
	iny
	lda (event_ptr),y		;Y			;(IF 0, DISREGARD, AND MOVE ON) (It would be a hassle at this point (having made >20 screens already) to have Y first :(. Also, Y needs to be incremented beforehand so that the next potential pair is properly loaded)
	beq @loop2end
	sta ent_y,x
	lda #0
	sta ent_dir,x
	lda #BANK_ENTS
	jsr SetPRGBank
	jsr InitEnt
	lda #BANK_EVENTS
	jsr SetPRGBank
@loop2end:
	lda temp3
	clc
	ldx spawn_prng_index
	adc Primes,x
	and #%00000111
	sta temp3				;generate the next random index 0-7 in the stream
	ldx temp1
	inx
	ldy temp2
	iny
	bne @loop2				;should always branch
@loop2done:
	;lda #BANK_METATILES
	;jmp SetPRGBank			;need to go back to loading metatiles after this
	rts