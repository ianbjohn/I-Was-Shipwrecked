PlayerRoutine:
	lda ent_dir+0
	sta player_dir_old

	ldx status
PlayerDepleteHealth:
	;this code is better commented in the hunger routine below
	lda HealthDepleteTimes,x
	beq PlayerDepleteHunger
	lda deplete_health_timer
	clc
	adc #1
	cmp HealthDepleteTimes,x
	bcc PlayerDepleteHealthDone
	;deplete health
	lda ent_health+0
	sec
	sbc #1
	bcs @norollunder
	lda #0
@norollunder:
	sta ent_health+0
	lda #0
PlayerDepleteHealthDone:
	sta deplete_health_timer
	
PlayerDepleteHunger:
	;every specific amount amount of time, decrement hunger and thirst (Thirst should deplete faster than hunger)
	;The amount of time it takes for depletions to happen depends on the status of the player
	lda HungerDepleteTimes,x
	beq PlayerDepleteThirst
	lda deplete_hunger_timer
	clc
	adc #1
	cmp HungerDepleteTimes,x
	bcc PlayerDepleteHungerDone
	;deplete hunger
	lda hunger
	sec
	sbc #1
	bcs @norollunder			;Not really necessary right now since it's only being decremented by 1, but if the player is hurt or sick in anyway,
									;health/hunger/thirst might deplete faster (i.e cut, infected, dehydrated, etc.)
									;This makes sure that if any of these roll under 0, they get set back to it
	lda #0
@norollunder:
	sta hunger
	lda #0
PlayerDepleteHungerDone:
	sta deplete_hunger_timer
	
PlayerDepleteThirst:
	lda ThirstDepleteTimes,x
	cmp #255
	beq PlayerDepleteThirstDone
	lda deplete_thirst_timer
	clc
	adc #1
	cmp ThirstDepleteTimes,x
	bcc @done
	;deplete thirst
	lda thirst
	sec
	sbc #1
	bcs @norollunder
	lda #0
@norollunder:
	sta thirst
	lda #0
@done:
	sta deplete_thirst_timer
PlayerDepleteThirstDone:
	
PlayerCheckDead:
	;if the player's health, hunger or thirst is zero, the game is over
		;Eventually add a dying state, and once that state is done, then it's game over
	lda ent_health+0
	beq @dead
	lda hunger
	beq @dead
	lda thirst
	beq @dead
	bne @continue
@dead:
	dec player_still_alive
	lda #STATE_GAMEOVER
	sta game_state
	ldy #SILENCE
	jmp PlaySound
@continue:

	;if the player's health, hunger or thirst are below 30, play an alert sound effect every 256 frames (~4.25 seconds)
	;see if there's a way to optimize this at all, as I feel like it could be at least a bit
AlertPlayerNearDeath:
	lda ent_health+0
	cmp #30
	bcc @alert
	lda hunger
	cmp #30
	bcc @alert
	lda thirst
	cmp #30
	bcc @alert
	lda #1
	sta near_death_alert_timer
	lda #0
	sta player_near_death
	beq AlertPlayerNearDeathDone	;w.a.b
@alert:
	lda #1
	sta player_near_death
AlertPlayerNearDeathDone:

PlayNearDeathAlert:
	;A will always have the contents of player_near_death here
	beq PlayNearDeathAlertDone
	dec near_death_alert_timer
	bne PlayNearDeathAlertDone
	ldy #SFX_PLAYERNEARDEATH
	jsr PlaySound
PlayNearDeathAlertDone:
	
	;restore X with ent_index
	ldx ent_index

	;animation timer stuff
PlayerAdvanceAnimation:
	lda ent_anim_timer+0
	clc
	adc #1
	cmp ent_anim_length+0
	bcc @continue
	;set timer back to 0, increment frame
	lda ent_anim_frame+0
	clc
	adc #1
	cmp ent_anim_frames+0
	bcc @continue2
	lda #0					;even if frame didn't get set back to 0, timer needs to be
@continue2:
	sta ent_anim_frame+0
	lda #0
@continue:
	sta ent_anim_timer+0
PlayerAdvanceAnimationDone:
	
	;if the player is attacking, and the timer at $0700 is 0, set the state to standing
	;The player should remain attacking for 16 frames, and then go back. However, depending on the weapon (Whether its a stabbing weapon or a projectile) it will decide when another weapon can spawn
		;This will be decided in each individual weapon ent's code
PlayerCheckAttackTimerZero:
	lda ent_state+0
	cmp #2				;attacking
	bne PlayerCheckAttackTimerZeroDone
	lda player_weapon_active_timer
	bne @dectimer
	lda #0
	sta ent_state+0
	beq PlayerCheckAttackTimerZeroDone	;will always branch
@dectimer:
	dec player_weapon_active_timer
PlayerCheckAttackTimerZeroDone:

	;if the player's PHI timer is not 0, decrement it
PlayerDecPHI:
	lda ent_phi_timer+0
	beq PlayerDecPHIDone
	dec ent_phi_timer+0
PlayerDecPHIDone:

	;if a specific event occurs, a message box will pop up.
	;the player's direction is used to read the metatile in the center to the (above, below, left, right, respectively) which decides the event
	;-
	;what message is shown will depend on the event that occured
	;the event is used as an index to load the proper message
	;the status board is hard-coded, and the stats shown are saved in ram, and don't get overrided
	;no need to save anything
PlayerReadA:
	lda ent_state+0
	cmp #2					;attacking
	bne @continue
	jmp PlayerReadB
@continue
	lda buttons_pressed
	and #BUTTONS_A
	bne @continue1
	jmp PlayerReadB
@continue1:
	lda ent_dir+0
	beq @up
	cmp #1
	beq @down
	cmp #2
	bne @right
	jmp @left
@right:
	lda ent_hb_x+0
	cmp #240
	bcc @continue2
	jmp PlayerReadB
@continue2:
	;check what metatile the player is interacting with by looking at the midpoint of the bitbox
	;I originally used a temp variable for this, but adding the two coordinates and then dividing by two (with ROR) does the same thing faster, smaller, and without a variable
	;lda ent_hb_y+0	;3 3
	;sec			;1 4
	;sbc ent_y+0	;3 7
	;lsr			;1 8		;divide by 2 to get the midpoint
	;sta temp1		;2 9
	;lda ent_y+0	;3 12
	;clc			;1 13
	;adc temp1		;2 15
	
	lda ent_y+0		;3 3
	clc				;1 4
	adc ent_hb_y+0	;3 7
	ror				;1 8
	;convert to metatile map coordinates (this is better explained in the BGCol file I believe)
	and #%11110000
	sec
	sbc #$30
	sta temp0
	lda ent_hb_x+0
	lsr
	lsr
	lsr
	lsr
	clc
	adc temp0
	tax
	inx
	jmp @check
@up:
	lda ent_y+0
	cmp #(16 + $30)		;don't try and interact with the status board
	bcs @continue3
	jmp PlayerReadB
@continue3:
	lda ent_y+0
	clc
	adc #16
	and #%11110000
	sec
	sbc #$30
	sta temp0
	lda ent_x+0
	clc
	adc ent_hb_x+0
	ror
	lsr
	lsr
	lsr
	lsr
	clc
	adc temp0
	sec
	sbc #16
	tax
	jmp @check
@down:
	lda ent_hb_y+0
	cmp #232
	bcc @continue4
	jmp PlayerReadB
@continue4:
	and #%11110000
	sec
	sbc #$30
	sta temp0
	lda ent_x+0
	clc
	adc ent_hb_x+0
	ror
	lsr
	lsr
	lsr
	lsr
	clc
	adc temp0
	clc
	adc #16
	tax
	jmp @check
@left:
	lda ent_x+0
	cmp #16
	bcc PlayerReadB
	lda ent_y+0
	clc
	adc ent_hb_y+0
	ror
	and #%11110000
	sec
	sbc #$30
	sta temp0
	lda ent_x+0
	lsr
	lsr
	lsr
	lsr
	clc
	adc temp0
	tax
	dex
@check:
	lda metatile_map,x
	jsr HandlePlayerInteraction
	jmp PlayerDone
	
PlayerReadB:
	;Pressing B makes the player use his weapon
	lda buttons_pressed
	and #BUTTONS_B
	bne @B_continue
	jmp PlayerReadSelect
@B_continue:
	;if the player is already attacking, skip this
	lda ent_state+0
	cmp #2				;attacking
	bne @attack
	jmp PlayerReadSelect
@attack:
	lda ent_active+1
	beq @attackactual
	jmp PlayerReadSelect
@attackactual:
	lda #2
	sta ent_state+0
	;Since a hitbox update may happen, and in which case it needs to happen now, we need to call the update hitbox subroutine (Which is part of the update anim length/frame routine)
	;lda ent_id+0
	;tax					;put here JUST IN CASE!!! The routine needs X to have ent_index. Uppon debugging, X seems to always be 0 when called by the player, but I don't wanna take any chances
	;asl
	;tay
	lda #0
	sta ent_anim_timer+0
	sta ent_anim_frame+0
	tay						;the player's ID will always be 0
	jsr UpdateEntHitbox
	;MAP WEAPONS TO ITEMS, CHECK IF THAT ITEM HAS A COUNT
		;IF SO
			;IF IT'S 0, AND THE WEAPON'S A GUN, PLAY THE EMPTY CLIP SOUND EFFECT
			;IF NOT, AND DECREMENT THE COUNT
	;ALSO ADD A SPECIAL CASE FOR, IF THE WEAPON IS A GUN
	;The weapon right now is hard-coded to have ent slot 1
	ldx weapon
	cpx #WEAPON_BULLET
	bne @notbullet
	lda rounds
	beq @loadgun
@stillhaverounds
	dec rounds
	lda #ENT_BULLET
	bne @continue		;W.A.B
@notbullet:
	lda WeaponItems,x
	cmp #ITEM_STICK
	beq @continue			;event though the stick has a count, the player doesn't lose a stick when he uses it
	jsr CheckIfItemHasCount
	beq @continue
	ldx weapon
	lda WeaponItems,x
	jsr GetItemCount
	bne @decrement
	;jmp PlayerDone		;Whatever weapon the player's trying to use, he does not currently have any of it
		;^ This'll animate the player using a weapon, but no weapon'll be used. See if this is preferred to just drawing a message saying you're out of the respective weapon
	lda #MSG_OUTOFWEAPON
	sta message
	lda #STATE_DRAWINGMBOX
	sta game_state
	rts
@decrement:
	ldx weapon
	lda WeaponItems,x
	ldy #1
	jsr SubtractFromItemCount
@continue:
	ldx weapon
	lda WeaponEnts,x
	sta ent_id+1
	pha
	jsr SpawnWeaponEntBasedOnPlayer
	pla
	cmp #ENT_BULLET
	bne @skipgun
	lda ent_x+1
	sta rounds_hud_x
	lda ent_y+1
	sta rounds_hud_y
	lda #128
	sta rounds_hud_timer
@loadgun:
	;the gun ent can just be put in slot 15 (for right now at least I guess)
	lda ent_dir+0
	asl
	tax
	lda #ENT_GUN
	sta ent_id+15
	lda ent_x+0
	clc
	adc GunSpawnPositionOffsets+0,x
	sta ent_x+15
	lda ent_y+0
	clc
	adc GunSpawnPositionOffsets+1,x
	sta ent_y+15
	lda ent_dir+0
	sta ent_dir+15
	lda #0
	sta ent_state+15
	ldx #15
	jsr InitEnt
	;change the gun's state to normal if no rounds
	lda rounds
	bne @skipgun
	lda #1			;gun's normal state (Don't draw explosion since no bullet was fired)
	sta ent_state+15
	;jsr FindEntAnimLengthsAndFrames	;The same as exploding
@skipgun:
	;set active timer for the weapon
	lda #16
	sta player_weapon_active_timer
	lda #0
	sta ent_anim_timer+0
	sta ent_anim_frame+0
	;play the appropriate weapon sound effect (See if this can be optimized at all, decrease # of branches)
	lda weapon
	cmp #WEAPON_BULLET
	bne @stillnogun
	lda rounds
	beq @empty
	ldy #SFX_GUNSHOT
	bne @playsound		;will always branch
@empty:
	ldy #SFX_EMPTYCLIP
	bne @playsound		;will always branch
@stillnogun:
	tax
	ldy WeaponSoundEffects,x
@playsound:
	jsr PlaySound
	jmp PlayerDone
	
	
PlayerReadSelect:
	;pauses the game but doesn't go to inventory screen
	lda buttons_pressed
	and #BUTTONS_SELECT
	beq PlayerReadStart
	lda #STATE_PAUSED
	sta game_state
	rts
PlayerReadStart:
	lda buttons_pressed
	and #BUTTONS_START
	beq PlayerReadUp
	lda #STATE_INVENTORY
	sta game_state
	rts
	
	
PlayerReadUp:
;{
	;if the player is attacking, he shouldn't be walking
	lda ent_state+0
	cmp #2
	bne @continue
	jmp PlayerDone
@continue:
	lda buttons
	and #BUTTONS_UP
	bne @continue2
	jmp PlayerReadDown
@continue2:
	lda #0
	sta ent_dir+0
	lda ent_y+0
	sec
	sbc #1
	;check if player left the screen
	cmp #40									;48? (minus 1? 2?)
	bcs @stillonscreen
	lda #0
	sta screen_leave_dir
	;subtract 5 from the scren							;THIS IS HARD-CODED FOR NOW SINCE THE SAMPLE ISLAND IS 5X5 SCREENS
	lda screen
	sta previous_screen				;save because we're gonna need it later
	sec
	sbc #8
	sta screen
	tay								;check to see if area was changed
	lda in_cave
	bne @cave
	lda #<(IslandAreasDifficulties)
	sta ptr1+0
	lda #>(IslandAreasDifficulties)
	sta ptr1+1
	bne @checkareachange
@cave:
	lda cave_level
	asl
	tax
	lda CaveAreasDifficulties+0,x
	sta ptr1+0
	lda CaveAreasDifficulties+1,x
	sta ptr1+1
@checkareachange
	lda (ptr1),y
	and #%00001111
	cmp area
	bne @fadeout
	lda #STATE_LOADINGSCREEN
	bne @changestate				;will always branch
@fadeout:
	lda #STATE_FADEOUT
@changestate:
	sta game_state
	jmp PlayerDone
@stillonscreen:
	sta ent_y+0
	lda ent_hb_y+0
	sec
	sbc #1
	sta ent_hb_y+0
	
	;background collision
	;since we only want background collision to happen with the player's feet (16x8), we need to change the hitbox.
	;a bit hard-coded but I don't give a rat's dick
@checkleft:
	lda ent_y+0
	clc
	adc #16
	sta ent_y+0
	jsr EntCheckBGColTL
@checkcenter:
	jsr EntCheckBGColTC
@checkright:
	jsr EntCheckBGColTR
@bgcoldone:
	lda ent_y+0
	sec
	sbc #16
	sta ent_y+0
	lda #1			;walking
	sta ent_state+0
	jmp PlayerReadLeft			;too far to branch :( (Don't bother moving player down if he's already moved up)
;}
PlayerReadDown:
;{
	lda buttons
	and #BUTTONS_DOWN
	bne @continue
	jmp PlayerReadLeft
@continue:
	lda #1
	sta ent_dir+0
	lda ent_y+0
	clc
	adc #1
	;check if player left the screen
	cmp #217
	bcc @stillonscreen
	lda #1
	sta screen_leave_dir
	;add 5 to the scren									;THIS IS HARD-CODED FOR NOW SINCE THE SAMPLE ISLAND IS 5X5 SCREENS
	lda screen
	sta previous_screen				;save because we're gonna need it later
	clc
	adc #8
	sta screen
	tay								;check to see if area was changed
	lda in_cave
	bne @cave
	lda #<(IslandAreasDifficulties)
	sta ptr1+0
	lda #>(IslandAreasDifficulties)
	sta ptr1+1
	bne @checkareachange
@cave:
	lda cave_level
	asl
	tax
	lda CaveAreasDifficulties+0,x
	sta ptr1+0
	lda CaveAreasDifficulties+1,x
	sta ptr1+1
@checkareachange
	lda (ptr1),y
	and #%00001111
	cmp area
	bne @fadeout
	lda #STATE_LOADINGSCREEN
	bne @changestate				;will always branch
@fadeout:
	lda #STATE_FADEOUT
@changestate:
	sta game_state
	jmp PlayerDone
@stillonscreen:
	sta ent_y+0
	lda ent_hb_y+0
	clc
	adc #1
	sta ent_hb_y+0
	
	;background collision
	;we might be able to optimize by making the Y conversion only happen once
	;since we only want background collision to happen with the player's feet (16x8), we need to change the hitbox.
@checkleft:
	lda ent_y+0
	clc
	adc #16
	sta ent_y+0
	jsr EntCheckBGColBL
@checkcenter:
	jsr EntCheckBGColBC
@checkright:
	jsr EntCheckBGColBR
@bgcoldone:
	lda ent_y+0
	sec
	sbc #16
	sta ent_y+0
	lda #1
	sta ent_state+0
;}
PlayerReadLeft:
;{
	lda buttons
	and #BUTTONS_LEFT
	bne @continue
	jmp PlayerReadRight
@continue:
	lda #2
	sta ent_dir+0
	lda ent_x+0
	sec
	sbc #1
	;check if player left the screen
	cmp #3
	bcs @stillonscreen
	lda #2
	sta screen_leave_dir
	lda screen
	sta previous_screen			;save because we're gonna need it later
	dec screen
	ldy	screen						;check to see if area was changed
	lda in_cave
	bne @cave
	lda #<(IslandAreasDifficulties)
	sta ptr1+0
	lda #>(IslandAreasDifficulties)
	sta ptr1+1
	bne @checkareachange
@cave:
	lda cave_level
	asl
	tax
	lda CaveAreasDifficulties+0,x
	sta ptr1+0
	lda CaveAreasDifficulties+1,x
	sta ptr1+1
@checkareachange
	lda (ptr1),y
	and #%00001111
	cmp area
	bne @fadeout
	lda #STATE_LOADINGSCREEN
	bne @changestate				;will always branch
@fadeout:
	lda #STATE_FADEOUT
@changestate:
	sta game_state
	jmp PlayerDone
@stillonscreen:
	sta ent_x+0
	lda ent_hb_x+0
	sec
	sbc #1
	sta ent_hb_x+0
	
	;background collision
	;since we only want background collision to happen with the player's feet (16x8), we need to change the hitbox.
	;Luckily we don't need a midpoint when checking horizontally
	;Since player's Y won't change, we can simply keep the original value of it on the stack
@checktop:
	lda ent_y+0
	pha				;save original Y coordinate of hitbox
	clc
	adc #16
	sta ent_y+0
	jsr EntCheckBGColTL
@checkbottom:
	jsr EntCheckBGColBL
@bgcoldone:
	pla
	sta ent_y+0
	lda #1
	sta ent_state+0
	bne PlayerDone			;will always branch (Don't bother moving the player right if we've already moved left)
;}
PlayerReadRight:
;{
	lda buttons
	and #BUTTONS_RIGHT
	bne @continue
	jmp PlayerDone
@continue:
	lda #3
	sta ent_dir+0
	lda ent_x+0
	clc
	adc #1
	sta ent_x+0
	lda ent_hb_x+0
	clc
	adc #1
	;check if player left the screen
	cmp #(256 - 3)
	bcc @stillonscreen
	lda #3
	sta screen_leave_dir
	lda screen
	sta previous_screen				;save because we're gonna need it later
	inc screen
	ldy	screen						;check to see if area was changed
	lda in_cave
	bne @cave
	lda #<(IslandAreasDifficulties)
	sta ptr1+0
	lda #>(IslandAreasDifficulties)
	sta ptr1+1
	bne @checkareachange
@cave:
	lda cave_level
	asl
	tax
	lda CaveAreasDifficulties+0,x
	sta ptr1+0
	lda CaveAreasDifficulties+1,x
	sta ptr1+1
@checkareachange
	lda (ptr1),y
	and #%00001111
	cmp area
	bne @fadeout
	lda #STATE_LOADINGSCREEN
	bne @changestate				;will always branch
@fadeout:
	lda #STATE_FADEOUT
@changestate:
	sta game_state
	jmp PlayerDone
@stillonscreen:
	sta ent_hb_x+0
	
	;background collision
	;since we only want background collision to happen with the player's feet (16x8), we need to change the hitbox.
	;Luckily we don't need a midpoint when checking horizontally
	;Since player's Y won't change, we can simply keep the original value of it on the stack
@checktop:
	lda ent_y+0
	pha				;save original Y coordinate of hitbox
	clc
	adc #16
	sta ent_y+0
	jsr EntCheckBGColTR
@checkbottom:
	jsr EntCheckBGColBR
@bgcoldone:
	pla
	sta ent_y+0
	lda #1
	sta ent_state+0
;}
PlayerDone:
	
	;stop the player from walking if neither left nor right nor up nor down on the d-pad was pressed
	lda ent_state+0
	cmp #1
	bne @done
	lda buttons
	and #%00001111
	bne @done
	lda #0					;standing
	sta ent_state+0
	sta ent_anim_timer+0
	sta ent_anim_frame+0
@done:
	ldx #0		;ent index for the player will always be 0
	jmp FindEntAnimLengthsAndFrames