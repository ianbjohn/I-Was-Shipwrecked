;What to do with all the status bytes
StatusBoardRoutines:
	.dw DSB_weapstrchr7, DSB_statstrchr6, DSB_weapstrchr5, DSB_weapstrchr4, DSB_weapstrchr3, DSB_weapstrchr2, DSB_weapstrchr1, DSB_weapstrchr0
	.dw DSB_statstrchr7, DSB_statstrchr6, DSB_statstrchr5, DSB_statstrchr4, DSB_statstrchr3, DSB_statstrchr2, DSB_statstrchr1, DSB_statstrchr0
	.dw DSB_bcdones, DSB_bcdtens, DSB_bcdhundreds, DSB_bcdthousands, DSB_bcdtenthousands, DSB_status, DSB_day, DSB_weapon
	.dw DSB_thirst, DSB_hunger, DSB_health, DSB_newline

;a somewhat shoddy way of drawing the border of the status board (This part doesn't get erased)
DrawStatusBoarder:
	;draw the top-left corner
	lda $2002
	lda #$20
	sta $2006
	sta $2006			;$2020
	lda #$32			;top-right corner tile
	sta $2007
	;draw the top edge
	ldx #30
	lda #$36
-	sta $2007
	dex
	bne -
	;draw the top-right corner
	lda #$33
	sta $2007
	;draw the left edge and right edge
	ldy #3
--	lda #$37
	sta $2007
	lda #SPA
	ldx #30
--- sta $2007
	dex
	bne ---
	lda #$37
	sta $2007
	dey
	bne --
	;draw the bottom-left corner, bottom edge and bottom-right corner
	lda #$34
	sta $2007
	ldx #30
	lda #$36
----	sta $2007
	dex
	bne ----
	lda #$35
	sta $2007
	
	
DrawStatusBoard:
	;This is similar to the code in the ErasingMBox state,
		;only it draws directly to the PPU and not to the buffer
		;PPU is off here
	;code is commented better in the messagebox.asm file
	;mbox variables should be default when starting
	lda $2002
	lda #>MBOX_START
	sta $2006
	lda #<MBOX_START
	sta $2006
DSB_loop:
	ldy mbox_pos
	lda StatusBoard,y
	cmp #$FF
	bne @continue
	;reset variables
	lda #$00
	sta mbox_pos
	sta mbox_screen_pos
	rts
@continue:
	cmp #$E3
	bcs @continue2			
	jmp DSB_normal
@continue2:
	;from here we know that it's a status byte. Use it as an index to find the appropriate code
	sec
	sbc #$E3
	asl
	tax
	lda StatusBoardRoutines+0,x
	sta jump_ptr+0
	lda StatusBoardRoutines+1,x
	sta jump_ptr+1
	jmp (jump_ptr)
DSB_newline:
	lda $2002				;drawing to a new line, so need to reset latch
	lda #>MBOX_START
	sta $2006
	lda mbox_screen_pos
	and #%11100000
	clc
	adc #%00100000
	sta mbox_screen_pos
	adc #<MBOX_START
	sta $2006
	inc mbox_pos
	jmp DSB_loop
DSB_health:
	;load player health into the BCD variable, call BCD subroutine
	lda ent_health+0
	sta bcd_value+0
	jsr BCD_8
	inc mbox_pos
	jmp DSB_loop
DSB_hunger:
	lda hunger
	sta bcd_value+0
	jsr BCD_8
	inc mbox_pos
	jmp DSB_loop
DSB_thirst:
	lda thirst
	sta bcd_value+0
	jsr BCD_8
	inc mbox_pos
	jmp DSB_loop
DSB_weapon:
	lda weapon
	asl
	tax
	lda WeaponStrings+0,x
	sta ptr1+0
	lda WeaponStrings+1,x
	sta ptr1+1
	inc mbox_pos
	jmp DSB_loop
DSB_day:
	lda day+0
	clc
	adc #1
	sta bcd_value+0
	lda day+1
	adc #0
	sta bcd_value+1
	jsr BCD_16
	inc mbox_pos
	jmp DSB_loop
DSB_status:
	lda status
	asl
	tax
	lda StatusStrings+0,x
	sta ptr1+0
	lda StatusStrings+1,x
	sta ptr1+1
	inc mbox_pos
	jmp DSB_loop
DSB_bcdtenthousands:
	lda bcd_tenthousands
	jmp DSB_normal
DSB_bcdthousands:
	lda bcd_hundreds
	jmp DSB_normal
DSB_bcdhundreds:
	lda bcd_hundreds
	jmp DSB_normal
DSB_bcdtens:
	lda bcd_tens
	jmp DSB_normal
DSB_bcdones:
	lda bcd_ones
	jmp DSB_normal
DSB_statstrchr0:
	ldy #0
	beq DSB_readpointer
DSB_statstrchr1:
	ldy #1
	bne DSB_readpointer
DSB_statstrchr2:
	ldy #2
	bne DSB_readpointer
DSB_statstrchr3:
	ldy #3
	bne DSB_readpointer
DSB_statstrchr4:
	ldy #4
	bne DSB_readpointer
DSB_statstrchr5:
	ldy #5
	bne DSB_readpointer
DSB_statstrchr6:
	ldy #6
	bne DSB_readpointer
DSB_statstrchr7:
	ldy #7
	bne DSB_readpointer
DSB_weapstrchr0:
	ldy #0
	beq DSB_readpointer
DSB_weapstrchr1:
	ldy #1
	bne DSB_readpointer
DSB_weapstrchr2:
	ldy #2
	bne DSB_readpointer
DSB_weapstrchr3:
	ldy #3
	bne DSB_readpointer
DSB_weapstrchr4:
	ldy #4
	bne DSB_readpointer
DSB_weapstrchr5
	ldy #5
	bne DSB_readpointer
DSB_weapstrchr6:
	ldy #6
	bne DSB_readpointer
DSB_weapstrchr7:
	ldy #7
DSB_readpointer:
	lda (ptr1),y
DSB_normal:
	;time to draw
	sta $2007
	inc mbox_screen_pos
	inc mbox_pos
	jmp DSB_loop