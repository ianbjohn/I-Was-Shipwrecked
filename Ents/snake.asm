	;Turn this into more of what you'd think of as a "State Machine", with indirect subroutines and whatnot
	;Better AI might be:
		;every 5 seconds or so, move either up or down if the player is respectively above or below the snake, and the same thing for left or right (Decide randomly to move horizontal or vertical)
		;When hit with a weapon, retreat for a few seconds
		;Spit venom
	;code is still very sloppy in general, so go through and rewrite (as pseudo first, obv)
SnakeRoutine:
	;if health is zero, (change to explosion ent, but for now) deactivate ent
SnakeCheckDead:
	lda ent_health,x
	bne SnakeCheckDeadDone
	lda ent_timer1,x
	bne SnakeCheckDeadDone		;only actually deactivate ent once the explosion from the hit is done
	
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
	lda #0
	sta ent_state,x
	jmp InitEnt
SnakeCheckDeadDone:
	
	;animation timer stuff
SnakeAdvanceAnimation:
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
SnakeAdvanceAnimationDone:

	;if snake's PHI timer is not 0, decrement it
SnakeDecPHI:
	lda ent_phi_timer,x
	beq SnakeDecPHIDone
	dec ent_phi_timer,x
	jmp SnakeCheckKnifeColDone	;don't register hits from the player's weapon if still in PHI
SnakeDecPHIDone:

								;KNIFE COLLISION CODE
	;check if hit knife
SnakeCheckKnifeCol:
	lda ent_state,x
	cmp #3						;HIT
	beq SnakeCheckKnifeColDone
	lda ent_active+1
	beq SnakeCheckKnifeColDone
	jsr CheckPlayerWeaponCollision
	beq SnakeCheckKnifeColDone
SnakeKnifeCol:
	;subtract hp from snakes
	lda ent_health,x
	sec
	sbc ent_health+1
	bcs @nounderflow
	lda #0
@nounderflow:
	sta ent_health,x
	ldy #SFX_ENEMYHURT
	jsr PlaySound
	;reverse snake's direction
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
SnakeCheckKnifeColDone:

CheckSnakeDirChange:
	lda ent_state,x
	;cmp #$00			;SLITHERING
	bne CheckSnakeDirChangeDone
	lda ent_timer1,x
	clc
	adc #1
	cmp #60
	bne @done
	;change directions
	lda random
	clc
	adc ent_index
	adc ent_id,x
	adc ent_x,x
	adc ent_y,x
	and #%00000011
	sta ent_dir,x
	lda #0
@done:
	sta ent_timer1,x
CheckSnakeDirChangeDone:

	;main AI logic
	lda ent_state,x
	cmp #2				;RETREATING
	bne SnakeCheckHit
	jmp SnakeRetreating
SnakeCheckHit:
	cmp #3				;HIT
	bne SnakeCheckAttack
	dec ent_timer1,x
	bne @rts
	lda #60
	sta ent_phi_timer,x
	lda #2				;RETREATING
	sta ent_state,x
	lda #0
	sta ent_anim_timer,x
	sta ent_anim_frame,x
	jmp FindEntAnimLengthsAndFrames
@rts:
	rts
	
SnakeCheckAttack:
	;don't register hits on the player if he's dead
	lda player_still_alive
	bne @continue
	rts
@continue:
	;If the player's X and Y are both within 40 pixels of the snake, it will attack
	;TODO: This could probably be optimized better with the ABS macro (maybe)
	;the center-middle of the player should be targeted.
	;temp0 and temp1 are used to get the x-middle and y-center of the player, respectively
	;x
	lda ent_x+0
	clc
	adc ent_hb_x+0
	ror						;This little fast midpoint trick I discovered is documented somewhere in the code (I believe in the BG collision routines)
	sta temp0
	;y
	lda ent_y+0
	clc
	adc ent_hb_y+0
	ror
	sta temp1
SnakeCheckAttack_l:
	lda temp0
	cmp ent_x,x
	bcs SnakeCheckAttack_r
	lda ent_x,x
	sec
	sbc temp0
	cmp #40
	bcc SnakeSetAttack
	bcs SnakeSetSlither
SnakeCheckAttack_r:
	lda ent_hb_x,x
	cmp temp0
	bcs SnakeCheckAttack_u
	lda temp0
	sec
	sbc ent_hb_x,x
	cmp #40
	bcc SnakeSetAttack
	bcs SnakeSetSlither
SnakeCheckAttack_u:
	lda temp1
	cmp ent_y,x
	bcs SnakeCheckAttack_d
	lda ent_y,x
	sec
	sbc temp1
	cmp #32
	bcc SnakeSetAttack
	bcs SnakeSetSlither
SnakeCheckAttack_d:
	lda ent_hb_y,x
	cmp temp1
	bcs SnakeSetAttack
	lda temp1
	sec
	sbc ent_hb_y,x
	cmp #32
	bcs SnakeSetSlither
SnakeSetAttack:
	lda #1
	sta ent_state,x
	jmp SnakeAttacking
SnakeSetSlither
	lda #0
	sta ent_state,x
	jmp SnakeSlithering
	
SnakeRetreating:
	lda ent_phi_timer,x
	bne @continue
	lda #0
	sta ent_state,x
	sta ent_timer1,x
	rts
@continue:
	lda ent_dir,x
	beq @up
	cmp #1
	beq @down
	cmp #2
	beq @left
	bne @right
@up:
	lda ent_y,x
	sec
	sbc #1
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
	adc #1
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
	sbc #1
	sta ent_x,x
	clc
	adc ent_width,x
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
@right:
	lda ent_x,x
	clc
	adc #1
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
	jsr EntCheckBGColTR
	jmp EntCheckBGColBR
SnakeRetreatingDone:

SnakeSlithering:
	lda ent_dir,x
	beq @up
	cmp #1
	beq @down
	cmp #2
	beq @left
	bne @right
@up:
	lda ent_ysp,x
	sec
	sbc #$80
	sta ent_ysp,x
	lda ent_y,x
	sbc #0
	sta ent_hb_y,x
	clc
	adc ent_height,x
	sta ent_hb_y,x
	jsr EntCheckBGColTL
	jmp EntCheckBGColTR
@down:
	lda ent_ysp,x
	clc
	adc #$80
	sta ent_ysp,x
	lda ent_y,x
	adc #0
	sta ent_y,x
	clc
	adc ent_height,x
	sta ent_hb_y,x
	jsr EntCheckBGColBL
	jmp EntCheckBGColBR
@left:
	lda ent_xsp,x
	sec
	sbc #$80
	sta ent_xsp,x
	lda ent_x,x
	sbc #0
	sta ent_x,x
	clc
	adc ent_width,x
	sta ent_hb_x,x
	jsr EntCheckBGColTL
	jmp EntCheckBGColBL
@right:
	lda ent_xsp,x
	clc
	adc #$80
	sta ent_xsp,x
	lda ent_x,x
	adc #0
	sta ent_x,x
	clc
	adc ent_width,x
	sta ent_hb_x,x
	jsr EntCheckBGColTR
	jmp EntCheckBGColBR
	
SnakeAttacking:
	lda #1
	sta ent_state,x
	
SnakeCheckPlayerCol:			;PLAYER COLLISION CODE
@up:
	lda ent_y,x
	cmp ent_hb_y+0
	beq @down
	bcc @down
	lda #0
	sta ent_dir,x
	lda ent_y,x
	sec
	sbc #1
	sta ent_y,x
	clc
	adc ent_height,x
	sta ent_hb_y,x
	jsr EntCheckBGColTL
	jmp EntCheckBGColTR
@down:
	lda ent_hb_y,x
	cmp ent_y+0
	bcs @left
	lda #1
	sta ent_dir,x
	lda ent_y,x
	clc
	adc #1
	sta ent_y,x
	clc
	adc ent_height,x
	sta ent_hb_y,x
	jsr EntCheckBGColBL
	jmp EntCheckBGColBR
@left:
	lda ent_x,x
	cmp ent_hb_x+0
	beq @right
	bcc @right
	lda #2
	sta ent_dir,x
	lda ent_x,x
	sec
	sbc #1
	sta ent_x,x
	clc
	adc ent_width,x
	sta ent_hb_x,x
	jsr EntCheckBGColTL
	jmp EntCheckBGColBL
@right:
	lda ent_hb_x,x
	cmp ent_x+0
	bcs SnakePlayerCol
	lda #3
	sta ent_dir,x
	lda ent_x,x
	clc
	adc #1
	sta ent_x,x
	clc
	adc ent_width,x
	sta ent_hb_x,x
	jsr EntCheckBGColTR
	jmp EntCheckBGColBR
SnakePlayerCol:
	;snake has collided with player
	lda ent_phi_timer+0
	bne SnakePlayerCol_done
	;(only take away a little bit of health)
	;(signal that the player is flashing)
	;(if player isn't already flashing, set timer)
	;I think I'll have the damage just be hard-coded for now and just have it take less damage when player levels up or whatever
				;Set up a formula for this somehow (In Ent Data, differentiate between damage and health. How much damage the player takes will involve the enemy's damage and the player's level)
	lda ent_health+0
	sec
	sbc #10
	bcs @nounderflow
	lda #0
@nounderflow:
	sta ent_health+0
	lda #120
	sta ent_phi_timer+0
	;if poisonous snake and a random chance occurs, poison the player
	lda ent_id,x
	cmp #ENT_POISONSNAKE
	bne @nopoison
	lda status
	cmp #STATUS_POISONED
	beq @nopoison
	lda random
	jsr RandomLFSR
	and #%00000111			;1/8 chance
	bne @nopoison
	lda #MSG_POISONED
	sta message
	lda #STATE_DRAWINGMBOX
	sta game_state
	ldy #SFX_OHSHIT
	jmp PlaySound
@nopoison:
	ldy #SFX_PLAYERHURT		;play sfx
	jmp PlaySound
SnakePlayerCol_done:
	rts