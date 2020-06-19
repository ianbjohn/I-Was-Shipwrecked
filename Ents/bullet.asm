BULLET_SPEED = 15


BulletInit:
	;The bullet doesn't immediately go to main code on init for the same reason that the spear doesn't. Better explained there.
	rts


BulletRoutine:
	;Since there's the chance of the spear being very close to the edge, but then moving and being despawned before it can be drawn, we wait one frame before moving so the player knows they threw a spear
	lda ent_state+1
	bne @normal
	inc ent_state+1		;No need to fetch new animation / frame data here, and now we're ready to go
	rts
@normal:
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