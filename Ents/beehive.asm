	.db "BEEHIVE"
BeehiveRoutine:
	;THE BEEHIVE ENT SHOULD SPAWN SOME BEES NEAR THE HIVE, GUARDING, AND OTHERS AWAY FROM THE HIVE, FORAGING (This should go in the beehive's creation routine, once creation routines are implemented)
	;When the hive spawns a new bee from the entrance (Which should be on a timer and depend on how many other bees are currently active) the bee should either guard the hive or forage for food
	dec ent_timer1,x	;foo variable that's set to 1 once a bee is spawned
	bne @done
	;stx beehive_ent_slot
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
	lda #1
	sta ent_active,y
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
	pha					;save bee's index as it'll get clobbered
	tax
	jsr InitEnt
	pla
	tay
	lda random
	jsr RandomLFSR
	sta ent_misc1,y
	jsr RandomLFSR
	sta ent_misc2,y
	;(either guard the hive or forage for food)
@done:
	rts