							;--- GLOBAL ROUTINES ---;	
	
InitEnt:
;Make sure when initing an ent that EVERYTHING gets reset, since it doesn't happen when ents deactivate. We don't want an ent to spawn in i.e state 3 on animation frame 2 accidentally
;State, X, Y, and dir should all be specified before the object is initialized. That way the correct animation frame and hitbox can be loaded depending on state, direction, etc.
	;X should be loaded with the correct ent index
	lda #1
	sta ent_active,x
	lda ent_id,x
	asl
	tay
	lda EntData+0,y
	sta ent_ptr1+0
	lda EntData+1,y
	sta ent_ptr1+1
	ldy #0
	;type
	lda (ent_ptr1),y
	sta ent_type,x
	cmp #ENT_TYPE_ENEMY		;we need to keep track of how many enemy ents are on the screen
	bne @checkifenemydone
	inc num_active_enemies
@checkifenemydone:
	iny
	;health
	lda (ent_ptr1),y
	sta ent_health,x
	iny
	;PHI
	lda (ent_ptr1),y
	sta ent_phi_time,x
	;anything that always gets set to 0 when an ent is initialized can go here
	lda #0
;InitWeapon:				;this is here to save redundant code for spawning weapons
	sta ent_state,x
	sta ent_xsp,x
	sta ent_ysp,x
	sta ent_hb_xsp,x
	sta ent_hb_ysp,x
	sta ent_xvel,x
	sta ent_xvel_sp,x
	sta ent_yvel,x
	sta ent_yvel_sp,x
	sta ent_xacc,x
	sta ent_xacc_sp,x
	sta ent_yacc,x
	sta ent_yacc_sp,x
	sta ent_phi_timer,x
	sta ent_anim_timer,x
	sta ent_anim_frame,x
	sta ent_timer1,x
	sta ent_timer2,x
	sta ent_misc1,x
	sta ent_misc2,x
	sta ent_misc3,x
	lda random
	jsr RandomLFSR
	sta ent_time1,x			;for right now, until I get around to adding init routines for ents
	inc num_active_ents
	jmp FindEntAnimLengthsAndFrames
	
	
SpawnWeaponEntBasedOnPlayer:
	;Could be turned into a macro since it's only called once by the player, but I really don't think it's worth the inevitable ungodly branch complexity
	;position itself based off player's direction
	;(use the table in main ROM based off weapon ent ID and direction to figure out where to put place the weapon)
	txa
	asl
	tay					;used indices for the tables we'll use
	lda ent_health+1
	sta ent_timer1+1
	lda ent_dir+0
	sta ent_dir+1
	beq @up
	cmp #1
	beq @down
	cmp #2
	beq @left
@right:
	lda ent_hb_x+0
	clc
	adc #4
	sta ent_x+1
	lda ent_y+0
	clc
	adc WeaponSpawnPositionOffsetsLeft+1,y
	sta ent_y+1
	jmp @done
@up:
	lda ent_x+0
	;adjust as necessary
	sec
	sbc WeaponSpawnPositionOffsetsUp+0,y
	sta ent_x+1
	lda ent_y+0
	sec
	sbc #1
	sbc WeaponSpawnPositionOffsetsUp+1,y
	sta ent_y+1
	jmp @done
@down:
	lda ent_x+0
	clc
	adc WeaponSpawnPositionOffsetsDown,x
	sta ent_x+1
	lda ent_hb_y+0
	clc
	adc #2
	sta ent_y+1
	jmp @done
@left:
	lda ent_x+0
	sec
	sbc #4
	sbc WeaponSpawnPositionOffsetsLeft+0,y
	sta ent_x+1
	lda ent_y+0
	clc
	adc WeaponSpawnPositionOffsetsLeft+1,y
	sta ent_y+1
@done:
	ldx #1
	jmp InitEnt


DeactivateEnt:
	;X should be loaded with ent_index
	;a subroutine saves more bytes than just having this code everywhere, even though it's so short
	lda #0
	sta ent_active,x
	dec num_active_ents
	rts
	
	
DeactivateAllEntsExceptPlayer:
	ldx #1
	stx num_active_ents
	lda #0
@loop:
	sta ent_active,x
	inx
	cpx #MAX_ENTS
	bne @loop
	rts
	

CheckPlayerCollision:
	;checks to see if an ent has interacted with the player (always ent 0)
	;returns 1 in Accumulator if there is a collision, and 0 if otherwise
	;X should contain the index of the non-player ent
@checkplayercol_u:
	lda ent_hb_y,x
	cmp ent_y+0
	bcc @nocollision
@checkplayercol_d:
	lda ent_y,x
	cmp ent_hb_y+0
	beq @checkplayercol_l		;we can only check >=, not simply >. If the compare WAS equal, we can go to the next check
	bcs @nocollision	;by now we have determined that the compare was not equal, so it can only be greater than
@checkplayercol_l:
	lda ent_hb_x,x
	cmp ent_x+0
	bcc @nocollision
@checkplayercol_r:
	lda ent_x,x
	cmp ent_hb_x+0
	beq @collision			;same as d
	bcs @nocollision
@collision:
	lda #1
	rts
@nocollision:
	lda #0
	rts
	
	
CheckPlayerWeaponCollision:
	;same idea as above routine
@checkpweapcol_u:
	lda ent_hb_y,x
	cmp ent_y+1
	bcc @nocollision
@checkpweapcol_d:
	lda ent_y,x
	cmp ent_hb_y+1
	beq @checkpweapcol_l		;we can only check >=, not simply >. If the compare WAS equal, we can go to the next check
	bcs @nocollision	;by now we have determined that the compare was not equal, so it can only be greater than
@checkpweapcol_l:
	lda ent_hb_x,x
	cmp ent_x+1
	bcc @nocollision
@checkpweapcol_r:
	lda ent_x,x
	cmp ent_hb_x+1
	beq @collision			;same as d
	bcs @nocollision
@collision:
	lda #1
	rts
@nocollision:
	lda #0
	rts
	
	
EntRoutines:
	;sorted by ID
	.dw PlayerRoutine, KnifeRoutine, SnakeRoutine, JarRoutine, HeartRoutine, MeatRoutine, BeehiveRoutine, BeeRoutine
	.dw GunRoutine, BulletRoutine, DoorRoutine, CrabRoutine, MacheteColRoutine, KnifeRoutine, StickColRoutine, KnifeRoutine
	.dw StoneRoutine, FlintRoutine, SpearRoutine, ClothRoutine, BatRoutine, SnakeRoutine, HoneycombRoutine
	;.db "ROUTINES"
RunEnt:
	ldx ent_index
	lda ent_id,x
	asl
	tay
	lda EntRoutines+0,y
	sta jump_ptr+0
	lda EntRoutines+1,y
	sta jump_ptr+1
	jmp (jump_ptr)
	
FindEntAnimLengthsAndFrames:
	;Metasprite definitions and the animation lengths and frames are stored separately. Only need to fetch these when an ent's state is changed
	;Despite the routine's name, hitbox data is also fetched here, as it can change when an ent's state changes. 
	;X should be loaded with the correct ent index
	;length
	lda ent_id,x
	asl
	tay
	sta temp0
	lda EntAnimationLengths+0,y
	sta ent_ptr1+0
	lda EntAnimationLengths+1,y
	sta ent_ptr1+1
	ldy ent_state,x
	lda (ent_ptr1),y
	sta ent_anim_length,x
	;frames
	ldy temp0
	lda EntAnimationFrames+0,y
	sta ent_ptr1+0
	lda EntAnimationFrames+1,y
	sta ent_ptr1+1
	ldy ent_state,x
	lda (ent_ptr1),y
	sta ent_anim_frames,x
	ldy temp0
UpdateEntHitbox:
	;hitbox size
	;(If UpdateEntHitbox is called directly, Y should be loaded with the would-be temp0. X should also be loaded with ent_index)
	lda EntHitboxSizes+0,y
	sta ent_ptr1+0
	lda EntHitboxSizes+1,y
	sta ent_ptr1+1
	lda ent_state,x
	asl
	tay
	lda (ent_ptr1),y
	sta ent_ptr2+0		;need to get direction as well
	iny
	lda (ent_ptr1),y
	sta ent_ptr2+1
	lda ent_dir,x
	asl					;multiply by 2 since width and height are stored together essentially as a word
	tay
	lda (ent_ptr2),y	;width
	sta ent_width,x
	iny
	lda (ent_ptr2),y	;height
	sta ent_height,x
	lda ent_x,x
	clc
	adc ent_width,x
	sta ent_hb_x,x
	lda ent_y,x
	clc
	adc ent_height,x
	sta ent_hb_y,x
	rts
	
	
	.db "DrawEnts"
DrawEnts:
	;Draw the player's weapon first so it'll always be in front of him
	;Then draw the player
	lda ent_draw_index
	pha					;need to save since DrawEnt uses ent_draw_index instead of ent_index, and we need to draw the weapon and player first
	lda #1
	sta ent_draw_index
@weapon:
	lda ent_active+1
	beq @player
	lda #1
	sta ent_draw_index
	jsr DrawEnt
@player:
	dec ent_draw_index
	jsr DrawEnt
@others:
	;Now draw the rest of the ents based on ent_draw_index
	pla
	sta ent_draw_index
	pha					;save again since once everything's drawn, we'll increment for the next frame
	tax
	ldy #2
	sty ent_index		;use as our actual index counter to loop through the rest of the ents
@entdrawloop:
	lda ent_active,x
	beq @continue
	jsr DrawEnt
@continue:
	;increment ent_draw_index, roll over from 16 to 2
	lda ent_draw_index
	clc
	adc #1
	cmp #MAX_ENTS
	bcc @rolloverdone
	lda #2
@rolloverdone:
	sta ent_draw_index
	tax
	inc ent_index
	ldy ent_index
	cpy #MAX_ENTS
	bne @entdrawloop
@entsdrawdone:
	pla
	clc
	adc #1
	cmp #MAX_ENTS
	bcc @rolloverdone1
	lda #2
@rolloverdone1:
	sta ent_draw_index
	rts

	
DrawEnt:
	;The current ent is assumed to be active (checked in the play state when the ent draw loop happens to save an unnecessary call)
	ldx ent_draw_index
	lda game_state
	cmp #STATE_PLAY
	bne @continue			;if the ent is in PHI flicker while the game is in a differen't state, draw it anyway
	lda ent_phi_timer,x
	and #%00000010
	beq @continue			;if ent is in PHI, and is on an even frame, don't draw (causes ent to flicker signaling PHI)
	jmp @done
@continue:
	lda ent_id,x
	asl
	tay
	lda EntMetaSprites+0,y
	sta ent_ptr1+0
	lda EntMetaSprites+1,y
	sta ent_ptr1+1
	lda ent_state,x
	asl
	tay
	lda (ent_ptr1),y
	sta ent_ptr2+0
	iny
	lda (ent_ptr1),y
	sta ent_ptr2+1
	lda ent_dir,x
	asl
	tay
	lda (ent_ptr2),y
	sta ent_ptr1+0
	iny
	lda (ent_ptr2),y
	sta ent_ptr1+1
	lda ent_anim_frame,x
	asl
	tay
	lda (ent_ptr1),y
	sta ent_ptr2+0
	iny
	lda (ent_ptr1),y
	sta ent_ptr2+1
	ldy #0
	lda (ent_ptr2),y
	beq @done				;if the first byte was 0, that means that the ent should be invisible for whatever state this is
	sta howmuchoamtodraw
	;inc pointer to start over from 0
	lda ent_ptr2+0
	clc
	adc #1
	bcc @skipoverflow
	inc ent_ptr2+1
@skipoverflow:
	sta ent_ptr2+0
@loop:
	ldx ent_draw_index
	lda ent_x,x
	clc
	adc (ent_ptr2),y		;Xoffs
	ldx oam_index
	sta $0203,x
	iny
	lda (ent_ptr2),y		;Sprite
	sta $0201,x
	iny
	lda (ent_ptr2),y		;Attribs
	sta $0202,x
	iny
	ldx ent_draw_index
	lda ent_y,x
	clc
	adc (ent_ptr2),y		;Yoffs
	ldx oam_index
	sta $0200,x
	txa
	clc
	adc #4					;originally advanced by #75 each time, but only doing this once a frame seems to look better
	sta oam_index
	iny
	cpy howmuchoamtodraw
	bne @loop
@done:
	rts
	
	
							;--- ROUTINES FOR EACH ENT ---;							
	.include "ents/player.asm"
	.include "ents/knife.asm"	
	.include "ents/snake.asm"
	.include "ents/jar.asm"
	.include "ents/heart.asm"
	.include "ents/meat.asm"
	.include "ents/beehive.asm"
	.include "ents/bee.asm"
	.include "ents/bullet.asm"
	.include "ents/gun.asm"
	.include "ents/door.asm"
	.include "ents/crab.asm"
	.include "ents/machete_col.asm"
	.include "ents/stick_col.asm"
	.include "ents/stone.asm"
	.include "ents/flint.asm"
	.include "ents/spear.asm"
	.include "ents/cloth.asm"
	.include "ents/bat.asm"
	.include "ents/honeycomb.asm"