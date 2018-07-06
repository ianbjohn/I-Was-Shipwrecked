	.db "FILE SELECT"
FileCursorPositionsX:
	.db 40,120,200
	
FileStatusOptions:
	;how many options each file select status substate has
	.db 1,2,2
	
FileStatusCursorPositions:
	.dw RegisterCursorPositionsX,PlayEraseCursorPositionsX,AreYouSureCursorPositionsX
RegisterCursorPositionsX:
	.db 8
PlayEraseCursorPositionsX:
	.db 8,72
AreYouSureCursorPositionsX:
	.db 128,144

FileStatusStrings:
	.dw Register,PlayErase,AreYouSure
	
Register:
	.db SPA,R,E,G,I,S,T,E,R,$FF
PlayErase:
	.db SPA,P,L,lA,lY, SPA,SPA,SPA,SPA, E,R,lA,S,E,$FF
AreYouSure:
	.db lA,R,E, SPA, lY,O,U, SPA, S,U,R,E,$31, SPA,SPA,SPA, N, SPA, lY,$FF
	
	
FileSelectInit:
	lda #%00000110
	sta $2001
	lda #0
	sta nmi_enabled
	
	;draw the top bar where the player will make decisions for which file to load, and/or what to do with the file
	lda $2002
	lda #$20
	sta $2006
	sta $2006
FS_DrawTopBar:
	lda #$32			;top left corner
	sta $2007
	ldx #30
	lda #$36
@loop0:
	sta $2007
	dex
	bne @loop0
	lda #$33			;top right corner
	sta $2007
	lda #$37
	sta $2007
	ldx #30
	lda #SPA
@loop1:
	sta $2007
	dex
	bne @loop1
	lda #$37
	sta $2007
	lda #$34			;bottom left corner
	sta $2007
	ldx #30
	lda #$36
@loop2:
	sta $2007
	dex
	bne @loop2
	lda #$35			;bottom right corner
	sta $2007
FS_DrawTopBarDone:

FS_DrawFileFrames:
	lda $2002
	lda #$20
	sta soft_2006+1
	;pha				;only the low byte will need to be pushed
	sta $2006
	lda #$A1
	sta soft_2006+0
	pha
	sta $2006
	ldy #3
@loop0:
	ldx #0
@loop0_inner:
	lda FileFrame,x
	cmp #$FF
	bne @continue
	;this could probably be done better. Maybe work on it some more
	lda $2002
	lda soft_2006+0
	clc
	adc #32
	sta soft_2006+0
	lda soft_2006+1
	adc #0
	sta $2006
	sta soft_2006+1
	lda soft_2006+0
	sta $2006
	jmp @done
@continue:	
	sta $2007
@done:
	inx
	cpx #230				;how many bytes long the FileFrame LUT is
	bne @loop0_inner
	dey
	beq FS_DrawFileFramesDone
	lda $2002
	lda #$20
	sta $2006
	sta soft_2006+1
	;pull our original PPU address low byte off the stack
	pla					;low byte
	clc
	adc #$0A				;how many tiles to advance to draw the next file frame
	sta soft_2006+0
	sta $2006
	pha					;push it back for the next time
	bne @loop0			;will always branch
FS_DrawFileFramesDone:
	pla					;pull off what we pushed onto the stack, we don't need it anymore
	
	;clear the last 4 nametable rows
	lda $2002
	lda #$23
	sta $2006
	lda #$40
	sta $2006
	ldx #128
	lda #SPA
@loop:
	sta $2007
	dex
	bne @loop
	
	;write the file numbers
	;just hard-coding these because I'm a lazy bastard
	ldx #1
	lda $2002
	lda #$20
	sta $2006
	lda #$C8
	sta $2006
	stx $2007
	inx
	
	lda $2002
	lda #$20
	sta $2006
	lda #$D2
	sta $2006
	stx $2007
	inx
	
	lda $2002
	lda #$20
	sta $2006
	lda #$DC
	sta $2006
	stx $2007
	
	;draw the BCD and strings for all the file data in their right places
	;Similar to DrawFileFrames in that we need to use soft_2006 in pretty much the same way
FS_DrawFileData:
	lda $2002
	lda #$21
	sta soft_2006+1
	sta $2006
	lda #$22					;data needs to always start at PPU address 0x2122, so these can be hard-coded immediates
	pha
	sta $2006
	sta soft_2006+0
	ldy #0
@loop0:
	;first of all, we need to check and see if the current file even has any data on it.
	;if it doesn't leave all the fields blank and go to the next file
	lda file_contents
	and PowersOfTwo,y			;check if the respective flag is set
	bne @continue
	jmp @done
@continue:
	;If we're at this point, then that means there's data on the file!!!
	;the BCD needs to have different stuff done with it than strings, so take care of that first
	ldx #0
@bcd_loop:
	lda #<(file_data_health)	;start of file data
	clc
	adc MultiplesOfThree,x		;we need to fake multiplying by 3 here
	sta ptr1+0
	lda #>(file_data_health)
	;adc #0						;uncomment this if we ever need to cross pages (i.e if the file data exceeds 256 bytes, which I doubt it will)
	sta ptr1+1
	lda (ptr1),y
	sta bcd_value
	txa							;save X since it gets clobbered in the following routine
	pha
	jsr BCD_8
	pla
	tax
	lda bcd_hundreds
	sta $2007
	lda bcd_tens
	sta $2007
	lda bcd_ones
	sta $2007
	lda #$30					; /255
	sta $2007
	lda #2
	sta $2007
	lda #5
	sta $2007
	sta $2007
	;advance 3 tile rows, or 96 tiles
	lda $2002
	lda soft_2006+0
	clc
	adc #96
	sta soft_2006+0
	lda soft_2006+1
	adc #0
	sta $2006
	sta soft_2006+1
	lda soft_2006+0
	sta $2006
	inx
	cpx #3						;we have 3 8-bit BCD values
	bne @bcd_loop
	
	;time to do the strings
	;status
	lda file_data_status,y
	asl
	tax
	lda StatusStrings+0,x
	sta ptr1+0
	lda StatusStrings+1,x
	sta ptr1+1
	tya
	pha							;save Y as it has the file index and is going to get clobbered
	ldy #0
@statusloop:
	lda (ptr1),y
	sta $2007
	iny
	cpy #8
	bne @statusloop
	pla
	tay
	
	;advance 3 tile rows, or 96 tiles
	lda $2002
	lda soft_2006+0
	clc
	adc #96
	sta soft_2006+0
	lda soft_2006+1
	adc #0
	sta $2006
	sta soft_2006+1
	lda soft_2006+0
	sta $2006
	
	;weapon
	lda file_data_weapon,y
	asl
	tax
	lda WeaponStrings+0,x
	sta ptr1+0
	lda WeaponStrings+1,x
	sta ptr1+1
	tya
	pha
	ldy #0
@weaponloop:
	lda (ptr1),y
	sta $2007
	iny
	cpy #8
	bne @weaponloop
	pla
	tay
	
	;advance 3 tile rows, or 96 tiles (+ 1 to make days look more center)
	lda $2002
	lda soft_2006+0
	clc
	adc #97
	sta soft_2006+0
	lda soft_2006+1
	adc #0
	sta $2006
	sta soft_2006+1
	lda soft_2006+0
	sta $2006
	
	;wll we have left to do (For right now, at least...) is to display how many days the player has spent on the island
	;have to multiply Y by two, since day is a word (no shit right :^) )
	tya
	pha						;save Y as it's going to get clobbered by the BCD routine below
	asl
	tay
	lda file_data_day+0,y
	clc
	adc #1					;days are 1-basd
	sta bcd_value+0
	lda file_data_day+1,y
	adc #0
	sta bcd_value+1
	jsr BCD_16
	lda bcd_tenthousands
	sta $2007
	lda bcd_thousands
	sta $2007
	lda bcd_hundreds
	sta $2007
	lda bcd_tens
	sta $2007
	lda bcd_ones
	sta $2007
	pla						;restore Y
	tay
@done:
	iny
	cpy #3
	beq FS_DrawFileDataDone
	lda $2002
	lda #$21
	sta $2006
	sta soft_2006+1
	;pull our original PPU address low byte off the stack
	pla					;low byte
	clc
	adc #$0A				;how many tiles to advance to draw the next file frame
	sta soft_2006+0
	sta $2006
	pha					;push it back for the next time
	jmp @loop0			;too far to branch :(
FS_DrawFileDataDone:
	pla
	
	;start with the first file selected
	ldx #0
	stx file			;this var will double as our selected file for this state
	;set the correct status
	lda file_contents
	and PowersOfTwo,x
	beq @nocontent
	lda #1
	bne @continue
@nocontent:
	lda #0
@continue:
	sta fileselect_status
	
	lda #%00011110
	sta soft_2001
	lda #1
	sta nmi_enabled
	rts

	
FileSelectMain:
	CycleSprites
	
FS_ReadA:
	lda buttons_pressed
	and #BUTTONS_A
	bne @continue
	jmp FS_ReadSelect
@continue:
	;if the status is 0 (Register), simply start a new game
	;else if the status is 1 (Play/Erase)
		;if the cursor position was 0 (Play), load the file and go to the main game
		;else if the cursor position was 1 (Erase), set the status to 2
	;else (if the status is 2 (Are you sure?))
		;if the cursor position was 0 (No), set the status to 1
		;else (if it was 1 (Yes))
			;delete the file, re-init the file select state
	lda fileselect_status
	bne @continue2
	;start a new game
	lda #STATE_LOADINGSCREEN
	sta game_state
	jmp FS_StartGame
@continue2:
	cmp #1
	beq @continue3
	jmp @continue4				;need this because the LoadFileData macro is very long
@continue3
	;Play/Erase
	lda fileselect_cursorpos
	beq @load
	jmp @erase
@load:
	;play
	LoadFileData
	lda #STATE_LOADINGSCREEN
	sta game_state
	jmp FS_StartGame
@erase:
	lda #0
	sta fileselect_cursorpos
	lda #2
	sta fileselect_status
	bne FS_ReadSelect				;will always branch
@continue4:
	;Are you sure?
	lda fileselect_cursorpos
	bne @yes
	;no
	lda #1
	sta fileselect_status
	bne FS_ReadSelect			;will always branch
@yes:
	DeleteFileData
	inc game_state_old			;we need to re-init the file select state, so fake a signal that the state changed so it'll get re-inited
	rts
;FS_ReadB:
;	lda buttons_pressed
;	and #BUTTONS_B
;	beq FS_ReadSelect
;	;if the status is 2 (Are you sure?), go back to status 1 (Play/Erase)
;	ldx fileselect_status
;	cpx #2
;	bne FS_ReadSelect
;	dex
;	stx fileselect_status
	
FS_ReadSelect:
	lda buttons_pressed
	and #BUTTONS_SELECT
	beq FS_ReadLeft
	;dont execute this code if the status is 2 (Are you sure?)
	lda fileselect_status
	cmp #2
	beq FS_ReadLeft
	;move the file select cursor
	lda file
	clc
	adc #1
	cmp #3
	bcc @skipoverflow
	lda #0
@skipoverflow:
	sta file
	tax
	;set the correct status
	lda file_contents
	and PowersOfTwo,x
	beq @nocontent
	lda #1
	bne @continue
@nocontent:
	lda #0
@continue:
	sta fileselect_status
	;reset the file action choice to 0
	lda #0
	sta fileselect_cursorpos
	;play a sound effect
	ldy #SFX_FILESELECT
	jsr PlaySound
	
FS_ReadLeft:
	lda buttons_pressed
	and #BUTTONS_LEFT
	beq FS_ReadRight
	ldx fileselect_status		;only play the ding sound effect if there's more than 1 option (i.e the selected file exists)
	lda FileStatusOptions,x
	cmp #1
	beq FS_ReadRight
	;play a sound effect
	ldy #SFX_SELECTION
	jsr PlaySound
	;move the file status cursor
	ldx fileselect_status
	lda fileselect_cursorpos
	sec
	sbc #1
	bcs @skipunderflow
	lda FileStatusOptions,x
	sec
	sbc #1
@skipunderflow:
	sta fileselect_cursorpos
	
FS_ReadRight:
	lda buttons_pressed
	and #BUTTONS_RIGHT
	beq FS_ReadRightDone
	ldx fileselect_status			;only play the ding sound effect if there's more than 1 option (i.e the selected file exists)
	lda FileStatusOptions,x
	cmp #1
	beq FS_ReadRightDone
	;play a sound effect
	ldy #SFX_SELECTION
	jsr PlaySound
	;move the file status cursor
	ldx fileselect_status
	lda fileselect_cursorpos
	clc
	adc #1
	cmp FileStatusOptions,x
	bcc @skipoverflow
	lda #0
@skipoverflow:
	sta fileselect_cursorpos
FS_ReadRightDone:

	;update the buffer regardless of whether or not it actually needs to change (Not much happens in this state (compared to others, at least), so we can spare the time it takes)
	lda fileselect_status
	asl
	tax						;get the right string
	lda FileStatusStrings+0,x
	sta ptr1+0
	lda FileStatusStrings+1,x
	sta ptr1+1
	ldx vram_buffer_pos
	lda #$20
	sta vram_buffer+0,x
	lda #$41
	sta vram_buffer+1,x
	lda #<(Copy30Bytes-1)
	sta vram_buffer+2,x
	lda #>(Copy30Bytes-1)
	sta vram_buffer+3,x
	ldy #0
@loop:
	lda (ptr1),y
	cmp #$FF
	beq @continue
	sta vram_buffer+4,x
	inx
	iny
	bne @loop				;will always branch
@continue:
	lda #SPA
@loop2:
	sta vram_buffer+4,x
	inx
	iny
	cpy #30
	bne @loop2
	txa
	clc
	adc #4
	sta vram_buffer_pos
	
	;draw the file select cursor sprite
	ldy oam_index
	ldx file
	lda FileCursorPositionsX,x	;X
	sta $0203,y
	lda #$52					;Tile (up cursor)
	sta $0201,y
	lda #0						;Attribs
	sta $0202,y
	lda #208					;Y
	sta $0200,y
	tya
	clc
	adc #76
	sta temp0					;save A (Y) as Y is going to get clobbered in a second
	;whatever status the file select state is in, use that for where to get sprite position data from
	lda fileselect_status
	asl
	tax
	lda FileStatusCursorPositions+0,x
	sta ptr1+0
	lda FileStatusCursorPositions+1,x
	sta ptr1+1
	ldy fileselect_cursorpos
	lda (ptr1),y				;X
	ldy temp0					;restore Y register
	sta $0203,y
	lda #$51					;Tile (left cursor)
	sta $0201,y
	lda #0						;Attribs
	sta $0202,y
	lda #16						;Y
	sta $0200,y
	tya
	clc
	adc #76
	sta oam_index
	rts
	
FS_StartGame:
	lda #%00000110
	sta $2001
	lda #0
	sta nmi_enabled
	
	jsr DrawStatusBoarder		;draws the border as well as the text for the status board
	
	lda #%00011110
	sta soft_2001
	lda #1
	sta nmi_enabled
	
	;Now that a game's been loaded or a new game's been started, we need to load the correct sprite palette for the player's weapon
	lda weapon
	asl
	tay
	lda PlayerWeaponPalettes+0,y
	sta ptr1+0
	lda PlayerWeaponPalettes+1,y
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
	lda #0
	sta vram_buffer+4,x
	sta vram_buffer+5,x
	lda #<(RestoreSP-1)
	sta vram_buffer+6,x
	lda #>(RestoreSP-1)
	sta vram_buffer+7,x
	;txa
	;clc
	;adc #8
	;sta vram_buffer_pos
	inc vram_update
	;in the normal game engine, VRAM updates can't happen if the game state is simultaneously changing,
		;so we need to wait for the frame to finish and for the NMI to trigger so the updates can 
	lda frame_counter
@waitframe:
	cmp frame_counter
	beq @waitframe
	rts