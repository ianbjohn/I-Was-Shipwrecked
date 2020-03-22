HeartRoutine:
	;only two things need to happen
	;check if player has come in contact with heart
		;if so, increase player's health, and show it over the player's head for 30 frames
	;otherwise, check if the timer's run out
		;if it has, deactivate the object
	;otherwise, we're done
	
DecHeartPHI:
	lda ent_state,x
	beq @continue
	jmp HeartShowCollected			;show over player's head for 30 frames
@continue:
	lda ent_phi_timer,x
	beq DecHeartPHIDone
	dec ent_phi_timer,x
DecHeartPHIDone:
	
	;check the jar file for more info on this collision code
	jsr CheckPlayerCollision
	bne @playercol
	lda ent_active+1
	beq @checkplayercol_done
	jsr CheckPlayerWeaponCollision
	beq @checkplayercol_done
	
@playercol:
@playerweaponcol:
	lda ent_health+0
	clc
	adc #10
	bcc @skipoverflow
	lda #255
@skipoverflow:
	sta ent_health+0
	ldy #SFX_HEARTCOLLECTED		;play item acquisition sound effect
	jsr PlaySound
	ldx ent_index
	inc ent_state,x
	;jsr FindEntAnimLengthsAndFrames
	lda #30
	sta ent_timer1,x
	rts
@checkplayercol_done:

	;if 120 frames remain, start making the ent flicker
	lda ent_timer1,x
	cmp #195					;255 - (120 / 2)
	bne @incrementtimer1
	lda #120
	sta ent_phi_timer,x			;will make the ent flicker
	
	;increment timer1 every other frame
	;once it rolls over, deactivate the ent (Stays on screen for ~8.5 seconds)
@incrementtimer1:
	lda frame_counter
	and #%00000001				;dec the timer every other frame, since 255 frames only lasts ~4.25 seconds (The ent should stay active longer)
	bne @incrementtimer1done
@continue:
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
	
HeartShowCollected:
	lda ent_timer1,x
	sec
	sbc #1
	bcs HeartShowCollectedDone
	DeactivateEnt
	rts
HeartShowCollectedDone:
	sta ent_timer1,x
	lda ent_y+0
	sec
	sbc ent_height,x
	sta ent_y,x
	lda ent_x+0
	sta ent_x,x
	rts