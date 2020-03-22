MeatRoutine:
	;The idea here is extremely similar to other collectibles such as:
		;honeycomb
	;So much so in fact that this routine is used for all of them
		;We simply map the ent ID to the corresponding item ID, display the corresponding "found" message", and accomplish the same thing

DecMeatPHI:
	lda ent_state,x
	beq @continue
	jmp MeatShowCollected
@continue:
	dec ent_phi_timer,x
	beq DecMeatPHIDone
DecMeatPHIDone:

	;collect if player or his weapon touches item
	jsr CheckPlayerCollision
	bne @playercol
	lda ent_active+1
	beq @checkplayercol_done
	jsr CheckPlayerWeaponCollision
	beq @checkplayercol_done
@playercol:
	lda EntItems,x
	jsr CheckIfItemObtained
	beq @newitem
	ldy #SFX_HEARTCOLLECTED		;just play the normal item acquisition sfx if item's already been obtained
	jsr PlaySound
	jmp @continue
@newitem:
	;let the player know what they got
	lda EntItems,x
	jsr SetItemAsObtained
	ldy #SFX_NEWITEMACQUISITION	;play new item acquisition sound effect
	jsr PlaySound
	ldx ent_index
	ldy EntItems,x
	lda ItemFoundMsgs,y
	sta message
	lda #STATE_DRAWINGMBOX
	sta game_state
@continue:
	;add #1 to the count
	ldx ent_index
	lda EntItems,x
	ldy #1
	jsr AddToItemCount
	ldx ent_index
	inc ent_state,x			;animation stuff will be the same
	lda #30					;display over player's head for 30 frames
	sta ent_timer1,x
	rts
@checkplayercol_done:
	
	;this next part is better explained in the heart code
	lda ent_timer1,x
	cmp #195
	bne @incrementtimer1
	lda #120
	sta ent_phi_timer,x
	
@incrementtimer1:
	lda frame_counter
	and #%00000001
	bne @incrementtimer1done
@continue2:
	lda ent_timer1,x
	clc
	adc #1
	bcc @skipoverflow2
	DeactivateEnt
	rts
@skipoverflow2:
	sta ent_timer1,x
@incrementtimer1done:
	rts
	
MeatShowCollected:
	dec ent_timer1,x
	bne MeatShowCollectedDone
	DeactivateEnt
	rts
MeatShowCollectedDone:
	lda ent_y+0
	sec
	sbc ent_height,x
	sta ent_y,x
	lda ent_x+0
	sta ent_x,x
	rts