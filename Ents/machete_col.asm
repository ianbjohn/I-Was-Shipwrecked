MacheteColRoutine:
	;deactivate itself automatically if jar_obtained is nonzero
	lda #ITEM_MACHETE
	jsr CheckIfItemObtained
	beq @continue
	ldx ent_index
	jmp DeactivateEnt
@continue:
	ldx ent_index
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
	jsr DeactivateEnt
	lda #ITEM_MACHETE
	jsr SetItemAsObtained
	ldy #SFX_NEWITEMACQUISITION	;play new item acquisition sound effect
	jsr PlaySound
	lda #MSG_MACHETEFOUND			;message saying a jar was found
	sta message
	lda #STATE_DRAWINGMBOX
	sta game_state
@checkplayercol_done:
	rts