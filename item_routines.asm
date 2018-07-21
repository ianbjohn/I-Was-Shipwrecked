SetItemAsObtained:
	;if an item is obtained, its respective obtained flag should be set
	;A should have the respective item's id
	;Clobbers X and Y
	pha			;we're gonna need a copy
	;divide item ID by 8 to get the byte where the item's flag is located
	lsr
	lsr
	lsr
	tax
	pla
	;check the lower 3 bits to get which bit the item's flag is, and which bit to set
	and #%00000111
	tay
	lda obtained_items,x
	ora PowersOfTwo,y			;set the right bit which was determined by the lower 3 bits of the ID
	sta obtained_items,x
	inc num_obtained_items
	rts
	
	
CheckIfItemObtained:
	;returns 0 if an item hasn't been obtained, and a number that isn't 0 if it has been obtained
	;A should have the respective item's id
	;code is similar to SetItemAsObtained, which is commented
	;Clobbers X and Y
	;Return value is in A
	;item ID is returned in temp0
	pha
	sta temp0
	lsr
	lsr
	lsr
	tax
	pla
	and #%00000111
	tay
	lda obtained_items,x
	and PowersOfTwo,y				;will give us just the flag we want (either 0 or 1)
	rts
	
	
CheckIfItemHasCount:
	;returns 0 if an item doesn't have a count (i.e certain weapons, jar, etc), and a number that isn't 0 if it does have a counter
	;A should have the respective item's id
	;code similar to CheckIfItemObtained
	;Clobbers X and Y
	pha
	lsr
	lsr
	lsr
	tax
	pla
	and #%00000111
	tay
	lda ItemHasCount,x
	and PowersOfTwo,y
	rts
	
	
GetItemCount:
	;returns the count of a specific item, in the Accumulator
	;Two item counts, since they can be at most 15, can be stored to one byte, so we need to find out which byte it is,
		;and then return either the high or low nibble of that byte, depending on bit 0 of the item ID
	;A should have the respective item's id
	pha			;need to save the id, as it's getting clobbered
	lsr					;divide by 2 to get which byte it is
	tax
	pla
	lsr					;check if bit 0 is set or not
	php					;save the carry flag
	lda item_count,x	;this needs to get loaded regardless of which branch we take, so better to load it now than duplicate it in both branches
	plp
	bcc @lownibble
@highnibble:
	;if bit 0 was set, we need to shift the high nibble down and return it
	lsr
	lsr
	lsr
	lsr					;shift high nibble into low nibble
	rts
@lownibble:
	and #%00001111		;get rid of the high nibble
	rts
	
	
AddToItemCount:
	;adds a number to the count of a certain item
	;Y should have the number to be added
	;A should have the respective item's id
	pha
	lsr					;this part is better commented in the above subroutine (Here we just need to divide by 2 instead of 8 since values are packed as nibbles instead of bits)
	tax
	pla
	lsr
	php
	lda item_count,x
	plp
	bcc @lownibble
@highnibble:
	sta temp0
	tya
	asl
	asl
	asl
	asl					;multiply by 4 to add to the high nibble
	clc
	adc temp0
	bcc @skipoverflowhi
	lda item_count,x
	ora #%11110000		;if it overflowed, we want to set the count back to 15, the max
@skipoverflowhi:
	sta item_count,x
	rts
@lownibble:
	and #%11110000
	sta temp1
	lda item_count,x
	and #%00001111		;only want to focus on the lower 4 bytes to see if the sum overflows 16
	sta temp0
	tya
	clc
	adc temp0
	cmp #16
	bcc @skipoverflowlo
	lda #%00001111		;if it overflowed, we want to set the count back to 15, the max
@skipoverflowlo:
	ora temp1
	sta item_count,x
	rts
	
	
SubtractFromItemCount:
	;subtracts a number from the count of a certain item
	;Y should have the number to be subtracted
	;A should have the respective item's id
	pha
	lsr					;this part is better commented in the above subroutine (Here we just need to divide by 2 instead of 8 since values are packed as nibbles instead of bits)
	tax
	pla
	lsr
	php
	lda item_count,x
	plp
	bcc @lownibble
@highnibble:
	pha
	;save the low nibble to re-OR at the end since it gets trashed
	and #%00001111
	sta temp1
	tya
	asl
	asl
	asl
	asl					;multiply by 4 to add to the high nibble
	sta temp0
	pla
	sec
	sbc temp0
	and #%11110000
	bcs @skipunderflowhi
	lda item_count,x
	and #%00001111		;if it underflowed, we want to set the count back to 0, the min
@skipunderflowhi:
	ora temp1
	sta item_count,x
	rts
@lownibble:
	and #%11110000
	sta temp1
	lda item_count,x
	and #%00001111		;only want to focus on the lower 4 bytes to see if the sum underflows
	pha
	tya
	sta temp0
	pla
	sec
	sbc temp0
	bcs @skipunderflowlo
	lda #%00000000		;if it underflowed, we want to set the count back to 0, the min
@skipunderflowlo:
	ora temp1
	sta item_count,x
	rts
	
	
CraftItem:
	;a work-in-progress currently
	;takes what's in the crafting queue, adds it up, and searches a table to see if such an item is valid (0 = not valid)
	;if it is valid, either add to the item's count or mark it as obtained
	;FOR RIGHT NOW, I'VE JUST MOVED THE CODE TO MAKE A SPEAR HERE, SINCE THE SAME GENERAL IDEA FOR CRAFTING (ALL THE EXTRA STUFF LIKE CHECKING FOR ITEMS AND DRAWING THE MESSAGES) WILL BE THE SAME
	;see if we have a stick and a flint, and if so, make a torch
	;lda #ITEM_STICK
	;jsr GetItemCount
	;beq @cantmaketorch
	;lda #ITEM_FLINT
	;jsr GetItemCount
	;beq @cantmaketorch
	;lda #ITEM_STICK
	;ldy #1
	;jsr SubtractFromItemCount
	;lda #ITEM_FLINT
	;ldy #1
	;jsr SubtractFromItemCount
	;lda #ITEM_TORCH
	;jsr CheckIfItemObtained
	;bne @inc
	;lda #ITEM_TORCH
	;jsr SetItemAsObtained
;@inc:
	;lda #ITEM_TORCH
	;ldy #1
	;jsr AddToItemCount
	;lda #MSG_CRAFTEDTORCH
	;bne @draw
;@cantmaketorch:
	;lda #MSG_CANTMAKETORCH
;@draw:
	;sta message
	;jmp Inventory_DrawCursor
	
	
	.db "CCQ"
ClearCraftQueue:
	;If the player leaves the inventory screen, or clears the craft queue manually, all the items in the queue need to be put back into the main inventory
	ldx #0
	stx temp2			;AddToItemCount uses temp0 and temp1
@clear:
	ldx temp0
	cmp craft_queue_count
	beq @done
	lda craft_queue,x
	ldy #1
	jsr AddToItemCount
	inc temp2
	bne @clear			;will always branch
@done:
	lda #0
	sta craft_queue_count
	rts