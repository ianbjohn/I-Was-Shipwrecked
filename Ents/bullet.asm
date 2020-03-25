BULLET_SPEED = 15


BulletRoutine:
	lda ent_dir+1
	beq MoveBulletUp
	cmp #DOWN
	beq MoveBulletDown
	cmp #LEFT
	beq MoveBulletLeft
MoveBulletRight:
	lda ent_x+1
	clc
	adc #BULLET_SPEED
	;cmp #240			;add this if the bullet still manages to wrap around and kill ents on the other side of the screen
	bcc @continue
	DeactivateEnt
	rts
@continue:
	sta ent_x+1
	lda ent_hb_x+1
	clc
	adc #BULLET_SPEED
	sta ent_hb_x+1
	jmp MoveBulletDone
MoveBulletLeft:
	lda ent_x+1
	sec
	sbc #BULLET_SPEED
	;cmp #16
	bcs @continue
	DeactivateEnt
	rts
@continue:
	sta ent_x+1
	lda ent_hb_x+1
	sec
	sbc #BULLET_SPEED
	sta ent_hb_x+1
	jmp MoveBulletDone
MoveBulletDown:
	lda ent_y+1
	clc
	adc #BULLET_SPEED
	;cmp #240
	bcc @continue
	DeactivateEnt
	rts
@continue:
	sta ent_y+1
	lda ent_hb_y+1
	clc
	adc #BULLET_SPEED
	sta ent_hb_y+1
	jmp MoveBulletDone
MoveBulletUp:
	lda ent_y+1
	sec
	sbc #BULLET_SPEED
	;cmp #16
	bcs @continue
	DeactivateEnt
	rts
@continue:
	sta ent_y+1
	lda ent_hb_y+1
	sec
	sbc #BULLET_SPEED
	sta ent_hb_y+1
MoveBulletDone:
	rts