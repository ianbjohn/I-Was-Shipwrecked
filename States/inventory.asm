InventoryItemRowPositions:
	;PPU positions for the Y position of items
	.dw $2101, $2181, $2201, $2281
InventorySaveString:
	.db S,lA,V,E
InventoryPageString:
	.db P,lA,G,E,SPA
InventoryQueueString:
	.db Q,U,E,U,E,$2F,SPA
InventoryClearString:
	.db C,L,E,lA,R
InventoryCraftString:
	.db C,R,lA,F,T
InventoryListString:
	.db L,I,S,T
	
ItemCraftable:
	;sorted by item ID
	.db 0,0,0,1,0,1,0,0,0,0,1,0,1,0,0,0
	
CraftTable:
	;when the player crafts an item, it uses what's in the crafting queue and hashes it to get a value between 0-63.
	;This table maps that value to items that would be crafted. (i.e stick + stone -> 8, so the 8th entry in the table (0-based) would correspond to the spear item. Stone + stick -> 1C, so entry 1C would also be a spear)
	;0 here means no item corresponds to the respective hash value
	.db 0,0,0,0,0,0,0,ITEM_TORCH,ITEM_SPEAR,0,0,ITEM_TOURNIQUET,0,0,0,0
	.db 0,0,0,0,0,0,0,0,0,0,0,0,ITEM_SPEAR,0,0,0
	.db 0,0,0,0,0,0,ITEM_TOURNIQUET,0,0,0,0,0,0,0,0,0
	.db 0,0,0,0,0,0,0,0,0,ITEM_TORCH,0,0,0,0,0,0
	
CraftMessages:
	;sorted by craftable item ID
	;which "Crafted X item" to draw based on the item that was crafted
	.db MSG_CRAFTEDSPEAR,MSG_CRAFTEDTORCH,MSG_CRAFTEDTOURNIQUET
	
ReverseCraftItemsMap:
	;maps items to their craftable item counterpart
	.db 0,0,0,0,0,0,0,CR_ITEM_SPEAR,0,0,0,CR_ITEM_TORCH,0,CR_ITEM_TOURNIQUET,0,0
	
	
ChangeWeaponPalette:
	;For right now I only think the weapon will change in the inventory state, so this can go here
	lda weapon
	asl
	tax
	lda PlayerWeaponPalettes+0,x
	sta ptr1+0
	lda PlayerWeaponPalettes+1,x
	sta ptr1+1
	ldx vram_buffer_pos
	lda #$3F
	sta vram_buffer+0,x
	lda #$15
	sta vram_buffer+1,x
	lda #<(Copy3Bytes-1)
	sta vram_buffer+2,x
	lda #>(Copy3Bytes-1)
	sta vram_buffer+3,x
	ldy #0
-	lda (ptr1),y
	sta vram_buffer+4,x
	inx
	iny
	cpy #3
	bne -
	txa
	clc
	adc #4
	sta vram_buffer_pos
	rts
	

CleanUpInventorySystem:
	lda #0
	ldx #26
@clear:
	sta in_inventory_state-1,x				;check the varsandconsts file, this clears all the inventory system variables (Excluding the crafting queue, since it should only be cleared manually by the player or by leaving the inventory state)
	dex
	bne @clear
	rts
	
	
InventoryInit:
	jsr ClearOAM

	;turn off PPU and disable NMIs
	lda #%00000110
	sta $2001
	lda #0
	sta nmi_enabled
	
	;this state might have been re-initialized after the player made a choice with an item, since other items' counts and whatnot can potentially be altered in the process, and they need to be updated so the player can know. Therefore, we need to draw the status board to the PPU (Even if it's already there)
	jsr DrawStatusBoard
	
	;clear the screen, except for the status board
	;clear nametable
	lda $2002
	lda #$20
	sta $2006
	lda #$C0
	sta $2006
	ldx #3
	ldy #0
	lda #$24
@clearScreen:
	sta $2007
	iny
	bne @clearScreen
	dex
	bne @clearScreen
	
	;clear attribute table
	lda $2002
	lda #$23
	sta $2006
	lda #$C0
	sta $2006
	lda #%11111111
	ldx #64
@clearattributes:
	sta $2007
	dex
	bne @clearattributes
	
	;let the game know that we're in the inventory state, and that message boxes are gonna work a little differently
	inc in_inventory_state
	
	;figure out how many pages the inventory system currently has
	lda num_obtained_items
	lsr
	lsr
	lsr
	lsr					;pages = num_obtained_items / 16
	sta inventory_pages
	
@drawccraftstuff:
	;only draw this, and "craft", if the craft queue isn't empty
	lda craft_queue_count
	bne @continue
	jmp @drawcraftstuffdone
@continue:
	lda $2002
	lda #$20			;left of "save"
	sta $2006
	lda #$C2
	sta $2006
	ldx #0
@craft:
	lda InventoryCraftString,x
	sta $2007
	inx
	cpx #5
	bne @craft
	;lda $2002
	lda #$20			;right of "save"
	sta $2006
	lda #$D9
	sta $2006
	ldx #0
@clear:
	lda InventoryClearString,x
	sta $2007
	inx
	cpx #5
	bne @clear
@queue:
	;lda $2002
	lda #$23
	sta $2006
	lda #$21
	sta $2006
	ldx #0
	stx temp0						;used to keep track of which item in the queue we're currently drawing
@queuestring:
	lda InventoryQueueString,x
	sta $2007
	inx
	cpx #6
	bne @queuestring
	lda #SPA
	sta $2007						
@queueitem:
	ldx temp0
	lda craft_queue,x
	asl
	tax
	lda ItemStrings,x
	sta ptr1+0
	lda ItemStrings+1,x
	sta ptr1+1
	ldy #0
@queueitemstringloop:
	lda (ptr1),y
	cmp #$FF
	bne @cont
	inc temp0
	lda temp0
	cmp craft_queue_count
	beq @drawcraftstuffdone
	lda #$29					;,
	sta $2007
	lda #SPA
	sta $2007
	bne @queueitem				;will always branch
@cont:
	sta $2007
	iny
	bne @queueitemstringloop	;will always branch
@drawcraftstuffdone:

@drawlist:
	lda #$23
	sta $2006
	lda #$57					;bottom-right-ish of the screen below the craft queue but above "page"
	sta $2006
	ldx #0
@drawlistloop:
	lda InventoryListString,x
	sta $2007
	inx
	cpx #4
	bne @drawlistloop
	
@drawsave
	;only draw this, and have saving as an option, if all the monsters on the screen have been killed
	lda num_active_enemies
	bne @drawsavedone
	lda $2002
	lda #$20
	sta $2006
	lda #$CE
	sta $2006
	ldx #0
@drawsaveloop:
	lda InventorySaveString,x
	sta $2007
	inx
	cpx #4
	bne @drawsaveloop
@drawsavedone:
	
	;Draw the borders around what'll be the item strings and counts
	;More gross-looking direct-writes to the PPU. But it's okay since it's turned off :^)
;	lda $2002
;	lda #$20
;	sta $2006
;	lda #$E0
;	sta $2006
;	ldx #4
;DrawInventoryBorders:
;	ldy #4
;@loop1:
;	lda #$34			;top-left corner
;	sta $2007
;	lda #$38			;horizontal
;	sta $2007
;	sta $2007
;	sta $2007
;	sta $2007
;	sta $2007
;	sta $2007
;	lda #$35			;top-right corner
;	sta $2007
;	dey
;	bne @loop1
;	ldy #12
;@loop2:
;	lda #$39			;vertical
;	sta $2007
;	lda #SPA
;	sta $2007
;	sta $2007
;	sta $2007
;	sta $2007
;	sta $2007
;	sta $2007
;	lda #$39
;	sta $2007
;	dey
;	bne @loop2
;	ldy #4
;@loop3
;	lda #$36			;bottom-left corner
;	sta $2007
;	lda #$38
;	sta $2007
;	sta $2007
;	sta $2007
;	sta $2007
;	sta $2007
;	sta $2007
;	lda #$37			;bottom-right corner
;	sta $2007
;	dey
;	bne @loop3
;	dex
;	bne DrawInventoryBorders
	
	;All inventory system variables should be reset (done when exiting the state), so we should be okay
	;to find where to start loading items from, we need to multiply the page # by 16 (how many items can be on one screen)
DrawItems:
	;figure out which items to draw on the current page
	lda inventory_page
	asl
	asl
	asl
	asl
	sta temp3
	;count which items have have been obtained compared to the current page to figure out what items to load on this page
	ldx #0
	stx temp2
@countobtaineditemsloop
	lda temp2
	cmp temp3
	beq @loopdone
	stx temp1						;save x
	jsr CheckIfItemObtained
	beq @countobtaineditemsloop
	ldx temp1
	inx
	inc temp2
	bne @countobtaineditemsloop		;will always branch
@loopdone:
	stx temp2						;temp2 now has the ITEM INDEX of the first item to draw on this page
ProcessItem:
	;stop drawing items if 16 have already been drawn
	lda items_on_screen
	cmp #16
	bne @continue
	jmp DrawItemsDone
@continue:
	;also stop drawing items if we've drawn the total number of them
	lda temp2
	cmp #NUM_TOTAL_ITEMS
	bne @continue2
	jmp DrawItemsDone
@continue2:
	jsr CheckIfItemObtained			;only draw item if player has obtained it
	bne @continue3
	jmp ProcessItemDone
@continue3:
	;item has been obtained, so let's draw it
	;we need to let the inventory system know which items are being stored in the 16 slots
	;^The array for this, however, is 1-based (Since 0 means the slot's empty), so we need to add 1 to the item ID
	lda temp0						;the item ID (which would have otherwise gotten clobbered while checking if it'd been obtained) needs to be restored from temp0
	ldx items_on_screen
	sta inventory_screen_items,x
	inc inventory_screen_items,x	;increment to account for the 1-based indexing
	
	;draw the data about the item (String, quantity)
	lda $2002
	;get row
	lda items_on_screen
	and #%00001100			;the two saved bits tell which row to draw the items on
	lsr						;shift down once, we're going to use this as an index to access the word table to find which base PPU address to draw to
	tax
	lda InventoryItemRowPositions+0,x
	sta temp0				;save low byte of where to draw
	lda items_on_screen
	and #%00000011			;the two saved bits tell which column to draw the items on
	asl
	asl
	asl						;multiply by 8 since cells are 8 tiles wide
	clc
	adc temp0
	sta temp0				;we're gonna need to update this when drawing the count. Keep a copy of where we are rather than recalculating all this
	pha						;save low byte of base+offset
	lda InventoryItemRowPositions+1,x
	adc #0
	sta temp1				;save the high byte of where we are so we can update it too
	sta $2006				;store high byte of base+offset as PPU address (high byte needs to come first)
	pla
	sta $2006				;finally set the low byte of the address
	;draw the string
	;use the item id as index to get the pointer to the string data
	lda temp2
	asl
	tax
	lda ItemStrings+0,x
	sta ptr1+0
	lda ItemStrings+1,x
	sta ptr1+1
	ldy #0
DrawItemString:
	lda (ptr1),y
	cmp #$FF
	bne @continue
	jmp DrawItemStringDone
@continue:
	cmp #$FE
	bne @continue2
	;(new line)
	lda $2002
	lda temp0
	clc
	adc #32
	pha
	lda temp1
	adc #0
	sta $2006
	pla
	sta $2006
	iny
	bne DrawItemString		;will always branch
	;jmp DrawItemStringDone
@continue2:
	sta $2007
	iny
	bne DrawItemString		;will always branch
DrawItemStringDone:
	
DrawItemCount:
	;draw the count of the item
	;temp0 and temp 1 currently have the low and high byte of where in $2006 we're at, respectively.
	;We need to go to a new line, so we need to add 32 to the address
	lda $2002
	lda temp0
	clc
	adc #64
	pha
	lda temp1
	adc #0
	sta $2006
	pla
	sta $2006
	lda temp2
	jsr CheckIfItemHasCount
	beq @hardcodedcount
@bcdcount:
	lda temp2				;need to reload since it got clobbered by the above routine
	;if the item has a count, we need to convert it to BCD and draw the tens and ones to the screen
	jsr GetItemCount		;returns the count of the item
	sta bcd_value+0
	jsr BCD_8				;and then converts it to BCD
	lda bcd_tens
	sta $2007
	lda bcd_ones
	sta $2007
	lda #$30				; "/15"
	sta $2007
	lda #1
	sta $2007
	lda #5
	sta $2007
	bne DrawItemCountDone	;will always branch
@hardcodedcount:
	lda #1					;if an item doesn't have a count, the player can only have one of it. In this case we can just hard-code these 3 tiles
	sta $2007
	lda #$30				; "/1"
	sta $2007
	lda #1
	sta $2007
DrawItemCountDone:

	inc items_on_screen
ProcessItemDone:
	inc temp2				;item hasn't been obtained yet, so try the next one
	jmp ProcessItem
DrawItemsDone:

	;draw page # / page #s
DrawPageNumber:
	lda $2002
	lda #$23
	sta $2006
	lda #$6C
	sta $2006
	ldx #0
@drawpagestring:
	lda InventoryPageString,x
	sta $2007
	inx
	cpx #5
	bne @drawpagestring
	;draw which page we're at now
	ldx inventory_page
	inx					;account for the fact that page # are 1-based
	stx $2007
	lda #$30			; /
	sta $2007
	;draw how many total pages there are
	ldx inventory_pages
	inx
	stx $2007

	lda #%00011110
	sta soft_2001
	lda #1
	sta nmi_enabled
	rts
	
	
InventoryCursorXs:
	.db $1A, $5A, $9A, $DA
InventoryCursorYs:
	.db $58, $78, $98, $B8
	
InventoryAButtonActions:
	;sorted by inventory_status
	.dw InventoryA_Normal, InventoryA_Save, Inventory_ReadB, InventoryA_ItemAction, InventoryA_CraftItem, InventoryA_ClearCraftQueue, InventoryA_ViewList
	

InventoryMain:
	lda prg_bank
	pha
	lda #BANK_MESSAGES
	jsr SetPRGBank
	
	;if the player is in the "item action" substate, we know there was an item in whatever cell was selected
	lda inventory_status
	cmp #3
	bne Inventory_ReadA:
@drawitemactioncursor:
	lda inventory_cursor_y
	asl
	asl						;multiply by 4 since its a 4x4 grid
	ora inventory_cursor_x	;combine high nibble Y with low nibble X
	tax
	ldy inventory_screen_items,x
	dey						;account for 1-based indexing
	tya
	asl						;accessing word table
	tax
	lda InventoryMessageCursorPositions+0,x
	sta ptr1+0
	lda InventoryMessageCursorPositions+1,x
	sta ptr1+1
	lda inventory_choice
	asl						;accessing "tuples" of X and Y
	tay
	ldx oam_index
	lda (ptr1),y			;X
	sta $0203,x
	iny
	lda (ptr1),y			;Y
	sta $0200,x
	lda #$51				;left cursor
	sta $0201,x
	lda #0
	sta $0202,x
	txa
	clc
	adc #4
	sta oam_index
	
Inventory_ReadA:
	lda buttons_pressed
	and #BUTTONS_A
	bne @continue
	jmp Inventory_ReadB
@continue:
	lda inventory_status
	asl
	tax
	lda InventoryAButtonActions+0,x
	sta jump_ptr+0
	lda InventoryAButtonActions+1,x
	sta jump_ptr+1
	jmp (jump_ptr)
	
InventoryA_Normal:
	;(if there's an item in the cell, draw what can be done with it to where the status board is)
	;whatever item cell is currently selected, draw either the right inventory message, or blackspace, to the status board
	;Use the X and Y of the cursor to get the item id of the cell
	lda inventory_cursor_y
	asl
	asl						;multiply by 4 since its a 4x4 grid
	ora inventory_cursor_x	;combine high nibble Y with low nibble X
	tax
	ldy inventory_screen_items,x
	bne @itemincel
	jmp Inventory_ReadB
@itemincel:
	lda #0					;reset the position of the choice cursor
	sta inventory_choice
	dey						;account for the 1-based indexing
	;Y now has the correct item id
	tya
	sta selected_item
	jsr DrawInventoryMessageToBuffer
	lda #3					;let the game know an item's been selected
	sta inventory_status
	jmp Inventory_DrawCursor
	
InventoryA_ItemAction:
	;call the right routine for the selected item's logic
	lda selected_item				;should have already been computed
	asl
	tay
	lda InventoryMessageLogics+0,y
	sta ptr1+0
	lda InventoryMessageLogics+1,y
	sta ptr1+1						;the logic is nested based on the item, and the choice made
	lda inventory_choice
	asl
	tay
	lda (ptr1),y
	sta jump_ptr+0
	iny
	lda (ptr1),y
	sta jump_ptr+1
	lda #STATE_DRAWINGMBOX
	sta game_state
	lda #0
	sta inventory_status
	jmp (jump_ptr)			;each routine should, instead of RTS, JMP back to Inventory_DrawCursor
	
InventoryA_Save:
	lda craft_queue_count	;only save if the crafting queue is empty, so items don't get lost
	beq @cansave
	lda #MSG_CANTSAVEWHILECRAFTING
	sta message
	lda #STATE_DRAWINGMBOX
	sta game_state
	jmp Inventory_DrawCursor
@cansave:
	SaveFileData			;save the game!!!!!
	;Play a sound effect
	ldy #SFX_SAVE
	jsr PlaySound
	jmp Inventory_DrawCursor
	

InventoryA_CraftItem:
	jsr CraftItem
	lda CraftTable,x
	beq @nothinghappened
	sta temp2				;save the item ID since we're going to need it later
	jsr CheckIfItemObtained
	bne @continue
	lda temp2
	jsr SetItemAsObtained
@continue:
	lda temp2
	jsr GetItemCount		;for now we can assume that any item that can get crafted will have a count, but this may change. In which case, be sure to check
	cmp #15
	beq @maxitemcount
	lda temp2
	ldy #1
	jsr AddToItemCount
	;if the item that was just crafted was a torch, and the count is now 1, and we're in a cave, load the lit cave palette
@resetcavepalette:
	;better commented in loadingscreen.asm
	lda area
	cmp #AREA_CAVE
	bne @resetcavepalettedone
	lda temp2
	cmp #ITEM_TORCH
	bne @resetcavepalettedone
	jsr GetItemCount
	cmp #1
	bne @resetcavepalettedone
	lda #BANK_METATILES
	jsr SetPRGBank
	lda cave_level
	asl
	tax
	lda CaveScreens+0,x
	sta mt_ptr1+0
	lda CaveScreens+1,x
	sta mt_ptr1+1
	lda screen
	asl
	tay
	lda (mt_ptr1),y
	sta ptr1+0		;will be used as the pointer for screen data
	iny
	lda (mt_ptr1),y
	sta ptr1+1
	jsr LoadScreenPalette
@resetcavepalettedone:
	ldx temp2
	lda ReverseCraftItemsMap,x
	sta temp2					;we're going to need this later too
	jsr CheckIfItemCrafted
	bne @checkcrafteddone
	lda temp2
	jsr SetItemAsCrafted
@checkcrafteddone:
	ldx temp2
	lda CraftMessages,x
	bne @continue2				;w.a.b
@maxitemcount:
	lda #MSG_MAXITEMCOUNT
	bne @continue2				;w.a.b
@nothinghappened:
	lda #MSG_NOTHINGHAPPENED
@continue2:
	sta message
	lda #STATE_DRAWINGMBOX
	sta game_state
	jmp Inventory_DrawCursor
	
InventoryA_ClearCraftQueue:
	jsr ClearCraftQueue
	jsr CleanUpInventorySystem
	lda #0						;re-initialize inventory state
	sta game_state_old
	jmp Inventory_DrawCursor
	
InventoryA_ViewList:
	lda #STATE_RECIPELIST
	sta game_state
	jmp Inventory_DrawCursor
	
Inventory_ReadB:
	;if B or START is pressed, exit this state
	lda buttons_pressed
	and #(BUTTONS_B | BUTTONS_START)
	beq Inventory_ReadSelect
	
	;if we're in substate #3 (item action), go back to #0 (normal)
	;else, exit this game state entirely
	lda inventory_status
	cmp #3
	bne @exit
	;we have two status board draw routines. One to draw the whole thing directly to the PPU (Which as a result must be turned off), and one to draw it tile-by tile to the buffer. These are both pretty big subroutines, so I really don't want to add another one where it draws the whole thing to the buffer.
		;So here I'm just gonna turn the PPU off for a single frame, redraw the status board, and turn it back on.
	lda #%00000110
	sta $2001
	lda #0
	sta nmi_enabled
	jsr DrawStatusBoard
	lda #%00011110
	sta soft_2001
	lda #1
	sta nmi_enabled
	lda #0
	tax
	sta inventory_status
	jmp InventoryMain_Done
	
@exit:
	jsr CleanUpInventorySystem
@clearcraftstuff:
	jsr ClearCraftQueue
	;When returning back to the play state, we need to reload the metatiles, attributes, and all that fun stuff from RAM, so we go to the Play state init code to do this
	lda #STATE_PLAY
	sta game_state
	jmp InventoryMain_Done
	
Inventory_ReadSelect:
	;pressing SELECT moves the cursor corresponding to the choices that can be made for a selected item
	lda buttons_pressed
	and #BUTTONS_SELECT
	beq Inventory_ReadUp
	
	lda inventory_status
	cmp #3						;item action
	bne Inventory_ReadUp		;we only need to do shit here if we're normal (i.e not at save or page and just looking at an item)
	
	;select the next possible thing to do with the item, wrapping around if necessary
	lda inventory_choice
	clc
	adc #1
	cmp inventory_choices
	bcc @skipoverflow
	lda #0
@skipoverflow:
	sta inventory_choice
	jmp Inventory_DrawCursor
	
Inventory_ReadUp:
	;ReadDown is better commented
	lda buttons_pressed
	and #BUTTONS_UP
	beq Inventory_ReadDown
	
	ldy #SFX_SELECTION			;play sfx
	jsr PlaySound
	lda inventory_status
	beq @normal
	cmp #1
	beq @gofromsavetopage
	cmp #2
	beq @gofrompagetolist
	cmp #4
	beq @gofromcrafttopage
	cmp #5
	beq @gofromcleartopage
	cmp #6
	beq @gofromlisttonormal
	bne Inventory_ReadDown
@gofromlisttonormal:
	lda #0
	sta inventory_status
	lda #3
	sta inventory_cursor_y
	jmp Inventory_ReadLeft
	
@gofrompagetolist:
	lda #6
	sta inventory_status
	jmp Inventory_ReadLeft
	
@gofromsavetopage:
@gofromcrafttopage:
@gofromcleartopage:
	lda #2
	sta inventory_status
	jmp Inventory_ReadLeft
	
@normal:
	lda inventory_cursor_y
	sec
	sbc #1
	bcs @skipunderflow
	;check if save is an option. If it is, go there, if not go to craft if possible, otherwise, go to page
	lda num_active_enemies
	beq @cangotosave
	lda craft_queue_count
	bne @cangotocraft
	;can't go to save, so just go to page
	lda #2
	bne @continue
@cangotosave:
	lda #1
	bne @continue
@cangotocraft:
	lda #4
@continue:
	sta inventory_status
	jmp Inventory_ReadLeft
@skipunderflow:
	sta inventory_cursor_y
	jmp Inventory_ReadLeft

Inventory_ReadDown:
	lda buttons_pressed
	and #BUTTONS_DOWN
	beq Inventory_ReadLeft
	
	ldy #SFX_SELECTION			;play sfx
	jsr PlaySound
	lda inventory_status
	beq @normal
	cmp #1
	beq @gofromsavetonormal
	cmp #2
	beq @gofrompagetosave
	cmp #4
	beq @gofromcrafttonormal
	cmp #5
	beq @gofromcleartonormal
	cmp #6
	beq @gofromlisttopage
	bne Inventory_ReadLeft
@gofrompagetosave:
	;we were at page. Now we need to go to either save if we can, if not go to craft if we can, otherwise back to normal
	lda num_active_enemies
	beq @cangotosave
	lda craft_queue_count
	bne @cangotocraft
	lda #0
	sta inventory_cursor_y		;wrap the cursor to the top
	beq @continue				;will always branch
@cangotosave:
	lda #1
	bne @continue
@cangotocraft:
	lda #4
@continue:
	sta inventory_status
	jmp Inventory_ReadLeft
	
@gofromsavetonormal:
@gofromcrafttonormal:
@gofromcleartonormal:
	lda #0
	sta inventory_status
	sta inventory_cursor_y
	beq Inventory_ReadLeft		;will always branch
	
@gofromlisttopage:
	lda #2
	sta inventory_status
	bne Inventory_ReadLeft
	
@normal:
	;do the normal thing and advance the cursor down by one
	lda inventory_cursor_y
	clc
	adc #1
	cmp #4
	bcc @skipoverflow
	;now at list
	lda #6					;list
	sta inventory_status
	lda #3
@skipoverflow:
	sta inventory_cursor_y
	
Inventory_ReadLeft:
	lda buttons_pressed
	and #BUTTONS_LEFT
	bne @continue
	jmp Inventory_ReadRight
@continue:
	ldy #SFX_SELECTION			;play sfx
	jsr PlaySound
	lda inventory_status
	beq @normal
	cmp #1					;don't do anything if save is selected
	beq @gofromsavetocraft
	cmp #2
	beq @prevpage
	cmp #3
	beq @itemaction
	cmp #4
	beq @gofromcrafttoclear
	cmp #5
	beq @gofromcleartosave
	jmp Inventory_DrawCursor	;don't do anything if list is selected
@normal:
	;simply move the cursor back 1, wrapping if necessary
	lda inventory_cursor_x
	sec
	sbc #1
	bcs @skipunderflow2
	lda #3
@skipunderflow2:
	sta inventory_cursor_x
	jmp Inventory_DrawCursor
@gofromsavetocraft:
	;only do so if the craft queue isn't empty
	lda craft_queue_count
	bne @cangotocraft
	jmp Inventory_DrawCursor
@cangotocraft:
	lda #4
	sta inventory_status
	jmp Inventory_DrawCursor
@prevpage:
	;if "page" is selected, and if we aren't at the first page, go back a page
	lda inventory_page
	sec
	sbc #1
	bcs @prev
	jmp Inventory_DrawCursor
@prev:
	;go to the previous page
	sta inventory_page
	lda #STATE_PLAY				;we need to re-initialize the game state, so set game_state to a state that isn't the inventory state
	sta game_state_old
	jmp Inventory_DrawCursor
@itemaction:
	;if we've gotten here, that means the player's selecting what to do with a selected item
	lda inventory_cursor_y
	asl
	asl						;multiply by 4 since its a 4x4 grid
	ora inventory_cursor_x	;combine high nibble Y with low nibble X
	tax
	ldy inventory_screen_items,x
	dey
	lda inventory_choice
	sec
	sbc #1
	bcs @skipunderflow
	ldx InventoryMessageChoices,y
	dex
	txa
@skipunderflow:
	sta inventory_choice
	jmp Inventory_DrawCursor
@gofromcrafttoclear:
	lda #5
	sta inventory_status
	jmp Inventory_DrawCursor
@gofromcleartosave:
	;basically the same idea as @gofromsavetocraft
	lda num_active_enemies
	beq @cangotosave
	lda #4
	bne @continue2
@cangotosave:
	lda #1
@continue2:
	sta inventory_status
	jmp Inventory_DrawCursor

	
Inventory_ReadRight:
	lda buttons_pressed
	and #BUTTONS_RIGHT
	bne @continue
	jmp Inventory_DrawCursor
@continue:
	ldy #SFX_SELECTION			;play sfx
	jsr PlaySound
	lda inventory_status
	beq @normal
	cmp #1
	beq @gofromsavetoclear
	cmp #2
	beq @nextpage
	cmp #3
	beq @itemaction
	cmp #4
	beq @gofromcrafttosave
	cmp #5
	beq @gofromcleartocraft
	bne Inventory_DrawCursor
@normal:
	;simply move the cursor forward 1, wrapping if necessary
	lda inventory_cursor_x
	clc
	adc #1
	cmp #4
	bcc @skipoverflow2
	lda #0
@skipoverflow2:
	sta inventory_cursor_x
	jmp Inventory_DrawCursor
@gofromsavetoclear:
	lda craft_queue_count
	beq Inventory_DrawCursor
	lda #5
	sta inventory_status
	bne Inventory_DrawCursor	;w.a.b
@nextpage:
	;if "page" is selected, and if we aren't at the last page, go forward a page
	lda inventory_page
	clc
	adc #1
	cmp inventory_pages
	bcs Inventory_DrawCursor
	;go to next page
	sta inventory_page
	lda #STATE_PLAY
	sta game_state_old
	bne Inventory_DrawCursor	;w.a.b
@itemaction:
	;if we've gotten here, that means the player's selecting what to do with a selected item
	lda inventory_cursor_y
	asl
	asl						;multiply by 4 since its a 4x4 grid
	ora inventory_cursor_x	;combine high nibble Y with low nibble X
	tax
	ldy inventory_screen_items,x
	dey
	lda inventory_choice
	clc
	adc #1
	cmp InventoryMessageChoices,y
	bcc @skipoverflow
	lda #0
@skipoverflow:
	sta inventory_choice
	jmp Inventory_DrawCursor
@gofromcrafttosave:
	lda num_active_enemies
	beq @cangotosave
	lda #5					;go straight to clear since we can't save
	bne @continue2
@cangotosave:
	lda #1
@continue2:
	sta inventory_status
	bne Inventory_DrawCursor	;w.a.b
@gofromcleartocraft:
	lda #4
	sta inventory_status
	
	
Inventory_DrawCursor:
	ldy oam_index
	lda inventory_status
	beq @normal
	cmp #3
	beq @normal
	cmp #1
	beq @save
	cmp #2
	beq @page
	cmp #4
	beq @craft
	cmp #5
	beq @clear
@list:
	lda #176					;X
	sta $0203,y
	lda #208					;Y
	sta $0200,y
	lda #$51					;left cursor
	sta $0201,y
	bne @findcursorposdone
@save:
	lda #$68
	sta $0203,y					;X
	lda #$30
	sta $0200,y					;Y
	lda #$51					;left cursor
	sta $0201,y
	bne @findcursorposdone		;will always branch
@page:
	lda #$58					;X
	sta $0203,y
	lda #$D8
	sta $0200,y					;Y
	lda #$51					;left cursor
	sta $0201,y
	bne @findcursorposdone		;will always branch
@craft:
	lda #8
	sta $0203,y					;X
	lda #48
	sta $0200,y					;Y
	lda #$51					;left cursor
	sta $0201,y
	bne @findcursorposdone		;w.a.b
@clear:
	lda #192					;X
	sta $0203,y
	lda #48						;Y
	sta $0200,y
	lda #$51					;left cursor
	sta $0201,y
	bne @findcursorposdone			;w.a.b
@normal:
	ldx inventory_cursor_x
	lda InventoryCursorXs,x
	sta $0203,y					;X
	ldx inventory_cursor_y
	lda InventoryCursorYs,x
	sta $0200,y					;Y
	lda #$52					;up cursor
	sta $0201,y
@findcursorposdone:
	lda #0
	sta $0202,y
	tya
	clc
	adc #4
	sta oam_index
	
InventoryMain_Done:
	pla
	jmp SetPRGBank