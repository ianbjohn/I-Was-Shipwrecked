.macro Abs
	;returns the absolute value of the accumulator
	bpl @absdone
	eor #%11111111
	clc
	adc #1
@absdone:
.endm


.macro DeactivateEnt
	;X should be loaded with ent_index
	lda #0
	sta ent_active,x
.endm


.macro SaveFileData
	;Saves current data to a given file
	;A, X and Y clobbered
	ldy file
	;tell the engine that the given file has contents
	lda file_contents
	ora PowersOfTwo,y
	sta file_contents
	;main variables
	lda screen
	sta file_data_screen,y
	lda ent_x+0
	sta file_data_x,y
	lda ent_y+0
	sta file_data_y,y
	lda ent_health+0
	sta file_data_health,y
	lda hunger
	sta file_data_hunger,y
	lda thirst
	sta file_data_thirst,y
	lda status
	sta file_data_status,y
	lda weapon
	sta file_data_weapon,y
	;since days is two bytes, we have to multiply Y by 2 to store in the right spot
	tya
	pha
	asl
	tay
	lda day+0
	sta file_data_day+0,y
	lda day+1
	sta file_data_day+1,y
	lda status_recovery_time+0		;a less common variable, but we're already deaing with 16-bit stuff here
	sta file_data_recovery_time+0,y
	lda status_recovery_time+1
	sta file_data_recovery_time+1,y
	lda torch_timer+0
	sta file_data_torch_timer+0,y
	lda torch_timer+1
	sta file_data_torch_timer+1,y
	;restore Y back to normal
	pla
	tay
	;less common variables
	lda jar_contents
	sta file_data_jar_contents,y
	lda num_obtained_items
	sta file_data_num_obtained_items,y
	lda num_crafted_items
	sta file_data_num_crafted_items,y
	lda rounds
	sta file_data_rounds,y
	lda in_cave_new
	sta file_data_in_cave,y
	lda cave_level
	sta file_data_cave_level,y
	tya
	pha					;save Y again since it's gonna get altered again and we're gonna need its original value...again
	;arrays
	;BE SURE TO SAVE ALL THE NORMAL VARIABLES BEFORE SAVING ARRAYS - IT'LL BE FASTER
	;instead of 0,0,0,1,1,1,2,2,2 ; data for these arrays are stored as 0,1,2,0,1,2,0,1,2,0,1,2
	;save the array of which items have been obtained
	;we do this (NUM_TOTAL_ITEMS / 8) + 1 times
	ldx #0
-	lda obtained_items,x
	sta file_data_obtained_items,y
	iny									;add 3 to y to save to the next byte
	iny
	iny
	inx
	cpx #((NUM_TOTAL_ITEMS / 8) + 1)
	bne -
	pla
	tay					;restore Y
	pha
	;pha				;BE SURE TO SAVE Y AGAIN IF THERE ARE EVER ANY MORE ARRAYS WE NEED TO SAVE
	;save the array of the counts of each item
	ldx #0
--	lda item_count,x
	sta file_data_item_count,y
	iny
	iny
	iny
	inx
	cpx #((NUM_TOTAL_ITEMS / 2) + 1)
	bne --
	pla
	tay
	;pha
	ldx #0
---	lda crafted_items,x
	sta file_data_crafted_items,y
	iny
	iny
	iny
	inx
	cpx #((NUM_CRAFTABLE_ITEMS / 8) + 1)
	bne ---
.endm

.macro LoadFileData
	;Loads the current data from a given file to main game RAM
	;A, X and Y are clobbered
	;the Save routine has a few more comments btw
	;main variables
	ldy file
	lda file_data_screen,y
	sta screen
	lda file_data_x,y
	sta ent_x+0
	lda file_data_y,y
	sta ent_y+0
	lda file_data_health,y
	sta ent_health+0
	lda file_data_hunger,y
	sta hunger
	lda file_data_thirst,y
	sta thirst
	lda file_data_status,y
	sta status
	lda file_data_weapon,y
	sta weapon
	;since days is two bytes, we have to multiply Y by 2 to load from the right spot
	tya
	pha
	asl
	tay
	lda file_data_day+0,y
	sta day+0
	lda file_data_day+1,y
	sta day+1
	lda file_data_recovery_time+0,y
	sta status_recovery_time+0
	lda file_data_recovery_time+1,y
	sta status_recovery_time+1
	lda file_data_torch_timer+0,y
	sta torch_timer+0
	lda file_data_torch_timer+1,y
	sta torch_timer+1
	;restore Y back to normal
	pla
	tay
	;less common variables
	lda file_data_jar_contents,y
	sta jar_contents
	lda file_data_num_obtained_items,y
	sta num_obtained_items
	lda file_data_num_crafted_items,y
	sta num_crafted_items
	lda file_data_rounds,y
	sta rounds
	lda file_data_in_cave,y
	sta in_cave_new
	lda file_data_cave_level,y
	sta cave_level
	tya
	pha				;save Y again, save routine explains
	;arrays
	ldx #0
-	lda file_data_obtained_items,y
	sta obtained_items,x
	iny
	iny
	iny
	inx
	cpx #((NUM_TOTAL_ITEMS / 8) + 1)
	bne -
	pla
	tay
	pha
	ldx #0
--	lda file_data_item_count,y
	sta item_count,x
	iny
	iny
	iny
	inx
	cpx #((NUM_TOTAL_ITEMS / 2) + 1)
	bne --
	pla
	tay
	;pha
	ldx #0
---	lda file_data_crafted_items,y
	sta crafted_items,x
	iny
	iny
	iny
	inx
	cpx #((NUM_CRAFTABLE_ITEMS / 8) + 1)
	bne ---
.endm


.macro DeleteFileData
	;Deletes the current data from a given file
	;A, X and Y are clobbered
	;the Save routine has a few more comments btw
	ldy file
	;tell the engine that the given file no longer has contents
	lda PowersOfTwo,y
	eor #%11111111			;we need to negate this so that the file flag gets cleared but the other flags stay what they are
	sta temp0
	lda file_contents
	and temp0
	sta file_contents
	;main variables
	lda #0
	sta file_data_screen,y
	sta file_data_x,y
	sta file_data_y,y
	sta file_data_health,y
	sta file_data_hunger,y
	sta file_data_thirst,y
	sta file_data_status,y
	sta file_data_weapon,y
	sta file_data_day+0,y
	sta file_data_day+1,y
	sta file_data_jar_contents,y
	sta file_data_num_obtained_items,y
	sta file_data_num_crafted_items,y
	sta file_data_in_cave,y
	sta file_data_cave_level,y
	sta file_data_recovery_time+0,y
	sta file_data_recovery_time+1,y
	sta file_data_torch_timer+0,y
	sta file_data_torch_timer+1,y
	tya
	pha					;save Y again since it's gonna get altered again and we're gonna need its original value...again
	;arrays
	ldx #0
	txa
-	sta file_data_obtained_items,y
	iny								;add 3 to y to save to the next byte
	iny
	iny
	inx
	cpx #((NUM_TOTAL_ITEMS / 8) + 1)
	bne -
	pla
	tay					;restore Y
	pha				;BE SURE TO SAVE Y AGAIN IF THERE ARE EVER ANY MORE ARRAYS WE NEED TO SAVE
	;save the array of the counts of each item
	ldx #0
	txa
--	sta file_data_item_count,y
	iny
	iny
	iny
	inx
	cpx #((NUM_TOTAL_ITEMS / 2) + 1)
	bne --
	pla
	tay
	;pha
	ldx #0
	txa
---	sta file_data_crafted_items,y
	iny
	iny
	iny
	inx
	cpx #((NUM_CRAFTABLE_ITEMS / 8) + 1)
	bne ---
.endm