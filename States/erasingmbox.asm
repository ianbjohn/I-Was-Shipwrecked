;What to do with all the status bytes
StatusBoardRoutines2:
	.dw EMB_weapstrchr7, EMB_statstrchr6, EMB_weapstrchr5, EMB_weapstrchr4, EMB_weapstrchr3, EMB_weapstrchr2, EMB_weapstrchr1, EMB_weapstrchr0
	.dw EMB_statstrchr7, EMB_statstrchr6, EMB_statstrchr5, EMB_statstrchr4, EMB_statstrchr3, EMB_statstrchr2, EMB_statstrchr1, EMB_statstrchr0
	.dw EMB_bcdones, EMB_bcdtens, EMB_bcdhundreds, EMB_bcdthousands, EMB_bcdtenthousands, EMB_status, EMB_day, EMB_weapon
	.dw EMB_thirst, EMB_hunger, EMB_health, EMB_newline

ErasingMBoxMain:
	;only draw ents if we're in the play state
	lda in_inventory_state
	bne EMB_loop
	jsr DrawEnts
EMB_loop:
	;the commands here are different from the commands for the rest of the message box engine
	ldy mbox_pos
	lda StatusBoard,y			;can be hard-coded
	cmp #$FF
	bne @continue
	;the end
	jsr CleanUpMBoxVars
;	;if we came from the inventory state, return there. Otherwise, return to the play state
;	lda in_inventory_state
;	beq @returntoplaystate
;@returntoinventorystate:
;	lda #0						;set the inventory substate back to normal
;	sta inventory_status
;	lda #STATE_INVENTORY
;	bne @returntostate			;will always branch
@returntoplaystate:
	lda #STATE_PLAY
@returntostate:
	sta game_state
	sta game_state_old
	rts
@continue:
	cmp #$E3			;first status byte
	bcs @continue2
	jmp EMB_normal		;account for the fact that the first day is displayed as "DAY 1"
@continue2
	;from here we know that it's a status byte. Use it as an index to find the appropriate code
	sec
	sbc #$E3
	asl
	tax
	lda StatusBoardRoutines2+0,x
	sta jump_ptr+0
	lda StatusBoardRoutines2+1,x
	sta jump_ptr+1
	jmp (jump_ptr)
EMB_newline:
	lda mbox_screen_pos
	and #%11100000
	clc
	adc #%00100000
	sta mbox_screen_pos
	inc mbox_pos
	jmp EMB_loop
EMB_health:
	;load player health into the BCD variable, call BCD subroutine
	lda ent_health+0
	sta bcd_value+0
	jsr BCD_8
	inc mbox_pos
	jmp EMB_loop
EMB_hunger:
	lda hunger
	sta bcd_value+0
	jsr BCD_8
	inc mbox_pos
	jmp EMB_loop
EMB_thirst:
	lda thirst
	sta bcd_value+0
	jsr BCD_8
	inc mbox_pos
	jmp EMB_loop
EMB_weapon:
	lda weapon
	asl
	tax
	lda WeaponStrings+0,x
	sta ptr1+0
	lda WeaponStrings+1,x
	sta ptr1+1
	inc mbox_pos
	jmp EMB_loop
EMB_day:
	lda day+0
	clc
	adc #1					;account for the fact that the first day is displayed as "DAY 1"
	sta bcd_value+0
	lda day+1
	adc #0
	sta bcd_value+1
	jsr BCD_16
	inc mbox_pos
	jmp EMB_loop
EMB_status:
	lda status
	asl
	tax
	lda StatusStrings+0,x
	sta ptr1+0
	lda StatusStrings+1,x
	sta ptr1+1
	inc mbox_pos
	jmp EMB_loop
EMB_bcdtenthousands:
	lda bcd_tenthousands
	jmp EMB_normal
EMB_bcdthousands:
	lda bcd_thousands
	jmp EMB_normal
EMB_bcdhundreds:
	lda bcd_hundreds
	jmp EMB_normal
EMB_bcdtens:
	lda bcd_tens
	jmp EMB_normal
EMB_bcdones:
	lda bcd_ones
	jmp EMB_normal
EMB_statstrchr0:
	ldy #0
	beq EMB_readpointer		;will always branch because the characters will always be letters (aka not 0)
							;the following will all always branch too
EMB_statstrchr1:
	ldy #1
	bne EMB_readpointer
EMB_statstrchr2:
	ldy #2
	bne EMB_readpointer
EMB_statstrchr3:
	ldy #3
	bne EMB_readpointer
EMB_statstrchr4:
	ldy #4
	bne EMB_readpointer
EMB_statstrchr5:
	ldy #5
	bne EMB_readpointer
EMB_statstrchr6:
	ldy #6
	bne EMB_readpointer
EMB_statstrchr7:
	ldy #7
	bne EMB_readpointer
EMB_weapstrchr0:
	ldy #0
	beq EMB_readpointer
EMB_weapstrchr1:
	ldy #1
	bne EMB_readpointer
EMB_weapstrchr2:
	ldy #2
	bne EMB_readpointer
EMB_weapstrchr3:
	ldy #3
	bne EMB_readpointer
EMB_weapstrchr4:
	ldy #4
	bne EMB_readpointer
EMB_weapstrchr5:
	ldy #5
	bne EMB_readpointer
EMB_weapstrchr6:
	ldy #6
	bne EMB_readpointer
EMB_weapstrchr7:
	ldy #7
EMB_readpointer:
	lda (ptr1),y
EMB_normal:
	sta temp0
	ldx vram_buffer_pos
	lda #>MBOX_START
	sta vram_buffer,x
	inx
	lda mbox_screen_pos
	clc
	adc #<MBOX_START
	sta vram_buffer,x
	inx
	lda #<(Copy1Byte-1)
	sta vram_buffer,x
	inx
	lda #>(Copy1Byte-1)
	sta vram_buffer,x
	inx
	lda temp0
	sta vram_buffer,x
	inx
	stx vram_buffer_pos
	inc mbox_screen_pos
	inc mbox_pos
	rts