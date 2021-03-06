DoorRoutine:
	;Doors are unique in that it should interact with the player's background collision hitbox
	lda ent_y+0
	clc
	adc #16
	sta ent_y+0
	jsr CheckPlayerCollision
	php
	lda ent_y+0
	sec
	sbc #16
	sta ent_y+0
	plp
	bne DoorCollision
	rts
DoorCollision:
	;the player collided with the door, time to do things!!!
	;clear the previous screen system
	lda #0
	ldx #21			;clear 21 bytes (Essentially resets the prev screen system, but doesn't mess with left_first_screen so new enemies can spawn)
@clearprevloop:
	sta enemy_palette_index-1,x
	dex
	bne @clearprevloop
	
	inc door_transition
	;(use whatever ent variables to set the new screen and in_cave and (cave_level if applicable))
	ldx ent_index
	lda ent_timer1,x
	sta screen
	lda ent_xvel,x
	sta door_tr_x
	lda ent_yvel,x
	sta door_tr_y
	lda ent_misc1,x
	sta in_cave_new
	lda ent_misc2,x
	sta cave_level
	lda #STATE_FADEOUT
	sta game_state
	rts