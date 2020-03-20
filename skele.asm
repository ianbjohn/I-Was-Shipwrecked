	;Header to make a file that an NES emulator can read
	.db "NES",$1a
	.db 8			;prg banks
	.db 0			;chr banks (Using RAM)
	.db %00010010	;mapper 1 (MMC1), battery-back WRAM (SRAM)
	.dsb 9,$00
	
	
	;variables and constants
	.include "varsandconsts.asm"
	;macros
	.include "macros.asm"
	
	
	;switchable bank 0
	.base $8000
	;This bank contains code for the entity (ent) system, as well as all the data needed for initializing ents, and for drawing their metasprites
	.include "ents/entsystem.asm"
	.include "ents/metasprites.asm"
	.include "ents/entdata.asm"
	
HealthDepleteTimes:
	;sorted by player status
	;once EXP/leveling up is implemented, treat this as a 2D array of sorts where X is level and Y is status (This might not need to be here, but leave it here for now)
	;0 means that the status shouldn't affect the thing
	;Might have to end up making these 16-bit, since it may just be too damn hard to get back to normal in such a short time
	;Look into how these actual conditions (such as poisoning / infections etc) actually affect things like hunger and thirst, if at all
	.db 000,210,200,235,210
HungerDepleteTimes:
	.db 255,235,255,245,240
ThirstDepleteTimes:
	.db 240,235,240,235,240
	
	.org $C000
	
	
	;switchable bank 1
	.base $8000
	.include "metatiles.asm"			;includes metatile definitions
	.include "screens.asm"				;includes screen structure definitions
										;Will eventually need multiple banks for screen structure data, but at the time of typing this (7/1/17) we're fine on size for this bank
	.org $C000
	
	;switchable bank 2
	.base $8000
	;This bank contains code for the messagebox system, as well as text data for all the messages (Maybe try a simple huffman encoding (or something) scheme for compressing the text if we end up needing to, but I think we'll be okay. Also have to remember that a lot of bytes correspond to different commands for the messagebox system)
	.include "Messages/messages.asm"
	.include "Messages/inventory_messages.asm"
	.org $C000
	
	;switchable bank 3
	.base $8000
	;put all the actual CHR data that can fit in here in here, before the tables and animation definitions and all that
	;BACKGROUND CHR DATA
CHR_Logo:
	.incbin "Graphics/CHR/logo_chr.chr"
	
CHR_GlobalBG:
	;textual characters and a few other "global" tiles. (Starts at $1000 in CHR RAM, and has a length of $500 bytes)
	.incbin "Graphics/CHR/global_bg.chr"
	
CHR_ShoreBG:
	.incbin "Graphics/CHR/shore_bg.chr"
CHR_CaveBG:
	.incbin "Graphics/CHR/cave_bg.chr"
	
	
	;SRITE CHR DATA
	;for right now, sprites all just use the same 4KB bank (Since there aren't really enough sprites drawn yet to make splitting them up necessary as of right now)
CHR_Sprites:
	.incbin "Graphics/CHR/sprites.chr"
	
	
	;individual tiles for animation
CHR_Waves:
	.incbin "Graphics/CHR/waves.chr"
	
	
CHR_Banks_BG:
	;sorted by area, where the background CHR data for each area starts (Always starts at $1500 in CHR RAM, and has a length of $B00 bytes)
	.dw CHR_ShoreBG,CHR_ShoreBG,CHR_ShoreBG,CHR_ShoreBG,CHR_CaveBG
	
	
	;Where in the CHR file the animation tiles are (more general stuff is at $F000)
Animated_CHR_Waves:
	.dw CHR_GlobalBG+1024, CHR_Waves+0, CHR_Waves+16, CHR_GlobalBG+576, CHR_Waves+48, CHR_Waves+64
	
	
	.org $C000
	
	
	;switchable bank 4
	.base $8000
	;music (16kb might be nowhere near enough for both music and the sound engine, so maybe try putting the sound engine in main ROM, or using multiple banks for music data)
	.include "music/sound_engine.asm"
	
	.org $C000
	
	;switchable bank 5
	.base $8000
	;events (Probably won't be anywhere near 16kb, so feel free to put other stuff in here if needed)
	.include "events.asm"
	
	.org $C000
	
	;switchable bank 6
	.base $8000
	;whatever else
CHR_Title:
	.incbin "Graphics/CHR/title_chr.chr"
CHR_TitleSprites:
	.incbin "Graphics/CHR/title_sprites.chr"
TitleScreen:
	.incbin "Graphics/title_screen.bin"
TitleScreenAttribs:
	.incbin "Graphics/title_screen_attribs.bin"
	
TitlePalette:
	.db $38,$11,$21,$30, $38,$0A,$1A,$17, $38,$1A,$29,$3C, $38,$0F,$3C,$30
	.db $38,$36,$0F,$30
	
TitleScreenSprites:
	;Y,sprite,attrs,X
	.db 20,$00,0,0			;sun
	.db 20,$01,0,8
	.db 20,$02,0,16
	.db 28,$03,0,0
	.db 28,$04,0,8
	.db 28,$05,0,16
	.db 36,$06,0,0
	.db 36,$07,0,8
	.db 36,$08,0,64			;"I WAS"
	.db 36,$09,0,80
	.db 36,$0A,0,88
	.db 36,$0B,0,96
	.db 118,$0C,0,108		;"Press Start"
	.db 118,$0D,0,116
	.db 118,$0E,0,124
	.db 118,$0B,0,132
	.db 118,$0B,0,140
	.db 130,$0B,0,108
	.db 130,$0F,0,116
	.db 130,$0A,0,124
	.db 130,$0D,0,132
	.db 130,$0F,0,140
	.db 200,$10,0,108		;(C)2018 Bona Fide Games
	.db 200,$11,0,116
	.db 200,$12,0,124
	.db 200,$13,0,132
	.db 200,$14,0,140
	.db 208,$15,0,92
	.db 208,$16,0,100
	.db 208,$17,0,108
	.db 208,$18,0,116
	.db 208,$19,0,132
	.db 208,$1A,0,140
	.db 208,$1B,0,148
	.db 208,$1C,0,156
	.db 216,$1D,0,108
	.db 216,$18,0,116
	.db 216,$1E,0,124
	.db 216,$1C,0,132
	.db 216,$1F,0,140
	
	
	;fixed bank
	.org $C000
	;When the game first boots up or gets reset, some shit needs to happen
RESET:
	sei					;Disable interrupt mode
	cld					;Disable decimal mode (We can't use it)
	ldx #$0F			;Disable DMC interrupts
	stx $4010
	ldx #$FF
	txs					;Init stack pointer
	stx $8000			;reset MMC1
	inx
	stx $2000			;Init PPU
	stx $2001
	stx $4017
VBlWait1:
	bit $2002
	bpl VBlWait1		;Wait two frames for everything to stabilize
	
	;reset memory
ClrMem:
	lda #$00
	sta $00,x
	sta $0100,x
	sta $0300,x
	sta $0400,x
	sta $0500,x
	sta $0600,x
	sta $0700,x
	sta $6000,x
	sta $6100,x
	;DON'T CLEAR $6200!!! - WHERE FILE DATA IS SAVED/LOADED
	;be sure to clear the rest of all used WRAM though
	sta $6300,x
	sta $6400,x
	sta $6500,x
	sta $6600,x
	sta $6700,x
	lda #$FE			;move sprites off-screen
	sta $0200,x
	inx
	bne ClrMem
VBlWait2:
	bit $2002
	bpl VBlWait2		;wait for the second frame
	
	
	;set up MMC1
	;This allows us to use more ROM space than originally available
SetUPMMC1:
	lda #%10000000		;reset the chip
	sta $8000
	lda #%00001110		;Let it know what we want (vertical mirroring, 16kb switchable + 16kb fixed PRG, CHR RAM)
	sta $8000
	lsr
	sta $8000
	lsr
	sta $8000
	lsr
	sta $8000
	lsr
	sta $8000
	
	lda #BANK_MUSIC
	jsr SetPRGBank
	jsr SoundInit		;set up the APU
	
	
	;on the game startup, we go to the title state
	;since that's already 0, nothing else to do
	
	;lda #STATE_TITLE
	;sta game_state
	;sta game_state_old
	
	;(load the logo CHR data)
	lda #BANK_GRAPHICS
	jsr SetPRGBank
	lda #<CHR_Logo
	sta mt_ptr1+0
	lda #>CHR_Logo
	sta mt_ptr1+1
	lda #$10		;store in PPU location $1000
	sta temp1
	lda #$00
	sta temp2
	sta temp3		;how many bytes to move
	lda #$04		;1-based
	sta temp4
	jsr LoadCHR
	
	;lda #1
	;sta in_cave_new
	;lda #9
	;sta cave_level
	
	lda #0					;BANK_ENTS
	jsr SetPRGBank
	jsr SelectStateToInit
	
	
	;main loop
MainLoop:
	lda frame_counter
@WaitFrame:
	cmp frame_counter	;variable gets INCd at the end of NMI, but accumulator stays the same
	beq @WaitFrame
	
	;tint the screen for how long it takes to run a frame (Show's how much shit is going on. If the whole screen turns blue, the game will lag)
	;For some reason, this causes some graphical glitches when turning the PPU off via setting $2001 to #%00000110.
	;However, when this debug feature is commented out, no glitches occur, so don't worry about it.
	lda $2001
	ora #%10000000
	sta $2001
	
	jsr ReadControllerDPCM		;read controller data once during the frame, and store it in RAM so we can access it whenever
	
	;If the game state's changed, do what needs to be done to initialize the new state
	lda game_state
	cmp game_state_old
	beq @noinit
	sta game_state_old
	jsr SelectStateToInit
	lda game_state			;if the state was changed in a state's init code, don't run the main code
	cmp game_state_old
	bne @mainstatedone
	sta game_state_old
@noinit:
	jsr SelectMainState		;otherwise, go to whatever state we're currently in and run it like normal
@mainstatedone
	
	;If something is in the VRAM buffer, that means an update needs to happen next NMI.
	;The flag should only be set here, once everything else in the frame is done, in case not everything can be
		;finished before VBlank (Good to be on the safe side)
		;What also needs to happen once everything (if anything) has been put into the buffer, the RestoreSP address
		;needs to be put at the end, so the unrolling in NMI can be completed successfully.
@checkVRAMbuffercontents:
	lda game_state
	;cmp game_state_old						;originally only actually performed VRAM updates if the game state had remained unchanged, but ran into problems when changing screens
	;beq @continue
	cmp #STATE_GAMEOVER
	bne @continue
	ldx #0
	stx vram_buffer_pos
	beq @checkVRAMbuffercontentsdone		;will always branch
@continue:
	;Add the address RestoreSP-1 to the VRAM buffer
	ldx vram_buffer_pos			;set to 0 in NMI once the buffer has been drawn
	beq	@checkVRAMbuffercontentsdone	;if position is at 0, the buffer is empty, so updates don't even need to happen
	lda #0
	sta vram_buffer+0,x
	sta vram_buffer+1,x
	lda #<(RestoreSP-1)
	sta vram_buffer+2,x
	lda #>(RestoreSP-1)
	sta vram_buffer+3,x
	inc vram_update
@checkVRAMbuffercontentsdone:
	;add up any other values and store them in the random number
	
	;stop tinting screen, everything in this frame is finished
	lda $2001
	and #%01111111
	sta $2001
	jmp MainLoop
	
	
	.include "NMI.asm"
	
	
	;subroutines
InitStates:
	.dw TitleInit, IntroInit, PlayInit, PausedInit, GameOverInit, FadeOutInit, DrawingMBoxInit
	.dw WritingMSGInit, MBoxResponseInit, ErasingMBoxInit, InventoryInit, LoadingScreenInit, FileSelectInit, RecipeListInit
SelectStateToInit:
	lda game_state
	asl
	tax
	lda InitStates+0,x
	sta jump_ptr+0
	lda InitStates+1,x
	sta jump_ptr+1
	jmp (jump_ptr)
	
	
MainStates:
	.dw TitleMain, IntroMain, PlayMain, PausedMain, GameOverMain, FadeOutMain, DrawingMBoxMain
	.dw WritingMsgMain, MBoxResponseMain, ErasingMBoxMain, InventoryMain, LoadingScreenMain, FileSelectMain, RecipeListMain
SelectMainState:
	lda game_state
	asl
	tax
	lda MainStates+0,x
	sta jump_ptr+0
	lda MainStates+1,x
	sta jump_ptr+1
	jmp (jump_ptr)
	
	;eventually these may need to be moved to other banks. If that happens, be sure to bank switch BEFORE trampolining
	.include "States/title.asm"
	.include "States/play.asm"
	.include "States/paused.asm"
	.include "States/gameover.asm"
	.include "States/drawingmbox.asm"
	.include "States/writingmsg.asm"
	.include "States/mboxresponse.asm"
	.include "States/erasingmbox.asm"
	.include "States/inventory.asm"
	.include "States/fileselect.asm"
	.include "States/loadingscreen.asm"
	.include "States/recipelist.asm"
	
	
IntroInit:
	rts
PausedInit:
	lda #0
	sta stream_status+0
	sta stream_status+1
	sta stream_status+2
	sta stream_status+3	;silence all the BGM channels
	sta stream_status+4
	lda #59				;this is the count down for the pause jingle. Once this gets to 0, the sound will be silenced, and the user will be allowed to unpause
	sta pause_jingle_timer
	ldy #SFX_PAUSE
	jmp PlaySound
FadeOutInit:
	lda in_cave_new
	cmp #1
	bne @silence
	lda in_cave
	cmp #1
	bne @silence
	rts
@silence
	ldy #SILENCE
	jmp PlaySound
MBoxResponseInit:
LoadingScreenInit:
IntroMain:
	rts
FadeOutMain:
	;Standard "Naive" way of fading out - every 15 frames decrease the brightness of the colors, until they're black
	;if (++fadeout_timer >= 15)
		;if (++fadeout_state < 8)
			;for each palette byte
				;if (palette byte & 0xF0 >= (0x30 - (fadeout_state << 4)))
					;palette_byte -= fadeout_state << 4;
				;else
					;palette_byte = 0x0F;
		;else
			;game_state = STATE_LOADINGSCREEN;
	lda fadeout_timer
	clc
	adc #1
	cmp #15
	bcs @continue
	jmp @done
@continue:
	lda fadeout_state
	clc
	adc #1
	cmp #8
	bcc @fade
	jmp @loadscreen
@fade:
	sta fadeout_state
	asl
	asl
	asl
	asl
	sta temp0
	lda #$30
	sec
	sbc temp0
	sta temp1
	ldx vram_buffer_pos
	lda #$3F
	sta vram_buffer+0,x
	lda #$00
	sta vram_buffer+1,x
	lda #<(Copy32Bytes-1)
	sta vram_buffer+2,x
	lda #>(Copy32Bytes-1)
	sta vram_buffer+3,x
	ldy #0
@fadeloop:
	lda palette_buffer,y
	and #%11110000
	cmp temp0
	bcs @continue1
	lda #$0F				;palette_buffer,y
	jmp @store
@continue1:
	lda palette_buffer,y
	sec
	sbc temp0
	sta palette_buffer,y
@store:
	sta vram_buffer+4,x
	inx
	iny
	cpy #32
	bne @fadeloop
	txa
	clc
	adc #4
	sta vram_buffer_pos
	lda #0
	beq @done
@loadscreen:
	lda #STATE_LOADINGSCREEN
	sta game_state
@done2:
	lda #0
	sta fadeout_state
@done:
	sta fadeout_timer
	rts
	
	
	;other subroutines
ReadController:
	;Stores the state of the controller in RAM
	ldx #1
	stx $4016
	stx temp0			;ring counter (IDK I don't really understand this but the code was taken from the NesDev wiki)
	dex
	stx $4016
	ldx #8
-	lda $4016
	and #%00000011
	cmp #1
	rol buttons
	lda $4017			;allow expansion port to be used
	and #%00000011
	cmp #1
	rol temp0
	bcc -
	rts
	
	
ReadControllerDPCM:
	;Since I am gonna use samples in the game, and because the NES has a stupid glitch that potentially corrupts controller reads while samples are playing, read controllers twice, compare the two, if there was a difference, use the old one
	lda buttons
	sta buttons_old
	sta last_frame_buttons
	jsr ReadController
	lda buttons
	sta first_read_buttons
	jsr ReadController
	lda buttons
	cmp first_read_buttons
	beq @notglitched
@glitched:
	lda last_frame_buttons
	sta buttons
@notglitched:
	;compute which buttons were pressed
	lda buttons_old
	eor #%11111111
	and buttons
	sta buttons_pressed
	;lda buttons
	;eor #%11111111
	;and buttons_old
	;sta buttons_released		;don't think we'll need this
	rts
	
	
	;Used to initialize the main palettes - Player, Powerups/collectibles, HUD
SetUpPalettes:
	lda $2002
	lda #$3F
	sta $2006
	lda #$0C
	sta $2006
	tay
	ldy #$0C
	lda #$0F
	sta $2007
	sta $2007
	sta $2007
	sta palette_buffer+0,y
	sta palette_buffer+1,y
	sta palette_buffer+2,y
	lda #$30
	sta $2007
	sta palette_buffer+3,y
	
	;set up the first sprite (player / cursor) subpalette)
	lda $2002
	lda #$3F
	sta $2006
	lda #$11
	sta $2006
	tay			;where we set the palette latch can also be used to index it
	ldx #0
@loop1:
	lda PlayerPalette,x
	sta $2007
	sta palette_buffer,y
	iny
	inx
	cpx #3
	bne @loop1
	
	;Set up player's weapon's subpalette
	lda weapon
	asl
	tax
	lda PlayerWeaponPalettes+0,x
	sta ptr1+0
	lda PlayerWeaponPalettes+1,x
	sta ptr1+1
	lda $2002
	lda #$3F
	sta $2006
	lda #$15
	sta $2006
	tax
	ldy #0
@loop2:
	lda (ptr1),y
	sta $2007
	sta palette_buffer,x
	iny
	cpy #3
	bne @loop2
	
	;also set up the misc sprite subpalette, might as well do it here
	lda $2002
	lda #$3F
	sta $2006
	lda #$1D
	sta $2006
	tay
	ldx #0
@loop3:
	lda MiscSpritePalette,x
	sta $2007
	sta palette_buffer,y
	iny
	inx
	cpx #3
	bne @loop3
	rts
	
	
	.include "Drawing/statusboarddraw.asm"
	.include "BGCol.asm"
	.include "bcd.asm"
	.include "Mapper/MMC1.asm"
	.include "item_routines.asm"
	
	
	;Still working on organizing the rest of this, as far as files go
LoadCHR:
	;still a work in progress
	;This is used to load Big bulks of CHR data, like for cutscenes and area transitions and things of that nature
	;Where to load the data from (mt_ptr1), where to put the data (temp1 and temp2), as well as how much data to load (Should be specified by temp3 and temp4), should all be set before-hand
	
	;lda $2002
	ldy #0
	;sty $2001
	lda temp1
	sta $2006
	lda temp2
	sta $2006
	ldx temp3
@loop:
	lda (mt_ptr1),y
	sta $2007
	iny
	bne @continue
	inc mt_ptr1+1
@continue:
	dex
	bne @loop
	;lda temp4
	;sec
	;sbc #1
	;bcc @done		;if high byte rolled under, we're done
	;sta temp4
	;bcs @loop		;w.a.b
	dec temp4
	bne @loop
@done:
	rts
	
	
LoadCHRTileToBuffer:
	;swaps a specific tile into CHR-RAM
	;X should have the index of which bank to read from (Assuming we end up with multiple chr banks which I anticipate we will)
	;Y should have the index of which tile to load from
	;A should have the index of which frame of the tile to load from
	sta temp0
	lda prg_bank
	pha
	lda #BANK_GRAPHICS
	jsr SetPRGBank
	lda temp0
	asl
	pha
	tay
	ldx vram_buffer_pos
	lda Animated_CHR_Tiles_Addresses+0,y
	sta vram_buffer+1,x
	lda Animated_CHR_Tiles_Addresses+1,y
	sta vram_buffer+0,x
	lda #<(Copy16Bytes-1)
	sta vram_buffer+2,x
	lda #>(Copy16Bytes-1)
	sta vram_buffer+3,x
	
	;get where from PRG ROM to load
	pla
	tax
	lda Animated_CHR_Tiles+0,x
	sta ptr1+0
	lda Animated_CHR_Tiles+1,x
	sta ptr1+1
	;get address of the right grame
	lda chr_anim_frame
	asl
	tay
	lda (ptr1),y
	sta mt_ptr1+0
	iny
	lda (ptr1),y
	sta mt_ptr1+1
	
	;finally, load the data
	lda vram_buffer_pos
	clc
	adc #4					;fix new vram buffer position
	tax
	ldy #0
@loop:
	lda (mt_ptr1),y
	sta vram_buffer,x
	inx
	iny
	cpy #16
	bne @loop
	stx vram_buffer_pos
	pla
	jmp SetPRGBank
	
	
	;.db "DIMTB"
DrawInventoryMessageToBuffer:
	;Kind of a complicated routine, but basically what it does is read characters from a string, printing to the status board until a terminating character is reached. From there, it pads the rest of the status board with blackspace.
	;Also supports going to the next line with $FE
	;Y has correct item id
	;Temp0 keeps track of where in the nametable to draw/print to (Initialized to #$41, once it gets to #$A1 the board has been properly set and we can RTS)
	lda InventoryMessageChoices,y
	sta inventory_choices
	tya
	asl
	tay
	lda InventoryMessages+0,y
	sta ptr1+0
	lda InventoryMessages+1,y
	sta ptr1+1
	ldy #0
	ldx vram_buffer_pos
	lda #$41
@bigloop:	
	sta temp0
	sta vram_buffer+1,x			;a tiny little optimization where we set the low byte (big-endian here) first
	lda #$20
	sta vram_buffer+0,x
	lda #<(Copy30Bytes-1)
	sta vram_buffer+2,x
	lda #>(Copy30Bytes-1)
	sta vram_buffer+3,x
@loop:
	lda (ptr1),y
	cmp #$FF
	beq @ff
	cmp #$FE
	beq @fe
	cmp #$FD
	beq @fd
	cmp #$FC
	beq @fc
@regular:
	sta vram_buffer+4,x
	inx
	iny
	bne @loop			;will always branch
@fd:
	;draw how many rounds the gun has
	;convert # of rounds to BCD and draw it
	txa
	pha					;Save X (BCD routine overwrites it)
	lda rounds
	sta bcd_value+0
	jsr BCD_8
	pla
	tax
	lda bcd_tens
	sta vram_buffer+4,x
	lda bcd_ones
	sta vram_buffer+5,x
	lda #$30			; /
	sta vram_buffer+6,x
	lda #3
	sta vram_buffer+7,x
	lda #0
	sta vram_buffer+8,x
	txa
	clc
	adc #5				;account for adding 5 bytes to the buffer (Once #$FF is reached it'll add the other 4)
	tax					;make sure X is saved
	;we can assume that not all 30 bytes will have been drawn at this point (Since # of rounds is always in the bottom left of the status board), so we can just go back to the loop
	iny
	bne @loop	;will always branch
	;jmp @loop
@fe:
	iny
@ff:
	lda #SPA
@draw
	sta vram_buffer+4,x
	txa
	;if X - vram_buffer_pos is 30, the current line of the status board has been padded properly
	sec
	sbc vram_buffer_pos
	cmp #30
	beq @done
	inx
	bne @ff
@done:
	;go to the next "line" of the status board, exiting if appropriate
	txa
	clc
	adc #4						;account for the off-by-4 indexing used in the routine
	sta vram_buffer_pos
	tax
	lda temp0
	clc
	adc #32
	cmp #$A1					;Once $FF has been reached, fill the rest of the board with blackspace
	bne @bigloop
	rts
@fc:
	;draw how much time a torch has before it goes out
	;convert torch timer to BCD and draw it in minutes:seconds format
	txa
	pha					;Save X (BCD routine overwrites it)
	lda torch_timer+1	;minutes
	sta bcd_value+0
	jsr BCD_8
	pla
	tax
	lda #0				;display the tens of the minute (which will always be 0, so we can just hardcode it)
	sta vram_buffer+4,x
	lda bcd_ones
	sta vram_buffer+5,x
	lda #$2F			; :
	sta vram_buffer+6,x
	txa
	pha
	lda torch_timer+0	;seconds
	sta bcd_value+0
	jsr BCD_8
	pla
	tax
	lda bcd_tens
	sta vram_buffer+7,x
	lda bcd_ones
	sta vram_buffer+8,x
	txa
	clc
	adc #5				;account for adding 5 bytes to the buffer (Once #$FF is reached it'll add the other 4)
	tax					;make sure X is saved
	iny
	jmp @loop
	
	
ClearOAM:
	ldx #0
	lda #$FE
@loop:
	sta $0200,x
	inx
	inx
	inx
	inx
	bne @loop
	rts
	
	
RandomLFSR:					;generate a pseudorandom number
	;a simple LFSR PRNG
	;should be used in addition to the summation of various variables to the random variable
	;routine taken from codebase64.org
	beq @eor
	asl
	beq @done
	bcc @done
@eor:
	eor #$1d
@done:
	sta random
	rts
	
	
CleanUpMBoxVars:
	;finish cleaning up the variables
	lda #0
	sta mbox_pos
	sta mbox_screen_pos
	sta message_ptr+0
	sta message_ptr+1
	rts
	

PlaySound:
	;Plays a sound
	;This needs to be here in the fixed bank since sometimes sound will need to be played from code in switchable banks, and since the sound engine is in a switchable bank itself a trampoline needs to happen.
	;Y should have the index of what sound to play
	lda prg_bank
	pha
	lda #BANK_MUSIC
	jsr SetPRGBank
	tya
	jsr SoundLoad
	pla
	jmp SetPRGBank
	
	
OverwriteScreenData:
	lda #BANK_METATILES
	jsr SetPRGBank
	lda prev_screen_screendata_ptr_ids+0
	asl
	tax
	lda PrevScreenScreenDataAddresses+0,x
	sta ptr1+0
	lda PrevScreenScreenDataAddresses+1,x
	sta ptr1+1
	ldx #0
	ldy #0
	;overwrite the metatile bank
	lda metatile_bank
	sta (ptr1),y
	iny
@looptiles:
	lda metatile_map,x
	sta (ptr1),y
	iny
	inx
	cpx #192
	bne @looptiles
	ldx #0					;this could be optimized out by just referring to metatile map (will spill into attribute map) and comparing to 248, but I don't think it's a huge deal 
@loopattribs:
	lda attribute_map,x
	sta (ptr1),y
	iny
	inx
	cpx #56
	bne @loopattribs
	lda temp4
	sta temp0
LoadMetaTiles:
	;read the first byte to get which metatile bank to read tiles from
	ldy #0
	sty temp1		;position in buffer
	sty temp2		;position in RAM map
	sty metatile_repeat
	
	lda $2002
	lda #$20
	sta $2006
	lda #$C0
	sta $2006
	
	lda in_cave
	bne @cave
	;load the hard-coded Island screen address
	lda #<(IslandScreens)
	sta ptr2+0
	lda #>(IslandScreens)
	sta ptr2+1
	bne @continue			;will always branch
@cave:
	lda cave_level
	asl
	tax
	lda CaveScreens+0,x
	sta ptr2+0
	lda CaveScreens+1,x
	sta ptr2+1
@continue:
	lda screen
	asl
	tay
	lda (ptr2),y
	sta ptr1+0
	iny
	lda (ptr2),y
	sta ptr1+1
	ldy temp0
	lda (ptr1),y
	sta metatile_bank
	asl
	tax
	lda MetaTileBanks+0,x
	sta mt_ptr1+0
	lda MetaTileBanks+1,x
	sta mt_ptr1+1
	inc temp0				;go to the next byte - actually start reading metatile data
	
LoadMetaTilesLoop:
	;stop drawing metatiles once #$FF is read
	ldy temp0
	lda (ptr1),y
	cmp #$FF
	bne @continue
	inc temp0
	jmp LoadMetaTilesDone
@continue:
	;no need to repeat any metatiles, but there's still data that needs to be read
	lda (ptr1),y	;we've determined the byte wasn't #$FF
	bpl @continue1	;check if repeat byte or not
	;if the sign bit was set, time to repeat the next byte low nibble number of times
	and #%00001111
	sta metatile_repeat
	;inc metatile_repeat		;account for off-by-1 since the repeat # is one-based (i.e 1111 means repeat 16 times)
	inc temp0
	ldy temp0
@continue1:
	;at this point we know that whatever byte is about to be read won't be a repeat byte
	lda (ptr1),y				;get metatile index
	ldx temp2
	sta metatile_map,x			;put the index in the RAM map
	inc temp2
	asl
	tay
	lda (mt_ptr1),y				;use the index and the metatile bank to find the definition address
	sta mt_ptr2+0
	iny
	lda (mt_ptr1),y
	sta mt_ptr2+1
@drawmetatile:
	;mt_ptr2 should be loaded with the address of the definition for whatever metatile should be drawn
	ldy #0
	ldx temp1
	lda (mt_ptr2),y		;top-left tile
	sta $2007
	iny
	lda (mt_ptr2),y		;top-right tile
	sta $2007
	iny
	lda (mt_ptr2),y		;bottom-left tile
	sta metatile_buffer,x
	iny
	inx
	lda (mt_ptr2),y		;bottom-right tile
	sta metatile_buffer,x
	inx
	cpx #32
	beq @unloadbuffer
	stx temp1
	;repeat the current metatile if need be
	lda metatile_repeat
	bne @repeat
	inc temp0			;go to the next byte and continue the whole process
	bne LoadMetaTilesLoop			;will always branch
@repeat:
	dec metatile_repeat	;otherwise decrement the counter and load another repeated metatile
	ldy temp0
	jmp @continue1
@unloadbuffer:
	ldx #0
	stx temp1			;reset the buffer position
@loop2:
	lda metatile_buffer,x
	sta $2007
	inx
	cpx #32
	bne @loop2
	inc temp0			;go on to the next byte and continue the whole process
	bne LoadMetaTilesLoop			;will always branch
LoadMetaTilesDone:
LoadAttributes:
	lda $2002
	lda #$23
	sta $2006
	lda #$C8
	sta $2006
	
	ldy temp0
	ldx #0
@loop:
	lda (ptr1),y
	sta $2007
	sta attribute_map,x			;save the map in RAM so that it can be altered by the player (Cutting down grass, things of that nature)
	iny
	inx
	cpx #56
	bne @loop
LoadAttributesDone:
	rts
	
	
ReloadMetaTiles:
	;similar to the LoadMetaTiles routine in LoadScreen
	;consult that for better comments
	ldy #0
	sty temp0
	sty temp1
	
	lda metatile_bank
	asl
	tay
	lda MetaTileBanks+0,y
	sta mt_ptr1+0
	lda MetaTileBanks+1,y
	sta mt_ptr1+1
	
	
	lda $2002
	lda #$20
	sta $2006
	lda #$C0
	sta $2006
@loop:
	ldy temp0
	cpy #192
	beq ReloadMetaTilesDone
@loop1:
	ldy temp0
	lda metatile_map,y
	asl
	tay
	lda (mt_ptr1),y
	sta mt_ptr2+0
	iny
	lda (mt_ptr1),y
	sta mt_ptr2+1
	
	ldy #0
	lda (mt_ptr2),y
	sta $2007
	iny
	lda (mt_ptr2),y
	sta $2007
	iny
	ldx temp1
	lda (mt_ptr2),y
	sta metatile_buffer,x
	iny
	inx
	lda (mt_ptr2),y
	sta metatile_buffer,x
	inc temp0
	inx
	stx temp1
	cpx #32
	bne @loop1
	
	ldx #0
	stx temp1
@loop2:
	lda metatile_buffer,x
	sta $2007
	inx
	cpx #32
	bne @loop2
	
	ldx #0
	stx temp1
	beq @loop			;will always branch
ReloadMetaTilesDone:
ReloadAttributes:
	lda $2002
	lda #$23
	sta $2006
	lda #$C8
	sta $2006
	ldy #0
@loop:
	lda attribute_map,y
	sta $2007
	iny
	cpy #56
	bne @loop
ReloadAttributesDone:
	rts
	
	
RedrawMetaTile:
	;given an index in the map in X (The value should have already been changed [for right now at least]), redraw the new metatile to the VRAM buffer
	;X should also be in temp0
	ldx temp0
	sta metatile_map,x
	sta temp1
	;get the PPU address
	txa
	clc
	adc #48			;account for status board
	sta temp0
	;NT address: 001000YY YY0XXXX0
	lda #$08			;will be shifted to 0x20 + y
	ldx vram_buffer_pos
	sta vram_buffer+0,x
	lda temp0
	and #%11110000
	asl
	rol vram_buffer+0,x
	asl
	rol vram_buffer+0,x
	sta vram_buffer+1,x
	lda temp0
	and #%00001111
	asl			;16 -> 32
	ora vram_buffer+1,x
	sta vram_buffer+1,x
	lda temp1
	lda #<(Copy2Bytes-1)
	sta vram_buffer+2,x
	lda #>(Copy2Bytes-1)
	sta vram_buffer+3,x
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
	ldy #0				;put the tiles in the buffer
	lda (mt_ptr2),y
	sta vram_buffer+4,x
	iny
	lda (mt_ptr2),y
	sta vram_buffer+5,x
	iny
	lda vram_buffer+1,x
	clc
	adc #32
	sta vram_buffer+7,x
	lda vram_buffer+0,x
	adc #0
	sta vram_buffer+6,x
	lda #<(Copy2Bytes-1)
	sta vram_buffer+8,x
	lda #>(Copy2Bytes-1)
	sta vram_buffer+9,x
	lda (mt_ptr2),y
	sta vram_buffer+10,x
	iny
	lda (mt_ptr2),y
	sta vram_buffer+11,x
	txa
	clc
	adc #12
	sta vram_buffer_pos
	pla
	jmp SetPRGBank
	
	
LoadDarkness:
	;Used for both loading a dark cave screen when the player has no torches, and for setting the background palette to pitch black when the player runs out of torches
	ldx vram_buffer_pos
	lda #$3F
	sta vram_buffer+0,x
	lda #$00
	sta temp1				;used to keep track of palette buffer position
	sta vram_buffer+1,x
	lda #<(Copy12Bytes-1)
	sta vram_buffer+2,x
	lda #>(Copy12Bytes-1)
	sta vram_buffer+3,x
	txa
	clc
	adc #4
	sta vram_buffer_pos
	ldy #0
	lda #$0F				;blackness
@darkness:
	ldx vram_buffer_pos
	sta vram_buffer,x
	inc vram_buffer_pos
	ldx temp1
	sta palette_buffer,x
	inc temp1
	iny
	cpy #12
	bne @darkness
	lda frame_counter
@waitframe:
	cmp frame_counter
	beq @waitframe
	rts
	
	;.db "LCP"
LoadScreenPalette:
	;used for both loading a normal cave palette when loading a screen, and for re-lighting a cave after crafting a torch
	ldy #0			;position in screen data (Shouldn't be reset until all the screen loading is done)
	;get the palette address
	lda (ptr1),y
	sta mt_ptr1+0
	iny
	lda (ptr1),y
	sta mt_ptr1+1
	iny
	sty temp0			;needed for loadingscreen.asm (Advance past the two bytes in screen data)
	;indirectly unload the palette data from the pointer to the VRAM buffer
	ldx vram_buffer_pos
	lda #$3F
	sta vram_buffer+0,x
	lda #$00
	sta temp1				;used to keep track of position in the palette buffer
	sta vram_buffer+1,x
	tay
	lda #<(Copy12Bytes-1)
	sta vram_buffer+2,x
	lda #>(Copy12Bytes-1)
	sta vram_buffer+3,x
	txa
	clc
	adc #4
	sta vram_buffer_pos
@loop:	
	ldx vram_buffer_pos
	lda (mt_ptr1),y
	sta vram_buffer,x
	inc vram_buffer_pos
	ldx temp1
	sta palette_buffer,x
	inc temp1
	iny
	cpy #12
	bne @loop
	lda frame_counter
@waitframe:				;wait for VBlank to update palette. This is to prevent the PPU registers from potentially getting corrupted during NMI if, say CHR RAM updates are happening during the main frame
	cmp frame_counter
	beq @waitframe
	rts
	
	
FindFreeEntSlot:
	;linearly searches slots 2-15, returning the index of the first empty slot (active = 0)
	;Returns 0 if none are found
	;Return value is in X
	ldx #2
@loop:
	lda ent_active,x
	bne @nope
	rts
@nope:
	inx
	cpx #16
	bne @loop
	ldx #0
	rts
	
	
DeactivateScreenEnts:
	ldx #2
	lda #0
@loop:
	sta ent_active,x
	inx
	cpx #16
	bne @loop
	rts
	
	
FetchStatusRecoveryTime:
	;whenever a status is changed, this routine should be called to figure out, based on the new status, how long it should take to return to normal, ;I don't think we'll need to check here if a status is recoverable, since usually the status change is hard-coded depending on where in the game we are. Besides, 0 can just be loaded anyway
	;Accumulator should be loaded with status
	asl
	tax
	lda StatusRecoveryTimes+0,x
	sta status_recovery_time+0
	lda StatusRecoveryTimes+1,x
	sta status_recovery_time+1
	rts
	
	
	.include "prev_screen_system.asm"
	
	
BREAK:
	;If the game fucks up bad enough, it'll freeze and we'll ge the "Red tint of death"
	;save A, X and Y
	sta $07F0
	stx $07F1
	sty $07F2
	;save PC
	pla
	sta $07F3
	pla
	sta $07F4
	;save SP
	tsx
	stx $07F5
	;save processor status byte
	php
	pla
	sta $07F6
	
	;shut off NMIs so we'll know for sure that the game crashed and it'll hang
	lda $2000
	and #%01111111
	sta $2000
	
	;tint the screen red so the player/me is aware that something bad happened
	lda #%00111110
	sta $2001
@loop:
	jmp @loop			;stay here until the end of time (or until the game is shut off / reset)
	
	
	;various random data that still needs to be organized
	.org $F000
	;As more and more stuff gets added to the fixed bank, it'll probably be better to just get rid of the above .org directive, and have all the code and data just be one thing	
IslandAreasDifficulties:
	;area and difficulty are combined into one byte
	.rept 8
		.db (AREA_SHORE | DIFF_EASY)
	.endr
	.db (AREA_SHORE | DIFF_EASY), (AREA_SHORE | DIFF_EASY), (AREA_JUNGLE | DIFF_EASY), (AREA_JUNGLE | DIFF_EASY), (AREA_SHORE | DIFF_EASY), (AREA_SHORE | DIFF_EASY), (AREA_SHORE | DIFF_EASY), (AREA_SHORE | DIFF_EASY)
	.db (AREA_SHORE | DIFF_EASY), (AREA_SHORE | DIFF_EASY), (AREA_JUNGLE | DIFF_MODERATE), (AREA_JUNGLE | DIFF_MODERATE), (AREA_SHORE | DIFF_EASY), (AREA_SHORE | DIFF_EASY), (AREA_SHORE | DIFF_EASY), (AREA_SHORE | DIFF_EASY)
	.db (AREA_SHORE | DIFF_EASY), (AREA_SHORE | DIFF_EASY), (AREA_JUNGLE | DIFF_MODERATE), (AREA_JUNGLE | DIFF_MODERATE), (AREA_JUNGLE | DIFF_EASY), (AREA_JUNGLE | DIFF_EASY), (AREA_SHORE | DIFF_EASY), (AREA_SHORE | DIFF_EASY)
	.db (AREA_SHORE | DIFF_EASY), (AREA_SHORE | DIFF_EASY), (AREA_JUNGLE | DIFF_MODERATE), (AREA_JUNGLE | DIFF_MODERATE), (AREA_JUNGLE | DIFF_EASY), (AREA_JUNGLE | DIFF_EASY), (AREA_SHORE | DIFF_EASY), (AREA_SHORE | DIFF_EASY)
	.db (AREA_SHORE | DIFF_EASY), (AREA_SHORE | DIFF_EASY), (AREA_JUNGLE | DIFF_EASY), (AREA_JUNGLE | DIFF_EASY), (AREA_JUNGLE | DIFF_EASY), (AREA_JUNGLE | DIFF_EASY), (AREA_SHORE | DIFF_EASY), (AREA_SHORE | DIFF_EASY)
	.db (AREA_SHORE | DIFF_EASY), (AREA_SHORE | DIFF_EASY), (AREA_SHORE | DIFF_EASY), (AREA_SHORE | DIFF_EASY), (AREA_SHORE | DIFF_EASY), (AREA_SHORE | DIFF_EASY), (AREA_SHORE | DIFF_EASY), (AREA_SHORE | DIFF_EASY)
	.rept 8
		.db (AREA_SHORE | DIFF_EASY)
	.endr
	
CaveAreasDifficulties:
	.dw Cave0AreasDifficulties,Cave1AreasDifficulties,Cave2AreasDifficulties,Cave3AreasDifficulties
	.dw Cave4AreasDifficulties,Cave5AreasDifficulties,Cave6AreasDifficulties,Cave7AreasDifficulties
	.dw Cave8AreasDifficulties,Cave9AreasDifficulties
	
Cave0AreasDifficulties:
	.db 0,0,0,(AREA_CAVE | DIFF_EASY)
Cave1AreasDifficulties:
	.db 0,0,0,(AREA_CAVE | DIFF_EASY),(AREA_CAVE | DIFF_EASY),0,0,0
	.db 0,0,0,(AREA_CAVE | DIFF_EASY),(AREA_CAVE | DIFF_EASY),0,0,0
	.db 0,0,0,(AREA_CAVE | DIFF_EASY),(AREA_CAVE | DIFF_EASY),0,0,0
	.db 0,0,0,(AREA_CAVE | DIFF_EASY),(AREA_CAVE | DIFF_EASY),0,0,0
Cave2AreasDifficulties:
Cave3AreasDifficulties:
Cave4AreasDifficulties:
Cave5AreasDifficulties:
Cave6AreasDifficulties:
Cave7AreasDifficulties:
Cave8AreasDifficulties:
Cave9AreasDifficulties:
	.db 0,0,0,(AREA_CAVE | DIFF_EASY)
	
	
PowersOfTwo:
	.db %00000001,%00000010,%00000100,%00001000,%00010000,%00100000,%01000000,%10000000
MultiplesOfThree:
	.db 0,3,6,9,12,15,18,21
Primes:
	.db 1,2,3,5,7,11,13,17
	
	
PrevScreenEntDataAddresses:
	.dw SAVED_ENT_DATA_0, SAVED_ENT_DATA_1, SAVED_ENT_DATA_2, SAVED_ENT_DATA_3
PrevScreenScreenDataAddresses:
	.dw SAVED_SCREEN_DATA_0, SAVED_SCREEN_DATA_1, SAVED_SCREEN_DATA_2, SAVED_SCREEN_DATA_3
	
	
WeaponEnts:
	;sorted by weapon
	;each weapon has an id for its respective ent
	.db ENT_KNIFE,ENT_STICK,ENT_SPEAR,$00,ENT_MACHETE,ENT_BULLET
	
	
WeaponSpawnPositionOffsetsUp:
	.db 3,7, 3,31, 3,39, 3,23, 3,15, 0,2
WeaponSpawnPositionOffsetsDown:
	;only need X positions here
	.db 5, 5, 5, 5, 4, 7
WeaponSpawnPositionOffsetsLeft:
	.db 7,7, 31,7, 39,7, 23,7, 15,7, 2,10	;right spawn positions have the same Y's so we can just read the Y component of these pairs
	
GunSpawnPositionOffsets:
	;The gun is the one real exception, so it needs its own special data.
	;Pairs of coordinates sorted by direction
	.db -7,-24, 1,16, -25,2, 11,2
	
SpriteDigits:
	;Maybe just add #$A0 to the BCD before drawing it as a sprite
	.db $A0,$A1,$A2,$A3,$A4,$A5,$A6,$A7,$A8,$A9
	
	
WeaponItems:
	;map each weapon to its respective item ID
	.db ITEM_KNIFE, ITEM_STICK, ITEM_SPEAR, ITEM_BIGBONE, ITEM_MACHETE, ITEM_GUN
	
ItemEnts:
	;map each item to its respective ent ID
	;It's unlikely that all of these will need to be used, but better safe than sorry
	;sorted by item ID
	.db ENT_KNIFE,ENT_JAR,ENT_MEAT,ENT_FLINT,0,ENT_STICKCOL,0,ENT_SPEAR
	.db 0,ENT_MACHETECOL,ENT_STONE,0,ENT_CLOTH,0,0,0
	
	
	;palettes
	;(have an address table for each unique sprite subpalette)
BG_Palette0:
	;sand, trees, water
	.db $38,$27,$17,$30, $38,$1A,$29,$17, $38,$12,$21,$30
BG_Palette1:
	;sand, rock, water
	.db $38,$27,$17,$30, $38,$00,$10,$30, $38,$12,$21,$30
BG_Palette2:
	;sand, rock, trees
	.db $38,$27,$17,$30, $38,$00,$10,$30, $38,$1A,$29,$17
BG_Palette3:
	;tree trunks, trees/ground, water
	.db $17,$1A,$27,$07, $17,$1A,$29,$17, $17,$12,$21,$30
BG_Palette4:
	;tree trunks, trees/ground, rock
	.db $17,$1A,$27,$07, $17,$1A,$29,$17, $17,$00,$10,$30
BG_Palette5:
	;cave walls, cave ground, water
	.db $0F,$00,$10,$30, $0F,$17,$05,$10, $0F,$12,$21,$30
BG_Palette6:
	;cave walls, cave ground, heiroglyphs
	.db $0F,$00,$10,$30, $0F,$17,$05,$10, $0F,$17,$28,$39
	
	
LogoPalette:
	.db $0F,$0F,$0F,$39, $0F,$0B,$1B,$2C
	

PlayerPalette
	.db $0F,$37,$07
	;.db $07,$37,$29
	
	
PlayerWeaponPalettes:
	.dw KnifePalette, StickPalette, SpearPalette, BigBonePalette, MachetePalette, GunPalette, BulletPalette
	
KnifePalette:
StickPalette:
SpearPalette:
MachetePalette:
BigBonePalette:
StonePalette:			;not a weapon, but it uses the same palette, so we might as well save bytes
	.db $20,$10,$00
GunPalette:
BulletPalette:
	.db $00,$26,$30


MiscSpritePalette:
	;things like hearts/meat, and other miscellaneous things as the name suggests
	.db $06,$16,$30
	
	
EnemySpritePalettes:
	;these indices are somewhat arbitrary, as they are given by events, so the first one is for snakes, the second for bees/beehives, etc
	;Not all of these are for enemies, either, so don't be confused by the admittedly confusing name
	.dw SP_Snake, SP_Bee, SP_Crab, KnifePalette, SP_Cloth, SP_Bat, SP_PoisonSnake

;Enemy / other ent sprite palettes (That aren't player, player's weapon, or powerups/droppings)
SP_Snake:
	.db $0F,$2A,$1B
SP_Bee:
	.db $0F,$28,$17
SP_Crab:
	.db $16,$26,$0F
SP_Bird:
	.db $16,$26,$37
SP_Cloth:
	.db $0C,$1C,$3C
SP_Bat:
	.db $00,$0F,$26
SP_PoisonSnake:
	.db $0F,$24,$13
	
	
;Since the event data and the ent data are in different banks, putting the table here simplifies things and avoids a bunch of back and forth bank switching. This table maps enemies to their terrain (i.e fish -> water, birds -> trees, etc)
EnemyTerrains:
	;sorted by ENT INDEX
	;There are labels for the types of terrain, but it seems unnecessary here. 0 - water, 1 - land, 2 - trees
	;Again, I originally planned for events to just have enemies, so don't let the name confuse you
	.db 0,0,1,0,0,0,2,2,0,0,0,1,1,1,1,1
	.db 1,1,1,1,2,1
TerrainSpawnCoordinates:
	;The addresses of the spawn coordinates for each terrain type
	.dw ent_spawns+0,ent_spawns+16,ent_spawns+32
	

;Eventually move all this stuff to a separate file (itemdata or something), and to a different bank (The same bank where all the message data and code is. Remember to bankswitch)
ItemStrings:
	.dw KnifeString, JarString, MeatString, FlintString, CoconutString, StickString, AloeString, SpearString
	.dw BigBoneString, MacheteString, StoneString, TorchString, ClothString, TourniquetString, GunString, HoneycombString
WeaponStrings:
	;Weapon strings need to be different from their item string counterparts, since there needs to be padding instead of a terminating character
	;only put weapons here. What value the player's weapon is only corresponds to weapons. Converting it to the correct ent index is taken care of elsewhere
	.dw W_KnifeString, W_StickString, W_SpearString, W_BigBoneString, W_MacheteString, W_GunString
;Craftable items in the recipe list should all be drawn as one line. So far, tourniquet is the only item that needs this unique string
RecipeItemStrings:
	;sorted by craftable item ID
	.dw SpearString, TorchString, R_TourniquetString
	
KnifeString:
	;FF - End
	;FE - new line
	.db K,N,I,F,E,$FF
JarString:
	.db J,lA,R,$FF
MeatString:
	.db M,E,lA,T,$FF
FlintString:
	.db F,L,I,N,T,$FF
CoconutString:
	.db C,O,C,O,$FE
	.db N,U,T,$FF
StickString:
	.db S,T,I,C,K,$FF
AloeString:
	.db lA,L,O,E,$FF
SpearString:
	.db S,P,E,lA,R,$FF
BigBoneString:
	.db B,I,G,$FE
	.db B,O,N,E,$FF
MacheteString:
	.db M,lA,C,H,$2D,$FE
	.db E,T,E,$FF
StoneString:
	.db S,T,O,N,E,$FF
TorchString:
	.db T,O,R,C,H,$FF
ClothString:
	.db C,L,O,T,H,$FF
TourniquetString:
	.db T,O,U,R,N,$2D,$FE
	.db I,Q,U,E,T,$FF
GunString:
	.db G,U,N,$FF
HoneycombString:
	.db H,O,N,E,lY,$FE
	.db C,O,M,B,$FF

	
W_KnifeString:
	.db SPA,K,N,I,F,E,SPA,SPA
W_StickString:
	.db SPA,S,T,I,C,K,SPA,SPA
W_SpearString:
	.db SPA,S,P,E,lA,R,SPA,SPA
W_BigBoneString:
	.db B,I,G,SPA,B,O,N,E
W_MacheteString:
	.db M,lA,C,H,E,T,E,SPA
W_GunString:
	.db SPA,SPA,G,U,N,SPA,SPA,SPA
	
	
R_TourniquetString:
	.db T,O,U,R,N,I,Q,U,E,T,$FF

	
ItemHasCount:
	;Table of flags, sorted by item id (the 0th item is the 0th bit of the 0th byte).
	;Whether or not each item has a count
	.db %11111100,%10111100
	
	
StatusStrings:
	;Make sure each of these are at most 8 characters/tiles/bytes
	.dw StatusStringNormal, StatusStringPoisoned, StatusStringInfected, StatusStringSick, StatusStringCut
	
StatusStringNormal:
	;If the string is less than 8 characters, fill it with spaces
	.db SPA,N,O,R,M,lA,L,SPA,SPA
StatusStringPoisoned:
	.db P,O,I,S,O,N,E,D
StatusStringInfected:
	.db I,N,F,E,C,T,E,D
StatusStringSick:
	.db SPA,SPA,S,I,C,K,SPA,SPA
StatusStringCut:
	.db SPA,SPA,C,U,T,SPA,SPA,SPA
	
	
StatusRecoverable:
	;for each status, there's a bit saying if it can return to normal
	;sorted by statuses
	.db %00011010
StatusRecoveryTimes:
	;how many frames it takes for a status to return to normal
	.dw 0, 9000, 0, 7200, 5400
	
	
JarContentsStringsIndices:
	;these values, sorted by the contents of the jar, correspond to where in the messages address table their respective strings are located
	.db MSG_EMPTY,MSG_WATER

	
StatusBoard:
	;FF - End
	;FE - new line
	;FD - health
	;FC - hunger
	;FB - thirst
	;FA - weapon
	;F9 - day
	;F8 - Status
	;F7 - BCD ten thousands
	;F6 - BCD thousands
	;F5 - BCD hundreds
	;F4 - BCD tens
	;F3 - BCD ones
	;F2 - status string char 0
	;F1 - status string char 1
	;F0 - status string char 2
	;EF - status string char 3
	;EE - status string char 4
	;ED - status string char 5
	;EC - status string char 6
	;EB - status string char 7
	;EA - weapon string char 0
	;E9 - weapon string char 1
	;E8 - weapon string char 2
	;E7 - weapon string char 3
	;E6 - weapon string char 4
	;E5 - weapon string char 5
	;E4 - weapon string char 6
	;E3 - weapon string char 7
	.db H,E,lA,L,T,H,$2F, $FD,$F5,$F4,$F3, $30,2,5,5, SPA, S,T,lA,T,U,S,$2F, $F8,$F2,$F1,$F0,$EF,$EE,$ED,$EC,$EB, $FE
	.db H,U,N,G,E,R,$2F, $FC,$F5,$F4,$F3, $30,2,5,5, SPA, T,H,I,R,S,T,$2F, $FB,$F5,$F4,$F3, $30,2,5,5, SPA, $FE
	.db W,E,lA,P,O,N,$2F, $FA,$EA,$E9,$E8,$E7,$E6,$E5,$E4,$E3, SPA, D,lA,lY, SPA, $F9,$F7,$F6,$F5,$F4,$F3, $FF
	
	
;Old data from the original temporary title screen, but kept here in case it needs to be used for some reason
Title:
	.db I, SPA, W,lA,S, SPA, S,H,I,P,W,R,E,C,K,E,D
PressStart:
	.db P,R,E,S,S, SPA, S,T,lA,R,T, SPA, T,O, SPA, B,E,G,I,N
BonaFideGames:
	.db $28,2,0,1,8, SPA, B,O,N,lA, SPA, F,I,D,E, SPA, G,lA,M,E,S
AllRightsReserved:
	.db lA,L,L, SPA, R,I,G,H,T,S, SPA, R,E,S,E,R,V,E,D
GameOver:
	.db G,lA,M,E, SPA,SPA, O,V,E,R
	
	
FileFrame:
	;what to draw for each file in the file select state
	;based off the current file being drawn
	;230 bytes
	;FF - new line
	.db $32,$36,$36,$36,$36,$36,$36,$36,$36,$33,$FF
	.db $37,SPA,F,I,L,E,SPA,SPA,SPA,$37,$FF
	.db $37,$2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D,$37,$FF
	.db $37,SPA,H,E,lA,L,T,H,SPA,$37,$FF
	.db $37,SPA,SPA,SPA,SPA,SPA,SPA,SPA,SPA,$37,$FF
	.db $37,$2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D,$37,$FF
	.db $37,SPA,H,U,N,G,E,R,SPA,$37,$FF
	.db $37,SPA,SPA,SPA,SPA,SPA,SPA,SPA,SPA,$37,$FF
	.db $37,$2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D,$37,$FF
	.db $37,SPA,T,H,I,R,S,T,SPA,$37,$FF
	.db $37,SPA,SPA,SPA,SPA,SPA,SPA,SPA,SPA,$37,$FF
	.db $37,$2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D,$37,$FF
	.db $37,SPA,S,T,lA,T,U,S,SPA,$37,$FF
	.db $37,SPA,SPA,SPA,SPA,SPA,SPA,SPA,SPA,$37,$FF
	.db $37,$2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D,$37,$FF
	.db $37,SPA,W,E,lA,P,O,N,SPA,$37,$FF
	.db $37,SPA,SPA,SPA,SPA,SPA,SPA,SPA,SPA,$37,$FF
	.db $37,$2D,$2D,$2D,$2D,$2D,$2D,$2D,$2D,$37,$FF
	.db $37,SPA,SPA,D,lA,lY,SPA,SPA,SPA,$37,$FF
	.db $37,SPA,SPA,SPA,SPA,SPA,SPA,SPA,SPA,$37,$FF
	.db $34,$36,$36,$36,$36,$36,$36,$36,$36,$35
	
	
EnemyItemDrops:
	;what an enemy should randomly drop after being killed
	;0 = nothing
	.db 0,ENT_HEART,0,0,ENT_MEAT,0,ENT_HEART,ENT_MEAT
	
	
;addresses for the animation frames of all animated CHR tiles	
Animated_CHR_Tiles:
	.dw Animated_CHR_Waves
;how many frames each CHR animation is
Animated_CHR_FrameCount:
	.db 4
;addresses of where in the CHR RAM to store the specific frame/tile
Animated_CHR_Tiles_Addresses:
	.dw $1400
	
	;(have a table in the fixed bank of which bank to use for each animated tile)
	
	
;which song to play depending on the game area
GameAreaSongs:
	.db SONG_SHORE,SONG_JUNGLE,0,0,SONG_CAVES
	
WeaponSoundEffects:
	;sorted by weapon
	.db SFX_STAB,SFX_STAB,SFX_THROW,SFX_STAB,SFX_STAB,SFX_GUNSHOT
	
	
	;DMC samples (Move this around if space after $F000 gets cramped)
SampleAddresses:
	.db ((Sample1 - $C000) >> 6), ((Sample2 - $C000) >> 6), ((Sample3 - $C000) >> 6)
SampleLengths:
	.db $5A,$0D,$1A
	
Sample1:
	.incbin "music/sfx/gunshot.dmc"
Sample2:
	.incbin "music/sfx/empty_clip.dmc"
Sample3:
	.incbin "music/sfx/snare_short.dmc"
	
	
	;At the very end of the ROM, we need to specify "vectors" - where the game should start at, and where interrupts happen
	.org $FFFA
	.dw NMI
	.dw RESET
	.dw BREAK