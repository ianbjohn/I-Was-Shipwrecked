GunRoutine:
	lda ent_state+15			;this part's here so that the gun, if out of rounds, still gets drawn the entire time the player's attacking (I use that word sparingly here)
	bne @continue
	lda ent_phi_time+15
	beq @continue
	dec ent_phi_time+15
	bne @animation
	;time to change states
	inc ent_state+15
	jmp UpdateEntHitbox
@continue:
	lda ent_state+0
	cmp #2			;player attacking?
	beq @animation
	DeactivateEnt
	rts
	
@animation:
	ldx #15
	jmp EntAdvanceAnimation