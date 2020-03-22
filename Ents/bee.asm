BeeStates:
	.dw BeeForaging, BeeReturning, BeeGuarding, BeeSwarming, BeeAttacking, BeeOnFlower, BeeHit
	
	
BeeInit:
	lda random
	jsr RandomLFSR
	sta ent_misc1,x
	jsr RandomLFSR
	sta ent_misc2,x
	;(either guard the hive or forage for food)
	lda #0				;foraging (for right now)
	sta ent_state,x
	jmp FindEntAnimLengthsAndFrames
	
	
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

BeeCheckKnifeCol:
	lda ent_state,x
	cmp #6				;hit
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
	lda #6
	sta ent_state,x
	lda #0
	sta ent_anim_timer,x
	sta ent_anim_frame,x
	;ldx ent_index
	jmp FindEntAnimLengthsAndFrames
BeeCheckKnifeColDone:

BeeCheckPlayerCol:
	lda player_still_alive
	bne @checkattack
	rts
@checkattack:
	;if attacking, check player collision
	lda ent_state,x
	cmp #4				;attacking
	bne BeeCheckPlayerColDone
@continue:
	jsr CheckPlayerCollision
	beq BeeCheckPlayerColDone
	;hurt player if PHI is up
	lda ent_phi_timer+0
	bne BeeCheckPlayerColDone
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

BeeCheckBeehive:
	;if the beehive isn't active (if it's been destroyed), go to swarm state
	lda ent_state,x
	cmp #6				;hit
	beq BeeCheckBeehiveDone
	lda beehive_ent_slot
	bne BeeCheckBeehiveDone		;if not 0, the beehive is still there
	lda #3						;swarming
	sta ent_state,x				;No real need to reload animation data here since it's the same
BeeCheckBeehiveDone:

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
	;When a bee is spawned from the beehive, if it starts out foraging, it should be given a random spot in ent_misc1 and ent_misc2 as the X and Y (respectively) of where to go
	;once it's been to this spot, (ADD A HOVERING STATE WHERE IT'LL HOVER AROUND THE SPOT FOR A FEW SECONDS), either return to the hive or generate coordinates of a new spot to go to.
	;TODO: If the player is within a certain distance of the bee and attacks, the bee should swarm
	lda ent_x,x
	cmp ent_misc1,x
	bne @movetowardsforagespot
	lda ent_y,x
	cmp ent_misc2,x
	bne @movetowardsforagespot
	lda random
	jsr RandomLFSR
	and #%00000001
	beq @newforage
@return:
	lda #1				;returning
	sta ent_state,x
	ldy beehive_ent_slot
	lda ent_x,y
	clc
	adc #4				;return to beehive entrance
	sta ent_misc1,x
	lda ent_y,y
	clc
	adc #12
	sta ent_misc2,x
	rts
@newforage:
	clc
	adc random
	jsr RandomLFSR
	sta ent_misc1,x
	jsr RandomLFSR
	sta ent_misc2,x
	rts
@movetowardsforagespot:
@horiz:
	lda ent_x,x
	cmp ent_misc1,x
	beq @vert
	bcs @left
@right:
	clc
	adc #1
	sta ent_x,x
	clc
	adc ent_width,x
	sta ent_hb_x,x
	lda #RIGHT
	sta ent_dir,x
	jmp @vert
@left:
	sec
	sbc #1
	sta ent_x,x
	clc
	adc ent_width,x
	sta ent_hb_x,x
	lda #LEFT
	sta ent_dir,x
	
@vert:
	lda ent_y,x
	cmp ent_misc2,x
	beq @done
	bcs @up
@down:
	clc
	adc #1
	sta ent_y,x
	clc
	adc ent_height,x
	sta ent_hb_y,x
	lda #DOWN
	sta ent_dir,x
	rts
@up:
	sec
	sbc #1
	sta ent_y,x
	clc
	adc ent_height,x
	sta ent_hb_y,x
	lda #UP
	sta ent_dir,x
@done:
	rts
	
	
BeeReturning:
	;When the bee returns from foraging, the coordinates of the hive should be saved in ent_misc1 and 2 respectively
	;return to these coordinates
	;TODO: Swarm player if he attacks near the bee, same as in BeeForaging (Make it a helper function or something)
	
	;once at the spot, enter the hive (deactivate)
	lda ent_x,x
	cmp ent_misc1,x
	bne @movetowardshive
	lda ent_y,x
	cmp ent_misc2,x
	bne @movetowardshive
	DeactivateEnt
	rts
@movetowardshive:
@horiz:
	lda ent_x,x
	cmp ent_misc1,x
	beq @vert
	bcs @left
@right:
	clc
	adc #1
	sta ent_x,x
	clc
	adc ent_width,x
	sta ent_hb_x,x
	lda #RIGHT
	sta ent_dir,x
	jmp @vert
@left:
	sec
	sbc #1
	sta ent_x,x
	clc
	adc ent_width,x
	sta ent_hb_x,x
	lda #LEFT
	sta ent_dir,x
	
@vert:
	lda ent_y,x
	cmp ent_misc2,x
	beq @done
	bcs @up
@down:
	clc
	adc #1
	sta ent_y,x
	clc
	adc ent_height,x
	sta ent_hb_y,x
	lda #DOWN
	sta ent_dir,x
	rts
@up:
	sec
	sbc #1
	sta ent_y,x
	clc
	adc ent_height,x
	sta ent_hb_y,x
	lda #UP
	sta ent_dir,x
@done:
	rts
	
	
BeeSwarming:
	;get the X and Y positions of the player's midpoint, and move towards him
	lda ent_x+0
	clc
	adc ent_hb_x+0
	ror
	sta ent_misc1,x
	lda ent_y+0
	clc
	adc ent_hb_y+0
	ror
	sta ent_misc2,x
	
@horiz:
	lda ent_x,x
	cmp ent_misc1,x
	bcs @left
@right:
	clc
	adc #2
	sta ent_x,x
	clc
	adc ent_width,x
	sta ent_hb_x,x
	lda #RIGHT
	sta ent_dir,x
	jmp @vert
@left:
	sec
	sbc #2
	sta ent_x,x
	clc
	adc ent_width,x
	sta ent_hb_x,x
	lda #LEFT
	sta ent_dir,x
	
@vert:
	lda ent_y,x
	cmp ent_misc2,x
	bcs @up
@down:
	clc
	adc #2
	sta ent_y,x
	clc
	adc ent_height,x
	sta ent_hb_y,x
	lda #DOWN
	sta ent_dir,x
	rts
@up:
	sec
	sbc #2
	sta ent_y,x
	clc
	adc ent_height,x
	sta ent_hb_y,x
	lda #UP
	sta ent_dir,x
	rts


BeeGuarding:
	;If guarding, check and see if the timer's up. If so, either enter the hive or start foraging
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
	
	
BeeOnFlower:
	;once timer hits 0, either pick a new spot to forage or return to hive

BeeHit:
	dec ent_timer1,x
	bne @done
	dec num_active_enemies
	DeactivateEnt			;For right now I don't think bees should drop anything
@done:
	rts
