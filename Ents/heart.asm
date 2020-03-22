HeartRoutine:
	;only two things need to happen
	;check if player has come in contact with heart
		;if so, increase player's health, and show it over the player's head for 30 frames
	;otherwise, check if the timer's run out
		;if it has, deactivate the object
	;otherwise, we're done
	
	;a bit confusing but basically the item is active for 512 frames (timer1 increases every other frame),
		;the last 120 of which of which it'll flicker (phi_timer decreases)
DecHeartPHI:
	lda ent_state,x
	beq @continue
	jmp HeartShowCollected			;show over player's head for 30 frames
@continue:
	lda ent_phi_timer,x				;stays at 0 until timer1 reaches 195 (explained below)
	beq DecHeartPHIDone
	dec ent_phi_timer,x
DecHeartPHIDone:
	
	;collect if player or his weapon touches item
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
	inc ent_state,x				;animation data will be the same
	lda #30						;now use timer1 to display over player's head for 30 frames
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
	inc ent_timer1,x
	bne @incrementtimer1done
	DeactivateEnt
@incrementtimer1done:
	rts
	
HeartShowCollected:
	dec ent_timer1,x
	bne HeartShowCollectedDone
	DeactivateEnt
	rts
HeartShowCollectedDone:
	lda ent_y+0
	sec
	sbc ent_height,x
	sta ent_y,x
	lda ent_x+0
	sta ent_x,x
	rts