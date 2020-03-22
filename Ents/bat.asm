BAT_ACCEL = $0070
BAT_DECCEL	= $0070
BAT_MAX_VEL = $0300
DETECTION_RADIUS = 48

BatStates:
	.dw BatPerched, BatFlying, BatGliding, BatHit

BatRoutine:
BatCheckDead:
	lda ent_health,x
	bne BatCheckDeadDone
	lda ent_timer1,x
	bne BatCheckDeadDone
	
	dec num_active_enemies
	
	lda random
	and #%00000111
	tay
	lda EnemyItemDrops,y
	bne @continue
	DeactivateEnt
	rts
@continue:
	sta ent_id,x
	lda #0
	sta ent_state,x
	jmp InitEnt
BatCheckDeadDone:

	jsr EntAdvanceAnimation

BatDecPHI:
	lda ent_phi_timer,x
	beq BatDecPHIDone
	dec ent_phi_timer,x
	jmp BatCheckKnifeColDone
BatDecPHIDone:

BatCheckKnifeCol:
	lda ent_state,x
	cmp #3				;hit
	beq BatCheckKnifeColDone
	lda ent_active+1
	beq BatCheckKnifeColDone
	jsr CheckPlayerWeaponCollision
	beq BatCheckKnifeColDone
BatKnifeCol:
	lda ent_health,x
	sec
	sbc ent_health+1
	bcs @nounderflow
	lda #0
@nounderflow:
	sta ent_health,x
	ldy #SFX_ENEMYHURT
	jsr PlaySound
	ldx ent_index
	lda ent_dir,x
	eor #%00000001		;will only move up/down (left/right actually, but those directions aren't needed)
	sta ent_dir,x
	
	lda #EXPLOSION_TIME
	sta ent_timer1,x
	lda #3				;hit
	sta ent_state,x
	jmp FindEntAnimLengthsAndFrames
BatCheckKnifeColDone:

BatCheckPlayerCol:
	;if flying || fliding, check player collision
	lda ent_state,x
	beq BatCheckPlayerColDone
	cmp #1			;flying
	beq @continue
	cmp #2			;gliding
	bne BatCheckPlayerColDone
@continue:
	lda ent_phi_timer+0
	bne BatCheckPlayerColDone
	jsr CheckPlayerCollision
	beq BatCheckPlayerColDone
	lda ent_health+0
	sec
	sbc #8
	bcs @nounderflow
	lda #0
@nounderflow:
	sta ent_health+0
	lda #120
	sta ent_phi_timer+0
	ldy #SFX_PLAYERHURT
	jmp PlaySound
BatCheckPlayerColDone:
	;Go to individual code for each state
	lda ent_state,x
	asl
	tay
	lda BatStates+0,y
	sta jump_ptr+0
	lda BatStates+1,y
	sta jump_ptr+1
	jmp (jump_ptr)
	

BatPerched:
	;if player is within x distance of bat, change to either flying or gliding depending on above/below player, and set a timer for when to return to perching
@vert:
	lda ent_y+0
	cmp ent_y,x
	bcs @down
@up:
	lda ent_y,x
	sec
	sbc ent_y+0
	cmp #DETECTION_RADIUS
	bcs @done
	bcc @horiz
@down:
	sec				;A has ent_y+0
	sbc ent_y+0
	cmp #DETECTION_RADIUS
	bcs @done
@horiz:
	lda ent_x+0
	cmp ent_x,x
	bcs @right
@left:
	lda ent_x,x
	sec
	sbc ent_x+0
	cmp #DETECTION_RADIUS
	bcs @done
	bcc @trigger
@right:
	sec				;A has ent_x+0
	sbc ent_x+0
	cmp #DETECTION_RADIUS
	bcs @done
@trigger:
	lda #<BAT_ACCEL
	sta ent_xacc_sp,x		;set base acceleration
	sta ent_xvel_sp,x		;set base velocity
	;lda #>BAT_ACCEL
	;sta ent_xacc,x
	;sta ent_xvel,x			;uncomment if acceleration is changed to >255
	lda #2					;gliding
	sta ent_state,x
	;figure out which direction to start flying based on where the player is horizontally in relation to the bat
	lda ent_x+0
	cmp ent_x,x
	bcs @moveright
@moveleft:
	lda #0
	beq @store
@moveright:
	lda #1
@store:
	sta ent_dir,x
	lda ent_x,x
	sta ent_misc1,x			;put this here until init code is added for ents
	lda ent_y,x
	sta ent_misc2,x
	;timer1 will need to be 16-bits since I want the bat to attack for more than 4 seconds
	lda #255
	sta ent_timer1,x
	lda #120
	sta ent_timer2,x
	jmp FindEntAnimLengthsAndFrames
@done:
	rts
	
	
BatFlying:
BatGliding:
	;basically the same state, but I wanna give some animation variety and have the bat only flap its wings if its flying upward.
	
	;if timer1 is 0
		;if we've returned to our original perching spot, set state to perching
		;else
			;keep flying to perching spot
			;if above perch spot, glide
			;otherwise fly
	;else
		;if slowing down == 0
			;if (timer2 == 0 && the player has changed directions in relation to the bat) || bat is <16 pixels from an edge of a screen
				;slowing down = 1
			;else
				;keep accelerating until max velocity is reached
				;decrement timer2
				;if bat is gliding, move down
				;otherwise move up
		;else
			;if velocity == 0
				;flip direction
				;slowing down = 0
				;set timer2
				;set base velocity / acceleration
			;otherwise, deccelerate and keep moving
		;decrement timer1
		;if bat is below player's mixpoint, fly
		;otherwise glide
	
	lda ent_timer1,x
	beq @continue
	jmp BatNotReturning
@continue:
	lda ent_x,x
	sec
	sbc ent_misc1,x
	Abs
	cmp #3
	bcs @movetowardsperchspot
	lda ent_y,x
	sec
	sbc ent_misc2,x
	Abs
	cmp #3
	bcs @movetowardsperchspot
	lda ent_misc1,x
	sta ent_x,x
	lda ent_misc2,x
	sta ent_y,x
	lda #0						;perched
	sta ent_dir,x
	sta ent_state,x
	jmp FindEntAnimLengthsAndFrames
@movetowardsperchspot:
	jsr BatAccelerate
@horiz:
	lda ent_x,x
	cmp ent_misc1,x
	bcs @left
@right:
	lda ent_xsp,x
	clc
	adc ent_xvel_sp,x
	sta ent_xsp,x
	lda ent_x,x
	adc ent_xvel,x
	sta ent_x,x
	clc
	adc ent_width,x
	sta ent_hb_x,x
	jmp @vert
@left:
	lda ent_xsp,x
	sec
	sbc ent_xvel_sp,x
	sta ent_xsp,x
	lda ent_x,x
	sbc ent_xvel,x
	sta ent_x,x
	clc
	adc ent_width,x
	sta ent_hb_x,x
@vert:
	lda ent_y,x
	cmp ent_misc2,x
	bcs @up
@down:
	lda ent_y,x
	clc
	adc #1		;make this subpixels if too fast, but no need for acceleration
	sta ent_y,x
	lda ent_state,x
	cmp #2			;gliding
	beq @done
	lda #2
	sta ent_state,x
	jmp FindEntAnimLengthsAndFrames
@up:
	lda ent_y,x
	sec
	sbc #1
	sta ent_y,x
	lda ent_state,x
	cmp #1
	beq @done
	lda #1
	sta ent_state,x
	jmp FindEntAnimLengthsAndFrames
@done:
	rts

BatNotReturning:
	lda ent_misc3,x			;whether or not bat is slowing down
	beq @continue
	lda #1
	sta ent_misc3,x
	jmp BatSlowDown
@continue:
	lda ent_timer2,x
	beq @continue2
	lda ent_dir,x
	beq @checknearedgeleft
	bne @checknearedgeright
@continue2:
	;check if player's changed directions w/ respect to bat
	lda ent_dir,x
	beq @checkright
@checkleft:
	lda ent_x,x
	cmp #32
	bcc @checknearedgeright
	inc ent_misc3,x		;bat is now slowing down
	jmp DecTimer1
@checkright:
	lda ent_hb_x,x
	cmp ent_x+0
	bcc @checknearedgeleft
	inc ent_misc3,x
	jmp DecTimer1
@checknearedgeright:
	lda ent_hb_x,x
	cmp #-32
	bcc BatNotSlowingDown
	bcs @slowdown
@checknearedgeleft:
	lda ent_x,x
	cmp #16
	bcs BatNotSlowingDown
@slowdown:
	inc ent_misc3,x
	jmp BatSlowDown
	
BatNotSlowingDown:
	jsr BatAccelerate
	lda ent_dir,x
	beq @left
@right:
	lda ent_xsp,x
	clc
	adc ent_xvel_sp,x
	sta ent_xsp,x
	lda ent_x,x
	adc ent_xvel,x
	sta ent_x,x
	clc
	adc ent_width,x
	sta ent_hb_x,x
	jmp @continue
@left:
	lda ent_xsp,x
	sec
	sbc ent_xvel_sp,x
	sta ent_xsp,x
	lda ent_x,x
	sbc ent_xvel,x
	sta ent_x,x
	clc
	adc ent_width,x
	sta ent_hb_x,x
@continue:
	dec ent_timer2,x
	lda ent_state,x
	cmp #1
	beq @flying
@gliding:					;make sure the bat stops once it's at the player (code might have to be altered then)
	lda ent_y,x
	clc
	adc #1
	sta ent_y,x
	clc
	adc ent_height,x
	sta ent_hb_y,x
	jmp DecTimer1
@flying:
	;if timer1 == 0, fly towards perch spot. Otherwise, only actually move up if below player's midpoint
	lda ent_timer1,x
	beq @fly
	lda ent_y+0
	clc
	adc ent_hb_y+0
	ror
	sta temp0		;get midpoint
	lda ent_y,x
	cmp temp0
	bcc @done		;<= midpoint, don't move up anymore, but still animate flying
	beq @done
@fly:
	lda ent_y,x
	sec
	sbc #1
	sta ent_y,x
	clc
	adc ent_height,x
	sta ent_hb_y,x
@done:
	jmp DecTimer1	
	
	
BatSlowDown:
	lda ent_xvel,x
	bne @subtract
	lda ent_xvel_sp,x
	beq @reverse
@subtract:
	lda ent_xvel_sp,x
	sec
	sbc #<BAT_DECCEL
	sta ent_xvel_sp,x
	lda ent_xvel,x
	sbc #>BAT_DECCEL
	bcs @nounderflow
	lda #0
	sta ent_xvel_sp,x		;prevent 16-bit underflows
@nounderflow:
	sta ent_xvel,x
	lda ent_dir,x
	beq @left
@right:
	lda ent_xsp,x
	clc
	adc ent_xvel_sp,x
	sta ent_xsp,x
	lda ent_x,x
	adc ent_xvel,x
	sta ent_x,x
	clc
	adc ent_width,x
	sta ent_hb_x,x
	jmp DecTimer1
@left:
	lda ent_xsp,x
	sec
	sbc ent_xvel_sp,x
	sta ent_xsp,x
	lda ent_x,x
	sbc ent_xvel,x
	sta ent_x,x
	clc
	adc ent_width,x
	sta ent_hb_x,x
	jmp DecTimer1
@reverse:
	lda ent_dir,x
	eor #%00000001
	sta ent_dir,x
	dec ent_misc3,x
	lda #120
	sta ent_timer2,x
	;lda #$A0
	lda ent_xacc_sp,x
	sta ent_xvel_sp,x		;set base velocity
	;lda ent_xacc,x
	;sta ent_xvel			;uncomment is acceleration is changed to >255
	

DecTimer1:
	dec ent_timer1,x
	;change bat's state to flying or gliding, depending on where bat is vertically relative to player's vertical midpoint
	lda ent_y+0
	clc
	adc ent_hb_y+0
	ror
	sta temp0		;get midpoint
	lda ent_state,x
	cmp #1			;flying
	beq @fly
@glide:
	lda ent_y,x
	cmp temp0
	bcc @done
	lda #1			;flying
	bne @changestate	;will always branch
@fly:
	lda ent_y,x
	cmp temp0
	bcs @done
	lda #2			;gliding
@changestate:
	sta ent_state,x
	jmp FindEntAnimLengthsAndFrames
@done:
	rts
	
	
BatHit:
	dec ent_timer1,x
	bne @done
	lda #60
	sta ent_phi_timer,x
	lda #1					;flying
	sta ent_state,x
	jmp FindEntAnimLengthsAndFrames
@done:
	rts
	
	
	;helper functions
BatAccelerate:
	lda ent_xvel,x
	cmp #>BAT_MAX_VEL
	bcc @add
	bne @done
	lda ent_xvel_sp,x
	bcs @done
@add:
	lda ent_xvel_sp,x
	clc
	adc ent_xacc_sp,x
	sta ent_xvel_sp,x
	lda ent_xvel,x
	adc ent_xacc,x
	sta ent_xvel,x
@done:
	rts