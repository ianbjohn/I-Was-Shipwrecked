	.db "BEEHIVE"
BeehiveRoutine:
	lda ent_timer1,x	;foo variable that's set to 1 once a bee is spawned
	bne @done
	stx beehive_ent_slot
	lda #1
	sta ent_timer1,x
	sta ent_active+14
	lda #ENT_BEE
	sta ent_id+14
	lda ent_x,x			;spawn out of the opening of the hive
	clc
	adc #4
	sta ent_x+14
	lda ent_y,x
	clc
	adc #12
	sta ent_y+14
	ldx #14
	jsr InitEnt
@done:
	;ldx ent_index
	;inc ent_timer1,x
	rts