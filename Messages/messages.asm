;	.dw Message15Response0
;	.dw MessageResponses

EraseMBoxOrReinitInventory:
	;If we were in the inventory state after drawing a message, the inventory state needs to be re-initialized as items and whatnot could have been altered after a choice was made. But if we weren't in the inventory state, we can simply just erase the mbox
	lda in_inventory_state
	beq @no
@yes:
	jsr CleanUpMBoxVars
	jsr CleanUpInventorySystem
	lda #STATE_INVENTORY
	bne @done				;will always branch
@no:
	lda #STATE_ERASINGMBOX
@done:
	sta game_state
	rts


Messages:
	;sorted by message index
	.dw Message0, Message1, Message2, Message3, Message4, Message5, Message6, Message7
	.dw Message8, Message9, MessageA, MessageB, MessageC, MessageD, MessageE, MessageF
	.dw Message10, Message11, Message12, Message13, Message14, Message15, Message11, Message17
	.dw Message18, Message19, Message1A, Message1B, Message1C, Message1D, Message1E, Message1F
	.dw Message20, Message21, Message22, Message23, Message24, Message25, Message26, Message27
	.dw Message28, Message29, Message2A, Message2B, Message2C, Message2D, Message2E, Message2F
	.dw Message30, Message31, Message32, Message33, Message34, Message35, Message36, Message37
	.dw Message38
MessageResponseNumbers:
	;sorted by message index
	.db 3,1,1,1,2,1,1,1
	.db 1,1,1,1,1,1,1,1
	.db 1,1,1,1,1,1,1,1
	.db 1,1,1,1,1,1,1,1
	.db 1,1,1,1,1,1,1,1
	.db 1,1,1,1,1,1,1,1
	.db 1,1,1,1,1,1,1,1
	.db 1
MessageResponses:
	;this is a jump table. This way, logic can happen for different responses
	;(M0R2 is just normal "Okay")
	.dw Message0Response0,Message0Response1,Message0Response2,Message0Response2,Message4Response0,Message0Response2,Message0Response2,Message0Response2
	.dw Message0Response2,Message9Response0,Message0Response2,Message0Response2,Message0Response2,Message0Response2,Message0Response2,Message0Response2
	.dw Message0Response2,Message11Response0,Message0Response2,Message0Response2,Message0Response2,Message15Response0,Message16Response0,Message0Response2
	.dw Message0Response2,Message0Response2,Message0Response2,Message0Response2,Message0Response2,Message0Response2,Message0Response2,Message0Response2
	.dw Message0Response2,Message0Response2,Message22Response0,Message0Response2,Message22Response0,Message0Response2,Message0Response2,Message0Response2
	.dw Message0Response2,Message0Response2,Message0Response2,Message0Response2,Message0Response2,Message0Response2,Message0Response2,Message0Response2
	.dw Message0Response2,Message22Response0,Message0Response2,Message0Response2,Message0Response2,Message0Response2,Message0Response2,Message0Response2
	.dw Message0Response2
	
Message0:
	.db T,H,E,R,E, SPA, I,S, SPA, F,R,E,S,H, SPA, W,lA,T,E,R, SPA, H,E,R,E,$2A,$FE
	.db SPA,D,R,I,N,K, SPA, U,N,B,O,I,L,E,D, SPA, SPA,C,O,L,L,E,C,T,$FE
	.db SPA,C,R,O,S,S,$FF
Message1:
	.db D,R,lA,N,K, SPA, U,N,B,O,I,L,E,D, SPA, W,lA,T,E,R,$2A,$FE
	.db $2E,5,0, SPA, T,H,I,R,S,T,$2A,$FF
Message2:
	.db P,lA,T,H,O,G,E,N,S, SPA, I,N, SPA, W,lA,T,E,R,$2A, SPA, B,E,C,lA,M,E,$FE
	.db S,I,C,K,$2A,$FF
Message3:
	.db N,O,T,H,I,N,G, SPA, T,O, SPA, C,O,L,L,E,C,T, SPA, W,lA,T,E,R, SPA, W,I,T,H,$2A,$FF
Message4:
	.db J,lA,R, SPA, H,lA,S, SPA, S,O,M,E,T,H,I,N,G, SPA, I,N, SPA, I,T,$2A,$FE
	.db C,O,L,L,E,C,T,$31,$FE
	.db SPA,lY,SPA,N,$FF
Message5:
	.db J,lA,R, SPA, F,I,L,L,E,D, SPA, W,I,T,H, SPA, U,N,B,O,I,L,E,D,$FE
	.db F,R,E,S,H, SPA, W,lA,T,E,R,$2A,$FF
Message6:
	.db W,lA,T,E,R, SPA, T,O,O, SPA, F,lA,R, SPA, T,O, SPA, C,R,O,S,S,$2A,$FF
Message7:
	.db O,B,T,lA,I,N,E,D, SPA, lA, SPA, J,lA,R,$2A,$FF
Message8:
	.db O,B,T,lA,I,N,E,D, SPA, M,E,lA,T,$2A,$FF
Message9:
	.db T,H,E,R,E, SPA, I,S, SPA, S,lA,L,T, SPA, W,lA,T,E,R, SPA, H,E,R,E,$2A,$FE
	.db SPA,C,R,O,S,S,$FF
MessageA:
	.db O,T,H,E,R, SPA, S,I,D,E, SPA, O,B,S,T,R,U,C,T,E,D,$2A,$FF
MessageB:
	;It would be nice to just have an "Equipped with x" message, and then just draw the weapon string (which we already have), but that would be more trouble than it's worth and for whatever size gains (The routine would probably trump any data space saved unforunately)
	.db K,N,I,F,E, SPA, E,Q,U,I,P,P,E,D,$2A,$FF
MessageC:
	.db lA,L,R,E,lA,D,lY, SPA, E,Q,U,I,P,P,E,D,$2A,$FF
MessageD:
	.db J,lA,R, SPA, E,M,P,T,I,E,D,$2A,$FF
MessageE:
	.db lA,L,R,E,lA,D,lY, SPA, E,M,P,T,I,E,D,$2A,$FF
MessageF:
	.db E,M,P,T,lY,$2A,$FF
Message10:
	.db W,lA,T,E,R,$2A,$FF
Message11:
	.db M,lA,D,E, SPA, F,I,R,E, SPA, lA,N,D, SPA, B,O,I,L,E,D, SPA, W,lA,T,E,R,$2A,$FE
	.db W,lA,T,E,R, SPA, N,O,W, SPA, C,L,E,lA,N,$2A,$FE
	.db $2B,$2D,1, SPA, F,L,I,N,T,$29, SPA, $2D,5, SPA, S,T,I,C,K,S,$2A,$2C,$FF
Message12:
	.db C,lA,N,N,O,T, SPA, M,lA,K,E, SPA, F,I,R,E,$2A,$FE
	.db $2B,R,E,Q,U,I,R,E,S, SPA, 5, SPA, S,T,I,C,K,S, SPA, $2E, SPA, 1, SPA, F,L,I,N,T,$2A,$2C,$FF
Message13:
	.db D,R,lA,N,K, SPA, C,L,E,lA,N, SPA, W,lA,T,E,R,$2A,$FE
	.db $2E,7,5, SPA, T,H,I,R,S,T,$2A,$FF
Message14:
	.db J,lA,R, SPA, I,S, SPA, E,M,P,T,lY,$2A,$FF
Message15:
	.db lA,T,E, SPA, U,N,C,O,O,K,E,D, SPA, M,E,lA,T,$2A,$FE
	.db $2E,5,0, SPA, H,U,N,G,E,R,$2A,$FF
Message17:
	.db lA,T,E, SPA, C,O,O,K,E,D, SPA, M,E,lA,T,$2A,$FE
	.db $2E,6,0, SPA, H,U,N,G,E,R,$2A,$FF
Message18:
	.db B,lA,D, SPA, M,E,lA,T,$2A, SPA, B,E,C,lA,M,E, SPA, S,I,C,K,$2A,$FF
Message19:
	.db G,U,N, SPA, E,Q,U,I,P,P,E,D,$2A,$FF
Message1A:
	.db T,H,E, SPA, B,R,U,S,H, SPA, I,S, SPA, T,O,O, SPA, T,H,I,C,K, SPA, T,O,$FE
	.db B,E, SPA, C,U,T, SPA, W,I,T,H, SPA, lA, SPA, K,N,I,F,E,$2A,$FF
Message1B:
	.db O,B,T,lA,I,N,E,D, SPA, M,lA,C,H,E,T,E,$2A,$FF
Message1C:
	.db M,lA,C,H,E,T,E, SPA, E,Q,U,I,P,P,E,D,$2A,$FF
Message1D:
	.db O,B,T,lA,I,N,E,D, SPA, S,T,I,C,K,$2A,$FF
Message1E:
	.db S,T,I,C,K, SPA, E,Q,U,I,P,P,E,D,$2A,$FF
Message1F:
	.db O,B,T,lA,I,N,E,D, SPA, S,T,O,N,E,$2A,$FF
Message20:
	.db O,B,T,lA,I,N,E,D, SPA, F,L,I,N,T,$2A,$FF
Message21:
	.db C,lA,N,N,O,T, SPA, M,lA,K,E, SPA, S,P,E,lA,R,$2A,$FE
	.db $2B,R,E,Q,U,I,R,E,S, SPA, 1, SPA, S,T,I,C,K, SPA, $2E, SPA, 1, SPA, S,T,O,N,E,$2A,$2C,$FF
Message22:
	.db C,R,lA,F,T,E,D, SPA, lA, SPA, S,P,E,lA,R,$2A,$FF
Message23:
	.db C,lA,N,N,O,T, SPA, M,lA,K,E, SPA, T,O,R,C,H,$2A,$FE
	.db $2B,R,E,Q,U,I,R,E,S, SPA, 1, SPA, S,T,I,C,K, SPA, $2E, SPA, 1, SPA, F,L,I,N,T,$2A,$2C,$FF
Message24:
	.db C,R,lA,F,T,E,D, SPA, lA, SPA, T,O,R,C,H,$2A,$FF
Message25:
	.db S,P,E,lA,R, SPA, E,Q,U,I,P,P,E,D,$2A,$FF
Message26:
	.db O,U,T, SPA, O,F, SPA, W,E,lA,P,O,N,$2A,$FF
Message27:
	.db T,H,E, SPA, C,lA,V,E, SPA, I,S, SPA, P,I,T,C,H, SPA, B,L,lA,C,K,$2A,$FF
Message28:
	.db C,U,T, SPA, F,O,O,T, SPA, O,N, SPA, J,U,N,G,L,E, SPA, F,L,O,O,R,$2A,$FF
Message29:
	.db C,U,T, SPA, B,E,C,lA,M,E, SPA, I,N,F,E,C,T,E,D, SPA, B,lY, SPA, S,lA,N,D,$2A,$FF
Message2A:
	.db O,B,T,lA,I,N,E,D, SPA, C,L,O,T,H,$2A,$FF
Message2B:
	.db lY,O,U, SPA, lA,R,E, SPA, N,O,T, SPA, C,U,T,$2A,$FF
Message2C:
	.db U,S,E,D, SPA, T,O,U,R,N,I,Q,U,E,T, SPA, lA,N,D, SPA, L,E,T,$FE
	.db C,U,T, SPA, H,E,lA,L,$2A,$FF
Message2D:
	.db S,T,lA,T,U,S, SPA, R,E,T,U,R,N,E,D, SPA, T,O, SPA, N,O,R,M,lA,L,$2A,$FF
Message2E:
	.db lY,O,U, SPA, B,E,C,lA,M,E, SPA, P,O,I,S,O,N,E,D,$2A,$FF
Message2F:
	.db C,R,lA,F,T,I,N,G, SPA, Q,U,E,U,E, SPA, I,S, SPA, F,U,L,L,$2A,$FF
Message30:
	.db O,U,T, SPA, O,F, SPA, I,T,E,M,$2A,$FF
Message31:
	.db C,R,lA,F,T,E,D, SPA, lA, SPA, T,O,U,R,N,I,Q,U,E,T,$2A,$FF
Message32:
	.db N,O,T,H,I,N,G, SPA, H,lA,P,P,E,N,E,D,$2A,$FF
Message33:
	.db M,lA,lX, SPA, N,U,M,B,E,R, SPA, O,F, SPA, I,T,E,M,$2A,$FF
Message34:
	.db lY,O,U, SPA, C,lA,N,$26,T, SPA, S,lA,V,E, SPA, W,H,I,L,E, SPA, C,R,lA,F,T,I,N,G,$2A,$FF
Message35:
	.db lY,O,U,R, SPA, T,O,R,C,H, SPA, W,E,N,T, SPA, O,U,T,$2A,$FF
Message36:
	.db lY,O,U, SPA, R,lA,N, SPA, O,U,T, SPA, O,F, SPA, T,O,R,C,H,E,S,$2A,$FF
Message37:
	.db O,B,T,lA,I,N,E,D, SPA, H,O,N,E,lY,C,O,M,B,$2A,$FF
Message38:
	.db lA,T,E, SPA, H,O,N,E,lY,C,O,M,B,$2A, SPA, $2E,1,5, SPA, H,U,N,G,E,R,$2A,$FF
	

TryCrossWater:
	;for now, hard-coded can't cross
	;In the future
		;set the player's hitbox size to 16x8
		;use the midpoint for whatever direction the player's facing
		;Check the collision id of the metatile respective of the direction
		;If he can't cross, say the message
		;If he can, set the game state to "player crossing water", and the player state to "Crossing water" (Have it do a little animation)
		;The player moves 16 pixels forward in the respective direction
	lda #MSG_CANTCROSS
	sta message
	lda #STATE_DRAWINGMBOX
	sta game_state
	pla
	jmp SetPRGBank
	

M0R0_Cursor_XY:
	;X,Y
	;sorted by response #
	.db 8,24, 136,24, 8,32
Message0Response0:
	;what to do at fresh water - Drink unboiled, collect, cross
M0R0_ReadB:
	;pressing B exits the message box and goes back go the normal gameplay
	lda buttons_pressed
	and #BUTTONS_B
	beq M0R0_ReadBDone
	lda #STATE_ERASINGMBOX
	sta game_state
	pla
	jmp SetPRGBank
M0R0_ReadBDone:
	;draw cursor
	ldy oam_index
	lda message_response
	asl
	tax
	lda M0R0_Cursor_XY+0,x		;x
	sta $0203,y
	lda #$51					;left cursor
	sta $0201,y
	lda #0
	sta $0202,y
	lda M0R0_Cursor_XY+1,x		;y
	sta $0200,y
	tya
	clc
	adc #4
	sta oam_index
M0R0_ReadA:
	lda buttons_pressed
	and #BUTTONS_A
	beq @rts
	
	lda message_response
	beq @drinkunboiled
	cmp #1
	beq @collect
	jmp TryCrossWater
@drinkunboiled
	;drinking unboiled water
	lda thirst
	clc
	adc #50
	bcc @norollover
	lda #255
@norollover:
	sta thirst
	;let player know what happened
	lda #MSG_DRANKUNBOILEDWATER
	bne @done			;will always branch
@collect:
	lda #ITEM_JAR
	jsr CheckIfItemObtained
	beq @nojar
	;has jar
	lda jar_contents
	beq @jarempty
	;jar not empty
	lda #MSG_JARNOTEMPTY
	bne @done			;will always branch
@jarempty:
	lda #1
	sta jar_contents
	lda #MSG_JARFILLUNFRESHWATER
	bne @done			;will always branch
@nojar:
	lda #MSG_NOJAR
	bne @done			;will always branch
@done:
	sta message
	lda #STATE_DRAWINGMBOX
	sta game_state
@rts:
	pla
	jmp SetPRGBank
	
Message0Response1:
	;(randomly) make player sick
@readA:
	lda buttons_pressed
	and #(BUTTONS_A | BUTTONS_B)
	beq @readADone
	lda random
	and #%00000001
	bne @sick				;if the randomly generated number was odd, the player gets sick
	jsr EraseMBoxOrReinitInventory
	bne @readADone			;will always branch
@sick:
	lda status
	cmp #STATUS_SICK
	bne @continue
	jsr EraseMBoxOrReinitInventory
	bne @readADone			;will always branch
@continue:
	lda #STATUS_SICK
	sta status
	jsr FetchStatusRecoveryTime
	ldy #SFX_OHSHIT
	jsr PlaySound
	lda #MSG_BADFRESHWATER
	sta message
	lda #STATE_DRAWINGMBOX
	sta game_state
@readADone:
	pla
	jmp SetPRGBank
	

Message0Response2:
	;set game back to normal
@readBorA:
	lda buttons_pressed
	and #(BUTTONS_B | #BUTTONS_A)
	beq @readBorADone
	jsr EraseMBoxOrReinitInventory
@readBorADone:
	pla
	jmp SetPRGBank
	
	
M4R0_Cursor_XY:
	.db 8,32, 24,32
Message4Response0:
	;checks to see if player wants to replace contents of jar
	;NOTE - this may end up not being used, as water might be the only thing that can be put in a jar
M4R0_ReadB:
	lda buttons_pressed
	and #BUTTONS_B
	beq M4R0_ReadBDone
	lda #STATE_ERASINGMBOX
	sta game_state
	pla
	jmp SetPRGBank
M4R0_ReadBDone:
	;draw cursor
	ldy oam_index
	lda message_response
	asl
	tax
	lda M4R0_Cursor_XY+0,x		;x
	sta $0203,y
	lda #$51
	sta $0201,y
	lda #0
	sta $0202,y
	lda M4R0_Cursor_XY+1,x		;y
	sta $0200,y
	tya
	clc
	adc #4
	sta oam_index
M4R0_ReadA:
	lda buttons_pressed
	and #BUTTONS_A
	beq M4R0_ReadADone
	lda message_response
	beq @yes
@no:
	lda #STATE_ERASINGMBOX
	sta game_state
	pla
	jmp SetPRGBank
@yes:
	;(put unboiled fresh water in jar)
	lda #1
	sta jar_contents
	lda #MSG_JARFILLUNFRESHWATER
	sta message
	lda #STATE_DRAWINGMBOX
	sta game_state
M4R0_ReadADone:
	pla
	jmp SetPRGBank
	
Message9Response0:
;what to do at salt water - cross
M9R0_ReadB:
	;pressing B exits the message box and goes back go the normal gameplay
	lda buttons_pressed
	and #BUTTONS_B
	beq M9R0_ReadBDone
	jsr EraseMBoxOrReinitInventory
	pla
	jmp SetPRGBank
M9R0_ReadBDone:
	;draw cursor
	ldy oam_index
	lda #8		;x
	sta $0203,y
	lda #$51
	sta $0201,y
	lda #0
	sta $0202,y
	lda #24		;y
	sta $0200,y
	tya
	clc
	adc #4
	sta oam_index
M9R0_ReadA:
	lda buttons_pressed
	and #BUTTONS_A
	beq @rts
	jmp TryCrossWater
@rts:
	pla
	jmp SetPRGBank
	
Message11Response0:
;boil and then drink water
;Wait for the user to press A or B, and then have the player drink the water
M11R0_ReadAorB:
	lda buttons_pressed
	and #(BUTTONS_A | BUTTONS_B)
	beq @rts
	lda thirst
	clc
	adc #75
	bcc @skipoverflow
	lda #255
@skipoverflow:
	sta thirst
	lda #0
	sta jar_contents
	lda #MSG_DRANKCLEANWATER
	sta message
	lda #STATE_DRAWINGMBOX
	sta game_state
@rts:
	pla
	jmp SetPRGBank
	
Message15Response0:
	;eating uncooked meat
	;increase (decrease) player's health by 40, but randomly make him sick
M15R0_ReadAorB:
	lda buttons_pressed
	and #(BUTTONS_A | BUTTONS_B)
	beq @rts
	lda hunger
	clc
	adc #50
	bcc @skipoverflow
	lda #255
@skipoverflow:
	sta hunger
	lda #ITEM_MEAT
	ldy #1
	jsr SubtractFromItemCount
	lda status
	cmp #STATUS_SICK
	bne @notsick
	lda random
	and #%00000001
	bne @sick
@notsick:
	jsr EraseMBoxOrReinitInventory
	bne @rts			;will always branch
@sick:
	lda #STATUS_SICK
	sta status
	jsr FetchStatusRecoveryTime
	ldy #SFX_OHSHIT
	jsr PlaySound
	lda #MSG_BADMEAT
	sta message
	lda #STATE_DRAWINGMBOX
	sta game_state
@rts:
	pla
	jmp SetPRGBank
	
Message16Response0:
	;cook and then eat meat
	;wait for user to press A or B, and then have the player eat the meat (no homo)
M16R0_ReadAorB:
	lda buttons_pressed
	and #(BUTTONS_A | BUTTONS_B)
	beq @rts
	lda hunger
	clc
	adc #60
	bcc @skipoverflow
	lda #255
@skipoverflow:
	sta hunger
	lda #ITEM_MEAT
	ldy #1
	jsr SubtractFromItemCount
	lda #MSG_ATECOOKEDMEAT
	sta message
	lda #STATE_DRAWINGMBOX
	sta game_state
@rts:
	pla
	jmp SetPRGBank
	
	
Message22Response0:
	;(Happens after crafting an item) reset inventory system, including the crafting system
@readBorA:
	lda buttons_pressed
	and #(BUTTONS_B | BUTTONS_A)
	beq @readBorADone
	jsr CleanUpMBoxVars
	jsr CleanUpInventorySystem
	sta craft_queue+0			;A has 0
	sta craft_queue+1
	sta craft_queue+2
	sta craft_queue_count
	lda #STATE_INVENTORY
	sta game_state
@readBorADone:
	pla
	jmp SetPRGBank