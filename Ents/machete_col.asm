MacheteColRoutine:
	ldx ent_index
	lda ent_state,x
	bne MacheteColShowCollected
	;the only thing that needs to happen is check if player (or his weapon) has come in contact with jar
	;if so, set jar_obtained to 1, and display a message saying that the jar was obtained
	;sprite collision
	jsr CheckPlayerCollision
	bne @playercol
	lda ent_active+1
	beq @checkplayercol_done		;don't check for a collision with player's weapon if it isn't active
	jsr CheckPlayerWeaponCollision
	beq @checkplayercol_done
	
@playercol:
@playerweaponcol:
	;a collision happened
	lda #ITEM_MACHETE
	jsr SetItemAsObtained
	ldy #SFX_NEWITEMACQUISITION	;play new item acquisition sound effect
	jsr PlaySound
	lda #MSG_MACHETEFOUND			;message saying a jar was found
	sta message
	lda #STATE_DRAWINGMBOX
	sta game_state
	ldx ent_index
	inc ent_state,x
	lda #30
	sta ent_timer1,x
@checkplayercol_done:
	rts
	
MacheteColShowCollected:
	lda ent_timer1,x
	sec
	sbc #1
	bcs MacheteColShowCollectedDone
	jmp DeactivateEnt
MacheteColShowCollectedDone:
	sta ent_timer1,x
	lda ent_y+0
	sec
	sbc ent_height,x
	sta ent_y,x
	lda ent_x+0
	sta ent_x,x
	rts