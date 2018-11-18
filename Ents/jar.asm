JarRoutine:
	lda ent_state,x
	beq @continue
	jmp JarShowCollected
	;deactivate itself automatically if jar_obtained is nonzero
	lda #ITEM_JAR
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
	lda #ITEM_JAR
	jsr SetItemAsObtained
	ldy #SFX_NEWITEMACQUISITION	;play new item acquisition sound effect
	jsr PlaySound
	lda #MSG_JARFOUND			;message saying a jar was found
	sta message
	lda #STATE_DRAWINGMBOX
	sta game_state
	ldx ent_index
	inc ent_state,x
	lda #30
	sta ent_timer1,x			;display jar above player's head for 30 frames to signify the item was obtained
@checkplayercol_done:
	rts
	
JarShowCollected:
	lda ent_timer1,x
	sec
	sbc #1
	bcs JarShowCollectedDone
	jmp DeactivateEnt
JarShowCollectedDone:
	sta ent_timer1,x
	lda ent_y+0
	sec
	sbc ent_height,x
	sta ent_y,x
	lda ent_x+0
	sta ent_x,x
	rts