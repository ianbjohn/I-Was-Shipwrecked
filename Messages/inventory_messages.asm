;Here, we aren't going to use the message system to draw these one character at a time (That would be annoying as shit if you're trying to go from item to item)
;Instead, we're going to draw it all directly to the buffer
;The structure here is
	;a table of the messages
	;a table for the logic for each item, which then has jump tables for all the different choices for each item
	;a table for how many choices each initial message has 
	;a table for what the cursor positions should be

InventoryMessages:
	;sorted by item
	.dw IM_Knife,IM_Jar,IM_Meat,IM_Flint,IM_Coconut,IM_Stick,IM_Aloe,IM_Spear
	.dw IM_BigBone,IM_Machete,IM_Stone,IM_Torch,IM_Cloth,IM_Tourniquet,IM_Gun,IM_Honeycomb
InventoryMessageLogics:
	.dw IML_Knife,IML_Jar,IML_Meat,IML_Flint,IML_Coconut,IML_Stick,IML_Aloe,IML_Spear
	.dw IML_BigBone,IML_Machete,IML_Stone,IML_Torch,IML_Cloth,IML_Tourniquet,IML_Gun,IML_Honeycomb
InventoryMessageChoices:
	.db 1,4,2,1,1,2,1,1
	.db 1,1,1,1,1,1,1
InventoryMessageCursorPositions:
	.dw IMCP_Knife,IMCP_Jar,IMCP_Meat,IMCP_Flint,IMCP_Coconut,IMCP_Stick,IMCP_Aloe,IMCP_Spear
	.dw IMCP_BigBone,IMCP_Machete,IMCP_Stone,IMCP_Torch,IMCP_Cloth,IMCP_Tourniquet,IMCP_Gun,IMCP_Honeycomb


IM_Knife:
IM_Spear:
IM_BigBone:
IM_Machete:
	.db SPA, E,Q,U,I,P,$FF
IM_Jar:
	.db SPA, E,M,P,T,lY, SPA,SPA, C,O,N,T,E,N,T,S, SPA,SPA, D,R,I,N,K,$FE,$FE
	.db SPA, B,O,I,L, $27, D,R,I,N,K,$FF
IM_Meat:
	;.db SPA, E,lA,T, SPA, R,lA,W, SPA,SPA, C,O,O,K, SPA, lA,N,D, SPA, E,lA,T,$FF
	.db SPA, E,lA,T, SPA,SPA,SPA,SPA,SPA,SPA, C,O,O,K, SPA, lA,N,D, SPA,$FE
	.db SPA, R,lA,W, SPA,SPA,SPA,SPA,SPA,SPA, E,lA,T,$FF
IM_Flint:
IM_Stone:
IM_Aloe:
IM_Cloth:
	.db SPA, lA,D,D, SPA, T,O, SPA, C,R,lA,F,T, SPA, Q,U,E,U,E,$FF
	.db SPA, M,lA,K,E, SPA, B,lA,N,D,lA,G,E,$FF
IM_Coconut:
IM_Stick:
	.db SPA, E,Q,U,I,P, SPA,SPA, lA,D,D, SPA, T,O, SPA, C,R,lA,F,T, SPA, Q,U,E,U,E,$FF
IM_Torch:
	.db SPA, N,O,T,H,I,N,G,$FE
	.db $FE
	.db $FC,$FF							;$FC is a special opcode to draw the remaining time a torch has to stay lit
IM_Tourniquet:
	.db SPA, U,S,E,$FF
IM_Gun:
	.db SPA, E,Q,U,I,P,$FE
	.db $FE
	.db R,O,U,N,D,S, $2F, $FD,$FF		;$FD is a special opcode to draw the tens and ones of the rounds variable as BCD
IM_Honeycomb:
	.db SPA, E,lA,T,$FF
	
	
IML_Knife:
	.dw IML_Knife_0
IML_Jar:
	.dw IML_Jar_0, IML_Jar_1, IML_Jar_2, IML_Jar_3
IML_Meat:
	.dw IML_Meat_0, IML_Meat_1
IML_Flint:
IML_Stone:
IML_Aloe:
IML_Cloth:
	.dw IML_Stick_1
IML_Coconut:
IML_Stick:
	.dw IML_Stick_0, IML_Stick_1
IML_Spear:
	.dw IML_Spear_0
IML_BigBone:
IML_Machete:
	.dw IML_Machete_0
IML_Torch:
	.dw IML_Torch_0
IML_Tourniquet:
	.dw IML_Tourniquet_0
IML_Gun:
	.dw IML_Gun_0
IML_Honeycomb
	.dw IML_Honeycomb_0
	
	
IML_Knife_0:
	lda weapon
	;cmp #WEAPON_KNIFE		;0
	beq @knifealreadyequipped
	jsr IncrementStickCount
	lda #WEAPON_KNIFE
	sta weapon
	jsr ChangeWeaponPalette
	lda #MSG_KNIFEEQUIPPED
	bne @draw
@knifealreadyequipped:
	lda #MSG_ALREADYEQUIPPED
@draw:
	sta message
	jmp Inventory_DrawCursor			;since these technically aren't subroutines, we need a JMP instead of an RTS
	
	
IML_Jar_0:
	lda jar_contents
	beq @emptyingdone
	lda #0
	sta jar_contents
	lda #MSG_JAREMPTIED
	bne @draw
@emptyingdone:
	lda #MSG_JARALREADYEMPTY
@draw:
	sta message
	jmp Inventory_DrawCursor
	
	
IML_Jar_1:
	ldx jar_contents
	lda JarContentsStringsIndices,x
	sta message
	jmp Inventory_DrawCursor
	
IML_Jar_2:
	;for right now, here we just assume that the jar will either be empty or have water in it.
	;later, we'll need to add a table of some kind to point to which message should be loaded so we know what to do based on what was in the jar (Same with IML_Jar_3)
	lda jar_contents
	beq @empty
	lda #0
	sta jar_contents	;jar should be empty after drinking what's inside it
	lda thirst
	clc
	adc #10
	bcc @skipoverflow
	lda #255
@skipoverflow:
	sta thirst
	lda #MSG_DRANKUNBOILEDWATER
	bne @draw			;will always branch
@empty:
	lda #MSG_JARISEMPTY
@draw:
	sta message
	jmp Inventory_DrawCursor
	
IML_Jar_3:
	;we should only be able to boil the water if there's water in the jar, and we have 5 sticks + 1 flint
	lda jar_contents
	beq @empty
	lda #ITEM_STICK
	jsr GetItemCount
	cmp #5
	bcc @cantboil
	lda #ITEM_FLINT
	jsr GetItemCount
	cmp #1
	bcc @cantboil
	;if we've gotten here, we have everything we need and we're ready to boil that water!!!
	lda #ITEM_STICK
	ldy #5
	jsr SubtractFromItemCount
	lda #ITEM_FLINT
	ldy #1
	jsr SubtractFromItemCount
	lda #MSG_MADEBOILFIRE
	bne @draw			;will always branch
@empty:
	lda #MSG_JARISEMPTY
	bne @draw			;^
@cantboil:
	lda #MSG_CANTMAKEFIRE
@draw:
	sta message
	jmp Inventory_DrawCursor
	
	
IML_Meat_0:
	lda #ITEM_MEAT
	jsr GetItemCount
	beq @nomeat
	lda #MSG_ATERAWMEAT
	bne @draw			;will always branch
@nomeat:
	lda #MSG_OUTOFITEM
@draw:
	sta message
	jmp Inventory_DrawCursor
	
IML_Meat_1:
	;Similar to boiling water, we should only be able to cook the meat if we have meat, and we have 5 sticks + 1 flint
	lda #ITEM_MEAT
	jsr GetItemCount
	beq @nomeat
	lda #ITEM_STICK
	jsr GetItemCount
	cmp #5
	bcc @cantcook
	lda #ITEM_FLINT
	jsr GetItemCount
	beq @cantcook
	;cmp #1
	;bcc @cantcook
	;if we've gotten here, we have everything we need and we're ready to cook that meat!!!
	lda #ITEM_STICK
	ldy #5
	jsr SubtractFromItemCount
	lda #ITEM_FLINT
	ldy #1
	jsr SubtractFromItemCount
	lda #MSG_MADECOOKFIRE
	bne @draw			;will always branch
@nomeat:
	lda #MSG_OUTOFITEM
	bne @draw
@cantcook:
	lda #MSG_CANTMAKEFIRE
@draw:
	sta message
	jmp Inventory_DrawCursor
	
	
IML_Gun_0:
	lda weapon
	cmp #WEAPON_BULLET
	beq @gunalreadyequipped
	jsr IncrementStickCount
	lda #WEAPON_BULLET
	sta weapon
	jsr ChangeWeaponPalette
	lda #MSG_GUNEQUIPPED
	bne @draw
@gunalreadyequipped:
	lda #MSG_ALREADYEQUIPPED
@draw:
	sta message
	jmp Inventory_DrawCursor			;since these technically aren't subroutines, we need a JMP instead of an RTS
	
	
IML_Machete_0:
	lda weapon
	cmp #WEAPON_MACHETE
	beq @knifealreadyequipped
	jsr IncrementStickCount
	lda #WEAPON_MACHETE
	sta weapon
	jsr ChangeWeaponPalette
	lda #MSG_MACHETEEQUIPPED
	bne @draw
@knifealreadyequipped:
	lda #MSG_ALREADYEQUIPPED
@draw:
	sta message
	jmp Inventory_DrawCursor			;since these technically aren't subroutines, we need a JMP instead of an RTS
	
	
	;.db "IMLS0"
IML_Stick_0:
	lda weapon
	cmp #WEAPON_STICK
	beq @stickalreadyequipped
	lda #ITEM_STICK
	jsr GetItemCount
	beq @nosticks
	lda #ITEM_STICK
	ldy #1
	jsr SubtractFromItemCount
	lda #WEAPON_STICK
	sta weapon
	lda #MSG_STICKEQUIPPED
	bne @draw
@stickalreadyequipped:
	lda #MSG_ALREADYEQUIPPED
	bne @draw
@nosticks:
	lda #MSG_OUTOFITEM
@draw:
	sta message
	jmp Inventory_DrawCursor
	
	
IML_Stick_1:
	;this is the general "Add item to crafting queue" logic.
	lda craft_queue_count
	cmp #3
	bcc @continue
	lda #MSG_CRAFTQUEUEFULL
	sta message
	jmp Inventory_DrawCursor
@continue:
	lda selected_item
	jsr GetItemCount
	bne @continue2
	lda #MSG_OUTOFITEM
	sta message
	jmp Inventory_DrawCursor
@continue2:
	lda selected_item
	ldx craft_queue_count
	sta craft_queue,x
	inc craft_queue_count
	ldy #1
	jsr SubtractFromItemCount
	lda #0
	sta game_state_old				;trick the state machine into thinking the inventory state should be re-initialized
	jsr EraseMBoxOrReinitInventory
	pla
	jmp SetPRGBank
	
	
IML_Spear_0:
	lda weapon
	cmp #WEAPON_SPEAR
	beq @spearalreadyequipped
	jsr IncrementStickCount
	lda #WEAPON_SPEAR
	sta weapon
	jsr ChangeWeaponPalette
	lda #MSG_SPEAREQUIPPED
	bne @draw
@spearalreadyequipped:
	lda #MSG_ALREADYEQUIPPED
@draw:
	sta message
	jmp Inventory_DrawCursor
	

IML_Torch_0:
	lda #MSG_NOTHINGHAPPENED
	sta message
	jmp Inventory_DrawCursor
	
	
IML_Tourniquet_0:
	lda #ITEM_TOURNIQUET
	jsr GetItemCount
	beq @notourni
	lda status
	cmp #STATUS_CUT
	bne @notcut
	lda #ITEM_TOURNIQUET
	ldy #1
	jsr SubtractFromItemCount
	lda #STATUS_NORMAL
	sta status
	lda #MSG_USEDTOURNIQUET
	bne @draw
@notourni:
	lda #MSG_OUTOFITEM
	bne @draw
@notcut:
	lda #MSG_NOTCUT
@draw:
	sta message
	jmp Inventory_DrawCursor
	
	
IML_Honeycomb_0:
	lda #ITEM_HONEYCOMB
	jsr GetItemCount
	beq @nohoneycomb
	lda hunger
	clc
	adc #15
	bcc @skipoverflow
	lda #255
@skipoverflow:
	sta hunger
	lda #ITEM_HONEYCOMB
	ldy #1
	jsr SubtractFromItemCount
	lda MSG_ATEHONEYCOMB
	bne @draw
@nohoneycomb:
	lda #MSG_OUTOFITEM
@draw:
	sta message
	jmp Inventory_DrawCursor
	
	
IncrementStickCount:
	;if the player was using the stick as a weapon but changes weapons, put the stick back in the inventory
	lda weapon
	cmp #WEAPON_STICK
	bne @done
	lda #ITEM_STICK
	ldy #1
	jmp AddToItemCount
@done:
	rts
	

IMCP_Knife:
IMCP_Jar:
IMCP_Spear:
IMCP_BigBone:
IMCP_Machete:
IMCP_Gun:
	.db 8,16, 64,16, 144,16, 8,32
IMCP_Meat:
	.db 8,16, 80,16
IMCP_Coconut:
IMCP_Stick:
IMCP_Stone:
IMCP_Flint:
IMCP_Cloth:
IMCP_Aloe:
IMCP_Torch:
IMCP_Tourniquet:
IMCP_Honeycomb:
	.db 8,16, 64,16