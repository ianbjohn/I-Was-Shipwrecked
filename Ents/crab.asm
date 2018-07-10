	;.db "CRAB"
CrabStates:
	.dw CrabMoving,CrabStill,CrabGrabbing,CrabHit
	
CrabRoutine:
CrabCheckDead:
	lda ent_health,x
	bne CrabCheckDeadDone
	lda ent_timer1,x
	bne CrabCheckDeadDone		;only actually deactivate ent once the explosion from the hit is done
	
	dec num_active_enemies
	
	;randomly drop either meat, heart, or nothing
	lda random
	and #%00000111
	tay
	lda EnemyItemDrops,y
	bne @continue			;if SOMETHING should be dropped, then do it. Otherwise, just deactivate whatever ent this is
	jmp DeactivateEnt
@continue:
	sta ent_id,x
	;change from a 16x16 hitbox to an 8x8 hitbox
	;get rid of this code once hitbox widths and heights are determined by ent states and kept in RAM
	;lda ent_x,x
	;clc
	;adc #7
	;sta ent_hb_x,x
	;lda ent_y,x
	;clc
	;adc #7
	;sta ent_hb_y,x
	jmp InitEnt
CrabCheckDeadDone:

CrabAdvanceAnimation:
	lda ent_anim_timer,x
	clc
	adc #1
	cmp ent_anim_length,x
	bcc @continue
	;set timer back to 0, increment frame
	lda ent_anim_frame,x
	clc
	adc #1
	cmp ent_anim_frames,x
	bcc @continue2
	lda #0					;even if frame didn't get set back to 0, timer needs to be
@continue2:
	sta ent_anim_frame,x
	lda #0
@continue:
	sta ent_anim_timer,x
CrabAdvanceAnimationDone:

CrabDecPHI:
	lda ent_phi_timer,x
	beq CrabDecPHIDone
	dec ent_phi_timer,x
	jmp CrabCheckKnifeColDone	;don't register hits from the player's weapon if still in PHI
CrabDecPHIDone:

CrabCheckKnifeCol:
	lda ent_state,x
	cmp #3				;hit
	beq CrabCheckKnifeColDone
	lda ent_active+1
	beq CrabCheckKnifeColDone
	jsr CheckPlayerWeaponCollision
	beq CrabCheckKnifeColDone
CrabKnifeCol:
	;subtract hp from Crabs
	lda ent_health,x
	sec
	sbc ent_health+1
	bcs @nounderflow
	lda #0
@nounderflow:
	sta ent_health,x
	ldy #SFX_ENEMYHURT
	jsr PlaySound
	;reverse Crab's direction
	ldx ent_index
	lda ent_dir,x
	beq @swapvert
	cmp #1
	beq @swapvert
@swaphor:
	eor #%00000001
	bpl @swapdone		;will always branch
@swapvert:
	eor #%00000010
@swapdone:
	sta ent_dir,x
	
	lda #EXPLOSION_TIME
	sta ent_timer1,x
	lda #3				;HIT
	sta ent_state,x
	lda #0
	sta ent_anim_timer,x
	sta ent_anim_frame,x
	jmp FindEntAnimLengthsAndFrames
CrabCheckKnifeColDone:

CrabCheckPlayerCol:
	;if moving || still, check player collision
	lda ent_state,x
	;cmp #0			;moving
	beq @continue
	cmp #1			;still
	bne CrabCheckPlayerColDone
@continue:
	jsr CheckPlayerCollision
	beq CrabCheckPlayerColDone
	lda #2				;grabbing
	sta ent_state,x
	jmp FindEntAnimLengthsAndFrames
CrabCheckPlayerColDone:

	;Go to individual code for each state
	lda ent_state,x
	asl
	tay
	lda CrabStates+0,y
	sta jump_ptr+0
	lda CrabStates+1,y
	sta jump_ptr+1
	jmp (jump_ptr)


CrabMoving:
	lda ent_timer1,x
	clc
	adc #1
	cmp ent_time1,x
	bne @continue
	lda #1				;still
	sta ent_state,x
	lda random
	jsr RandomLFSR
	and #%00111000
	ora #%00000111
	sta ent_time1,x
	lda #0
	sta ent_timer1,x
	jmp FindEntAnimLengthsAndFrames
@continue:
	sta ent_timer1,x
	lda ent_dir,x
	beq @up
	cmp #1
	beq @down
	cmp #2
	beq @left
@right:
	lda ent_x,x
	clc
	adc #2
	sta ent_x,x
	clc
	adc ent_width,x
	sta ent_hb_x,x
	bcc @rightcheckbgcol
	lda #-1
	sta ent_hb_x,x
	sec
	sbc ent_width,x
	sta ent_x,x
	rts
@rightcheckbgcol:
	;background collision
	jsr EntCheckBGColTR
	jmp EntCheckBGColBR
@up:
	lda ent_y,x
	sec
	sbc #2
	sta ent_y,x
	clc
	adc ent_height,x
	sta ent_hb_y,x
	lda ent_y,x
	cmp #48				;status board height
	bcs @upcheckbgcol
	lda #48
	sta ent_y,x
	clc
	adc ent_height,x
	sta ent_hb_y,x
	rts
@upcheckbgcol:
	jsr EntCheckBGColTL
	jmp EntCheckBGColTR
@down:
	lda ent_y,x
	clc
	adc #2
	sta ent_y,x
	clc
	adc ent_height,x
	sta ent_hb_y,x
	cmp #224
	bcc @downcheckbgcol
	lda #223
	sta ent_hb_y,x
	sec
	sbc ent_height,x
	sta ent_y,x
	rts
@downcheckbgcol:
	jsr EntCheckBGColBL
	jmp EntCheckBGColBR
@left:
	lda ent_x,x
	sec
	sbc #2
	sta ent_x,x
	clc
	adc ent_height,x
	sta ent_hb_x,x
	cmp #15
	bcs @leftcheckbgcol
	lda #15
	sta ent_hb_x,x
	sec
	sbc ent_width,x
	sta ent_x,x
	rts
@leftcheckbgcol:
	jsr EntCheckBGColTL
	jmp EntCheckBGColBL
	
	
CrabStill:
;If timer is up:
		;If (1/2 chance):
			;Set direction as random
		;Else:
			;If (1/2 chance):
				;If player is above crab
					;Set direction to up
				;Else
					;Set direction to down
			;Else:
				;If player is to the left of crab
					;Set direction to left
				;Else
					;set direction to right
		;reset timer
	lda ent_timer1,x
	clc
	adc #1
	cmp ent_time1,x
	bne @done
	lda #0			;MOVING
	sta ent_state,x
	lda random
	jsr RandomLFSR
	and #%00000001
	beq @random
	;move towards player
	jsr RandomLFSR
	and #%00000001
	beq @vert
@horiz:
	lda ent_x,x
	cmp ent_hb_x+0
	bcc @right
@left:
	lda #2
	bne @changedir
@right:
	lda #3
	bne @changedir
@vert:
	lda ent_y,x
	cmp ent_hb_y+0
	bcc @down
@up:
	lda #0
	beq @changedir
@down:
	lda #1
@changedir:
	sta ent_dir,x
	jmp @movementdone
@random:
	;change directions
	lda random
	clc
	adc ent_index
	adc ent_anim_frame,x
	adc ent_x,x
	adc ent_y,x
	and #%00000011
	sta ent_dir,x
@movementdone:
	lda random
	and #%00111000
	ora #%00000111
	sta ent_time1,x
	lda #0
@done:
	sta ent_timer1,x
	rts
	
	;.db "GRAB"
CrabGrabbing:
	;if the player fidgets the D-Pad fast enough, the crab'll stop grabbing
	lda buttons_old
	and #%00000011			;left and right presses
	sta temp0
	lda buttons
	and #%00000011
	sta temp1
	lda temp0
	eor temp1
	cmp #%00000011
	bne @grab				;still grabbing
	lda #1			;still
	sta ent_state,x
	;(for now, set the crab to the middle of the screen until "flying" is implemented)
	lda #$80
	sta ent_x,x
	sta ent_y,x
	clc
	adc ent_width,x
	sta ent_hb_x,x
	sta ent_hb_y,x
	lda #0
	sta ent_timer1,x
	lda random
	jsr RandomLFSR
	and #%00111000
	ora #%00000111
	sta ent_time1,x
	jmp FindEntAnimLengthsAndFrames
@grab:
	lda ent_x+0
	clc
	adc ent_hb_x+0
	ror
	sta temp0		;get midpoint of player's width
	lda ent_y+0
	clc
	adc ent_hb_y+0
	ror
	sta temp1		;get midpoint of player's height
	lda temp0
	sta ent_x,x
	clc
	adc ent_width,x
	sta ent_hb_x,x
	lda temp1
	sta ent_y,x
	clc
	adc ent_height,x
	sta ent_hb_y,x
	;hurt player if PHI is up
	;snake has collided with player
	lda ent_phi_timer+0
	bne CrabGrabbingDone
	lda ent_health+0
	sec
	sbc #5
	bcs @nounderflow
	lda #0
@nounderflow:
	sta ent_health+0
	lda #120
	sta ent_phi_timer+0
	ldy #SFX_PLAYERHURT		;play sfx
	jmp PlaySound
CrabGrabbingDone:
	rts
	
	
CrabHit:
	lda ent_timer1,x
	sec
	sbc #1
	bcs @done
	lda #0
	sta ent_timer1,x
	lda #60
	sta ent_phi_timer,x
	lda #1				;still
	sta ent_state,x
	lda random
	jsr RandomLFSR
	and #%00111000
	ora #%00000111
	sta ent_time1,x
	jmp FindEntAnimLengthsAndFrames
@done:
	sta ent_timer1,x
	rts