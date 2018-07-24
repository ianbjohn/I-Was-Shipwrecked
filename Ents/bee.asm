BeeStates:
	.dw BeeForaging, BeeReturning, BeeGuarding, BeeSwarming, BeeAttacking, BeeEnteringHive, BeeInsideHive, BeeHit
	
BeeRoutine:
BeeAdvanceAnimation:
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
BeeAdvanceAnimationDone:

	;Deactivate bee after getting hit
	lda ent_state,x		;if bee exploded, decrement timer1
	cmp #7				;explosion
	bne BeeCheckAttack
	dec ent_timer1,x
	lda ent_timer1,x
	bne @rts
	;bee will be dead at this point
	dec num_active_enemies
	
	;randomly drop stuff
	lda random
	and #%00000011
	tay
	lda EnemyItemDrops,y
	bne @continue
	jmp DeactivateEnt

BeeCheckKnifeCol:
	lda ent_state,x
	cmp #7				;hit
	beq BeeCheckKnifeColDone
	lda ent_active+1
	beq BeeCheckKnifeColDone
	jsr CheckPlayerWeaponCollision
	beq BeeCheckKnifeColDone
	;set bee HP to 0
	lda #0
	sta ent_health,x
	
	lda #EXPLOSION_TIME
	sta ent_timer1,x
	lda #7
	sta ent_state,x
	lda #0
	sta ent_anim_timer,x
	sta ent_anim_frame,x
	;ldx ent_index
	jmp FindEntAnimLengthsAndFrames
BeeCheckPlayerWeaponCol_done:

BeeCheckPlayerCol:
	lda player_still_alive
	bne @checkattack
	rts
@checkattack:
	;if attacking, check player collision
	lda ent_state,x
	cmp #4				;attacking
	bne BeeCheckPlayerCollisionDone
@continue:
	jsr CheckPlayerCollision
	beq BeeCheckPlayerColDone
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
BeeCheckPlayerColDone:

	;go to individual code for each state
	lda ent_state,x
	asl
	tay
	lda BeeStates+0,y
	sta jump_ptr+0
	lda BeeStates+1,y
	sta jump_ptr+1
	jmp (jump_ptr)
	
	
BeeForaging:
BeeReturning:
BeeGuarding:
BeeSwarming:
	rts


BeeAttacking:
@horiz:
	lda random
	and #%00000001
	beq @left
@right:
	lda ent_x,x
	clc
	adc #1
	sta ent_x,x
	lda ent_hb_x,x
	clc
	adc #1
	sta ent_hb_x,x
	;lda #RIGHT
	;sta ent_dir,x
	;bne @vert			;w.a.b
	jmp @vert
@left:
	lda ent_x,x
	sec
	sbc #1
	sta ent_x,x
	lda ent_hb_x,x
	sec
	sbc #1
	sta ent_hb_x,x
	;lda #LEFT
	;sta ent_dir,x
@vert:
	lda random
	and #%00000010
	beq @up
@down:
	lda ent_y,x
	clc
	adc #1
	sta ent_y,x
	lda ent_hb_y,x
	clc
	adc #1
	sta ent_hb_y,x
	;lda #DOWN
	;sta ent_dir,x
	rts
@up:
	lda ent_y,x
	sec
	sbc #1
	sta ent_y,x
	lda ent_hb_y,x
	sec
	sbc #1
	sta ent_hb_y,x
	;lda #UP
	;sta ent_dir,x
	rts
	
	
BeeEnteringHive:
BeeInsideHive:
BeeHit:
	rts