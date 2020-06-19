SpearInit:
	;When the spear is first thrown, there is a chance of it immmediately being off screen
	;We can catch these cases based on the spear's direction, and see if they're just outside the screen boundaries, and if so disregard the spear throw and give it back to the player
	;(Maybe make this a more general out-of-bounds check routine for other long weapons like the stick, to prevent them from wrapping around the screen. Although it might not be a super big glitch since it can help with killing enemies)
	jsr FindEntAnimLengthsAndFrames
	lda ent_dir+1
	beq @done		;Since our status board is 6 tiles, we shouldn't need to worry about a spear being out of bounds when travelling upwards
	cmp #1
	beq @down
	cmp #2
	beq @left
@right:
	lda ent_hb_x+1
	cmp #40			;If the spear is going to the right and is less than 40 pixels from the left border, the player was too close to the right border when throwing it
	bcc @outofbounds
	rts
@down:
	lda ent_hb_y+1
	cmp #40
	bcc @outofbounds
	rts
@left:
	lda ent_x+1
	cmp #216
	bcc @done	;We can just branch directly here
@outofbounds:
	jmp SpearReturn	;Deactivates the spear and adds the item back to the player's possession (BGCol routine)
@done:
	rts				;Here we don't go into main code since the spear can get spawned very close to the edge, but its main code moves it and despawns it if it goes off the screen.
					;In the main code, we wait one frame before moving, so that the player has a chance to see the spear before it potentially disappears. But since this gets spawned by the player and is now active,
						;So when the spear gets spawned, we do nothing with main code, and then when the player's done and the spear is ran, it waits for one frame.


SpearRoutine:
	;Since there's the chance of the spear being very close to the edge, but then moving and being despawned before it can be drawn, we wait one frame before moving so the player knows they threw a spear
	lda ent_state+1
	bne @normal
	inc ent_state+1		;No need to fetch new animation / frame data here, and now we're ready to go
	rts
@normal:
	lda ent_dir+1
	beq SpearUp
	cmp #1
	beq SpearDown
	cmp #2
	beq SpearLeft
SpearRight:
	lda ent_hb_x+1
	clc
	adc #4
	bcc @stillonscreen
	DeactivateEnt
	rts
@stillonscreen:
	sta ent_hb_x+1
	lda ent_x+1
	clc
	adc #4
	sta ent_x+1
	jsr EntCheckBGColTR
	jmp EntCheckBGColBR
	
SpearUp:
	lda ent_y+1
	sec
	sbc #4
	cmp #40				;top screen border
	bcs @stillonscreen
	DeactivateEnt
	rts
@stillonscreen:
	sta ent_y+1
	lda ent_hb_y+1
	sec
	sbc #4
	sta ent_hb_y+1
	jsr EntCheckBGColTL
	jmp EntCheckBGColTR
	
SpearDown:
	lda ent_hb_y+1
	clc
	adc #4
	cmp #240			;bottom screen border
	bcc @stillonscreen
	DeactivateEnt
	rts
@stillonscreen:
	sta ent_hb_y+1
	lda ent_y+1
	clc
	adc #4
	sta ent_y+1
	jsr EntCheckBGColBL
	jmp EntCheckBGColBR
	
SpearLeft:
	lda ent_x+1
	sec
	sbc #4
	bcs @stillonscreen
	DeactivateEnt
	rts
@stillonscreen:
	sta ent_x+1
	lda ent_hb_x+1
	sec
	sbc #4
	sta ent_hb_x+1
	jsr EntCheckBGColTL
	jmp EntCheckBGColBL