GunRoutine:
	lda ent_state+15			;this part's here so that the gun, if out of rounds, still gets drawn the entire time the player's attacking (I use that word sparingly here)
	bne @continue
	lda ent_phi_time+15
	beq @continue
	dec ent_phi_time+15
	bne GunAdvanceAnimation
	;time to change states
	inc ent_state+15
	jmp UpdateEntHitbox
@continue:
	lda ent_state+0
	cmp #2			;player attacking?
	beq GunAdvanceAnimation
	jmp DeactivateEnt
	
GunAdvanceAnimation:
	lda ent_anim_timer+15
	clc
	adc #1
	cmp ent_anim_length+15
	bcc @continue
	lda ent_anim_frame+15
	clc
	adc #1
	cmp ent_anim_frames+15
	bcc @continue2
	lda #0
@continue2:
	sta ent_anim_frame+15
	lda #0
@continue:
	sta ent_anim_timer+15

	rts