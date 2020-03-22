ClothRoutine:
	;The idea here is extremely similar to other collectibles such as:
		;flint, jar, machete, stick, stone
	;So much so in fact that this routine is used for all of them
		;We simply map the ent ID to the corresponding item ID, display the corresponding "found" message", and accomplish the same thing
		
	lda ent_state,x
	beq @continue
	jmp ClothShowCollected
	
@continue:
	jsr CheckPlayerCollision
	bne @playercol
	lda ent_active+1
	beq @checkplayercol_done
	jsr CheckPlayerWeaponCollision
	beq @checkplayercol_done
@playercol:
	ldy ent_id,x
	lda EntItems,y
	jsr CheckIfItemObtained
	beq @newitem
	ldy #SFX_HEARTCOLLECTED
	jsr PlaySound
	jmp @continue2
@newitem:
	ldx ent_index
	ldy ent_id,x
	lda EntItems,y
	jsr SetItemAsObtained
	ldy #SFX_NEWITEMACQUISITION	;play new item acquisition sound effect
	jsr PlaySound
	ldx ent_index
	ldy ent_id,x
	ldx EntItems,y
	lda ItemFoundMsgs,x
	sta message
	lda #STATE_DRAWINGMBOX
	sta game_state
@continue2:
	ldx ent_index
	ldy ent_id,x
	lda EntItems,y
	ldy #1
	jsr AddToItemCount
	ldx ent_index
	inc ent_state,x			;animation data will be the same
	lda #30
	sta ent_timer1,x
@checkplayercol_done:
	rts

ClothShowCollected:
	dec ent_timer1,x
	bne ClothShowCollectedDone
	DeactivateEnt
	rts
ClothShowCollectedDone:
	lda ent_y+0
	sec
	sbc ent_height,x
	sta ent_y,x
	lda ent_x+0
	sta ent_x,x
	rts