BeehiveStates:
	.dw BeehiveNormal, BeehiveHit
	
	
BeehiveInit:
	lda random
	jsr RandomLFSR
	and #%00111111
	clc
	adc #1				;wait anywhere from 1-64 frames before trying to spawn a new bee
	sta ent_timer1,x
	jmp FindEntAnimLengthsAndFrames
	

BeehiveRoutine:
@checkKnifeCol:
	lda ent_state,x
	cmp #1				;hit
	beq @checkKnifeColDone
	lda ent_active+1
	beq @checkKnifeColDone
	jsr CheckPlayerWeaponCollision
	beq @checkKnifeColDone
	;set bee HP to 0
	lda #0
	sta ent_health,x
	
	lda #EXPLOSION_TIME
	sta ent_timer1,x
	lda #1
	sta ent_state,x
	jmp FindEntAnimLengthsAndFrames
@checkKnifeColDone:

	;go to individual code for each state
	lda ent_state,x
	asl
	tay
	lda BeehiveStates+0,y
	sta jump_ptr+0
	lda BeehiveStates+1,y
	sta jump_ptr+1
	jmp (jump_ptr)
	

BeehiveNormal
	;THE BEEHIVE ENT SHOULD SPAWN SOME BEES NEAR THE HIVE, GUARDING, AND OTHERS AWAY FROM THE HIVE, FORAGING (This should go in the beehive's creation routine, once creation routines are implemented)
	;When the hive spawns a new bee from the entrance (Which should be on a timer and depend on how many other bees are currently active) the bee should either guard the hive or forage for food
	dec ent_timer1,x	;foo variable that's set to 1 once a bee is spawned
	bne @done
	stx beehive_ent_slot
	lda random
	jsr RandomLFSR
	and #%00111111
	clc
	adc #1				;wait anywhere from 1-64 frames before trying to spawn a new bee
	sta ent_timer1,x
	jsr FindFreeEntSlot
	txa
	beq @done
	tay					;the bee's potential spot should be in Y, since the beehive's ent index should stay in X
	ldx ent_index
	lda #ENT_BEE
	sta ent_id,y
	lda ent_x,x			;spawn out of the opening of the hive
	clc
	adc #4
	sta ent_x,y
	lda ent_y,x
	clc
	adc #12
	sta ent_y,y
	tya
	tax
	;either guard hive or forage for food (just forage for right now)
	lda #0
	sta ent_state,x		;direction can be whatever since it'll go to the foraging spot
	jmp InitEnt
@done:
	rts
	
	
BeehiveHit:
	dec ent_timer1,x
	bne @done
	;Set beehive slot to 0 since it's gone now
	lda #0
	sta beehive_ent_slot
	dec num_active_enemies
	;1/2 chance, drop honeycomb
	lda random
	jsr RandomLFSR
	and #%00000001
	beq @dropnothing
	lda #ENT_HONEYCOMB
	sta ent_id,x
	lda #0
	sta ent_state,x
	jsr InitEnt
	jmp @spawnbees
@dropnothing:
	DeactivateEnt 
@spawnbees:
	;Fill any available ent slots with swarming bees
	;We know that whatever slot the beehive just was will be free now, but it'll be less code to simply just deactivate it and do a standard loop,
		;rather than copying the overhead of setting up the bee here for one pass
	;A bit sloppy, but ent initialization only uses temp0, so we'll save the beehive's X and Y to temp1 and temp2 respectively
	lda ent_x,x
	sta temp1
	lda ent_y,x
	sta temp2
	ldx #2
@spawnbeeloop:
	lda ent_active,x
	bne @spawnbeesdone
	lda #ENT_BEE
	sta ent_id,x
	lda #3			;swarming
	sta ent_state,x
	;The direction doesn't matter here since it'll immediately change to face the player
	;Give the bees some different positions, which'll also help them not all immediately die from the player's weapon
	lda random
	jsr RandomLFSR
	and #%00001111
	clc
	adc temp1
	sta ent_x,x
	jsr RandomLFSR
	and #%00001111
	clc
	adc temp2
	sta ent_y,x
	jsr InitEnt
@spawnbeesdone:
	inx
	cpx #16
	bne @spawnbeeloop
@done:
	rts