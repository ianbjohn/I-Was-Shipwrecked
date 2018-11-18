	;Code is commented in heart.asm and meat.asm
HoneycombRoutine:
	
DecHoneycombPHI:
	lda ent_state,x
	beq @continue
	jmp HoneycombShowCollected
@continue:
	lda ent_phi_timer,x
	beq DecHoneycombPHIDone
	dec ent_phi_timer,x
DecHoneycombPHIDone:

	jsr CheckPlayerCollision
	bne @playercol
	lda ent_active+1
	beq @checkplayercol_done
	jsr CheckPlayerWeaponCollision
	beq @checkplayercol_done
@playercol
	lda #ITEM_HONEYCOMB
	jsr CheckIfItemObtained
	beq @newitem
	ldy #SFX_HEARTCOLLECTED
	jsr PlaySound
	jmp @continue
@newitem:
	lda #ITEM_HONEYCOMB
	jsr SetItemAsObtained
	ldy #SFX_NEWITEMACQUISITION
	jsr PlaySound
	lda #MSG_HONEYCOMBFOUND
	sta message
	lda #STATE_DRAWINGMBOX
	sta game_state
@continue:
	lda #ITEM_HONEYCOMB
	ldy #1
	jsr AddToItemCount
	ldx #ent_index
	inc ent_state,x
	lda #30
	sta ent_timer1,x
	rts
@checkplayercol_done:

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
	
HoneycombShowCollected:
	lda ent_timer1,x
	sec
	sbc #1
	bcs HoneycombShowCollectedDone
	jmp DeactivateEnt
HoneycombShowCollectedDone:
	sta ent_timer1,x
	sta ent_y+0
	sec
	sbc ent_height,x
	sta ent_y,x
	lda ent_x+0
	sta ent_x,x
	rts