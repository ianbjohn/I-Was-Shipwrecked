KnifeRoutine:
	;check if timer has run out, and deactivate if it has
@checktimerzero:
	lda player_weapon_active_timer
	bne @checktimerzerodone
	DeactivateEnt
	rts
@checktimerzerodone:
	lda ent_dir+1
	beq @up
	cmp #1
	beq @down
	cmp #2
	beq @left
@right:
	jsr EntCheckBGColTR
	jsr EntCheckBGColTL
	jsr EntCheckBGColBL
	jmp EntCheckBGColBR
@up:
	jsr EntCheckBGColTL
	jsr EntCheckBGColLM
	jsr EntCheckBGColRM
	jmp EntCheckBGColTR
@down:
	jsr EntCheckBGColBL
	jsr EntCheckBGColLM
	jsr EntCheckBGColRM
	jmp EntCheckBGColBR
@left:
	jsr EntCheckBGColTL
	jsr EntCheckBGColTR
	jsr EntCheckBGColBR
	jmp EntCheckBGColBL