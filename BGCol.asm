EntCheckBGColTL:
	;X should be loaded with ent_index for all of these
	lda ent_y,x
	and #%11110000
	sec
	sbc #$30			;account for status board
	sta temp0
	lda ent_x,x
	lsr					;convert to metatile map coordinates
	lsr
	lsr
	lsr
	clc
	adc temp0
	tax
	lda metatile_map,x
	jmp HandleBGCol
EntCheckBGColTC:
	lda ent_y,x
	and #%11110000
	sec
	sbc #$30
	sta temp0
	lda ent_x+0
	clc
	adc ent_hb_x+0
	ror				;divide by 2 (Keeping the carry bit if there was an overflow) to get the midpoint
	lsr
	lsr
	lsr
	lsr
	clc
	adc temp0
	tax
	lda metatile_map,x
	jmp HandleBGCol
EntCheckBGColTR:
	lda ent_y,x
	and #%11110000
	sec
	sbc #$30
	sta temp0
	lda ent_hb_x,x
	lsr
	lsr
	lsr
	lsr
	clc
	adc temp0
	tax
	lda metatile_map,x
	jmp HandleBGCol
EntCheckBGColLM:
	lda ent_y+0,x
	clc
	adc ent_hb_y+0,x
	ror
	and #%11110000
	sec
	sbc #$30
	sta temp0
	lda ent_x,x
	lsr
	lsr
	lsr
	lsr
	clc
	adc temp0
	tax
	lda metatile_map,x
	jmp HandleBGCol
EntCheckBGColRM:
	lda ent_y+0
	clc
	adc ent_hb_y+0
	ror
	and #%11110000
	sec
	sbc #$30
	sta temp0
	lda ent_hb_x,x
	lsr
	lsr
	lsr
	lsr
	clc
	adc temp0
	tax
	lda metatile_map,x
	jmp HandleBGCol
EntCheckBGColBL:
	lda ent_hb_y,x
	and #%11110000
	sec
	sbc #$30
	sta temp0
	lda ent_x,x
	lsr
	lsr
	lsr
	lsr
	clc
	adc temp0
	tax
	lda metatile_map,x
	jmp HandleBGCol
EntCheckBGColBC:
	lda ent_hb_y,x
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
	tax
	lda metatile_map,x
	jmp HandleBGCol
EntCheckBGColBR:
	lda ent_hb_y,x
	and #%11110000
	sec
	sbc #$30
	sta temp0
	lda ent_hb_x,x
	lsr
	lsr
	lsr
	lsr
	clc
	adc temp0
	tax
	lda metatile_map,x
	jmp HandleBGCol


;For each ent, have a table sorted by the type of collision for what to do.
;A common routine will be to nothing, which will simply RTS
;The player, when pressing A, has a similar but different version of this (below)
;EVENTUALLY, MAYBE MOVE THE INDIVIDUAL ROUTINES TO A DIFFERENT BANK
EntBGColResponses:
	;sorted by ent ID
	.dw PlayerBGColResponses,KnifeBGColResponses,SnakeBGColResponses,BREAK,BREAK,BREAK,BREAK,BREAK
	.dw BREAK,BREAK,BREAK,CrabBGColResponses,BREAK,MacheteBGColResponses,BREAK,StickBGColResponses
	.dw BREAK,BREAK,BREAK,BREAK,BREAK,SnakeBGColResponses

PlayerBGColResponses:
	;sorted by collision type (consult metatiles.asm for more info)
	.dw DoNothing,EjectEnt,EjectEnt,EjectEnt,EjectEnt,HurtPlayer,EjectEnt
KnifeBGColResponses:
	.dw DoNothing,DoNothing,DoNothing,DoNothing,DoNothing,DoNothing,KnifeCutBrush
SnakeBGColResponses:
CrabBGColResponses:
	.dw DoNothing,EjectEnt,EjectEnt,EjectEnt,EjectEnt,EjectEnt,EjectEnt
MacheteBGColResponses:
	.dw DoNothing,DoNothing,DoNothing,DoNothing,KnifeCutBrush,KnifeCutBrush,KnifeCutBrush
StickBGColResponses:
	.dw DoNothing,DoNothing,DoNothing,DoNothing,DoNothing,DoNothing,DoNothing
	
	
HandleBGCol:
	;A should be loaded with the correct metatile index from the map
	stx temp0
	sta temp1
	;have to bankswitch to read metatiles
	lda prg_bank
	pha
	lda #BANK_METATILES
	jsr SetPRGBank
	lda metatile_bank
	asl
	tay
	lda MetaTileBanks+0,y
	sta mt_ptr1+0
	lda MetaTileBanks+1,y
	sta mt_ptr1+1
	lda temp1
	asl
	tay
	lda (mt_ptr1),y
	sta mt_ptr2+0
	iny
	lda (mt_ptr1),y
	sta mt_ptr2+1
	ldy #4
	lda (mt_ptr2),y			;what type of metatile it is
	pha
	ldx ent_index
	lda ent_id,x
	asl
	tax
	lda EntBGColResponses+0,x
	sta ent_ptr1+0
	lda EntBGColResponses+1,x
	sta ent_ptr1+1
	pla
	asl
	tay
	lda (ent_ptr1),y
	sta ent_ptr2+0
	iny
	lda (ent_ptr1),y
	sta ent_ptr2+1
	pla
	jsr SetPRGBank
	jmp (ent_ptr2)
	
	
DoNothing:
	;simply RTS
	ldx ent_index
	rts


EntEjectDirections:
	;sorted by directions
	.dw EjectEntDown, EjectEntUp, EjectEntRight, EjectEntLeft
	
	
	;SPLIT ALL THESE WORD TABLES INTO HI/LO TABLES, SINCE THIS IS CRITICAL SHIT AND NEEDS TO HAPPEN AS QUICKLY AS POSSIBLE
EjectEnt:
	;make sure X doesnt get clobbered
	ldx ent_index
	lda ent_dir,x
	asl
	tay
	lda EntEjectDirections+0,y
	sta jump_ptr+0
	lda EntEjectDirections+1,y
	sta jump_ptr+1
	jmp (jump_ptr)
	

EjectEntDown:
	lda ent_y,x
	and #%00001111
	sta temp0
	lda #%00010000			;I think there's an optimization for 16 - a value. Try and find it
	sec
	sbc temp0
	sta temp0
	lda ent_y,x
	clc
	adc temp0
	sta ent_y,x
	lda ent_hb_y,x
	clc
	adc temp0
	sta ent_hb_y,x
	rts
	
EjectEntUp:
	lda ent_hb_y,x
	and #%00001111
	sta temp0
	inc temp0
	lda ent_y,x
	sec
	sbc temp0
	sta ent_y,x
	lda ent_hb_y,x
	sec
	sbc temp0
	sta ent_hb_y,x
	rts
	
EjectEntRight:
	lda ent_x,x
	and #%00001111
	sta temp0
	lda #%00010000
	sec
	sbc temp0
	sta temp0
	lda ent_x,x
	clc
	adc temp0
	sta ent_x,x
	lda ent_hb_x,x
	clc
	adc temp0
	sta ent_hb_x,x
	rts
	
EjectEntLeft:
	lda ent_hb_x,x
	and #%00001111
	sta temp0
	inc temp0
	lda ent_x,x
	sec
	sbc temp0
	sta ent_x,x
	lda ent_hb_x,x
	sec
	sbc temp0
	sta ent_hb_x,x
	rts
	
	
HurtPlayer:
	;subtract health if not in PHI, and eject
	lda ent_phi_timer+0
	bne @eject
	lda ent_health+0
	sec
	sbc #5
	bcs @nounderflow
	lda #0
@nounderflow:
	sta ent_health+0
	lda #120
	sta ent_phi_timer+0
	ldy #SFX_PLAYERHURT
	jsr PlaySound
@eject:
	jmp EjectEnt
	
	
KnifeCutBrush:
	;temp0 still has where in the map to read from
	ldx temp0
	lda #$29			;jungle floor
	sta metatile_map,x
	jmp RedrawMetaTile
	
	
PlayerInteractions:
	;what message to display depending on the interaction.
	;FF says to do nothing
	;sorted by type of metatile
	.db $FF,MSG_SALTWATER,$FF,MSG_FRESHWATER,MSG_CANBECUT,$FF,$FF
	
	
HandlePlayerInteraction:
	;A should be loaded with the correct metatile index from the map
	sta temp1								;pushing and pulling to the stack would be 2 bytes less, but one cycle more since PLA is 4 cycles. I don't think we'll be that pressed for space to make such a tiny optimization
	;have to bankswitch to read metatiles
	lda prg_bank
	pha
	lda #BANK_METATILES
	jsr SetPRGBank
	lda metatile_bank
	asl
	tay
	lda MetaTileBanks+0,y
	sta mt_ptr1+0
	lda MetaTileBanks+1,y
	sta mt_ptr1+1
	lda temp1
	asl
	tay
	lda (mt_ptr1),y
	sta mt_ptr2+0
	iny
	lda (mt_ptr1),y
	sta mt_ptr2+1
	ldy #4
	lda (mt_ptr2),y			;what type of metatile it is
	tax
	lda PlayerInteractions,x
	cmp #$FF
	;bne @continue
	;play a sound effect to signal that there's nothing here
	beq @done				;do nothing if #$FF
@continue:
	sta message
	lda #STATE_DRAWINGMBOX
	sta game_state
@done:
	pla
	jmp SetPRGBank