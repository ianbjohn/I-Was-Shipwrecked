BeeRoutine:
	;for right now, bee hurts player when it touches him, and dies instantly when it touches weapon
	;The different states will make this more complicated later, but we don't need to worry about PHI since bees will always die in one hit

	;animation timer stuff
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

	;Main AI logic
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
@continue:
	sta ent_id,x
	jmp InitEnt
@rts:
	rts
	
BeeCheckAttack:
	;don't register hits on the player if he's dead
	lda player_still_alive
	bne @continue:
	rts
@continue:
	;If player is close to the hive, or close to the bee and attacks, the bee should attack
		;(We haven't gotten there yet though)

	;randomly move the bee about like a spaz
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
	jmp BeeCheckPlayerWeaponCol
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

BeeCheckPlayerWeaponCol:
	lda ent_active+1
	beq BeeCheckPlayerCol
	jsr CheckPlayerWeaponCollision
	beq BeeCheckPlayerWeaponCol_done
BeePlayerWeaponCol:
	;set bee HP to 0
	lda #0
	sta ent_health,x
	
	lda #EXPLOSION_TIME
	sta ent_timer1,x
	lda #7				;HIT
	sta ent_state,x
	lda #0
	sta ent_anim_timer,x
	sta ent_anim_frame,x
	;ldx ent_index
	jmp FindEntAnimLengthsAndFrames
BeeCheckPlayerWeaponCol_done:

BeeCheckPlayerCol:
@up:
	lda ent_y,x
	cmp ent_hb_y+0
	beq @down
	bcc @down
	rts
@down:
	lda ent_hb_y,x
	cmp ent_y+0
	bcs @left
	rts
@left:
	lda ent_x,x
	cmp ent_hb_x+0
	beq @right
	bcc @right
	rts
@right:
	lda ent_hb_x,x
	cmp ent_x+0
	bcs BeePlayerCol
	rts
BeePlayerCol:
	lda ent_phi_timer+0
	bne BeePlayerCol_done
	
	lda ent_health+0
	sec
	sbc #5
	bcs @nounderflow
	lda #0
@nounderflow:
	sta ent_health+0
	;(if a random chance occurs, poison player)
	lda #120
	sta ent_phi_timer+0
	ldy #SFX_PLAYERHURT		;play sfx
	jsr PlaySound
BeePlayerCol_done:
	rts