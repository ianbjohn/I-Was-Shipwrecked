StickColRoutine:
	;similar to meat's code
	lda ent_state,x
	beq @continue
	jmp StickShowCollected
	
@continue:
	jsr CheckPlayerCollision
	bne @playercol
	lda ent_active+1
	beq @checkplayercol_done
	jsr CheckPlayerWeaponCollision
	beq @checkplayercol_done
@playercol:
	lda #ITEM_STICK
	jsr CheckIfItemObtained
	beq @newitem
	ldy #SFX_HEARTCOLLECTED
	jsr PlaySound
	jmp @continue2
@newitem:
	lda #ITEM_STICK
	jsr SetItemAsObtained
	ldy #SFX_NEWITEMACQUISITION	;play new item acquisition sound effect
	jsr PlaySound
	lda #MSG_STICKFOUND
	sta message
	lda #STATE_DRAWINGMBOX
	sta game_state
@continue2:
	lda #ITEM_STICK
	ldy #1
	jsr AddToItemCount
	ldx ent_index
	inc ent_state,x
	;jsr FindEntAnimLengthsAndFrames
	lda #30
	sta ent_timer1,x
@checkplayercol_done:
	rts

StickShowCollected:
	lda ent_timer1,x
	sec
	sbc #1
	bcs StickShowCollectedDone
	DeactivateEnt
	rts
StickShowCollectedDone:
	sta ent_timer1,x
	lda ent_y+0
	sec
	sbc ent_height,x
	sta ent_y,x
	lda ent_x+0
	sta ent_x,x
	rts