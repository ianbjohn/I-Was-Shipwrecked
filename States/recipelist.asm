ItemRecipes:
	.dw SpearRecipe,TorchRecipe,TourniquetRecipe
	
SpearRecipe:
	.db S,T,I,C,K, SPA, $2E, SPA, S,T,O,N,E,$FF
TorchRecipe:
	.db S,T,I,C,K, SPA, $2E, SPA, F,L,I,N,T,$FF
TourniquetRecipe:
	.db S,T,I,C,K, SPA, $2E, SPA, C,L,O,T,H,$FF


RecipeListInit:
	;Clear screen completely
	;For however many craftable items have been discovered
		;Draw the item string, and then under it (Or after a colon or something)
	lda #%00000110
	sta $2001
	lda #0
	sta nmi_enabled
	
	jsr ClearOAM
	
	;clear the entire screen, including the status board
	lda $2002
	lda #$20
	sta $2006
	lda #$00
	sta $2006
	lda #$24
	ldy #4
	ldx #0
@clearscreen:
	sta $2007
	inx
	bne @clearscreen
	dey
	bne @clearscreen
	
	;reset attributes
	lda #$23
	sta $2006
	lda #$C0
	sta $2006
	lda #%11111111
	ldx #64
@resetattributes:
	sta $2007
	dex
	bne @resetattributes
	
	;Start drawing items that have been crafted from the top of the screen down
	;Keep track of the PPU position
	lda $2002
	lda #$20
	sta temp2
	sta $2006
	lda #$41
	sta temp3
	sta $2006
	lda #0
	sta temp1				;how many items have currently been drawn
	sta temp4				;which craftable item index we're at
@drawcrafteditems:
	lda temp1
	cmp num_crafted_items
	beq @drawcrafteditemsdone
	lda temp4
	jsr CheckIfItemCrafted
	bne @crafted
	inc temp4
	bne @drawcrafteditems		;w.a.b
@crafted:
	;draw the item string
	lda temp0					;the ID of the crafted item that was returned
	asl
	tax
	lda RecipeItemStrings+0,x	;in the data section of the main skeleton file
	sta ptr1+0
	lda RecipeItemStrings+1,x
	sta ptr1+1
	ldy #0
@drawitemstring:
	lda (ptr1),y
	cmp #$FF
	beq @drawrecipe
	sta $2007
	iny
	bne @drawitemstring			;w.a.b
@drawrecipe:
	lda #$2F					; :
	sta $2007
	lda #$24
	sta $2007
	lda temp0
	asl
	tax
	lda ItemRecipes+0,x
	sta ptr1+0
	lda ItemRecipes+1,x
	sta ptr1+1
	ldy #0
@drawrecipeloop:
	lda (ptr1),y
	cmp #$FF
	beq @drawrecipeloopdone
	sta $2007
	iny
	bne @drawrecipeloop			;w.a.b
@drawrecipeloopdone:
	lda $2002
	lda temp3					;go to the next tile row of the screen
	clc
	adc #32
	sta temp3
	lda temp2
	adc #0
	sta temp2
	sta $2006
	lda temp3
	sta $2006
	inc temp1
	bne @drawcrafteditems		;w.a.b
@drawcrafteditemsdone:

	lda #%00011110
	sta soft_2001
	lda #1
	sta nmi_enabled
	rts
	

RecipeListMain:
	;If B is pressed
		;Redraw status board
		;Go back to inventory state
	lda buttons_pressed
	and #BUTTONS_B
	beq @done
	lda #%00000110
	sta $2001
	lda #0
	sta nmi_enabled
	jsr DrawStatusBoarder
	lda #%00011110
	sta soft_2001
	lda #1
	sta nmi_enabled
	lda #STATE_INVENTORY
	sta game_state
	jmp CleanUpInventorySystem
@done:
	rts