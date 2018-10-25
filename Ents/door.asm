	;.db "DOOR"
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
	.db "DOORCOLLISION"
DoorCollision:
	;the player collided with the door, time to do things!!!
	;clear the previous screen system
	lda #0
	ldx #22			;clear 22 bytes
@clearprevloop:
	sta enemy_palette_index-1,x
	dex
	bne @clearprevloop
	;See if all the screens and whatnot in WRAM need to be cleared as well
	jsr DeactivateScreenEnts
	inc door_transition
	
	;(use whatever ent variables to set the new screen and in_cave and (cave_level if applicable))
	ldx ent_index
	lda ent_timer1,x
	sta screen
	lda ent_xvel,x
	sta door_tr_x
	lda ent_yvel,x
	sta door_tr_y
	lda ent_phi_timer,x
	sta in_cave_new
	lda ent_phi_time,x
	sta cave_level
	lda #STATE_FADEOUT
	sta game_state
	rts