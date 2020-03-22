FLYING_ACCELERATION = $0050
BASE_FLYING_VELOCITY = $0500
STOP_FLYING_VELOCITY = -BASE_FLYING_VELOCITY


CrabStates:
	.dw CrabMoving,CrabStill,CrabGrabbing,CrabFlying,CrabHit
	
	
CrabInit:
	lda random
	jsr RandomLFSR
	and #%00111000
	ora #%00000111
	clc
	adc #1
	sta ent_timer1,x		;Need an initial time to move randomly
	jmp FindEntAnimLengthsAndFrames
	
	
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
	DeactivateEnt
	rts
@continue:
	sta ent_id,x
	lda #0
	sta ent_state,x
	jmp InitEnt
CrabCheckDeadDone:

	jsr EntAdvanceAnimation

CrabDecPHI:
	lda ent_phi_timer,x
	beq CrabDecPHIDone
	dec ent_phi_timer,x
	jmp CrabCheckKnifeColDone	;don't register hits from the player's weapon if still in PHI
CrabDecPHIDone:

CrabCheckKnifeCol:
	lda ent_state,x
	cmp #4				;hit
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
	lda #4				;HIT
	sta ent_state,x
	jmp FindEntAnimLengthsAndFrames
CrabCheckKnifeColDone:

CrabCheckPlayerCol:
	lda player_still_alive
	bne @checkattack
	rts
@checkattack:
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
	dec ent_timer1,x
	bne @continue
	lda #1				;still
	sta ent_state,x
	lda random
	jsr RandomLFSR
	and #%00111000
	ora #%00000111
	clc
	adc #1
	sta ent_timer1,x
	jmp FindEntAnimLengthsAndFrames
@continue:
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
	dec ent_timer1,x
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
	;reset timer
	lda random
	jsr RandomLFSR
	and #%00111000
	ora #%00000111
	clc
	adc #1
	sta ent_timer1,x
@done:
	rts
	

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
	lda #3					;flying
	sta ent_state,x
	lda random
	jsr RandomLFSR
	and #%00000001			;fly either left or right
	ora #%00000010
	sta ent_dir,x
	lda #<BASE_FLYING_VELOCITY
	sta ent_yvel_sp,x
	;lda #>FLYING_ACCELERATIN
	sta ent_yacc,x
	lda #>BASE_FLYING_VELOCITY
	sta ent_yvel,x
	lda #<FLYING_ACCELERATION
	sta ent_yacc_sp,x
	rts
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
	
	;.db "fly"
CrabFlying:
	;move in a parabolic arc
	lda ent_yvel_sp,x
	sec
	sbc ent_yacc_sp,x
	sta ent_yvel_sp,x
	lda ent_yvel,x
	sbc ent_yacc,x
	sta ent_yvel,x
	;if velocity < negative base flying velocity, stop flying
	;signed 16-bit comparison for <
	;Thanks to 6502.org for this
	lda ent_yvel,x
	sec
	sbc #>STOP_FLYING_VELOCITY
	bvc @vc
	eor #$80
@vc:
	bpl @pl
	jmp @doneflying
@pl:
	bvc @checklo
	eor #$80
@checklo:
	bne @fly
	lda ent_yvel_sp,x
	sbc #<STOP_FLYING_VELOCITY
	bcc @doneflying
@fly:
	lda ent_ysp,x
	sec
	sbc ent_yvel_sp,x
	sta ent_ysp,x
	lda ent_y,x
	sec
	sbc ent_yvel,x
	cmp #48
	bcs @nooverflow
	lda #48
@nooverflow:
	sta ent_y,x
	clc
	adc ent_height,x
	sta ent_hb_y,x
	lda ent_dir,x
	pha
	;vertical collision detection
	lda #0
	sta ent_dir,x
	jsr EntCheckBGColTL
	jsr EntCheckBGColTR
	inc ent_dir,x
	jsr EntCheckBGColBL
	jsr EntCheckBGColBR
	pla
	sta ent_dir,x
	cmp #2
	beq @left
@right:
	lda ent_hb_x,x
	clc
	adc #2
	bcc @nooverflow2
	lda #255
@nooverflow2:
	sta ent_hb_x,x
	sec
	sbc ent_width,x
	sta ent_x,x
	jsr EntCheckBGColTR
	jmp EntCheckBGColBR
	;rts
@left:
	lda ent_x,x
	sec
	sbc #2
	bcs @nounderflow
	lda #0
@nounderflow:
	sta ent_x,x
	clc
	adc ent_width,x
	sta ent_hb_x,x
	jsr EntCheckBGColTL
	jmp EntCheckBGColBL
	;rts
@doneflying:
	lda random
	jsr RandomLFSR
	clc
	adc #1
	sta ent_timer1,x
	lda #1					;still
	sta ent_state,x
	jmp FindEntAnimLengthsAndFrames
	
	
CrabHit:
	dec ent_timer1,x
	bne @done
	lda ent_health,x
	beq @done
	lda #0
	lda #60
	sta ent_phi_timer,x
	lda #1				;still
	sta ent_state,x
	lda random
	jsr RandomLFSR
	and #%00111000
	ora #%00000111
	clc
	adc #1
	sta ent_timer1,x
	jmp FindEntAnimLengthsAndFrames
@done:
	rts