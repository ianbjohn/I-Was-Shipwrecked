MBoxResponseMain:
	;draw (but not process) each active ent (But don't do this if we're in the inventory state)
	lda in_inventory_state
	bne @endofentstuff
	jsr DrawEnts
@endofentstuff:
	lda prg_bank
	pha
	lda #BANK_MESSAGES
	sta prg_bank
	jsr SetPRGBank
	
MBR_ReadLeft:
	lda buttons_pressed
	and #BUTTONS_LEFT
	beq MBR_ReadRight
	;play sound effect
	ldy #SFX_SELECTION
	jsr PlaySound
	;move the cursor to the left, wrapping if necessary
	lda message_response
	sec
	sbc #1
	bcs @skipunderflow
	ldy message
	ldx MessageResponseNumbers,y
	dex
	txa
@skipunderflow:
	sta message_response
	
MBR_ReadRight:
	lda buttons_pressed
	and #BUTTONS_RIGHT
	beq MBR_Done
	;play sound effect
	ldy #SFX_SELECTION
	jsr PlaySound
	;move the cursor to the right, wrapping if necessary
	lda message_response
	clc
	adc #1
	ldy message
	cmp MessageResponseNumbers,y
	bcc @skipoverflow
	lda #0
@skipoverflow:
	sta message_response
	
MBR_Done:
	;use message as index to jump table for response routines
	;The reason we can't just peform actions based on controller input here is that A and B sometimes do different things, so they have to be defined for each response
	lda message
	asl
	tax
	lda MessageResponses+0,x
	sta jump_ptr+0
	lda MessageResponses+1,x
	sta jump_ptr+1
	jmp (jump_ptr)