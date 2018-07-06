	;.db "MEAT"
MeatRoutine:

DecMeatPHI:
	lda ent_state,x
	beq @continue
	jmp MeatShowCollected
@continue:
	lda ent_phi_timer,x
	beq DecMeatPHIDone
	dec ent_phi_timer,x
DecMeatPHIDone:

	jsr CheckPlayerCollision		;check jar file for more info on this code
	bne @playercol
	lda ent_active+1
	beq @checkplayercol_done
	jsr CheckPlayerWeaponCollision
	beq @checkplayercol_done
@playercol:
	;(play item acquisition sound effect)
	lda #ITEM_MEAT
	jsr CheckIfItemObtained
	beq @newitem
	ldy #SFX_HEARTCOLLECTED		;just play the normal item acquisition sfx if meat's already been obtained
	jsr PlaySound
	jmp @continue
@newitem:
	;let the player know they got meat
	lda #ITEM_MEAT
	jsr SetItemAsObtained
	ldy #SFX_NEWITEMACQUISITION	;play new item acquisition sound effect
	jsr PlaySound
	lda #MSG_MEATFOUND
	sta message
	lda #STATE_DRAWINGMBOX
	sta game_state
@continue:
	;add #1 to the count of meat
	lda #ITEM_MEAT
	ldy #1
	jsr AddToItemCount
	ldx ent_index
	inc ent_state,x
	;jsr FindEntAnimLengthsAndFrames
	lda #30
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
	jmp DeactivateEnt
@skipoverflow2:
	sta ent_timer1,x
@incrementtimer1done:
	rts
	
MeatShowCollected:
	lda ent_timer1,x
	sec
	sbc #1
	bcs MeatShowCollectedDone
	jmp DeactivateEnt
MeatShowCollectedDone:
	sta ent_timer1,x
	lda ent_y+0
	sec
	sbc ent_height,x
	sta ent_y,x
	lda ent_x+0
	sta ent_x,x
	rts