SpearRoutine:
	lda ent_dir,x
	beq SpearUp
	cmp #1
	beq SpearDown
	cmp #2
	beq SpearLeft
SpearRight:
	lda ent_hb_x,x
	clc
	adc #4
	bcc @stillonscreen
	DeactivateEnt
	rts
@stillonscreen:
	sta ent_hb_x,x
	lda ent_x,x
	clc
	adc #4
	sta ent_x,x
	rts
	
SpearUp:
	lda ent_y,x
	sec
	sbc #4
	cmp #40				;top screen border
	bcs @stillonscreen
	DeactivateEnt
	rts
@stillonscreen:
	sta ent_y,x
	lda ent_hb_y,x
	sec
	sbc #4
	sta ent_hb_y,x
	rts
	
SpearDown:
	lda ent_hb_y,x
	clc
	adc #4
	cmp #217			;bottom screen border
	bcc @stillonscreen
	DeactivateEnt
	rts
@stillonscreen:
	sta ent_hb_y,x
	lda ent_y,x
	clc
	adc #4
	sta ent_y,x
	rts
	
SpearLeft:
	lda ent_x,x
	sec
	sbc #4
	bcs @stillonscreen
	DeactivateEnt
	rts
@stillonscreen:
	sta ent_x,x
	lda ent_hb_x,x
	sec
	sbc #4
	sta ent_hb_x,x
	rts