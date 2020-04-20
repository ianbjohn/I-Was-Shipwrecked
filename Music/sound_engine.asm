NoteTable:
	;thanks Metal Slime / Celius
    .dw                                                                $07F1, $0780, $0713 ; A1-B1 ($00-$02)
    .dw $06AD, $064D, $05F3, $059D, $054D, $0500, $04B8, $0475, $0435, $03F8, $03BF, $0389 ; C2-B2 ($03-$0E)
    .dw $0356, $0326, $02F9, $02CE, $02A6, $027F, $025C, $023A, $021A, $01FB, $01DF, $01C4 ; C3-B3 ($0F-$1A)
    .dw $01AB, $0193, $017C, $0167, $0151, $013F, $012D, $011C, $010C, $00FD, $00EF, $00E2 ; C4-B4 ($1B-$26)
    .dw $00D5, $00C9, $00BD, $00B3, $00A9, $009F, $0096, $008E, $0086, $007E, $0077, $0070 ; C5-B5 ($27-$32)
    .dw $006A, $0064, $005E, $0059, $0054, $004F, $004B, $0046, $0042, $003F, $003B, $0038 ; C6-B6 ($33-$3E)
    .dw $0034, $0031, $002F, $002C, $0029, $0027, $0025, $0023, $0021, $001F, $001D, $001B ; C7-B7 ($3F-$4A)
    .dw $001A, $0018, $0017, $0015, $0014, $0013, $0012, $0011, $0010, $000F, $000E, $000D ; C8-B8 ($4B-$56)
    .dw $000C, $000C, $000B, $000A, $000A, $0009, $0008                                    ; C9-F#9 ($57-$5D)
	.dw $0000
NoteLengthTable:
	.db $01				;32nd
	.db $02				;16th
	.db $04				;8th
	.db $08				;qtr
	.db $10				;hlf
	.db $20				;whl
	;dotted
	.db $03				;dtd 16th
	.db $06				;dtd 8th
	.db $0C				;dtd qtr
	.db $18				;dtd hlf
	.db $30				;dtd whl
	;other
	.db $0A				;5/16
	.db $14				;5/8
	.db $1C				;7/8
	.db $40				;two whole
	.db $F0				;the long-ass note towards the beginning of the shore song
	.db $D0				;the long-ass rest following the above long-ass note
	.db $80				;how long the first fade-in wave should last (4 whole notes)
	.db $70				;how long the second fade-in wave should last
	.db $0E				;7/16
	.db $12				;9/16
	.db $C0				;six whole notes, used for the very long downward portamento note at the end of the mountains song
	
	
Vibrato:
	.dw 0,-1,-2,-3,-3,-3,-2,-1,0,1,2,3,3,3,2,1

	
VolumeEnvelopes:
	.dw SoundVE0,SoundVE1,SoundVE2,SoundVE3,SoundVE4,SoundVE5,SoundVE6,SoundVE7
	.dw SoundVE8,SoundVE9,SoundVE10,SoundVE11,SoundVE12,SoundVE13,SoundVE14,SoundVE15
	.dw SoundVE16,SoundVE17,SoundVE18,SoundVE19,SoundVE20,SoundVE21,SoundVE22,SoundVE23
	.dw SoundVE24,SoundVE25,SoundVE26,SoundVE27

SoundVE0:
	;standard attack
	.db 7,6,5,$FF
SoundVE1:
	;fade in used at the beginning of the shore song
	.db 1,2,3,4,5,$FF
SoundVE2:
	;fade in for the accompaniment in the intro of the shore song
	.db 0,1,2,3,4,5,6,0,$FF
SoundVE3:
	;fade in for the waves
	.db 0,1,1,1,1,1,1,2,2,2,2,3,3,4,4,4,4,5,5,5,5,5,5,6,$FF
SoundVE4:
	;fade out for the waves
	.db 6,5,5,5,5,5,5,4,4,4,4,3,3,2,2,2,2,1,1,1,1,1,1,0,$FF
SoundVE5:
	;hi-hat for drums
	.db 6,5,0,$FF
SoundVE6:
	;snare for drums
	.db 7,6,5,0,$FF
SoundVE7:
	;ping-pong accompaniment for the shore song
	.db 3,2,0,$FF
SoundVE8:
	;same as VE 7, but this one is used with arpeggio, so it doesn't get silenced
	.db 3,2,1,$FF
SoundVE9:
	;used for most sound effects
	.db 10,$FF
SoundVE10:
	;stabbing
	.db 10,9,9,9,0,$FF
SoundVE11:
	;used in the save sfx
	.db 10,9,8,7,5,3,1,0,$FF
SoundVE12:
	.db 5,$FF ;used to sustain long notes so effects can be added at given times
SoundVE13:
	;used for slightly quieter notes than with the main VE
	.db 6,5,4,$FF
SoundVE14:
	;used for accompaniment in the title track. Can also be used for quieter notes
	.db 3,$FF
SoundVE15:
	;used for a "pedal" hihat, in the title
	.db 4,3,2,1,$FF
SoundVE16:
	;also pedal hihat, but with silence at the end
	.db 4,3,2,1,1,0,$FF
SoundVE17:
	;yet another sustain envelope
	.db 4,$FF
SoundVE18:
	;used for accompaniment in the jungle song
	.db 1,2,3,2,1,0,$FF
SoundVE19:
	;The staccato used in the caves song
	.db 7
SoundVE20:
	.db 6,5,4,3,2,1,0,$FF
SoundVE21:
	;used for the throwing sound effect
	.db 0,1,2,2,3,4,6,8,10,10,0,$FF
SoundVE22:
	.db 1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9,10,$FF
SoundVE23:
	;Used for the funny synths at the beginning of the mountains song
	.db 5,4,3,$FF
SoundVE24:
	;Used for the quick fadey synths in the mountains song
	.db 3,5,7,6,5,0,$FF
SoundVE25:
	;The same thing as ^, but sustained
	.db 3,5,7,6,5,$FF
SoundVE26:
	;Used for the accompanying square synths in the mountains song
	.db 2,3,2,0,$FF
SoundVE27:
	;Used for the OTHER accompanying square synths in the mountains song
	.db 3,4,3,2,0,$FF

	
	
Sounds:
	.dw SongShore,SFXHeartCollected,SFXPause,SFXStab,SFXSave,SFXFileSelect,SFXSelection,SFXPlayerHurt
	.dw SFXNewItemAcquisition,SFXPlayerNearDeath,Silence,SFXEnemyHurt,SFXGunshot,SFXEmptyClip,SongTitle,SongJungle
	.dw SongCaves,SFXThrow,SFXRecovery,SFXOhShit,SongMountains
	
	
SoundInit:
	;set up the APU
	lda #%00001111		;Allow all channels to be used
	sta $4015
	lda #1
	sta sound_enabled
	lda #$FF			;initialize with a value that wouldn't otherwise be there at init
	sta sound_sq1_old
	sta sound_sq2_old
	;initialize any other future variables here
	;start out by silencing the channals
SoundSilence:
	lda #$30
	sta soft_apu_ports+0		;SQ1
	sta soft_apu_ports+4		;SQ2
	sta soft_apu_ports+12		;NOI
	lda #$80
	sta soft_apu_ports+8		;TRI
	rts


.macro SoundDisable
	lda #0
	sta $4015
	sta sound_enabled
.endm
	
	
SoundLoad:
	;A should be loaded with the sound index
	inc loading_sound
	sta sound_temp0			;we need to remember this
	asl
	tay
	lda Sounds+0,y
	sta se_ptr+0
	lda Sounds+1,y
	sta se_ptr+1
	
	ldy #0
	lda (se_ptr),y			;# streams
	sta sound_temp1
	iny
@loop:
	lda (se_ptr),y			;stream #
	tax						;use as index
	iny
	lda (se_ptr),y			;status byte (Just enabled/disabled for right now)
	sta stream_status,x
	php
	cpx #5
	bcs @continue
	sta paused_stream_statuses,x
@continue:
	plp
	beq @next				;don't do anything with this stream if it's disabled
	iny
	lda (se_ptr),y			;channel #
	sta stream_channel,x
	iny
	lda (se_ptr),y			;initial duty
	sta stream_vol_duty,x
	iny
	lda (se_ptr),y			;initial volume envelope
	sta stream_ve,x
	iny
	lda (se_ptr),y			;pointer to stream data
	sta stream_ptr_lo,x
	iny
	lda (se_ptr),y
	sta stream_ptr_hi,x
	iny
	lda (se_ptr),y			;initial tempo
	sta stream_tempo,x
	lda #$A0
	sta stream_ticker_total,x
	lda #1
	sta stream_note_length_counter,x
	lda #0
	sta stream_ve_index,x
	sta stream_vib_index,x
	sta stream_vib,x
	sta stream_porta,x
	;sta stream_porta_dest,x
	sta stream_porta_type,x			;portamento speed can be set at a song/sfx's discretion
	sta stream_loop0,x
	sta stream_loop1,x
@next:
	iny
	
	lda sound_temp0
	sta stream_curr_sound,x
	dec sound_temp1
	bne @loop
	dec loading_sound
	rts
	
	
.macro SoundPlayFrame:
	;advances the sound engine every frame (during NMI)
	;Lots of ugly branching / jumps to avoid out-of-range errors, but I want to avoid subroutines since this should be fast
	lda sound_enabled
	bne @continue
	jmp @done
@continue:
	lda loading_sound
	beq @load
	jmp @done
@load:
	
	jsr SoundSilence

	ldx #0				;time to go through the streams
@loop:
	lda stream_status,x
	and #%00000001		;check bit 0 to see if its enabled or not, and move onto the next if it isnt
	bne @continue1
	jmp @endloop
@continue1:
	lda stream_channel,x
	cmp #DMC
	beq @continue2
	
	;if portamento is on, add/subtract (currently hard-coded value) to/from the pitch of the channel
	lda stream_porta,x
	beq @portadone
	lda stream_porta_dest,x
	asl
	tay
	lda stream_porta_type,x
	beq @lower
@higher:
	lda stream_note_lo,x
	sec
	sbc stream_porta_speed,x
	sta stream_note_lo,x
	lda stream_note_hi,x
	sbc #0
	sta stream_note_hi,x
	cmp NoteTable+1,y
	bcc @stopporta
	bne @portadone
	lda stream_note_lo,x
	cmp NoteTable+0,y
	bcc @stopporta
	bcs @portadone			;will always branch
@lower:
	lda stream_note_lo,x
	clc
	adc stream_porta_speed,x
	sta stream_note_lo,x
	lda stream_note_hi,x
	adc #0
	sta stream_note_hi,x
	cmp NoteTable+1,y
	bcc @portadone
	bne @stopporta
	lda stream_note_lo,x
	cmp NoteTable+0,y
	bcc @portadone
@stopporta:
	;set the destination note to the current stream data, and turn porta off
	lda NoteTable+0,y
	sta stream_note_lo,x
	lda NoteTable+1,y
	sta stream_note_hi,x
	lda #0
	sta stream_porta,x
@portadone:
	
	;increase vibrato index, wrapping back if necessary
	lda stream_vib,x
	beq @continue2
	lda stream_vib_index,x
	clc
	adc #1
	cmp #16
	bne @skipoverflow
	lda #0
@skipoverflow:
	sta stream_vib_index,x
@continue2:

	;add tempo to the ticker total, advancing if there was an overflow
	lda stream_ticker_total,x
	clc
	adc stream_tempo,x
	sta stream_ticker_total,x
	bcc @next			;dec counter if there was a tick
	
	dec stream_note_length_counter,x
	bne @next			;if not 0, note is still playing
	lda stream_note_length,x		;reload note length so that the length will stay the same until a different length is specified
	sta stream_note_length_counter,x
	jsr SoundFetchByte
@next:
	jsr SoundSetTempPorts
@endloop:
	inx
	cpx #NUM_STREAMS
	beq @set
	jmp @loop
@set:
	jsr SoundSetAPU
@done:
.endm


SoundFetchByte:
	;technically this can be a macro but it's easier if it's just a subroutine
	;reads and handles a byte from the current stream
	;X has the stream #
	lda stream_ptr_lo,x
	sta se_ptr+0
	lda stream_ptr_hi,x
	sta se_ptr+1
	
	ldy #0
@fetch:
	lda (se_ptr),y		;read byte from the stream, and figure out what to do with it
	bpl @note
	cmp #$A0
	bcc @notelength
@opcode:
	jsr SoundSelectOpcode
	iny					;next byte in stream
	lda stream_status,x
	and #%00000001
	bne @fetch			;continue unless stream is disabled
	rts
@notelength:
	;chop off bit 7 to get the correct length, and store it in appropriate RAM
	and #%01111111
	sty sound_temp0
	tay
	lda NoteLengthTable,y
	sta stream_note_length,x
	sta stream_note_length_counter,x
	ldy sound_temp0
	iny
	jmp @fetch
@note:
	sta sound_temp1		;save note value (gets altered when checking if noise)
	lda stream_channel,x
	cmp #NOISE
	bne @notnoise
	jsr SoundDoNoise
	jmp @resetve
@notnoise:
	cmp #DMC
	bne @notdmc
	jsr SoundDoDMC
	jmp @updateptr
@notdmc:
	lda sound_temp1		;restore note value
	asl
	sty sound_temp0		;need to save Y cuz it bouta get clobbered
	tay
	lda NoteTable+0,y
	sta stream_note_lo,x
	lda NoteTable+1,y
	sta stream_note_hi,x
	ldy sound_temp0
@resetve:
	lda #0
	sta stream_ve_index,x
	;check if rest
	jsr SoundCheckRest
@updateptr:
	;direct the pointer to the next byte in the stream for the next frame
	iny
	tya
	clc
	adc stream_ptr_lo,x
	sta stream_ptr_lo,x
	bcc @end			;only inc high byte if there was an overflow
	inc stream_ptr_hi,x
@end:
	rts
	
	
SoundSetAPU:
	;unload the buffer to the hardware APU registers
@square1:
	lda soft_apu_ports+0
	sta $4000
	lda soft_apu_ports+1
	sta $4001
	lda soft_apu_ports+2
	sta $4002
	lda soft_apu_ports+3
	cmp sound_sq1_old
	beq @square2
	sta $4003
	sta sound_sq1_old		;save this so we can avoid redundant writes to the hardware registers and prevent crackling
@square2:
	lda soft_apu_ports+4
	sta $4004
	lda soft_apu_ports+5
	sta $4005
	lda soft_apu_ports+6
	sta $4006
	lda soft_apu_ports+7
	cmp sound_sq2_old
	beq @triangle
	sta $4007
	sta sound_sq2_old
@triangle:
	lda soft_apu_ports+8
	sta $4008
	lda soft_apu_ports+10
	sta $400A
	lda soft_apu_ports+11
	sta $400B
@noise:
	lda soft_apu_ports+12
	sta $400C
	lda soft_apu_ports+14
	sta $400E
	lda soft_apu_ports+15
	sta $400F
	rts
	
	
SoundSetTempPorts:
	;fill the buffer with what data we got based on the streams
	lda stream_channel,x
	cmp #DMC
	beq @done
	asl
	asl						;this'll compute the proper registers to write to
	tay
	
	jsr SoundSetVolume
	
	lda #8
	sta soft_apu_ports+1,y	;sweep
	lda stream_vib,x
	beq @novib
	sty sound_temp0
	lda stream_vib_index,x
	asl
	sta sound_temp1
	tay
	lda stream_note_lo,x
	clc
	adc Vibrato+0,y
	php
	ldy sound_temp0
	sta soft_apu_ports+2,y	;period low
	ldy sound_temp1
	lda stream_note_hi,x
	plp
	adc Vibrato+1,y
	ldy sound_temp0
	sta soft_apu_ports+3,y	;period high
	lda stream_vib_index,x
	rts
@novib:
	lda stream_note_lo,x
	sta soft_apu_ports+2,y	;period low
	lda stream_note_hi,x
	sta soft_apu_ports+3,y	;period high
@done:
	rts
	
	
SoundCheckRest:
	lda (se_ptr),y
	cmp #rest
	bne @norest
	lda stream_status,x
	ora #%00000010		;set the bit indicating that we're resting
	bne @store			;will always branch
@norest:
	lda stream_status,x
	and #%11111101		;clear the bit indicating that we're not resting
@store:
	sta stream_status,x
	rts
	

SoundSetVolume:
	sty sound_temp0
	lda stream_ve,x
	asl
	tay
	lda VolumeEnvelopes+0,y
	sta se_ptr+0
	lda VolumeEnvelopes+1,y
	sta se_ptr+1
@readve:
	ldy stream_ve_index,x
	lda (se_ptr),y
	cmp #$FF
	bne @setvol
	dec stream_ve_index,x
	jmp @readve
@setvol:
	sta sound_temp1
	cpx #TRIANGLE
	bne @squares
	lda sound_temp1
	bne @squares
	lda #$80
	bmi @storevol
@squares:
	lda stream_vol_duty,x
	and #%11110000			;zero out old volume
	ora sound_temp1
@storevol:
	ldy sound_temp0
	sta soft_apu_ports,y
	inc stream_ve_index,x
	;check rest flag of stream status, overwriting volume with silence if necessary
@checkrest:
	lda stream_status,x
	and #%00000010
	beq @done
	lda stream_channel,x
	cmp #TRIANGLE
	beq @tri
	lda #$30
	bne @store
@tri:
	lda #$80
@store:
	sta soft_apu_ports,y
@done:
	rts
	
	
SoundSelectOpcode:
	;indirect jump to the right opcode to do (Should be in A)
	sty sound_temp0
	sec
	sbc #$A0
	asl
	tay
	lda SoundOpcodes+0,y
	sta jump_ptr+0
	lda SoundOpcodes+1,y
	sta jump_ptr+1
	ldy sound_temp0
	iny				;next byte in stream
	jmp (jump_ptr)
	
	
SoundDoNoise:
	lda sound_temp1		;restore note value
	and #%00010000		;which type of noise it is (there are 2)
	beq @mode0
@mode1:
	lda sound_temp1
	ora #%10000000		;mode 1 enabled
	sta sound_temp1
@mode0:
	lda sound_temp1
	sta stream_note_lo,x	;temporary port that'll get copied to $400E
	rts
	
	
SoundDoDMC:
	txa
	pha
	ldx sound_temp1
	beq @done
	;0 is equivalent to a rest. Dont play any samples
	dex ;this way the first actual sample can start at index 0
	lda SampleAddresses,x
	sta $4012
	lda SampleLengths,x
	sta $4013
	lda #%00011111
	sta $4015
@done:
	pla
	tax
	rts
	
	
	;opcode subroutines
SoundOpcodes:
	.dw SoundOpEndSound, SoundOpInfiniteLoop, SoundOpChangeVE, SoundOpChangeDuty
	.dw SoundOpSetLoop0Count, SoundOpSetLoop0, SoundOpSetLoop1Count, SoundOpSetLoop1
	.dw SoundOpVibratoOn, SoundOpVibratoOff, SoundOpPortaOn, SoundOpPortaOff
	.dw SoundOpChangePSpeed
	
	
SoundOpEndSound:
	lda stream_status,x
	and #%11111110		;clear enable flat
	sta stream_status,x
	
	lda stream_channel,x	;silence channels, triangle needs its own special shit
	cmp #TRIANGLE
	beq @silencetri
	lda #$30
	bne @silence			;w.a.b
@silencetri:
	lda #$80
@silence:
	sta stream_vol_duty,x
	rts
	
	
SoundOpInfiniteLoop:
	lda (se_ptr),y		;read the address to jump back to
	sta stream_ptr_lo,x
	iny
	lda (se_ptr),y
	sta stream_ptr_hi,x
	sta se_ptr+1		;update the actual ptr
	lda stream_ptr_lo,x
	sta se_ptr+0
	ldy #$FF			;reset counter back to 0 (will get INYd after this)
	rts
	
	
SoundOpChangeVE:
	lda (se_ptr),y		;read the argument (which volume envelope to load)
	sta stream_ve,x
	lda #0
	sta stream_ve_index,x	;reset position of the envelope
	rts
	
	
SoundOpChangeDuty:
	lda (se_ptr),y
	sta stream_vol_duty,x
	rts
	
	
SoundOpSetLoop0Count:
	lda (se_ptr),y		;get # times to loop
	sta stream_loop0,x
	rts
	
	
SoundOpSetLoop0:
	dec stream_loop0,x
	lda stream_loop0,x
	beq @last
@loopback:
	lda (se_ptr),y
	sta stream_ptr_lo,x
	iny
	lda (se_ptr),y
	sta stream_ptr_hi,x
	sta se_ptr+1
	lda stream_ptr_lo,x
	sta se_ptr+0
	ldy #$FF
	rts
@last:
	iny
	rts
	
	
SoundOpSetLoop1Count:
	lda (se_ptr),y
	sta stream_loop1,x
	rts
	
	
SoundOpSetLoop1:
	dec stream_loop1,x
	lda stream_loop1,x
	beq @last
@loopback:
	lda (se_ptr),y
	sta stream_ptr_lo,x
	iny
	lda (se_ptr),y
	sta stream_ptr_hi,x
	sta se_ptr+1
	lda stream_ptr_lo,x
	sta se_ptr+0
	ldy #$FF
	rts
@last:
	iny	
	rts
	
	
SoundOpVibratoOn:
	lda #1
	sta stream_vib,x
	lda #0
	sta stream_vib_index,x
	dey			;most every other opcode has operands with it, but not this one. So we need to decrement here so it'll be in the right position afterwards
	rts
	
	
SoundOpVibratoOff:
	lda #0
	sta stream_vib,x
	dey
	rts
	
SoundOpPortaOn:
	lda #1
	sta stream_porta,x		;turn on portamento
	sty sound_temp0			;save Y, about to get clobbered
	iny
	lda (se_ptr),y			;Peek the next-next byte, which will be the starting note that'll be compared to the byte before it - the destination note
	asl
	tay
	lda NoteTable+1,y
	sta stream_note_hi,x
	lda NoteTable+0,y
	sta stream_note_lo,x
	ldy sound_temp0			;Now time to get the destination note
	lda (se_ptr),y
	sta stream_porta_dest,x
	asl
	tay
	;16-bit compare for <, sets variable accordingly
	lda NoteTable+1,y
	cmp stream_note_hi,x
	bcc @higher
	bne @lower
	lda NoteTable+0,y
	cmp stream_note_lo,x
	bcc @higher
@lower:
	lda #0
	beq @done				;w.a.b
@higher:
	lda #1
@done:
	sta stream_porta_type,x
	ldy sound_temp0
	;iny 					;Sound engine needs to be ready to read the starting note
	rts
	
	
SoundOpPortaOff:
	lda #0
	sta stream_porta,x
	dey
	rts
	
	
SoundOpChangePSpeed:
	lda (se_ptr),y		;get speed
	sta stream_porta_speed,x
	rts
	
	
	;Actual song / sfx data
	.include "music/bgm/song_title.asm"
	.include "music/bgm/song_shore.asm"
	.include "music/bgm/song_jungle.asm"
	.include "music/bgm/song_caves.asm"
	.include "music/bgm/song_mountains.asm"
	.include "music/sfx/sfx_heartcollected.asm"
	.include "music/sfx/sfx_pause.asm"
	.include "music/sfx/sfx_stab.asm"
	.include "music/sfx/sfx_save.asm"
	.include "music/sfx/sfx_fileselect.asm"
	.include "music/sfx/sfx_selection.asm"
	.include "music/sfx/sfx_playerhurt.asm"
	.include "music/sfx/sfx_newitemacquisition.asm"
	.include "music/sfx/sfx_playerneardeath.asm"
	.include "music/silence.asm"
	.include "music/sfx/sfx_enemyhurt.asm"
	.include "music/sfx/sfx_gunshot.asm"
	.include "music/sfx/sfx_emptyclip.asm"
	.include "music/sfx/sfx_throw.asm"
	.include "music/sfx/sfx_recovery.asm"
	.include "music/sfx/sfx_ohshit.asm"