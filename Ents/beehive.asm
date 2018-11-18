BeehiveStates:
	.dw BeehiveNormal, BeehiveHit

	.db "BEEHIVE"
BeehiveRoutine:
BeehiveAdvanceAnimation:
	lda ent_anim_timer,x
	clc
	adc #1
	cmp ent_anim_length,x
	bcc @continue
	;set timer back to 0, increment frame
	lda ent_anim_frame,x
	clc
	adc #1
	cmp ent_anim_frames,x
	bcc @continue2
	lda #0					;even if frame didn't get set back to 0, timer needs to be
@continue2:
	sta ent_anim_frame,x
	lda #0
@continue:
	sta ent_anim_timer,x
BeehiveAdvanceAnimationDone:

BeehiveCheckKnifeCol:
	lda ent_state,x
	cmp #6				;hit
	beq BeehiveCheckKnifeColDone
	lda ent_active+1
	beq BeehiveCheckKnifeColDone
	jsr CheckPlayerWeaponCollision
	beq BeehiveCheckKnifeColDone
	;set bee HP to 0
	lda #0
	sta ent_health,x
	
	lda #EXPLOSION_TIME
	sta ent_timer1,x
	lda #6
	sta ent_state,x
	lda #0
	sta ent_anim_timer,x
	sta ent_anim_frame,x
	;ldx ent_index
	jmp FindEntAnimLengthsAndFrames
BeehiveCheckKnifeColDone:

	;go to individual code for each state
	lda ent_state,x
	asl
	tay
	lda BeeStates+0,y
	sta jump_ptr+0
	lda BeeStates+1,y
	sta jump_ptr+1
	jmp (jump_ptr)
	

BeehiveNormal
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
	
	
BeehiveHit:
	lda ent_timer1,x
	sec
	sbc #1
	bcs @done
	;1/2 chance, drop honeycomb
	lda random
	jsr RandomLFSR
	and #%00000001
	beq @dropnothing
	lda #ENT_HONEYCOMB
	sta ent_index,x
	jmp InitEnt
@dropnothing:
	jmp DeactivateEnt			;For right now I don't think bees should drop anything
@done:
	sta ent_timer1,x
	rts