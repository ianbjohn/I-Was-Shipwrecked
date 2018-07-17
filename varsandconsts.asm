	;variables
	.enum $0000
	nmi_enabled			.dsb 1		;Whether or not graphics updates are allowed to happen
	frame_counter		.dsb 1
	clock				.dsb 3		;used to determine when to increment day (byte 0 - frame counter to determine seconds, bytes 1 and 2 - keeping track of seconds)
	soft_2001			.dsb 1		;software PPU (The graphics chip in the nes) registers
	soft_2006			.dsb 2		;little-endian, used mainly in the file-select state
	deplete_health_timer	.dsb 1
	deplete_hunger_timer	.dsb 1
	deplete_thirst_timer	.dsb 1
	random				.dsb 1		;frame counter and buttons added together
	buttons				.dsb 1		;what buttons on the controller are currently being pressed
	buttons_old			.dsb 1
	buttons_pressed		.dsb 1
	last_frame_buttons	.dsb 1		;these two variables are used to protect controller reads from DPCM conflicts
	first_read_buttons	.dsb 1
	game_state			.dsb 1		;title, intro, play, paused, game over, fading in, fading out, drawing message box, writing message, waiting for message box response, erasing message box
	game_state_old		.dsb 1
	nmi_bankswitch		.dsb 1		;if an NMI bankswitch occurred during bankswitching in the main thread. In which case, some extra logic is needed
	ent_index			.dsb 1		;which ent is currently being processed
	num_active_ents		.dsb 1		;make sure this is set to 1 (player ent should always be active in the play state) when loading a new screen, before any other ents are loaded
	num_active_enemies	.dsb 1		;can only save when @ 0
	;bank switching
	prg_bank			.dsb 1		;which bank of program ROM we're currently working with
	;chr RAM and animation
	chr_anim_frame		.dsb 1		;Used for tile animation
	chr_anim_timer		.dsb 1
	;sprite cycling
	oam_index			.dsb 1		;Only 8 sprites can be displayed on a scanline, so this helps cycle the order they're drawn to make them flicker
	;numspritesactive	.dsb 1		;Reset at start of frame, INCd whenever a sprite is drawn. Once everything has been drawn, everything else is cleared
	howmuchoamtodraw	.dsb 1		;when drawing a metasprite, how many sprites it has * 4
	;BCD (Binary-coded decimal)
	bcd_value			.dsb 2		;value that will get turned into BCD (8 or 16 bit)
	bcd_tenthousands	.dsb 1
	bcd_thousands		.dsb 1
	bcd_hundreds		.dsb 1
	bcd_tens			.dsb 1
	bcd_ones			.dsb 1
	;pointers
	jump_ptr			.dsb 2		;Used for indirect jumping
	message_ptr			.dsb 2
	ent_ptr1			.dsb 2
	ent_ptr2			.dsb 2
	mt_ptr1				.dsb 2		;Used for metatiles
	mt_ptr2				.dsb 2
	ptr1				.dsb 2		;general purpose pointer
	attribs_ptr			.dsb 2
	se_ptr				.dsb 2		;sound engine pointer (Since ptr1 is used extensively by the rest of the game during the frame, we need a seperate pointer in case everything can't get done before vblank [otherwise ptr1 could get clobbered by the sound engine during NMI])
	event_ptr			.dsb 2
	door_ptr			.dsb 2
	;message box stuff
	mbox_screen_pos		.dsb 1
	mbox_pos			.dsb 1
	mbox_responses		.dsb 1		;0 - no responses (Only happens if a message is too big for the box and so gets split up into 2 messages)
	message				.dsb 1		;index
	mbox_drawingbcdorstring	.dsb 1	;whether or not a string (Status or weapon) or a BCD number (health, hunger, thirst) is being drawn to the status board or somewhere else
	;VRAM stuff
	sp_temp				.dsb 1		;stack pointer is saved here when doing VRAM updates and then restored afterwords
	vram_buffer_pos		.dsb 1
	vram_update			.dsb 1
	;temp vars						(***These should be treated as having a "local" scope, and only used in one subroutine at a time)
	temp0				.dsb 1
	temp1				.dsb 1
	temp2				.dsb 1
	temp3				.dsb 1
	temp4				.dsb 1
	;player-specific variables
	health_old			.dsb 1
	hunger				.dsb 1
	hunger_old			.dsb 1
	thirst				.dsb 1
	thirst_old			.dsb 1
	status				.dsb 1		;0 - normal
	status_old			.dsb 1
	weapon				.dsb 1		;0 - knife
	weapon_old			.dsb 1
	day					.dsb 2
	day_old				.dsb 1		;only need to check if the low byte is different each time
	level				.dsb 1
	level_old			.dsb 1
	exp					.dsb 1
	exp_old				.dsb 1
	rounds				.dsb 1
	player_still_alive	.dsb 1		;if this is 0, enemies shouldn't be able to attack the player (differnet from ent_active+0 because the player still needs to be animated dying, but his code shouldn't be run)
	;screen stuff
	island_part			.dsb 1		;0 - on island, 1 - in a cave
	screen				.dsb 1
	area				.dsb 1
	area_old			.dsb 1
	difficulty			.dsb 1
	screen_flags		.dsb 1		;water on screen, (any other 1/0 things about the flag can go here)
	in_cave				.dsb 1
	in_cave_new			.dsb 1
	cave_level			.dsb 1		;what level / floor of the cave the player's in (irrelevant if in_cave is 0)
	;metatile and RLE compression stuff
	metatile_buffer		.dsb 32
	attrib_buffer		.dsb 8
	metatile_bank		.dsb 1
	metatile_repeat		.dsb 1	;if > 0 then the current metatile is being repeated; otherwise continue to read data
	;global sound engine stuff
	sound_enabled		.dsb 1
	sound_temp0			.dsb 1
	sound_temp1			.dsb 1
	sound_temp2			.dsb 1
	soft_apu_ports		.dsb 16		;for buffering to the real hardware registers
	sound_sq1_old		.dsb 1		;prevent crackling in the square channels by avoiding redundant writes
	sound_sq2_old		.dsb 1
	;master_volume		.dsb 1		;Used to fade the music out when changing areas
	.ende
	.enum $0101
	;VRAM buffer
	vram_buffer			.dsb 64
	.ende
	.enum $0300
	;sound engine
	stream_curr_sound	.dsb NUM_STREAMS		;song/sfx currently playing
	stream_channel		.dsb NUM_STREAMS		;which channel it's playing on
	stream_status		.dsb NUM_STREAMS		;enabled/disabled, resting / not resting
	stream_vol_duty			.dsb NUM_STREAMS
	stream_note_lo		.dsb NUM_STREAMS
	stream_note_hi		.dsb NUM_STREAMS
	stream_ptr_lo		.dsb NUM_STREAMS		;pointer to stream data
	stream_ptr_hi		.dsb NUM_STREAMS
	stream_tempo		.dsb NUM_STREAMS		;what to add to -v each frame
	stream_ticker_total	.dsb NUM_STREAMS
	stream_note_length_counter	.dsb NUM_STREAMS
	stream_note_length	.dsb NUM_STREAMS
	stream_ve			.dsb NUM_STREAMS
	stream_ve_index		.dsb NUM_STREAMS
	stream_vib			.dsb NUM_STREAMS		;whether or not vibrato is enabled
	stream_vib_index	.dsb NUM_STREAMS		;what position in a vibrato envelope we're in
	stream_porta		.dsb NUM_STREAMS		;whether or not portamento is enabled
	stream_porta_dest	.dsb NUM_STREAMS		;if we're doing sliding/portamento, we need a destination note to slide to, and each frame, we'll subtract a certain amount from the note period, until it's either higher or lower than the destination note's period (depending on stream_porta_type)
	stream_porta_type	.dsb NUM_STREAMS		;0 - destination note is lower than source note, 1 - higher than source note
	stream_porta_speed	.dsb NUM_STREAMS		;how much to subtract from / add to the note each tick
	stream_loop0		.dsb NUM_STREAMS
	stream_loop1		.dsb NUM_STREAMS
	;(other stuff)
	.ende
	.enum $0400
	;entity system
	ent_active			.dsb MAX_ENTS
	ent_type			.dsb MAX_ENTS	;player, enemy, powerup, etc
	ent_id				.dsb MAX_ENTS
	ent_state			.dsb MAX_ENTS
	ent_health			.dsb MAX_ENTS
	ent_x				.dsb MAX_ENTS
	ent_xsp				.dsb MAX_ENTS	;subpixel
	ent_y				.dsb MAX_ENTS
	ent_ysp				.dsb MAX_ENTS
	ent_hb_x			.dsb MAX_ENTS	;hitbox
	ent_hb_xsp			.dsb MAX_ENTS	;might not be necessary if we can just add width
	ent_hb_y			.dsb MAX_ENTS
	ent_hb_ysp			.dsb MAX_ENTS	;^
	ent_xvel			.dsb MAX_ENTS
	ent_xvel_sp			.dsb MAX_ENTS
	ent_yvel			.dsb MAX_ENTS
	ent_yvel_sp			.dsb MAX_ENTS
	ent_xacc			.dsb MAX_ENTS
	ent_xacc_sp			.dsb MAX_ENTS
	ent_yacc			.dsb MAX_ENTS
	ent_yacc_sp			.dsb MAX_ENTS
	ent_width			.dsb MAX_ENTS
	ent_height			.dsb MAX_ENTS
	ent_dir				.dsb MAX_ENTS	;up, down, left, right
	ent_anim_frame		.dsb MAX_ENTS
	ent_anim_timer		.dsb MAX_ENTS
	ent_anim_length		.dsb MAX_ENTS
	ent_anim_frames		.dsb MAX_ENTS
	ent_phi_timer		.dsb MAX_ENTS	;if at 0, ent is not in post-hit invincibility
	ent_phi_time		.dsb MAX_ENTS
	ent_timer1			.dsb MAX_ENTS	;Used for various different things depending on the ent
	ent_time1			.dsb MAX_ENTS
	ent_timer2			.dsb MAX_ENTS	;Used for various different things depending on the ent
	ent_time2			.dsb MAX_ENTS
	ent_misc1			.dsb MAX_ENTS
	ent_misc2			.dsb MAX_ENTS
	ent_misc3			.dsb MAX_ENTS
	;Make sure less than $0300 bytes (48 variables, assuming the # of ents is kept at 16) are utilized by the ent system, so nothing spills into page 7.
	;Once we're sure there's absolutely nothing else that the ent system needs, and if there's still room, and it's necessary, use whatever remaining RAM there is left for whatever I guess
	;Or maybe just use WRAM if possible, that may be more organized
	.ende
	.enum $0700
	;Local variables or less general variables that aren't used every frame
	player_weapon_active_timer		.dsb 1				;if later weapons are added that fly across the screen rather than being stabbed with, don't use this variable
	message_response	.dsb 1
	in_inventory_state	.dsb 1		;Used by the messagebox system for things like - Draw ents only if in the play state (and not the inventory state), which state to return to, etc
	inventory_page		.dsb 1		;what page of the inventory screen we're currently on (16 items per page)
	inventory_pages		.dsb 1
	inventory_screen_items	.dsb 16	;keep track of what items are currently on the inventory screen. **IMPORTANT** -> 0 means that the cell is empty, so items here are indexed 1-based. Be sure to account for this and avoid off-by-one errors
	items_on_screen		.dsb 1		;stop processing and drawing items once this gets to 16
	;inventory_screen_pos	.dsb 1	;where on the screen information about items is currently being drawn
	file				.dsb 1		;current file being played (0-2)
	fadeout_state		.dsb 1		;0 - regular palette, 1 - palette-$10, 2 - palette-$20, 3 - palette-$30, 4 - all black, 5 - go to loading screen state
	fadeout_timer		.dsb 1
	inventory_cursor_x	.dsb 1		;0-15			;maybe convert these to nibbles to save a byte of RAM but it doesn't seem like a huge deal right now
	inventory_cursor_y	.dsb 1		;0-15
	inventory_status	.dsb 1		;normal (selecting an item), at "save", at "page", selecting item choice
	fileselect_status	.dsb 1
	fileselect_cursorpos	.dsb 1	;which position the horizontal cursor in the file select state is
	inventory_choices	.dsb 1		;how many choices in the inventory screen you can make with the given item
	inventory_choice	.dsb 1		;the ID of whatever selected choice for whatever selected item
	palette_buffer		.dsb 32
	screen_leave_dir	.dsb 1		;0 - up, 1 - down, 2 - left, 3 - right
	;arrays and other stuff for the "previous screen ent data reloading system" (The ent data is kept track of for the last 4 screens the player's visited)
	enemy_palette_index	.dsb 1
	prev_enemy_palette_index	.dsb 1
	previous_screen		.dsb 1
	prev_screendata_id	.dsb 1
	prev_screen_ids		.dsb 4
	prev_screen_entdata_ptr_ids	.dsb 4
	prev_screen_enemy_palettes	.dsb 4
	prev_screen_screendata_ptr_ids	.dsb 4
	num_previous_screens	.dsb 1	;Number of unique screens that have been visited so far in this particular playing session (stops at 4)
	left_first_screen	.dsb 1		;initialized to 0, set to 1 only read from once player leaves the first screen
	pause_jingle_timer	.dsb 1
	paused_stream_statuses	.dsb 5	;save which of the 4 BGM streams were enabled (These will almost always, but not always, be all 1)
	near_death_alert_timer	.dsb 1	;if health, hunger or thirst are below 30, alert the player every 256 frames / ~4.25 seconds
	player_near_death	.dsb 1
	beehive_ent_slot	.dsb 1
	rounds_hud_x		.dsb 1
	rounds_hud_y		.dsb 1
	rounds_hud_timer	.dsb 1
	screen_special		.dsb 1		;set to 1 if the screen has special events
	special_event		.dsb 1		;special event index
	screen_terrain		.dsb 1		;first 3 bits say what types of terrain this screen has (water, land, trees)
	ent_spawns			.dsb 48		;the 8 pairs of spawn coordinates for each type of terrain in each screen
	spawn_prng_index	.dsb 1		;used to select which prime number to choose from to help randomly select ent spawn coordinates
	door_count			.dsb 1		;how many doors are on the current screen
	door_transition		.dsb 1		;bypass the normal player placement by LoadScreen if there was a door transition
	door_tr_x			.dsb 1		;where to put the player after a door transition
	door_tr_y			.dsb 1
	loading_sound		.dsb 1		;prevent corruption from NMI sound code when a sound is being loaded
	player_dir_old		.dsb 1
	torch_time			.dsb 2		;# of frames left until current torch goes out
	craft_queue			.dsb 3		;IDs of what items are currently in the crafting queue. A max of only 3 items is needed to make a new item.
									;1-based, so 0 means no item. Be sure to remember this and subtract 1
	craft_queue_status	.dsb 1		;0 - queue is empty, 1 - it isnt
	discovered_recipes	.dsb 2		;Think more about how to do this. These can be encoded as bits. I guess for each "craftable" item, keep track of whether or not the recipe to make it has been discovered. Store the string for its recipe in the messages bank? (Maybe in the encounters bank since I'm thinking thats where extra miscellaneous stuff can go)
	status_recovery_time	.dsb 2	;how long it takes for whatever status the player has to return to normal
									;depends on status
	.ende
	;WRAM (8kb of extra RAM)
	.enum $6000
	;the map is saved in WRAM so changes can happen
	metatile_map		.dsb 192		;16 * 12 metatiles
	attribute_map		.dsb 56			;attributes for all of the screen except for the status board, which always stays the same
	;items that have been obtained
	;At the start of a new game, these are all set to 0. When obtained, they're set to 1, and left that way for the rest of the game.
	;Items should only show up in inventory screen after they've been obtained
	;Here, whether or not each item has been obtained is represented as a flag. 8 flags packed into one byte.
	;jar, meat, wood, flint, green coconuts, brown coconuts, ...
	;so the 0th item is the 0th bit in the 0th byte, 8th item is the 0th bit in the 1st byte, etc.
	obtained_items		.dsb (NUM_TOTAL_ITEMS / 8) + 1
	num_obtained_items	.dsb 1				;how many items have been obtained so far (Divide by 16 to get how many pages long the inventory screen is)
	;unique variables related to different items
	jar_contents		.dsb 1		;empty, water
	;stuff for inventory system
	item_count			.dsb (NUM_TOTAL_ITEMS / 2) + 1		;You can only have a maximum of 15 of each item, so we can pack 2 items to a byte
	;(*** Make sure this doesn't spill into the next page. If it does, move the save file variables to the next page ***)
	.ende
	.enum $6200
	;Save file variables (And a few other SRAM variables most of which are related to the file system)
	;main variables
	file_data_screen	.dsb 3		;a variable for each save file
	file_data_x			.dsb 3
	file_data_y			.dsb 3
	file_data_health	.dsb 3
	file_data_hunger	.dsb 3
	file_data_thirst	.dsb 3
	file_data_status	.dsb 3
	file_data_weapon	.dsb 3
	file_data_day		.dsb 6
	file_data_rounds	.dsb 3
	;less common variables
	file_data_jar_contents	.dsb 3
	file_data_num_obtained_items	.dsb 3
	file_data_in_cave	.dsb 3
	file_data_cave_level	.dsb 3
	file_data_recovery_time	.dsb 6
	;arrays
	file_data_obtained_items	.dsb 3 * ((NUM_TOTAL_ITEMS / 8) + 1)	;stored as such - first bytes of all 3 files, second bytes of all 3 files, etc.
	file_data_item_count	.dsb 3 * ((NUM_TOTAL_ITEMS / 2) + 1)		;^
	;other SRAM things
	file_contents		.dsb 1		;last 3 bits tell which of the three files has data (0 - no data, 1 - data)
	.ende
	;$6300-$67FF is for the data for the previous screen system
	
	
	;constants
	PLAYERHEIGHT		= 24
	PLAYERWIDTH			= 10
	
	;copies of ent data saved from screens previously visited by the player
	;fortunately, not as much data needs to be saved
	SAVED_ENT_DATA_0 = $6300
	;x
	;y
	;id
	;active
	;organized like x,y,i,a, x,y,i,a, x,y,i,a, ... instead of x,x,x,x,x,x,x,x, y,y,y,y,y,y,y,y, i,i,i,i, ...
	SAVED_ENT_DATA_1 = $6300 + (1 * 4 * 14)		;dont save the player and player's weapon
	SAVED_ENT_DATA_2 = $6300 + (2 * 4 * 14)
	SAVED_ENT_DATA_3 = $6300 + (3 * 4 * 14)
	
	SAVED_SCREEN_DATA_0 = $6400		;metatiles and attributes for the first saved screen
	SAVED_SCREEN_DATA_1 = $6500
	SAVED_SCREEN_DATA_2 = $6600
	SAVED_SCREEN_DATA_3 = $6700
	
	NUM_TOTAL_ITEMS		= 15
	MAX_ENTS			= 16
	
	;controller buttons
	BUTTONS_A			= %10000000
	BUTTONS_B			= %01000000
	BUTTONS_SELECT		= %00100000
	BUTTONS_START		= %00010000
	BUTTONS_UP			= %00001000
	BUTTONS_DOWN		= %00000100
	BUTTONS_LEFT		= %00000010
	BUTTONS_RIGHT		= %00000001
	
	;directions
	UP					= 0
	DOWN				= 1
	LEFT				= 2
	RIGHT 				= 3
	
	;game states
	STATE_TITLE			= 0
	STATE_INTRO			= 1
	STATE_PLAY			= 2
	STATE_PAUSED		= 3
	STATE_GAMEOVER		= 4
	STATE_FADEIN		= 5
	STATE_FADEOUT		= 6
	STATE_DRAWINGMBOX	= 7
	STATE_WRITINGMSG	= 8
	STATE_MBOXRESPONSE	= 9
	STATE_ERASINGMBOX	= 10
	STATE_INVENTORY		= 11
	STATE_LOADINGSCREEN	= 12
	STATE_FILESELECT	= 13
	
	;prg banks
	BANK_ENTS			= 0
	BANK_METATILES		= 1
	BANK_MESSAGES		= 2
	BANK_GRAPHICS		= 3
	BANK_MUSIC			= 4
	BANK_EVENTS			= 5
	BANK_OTHER			= 6
	
	;game areas
	AREA_SHORE			= 0
	AREA_JUNGLE			= 1
	AREA_CLEARING		= 2
	AREA_MOUNTAINS		= 3
	AREA_CAVE			= 4
	
	;terrains
	TERR_WATER			= 0
	TERR_LAND			= 1
	TERR_TREES			= 2 ;or anything "above-ground" really
	
	;screen difficulties
	DIFF_EASY			= (0 << 4)		;These are treated as high nibbles and are OR'd with areas in a big lookup table so area and difficulty can be quickly and compactly found
	DIFF_MODERATE		= (1 << 4)
	DIFF_HARD			= (2 << 4)
	
	;message IDs
	MSG_FRESHWATER			= 0
	MSG_DRANKUNBOILEDWATER	= 1
	MSG_BADFRESHWATER		= 2
	MSG_NOJAR				= 3
	MSG_JARNOTEMPTY			= 4
	MSG_JARFILLUBFRESHWATER	= 5
	MSG_CANTCROSS			= 6
	MSG_JARFOUND			= 7
	MSG_MEATFOUND			= 8
	MSG_SALTWATER			= 9
	MSG_OTHERSIDEOBSTRCTD	= $0A
	MSG_KNIFEEQUIPPED		= $0B
	MSG_ALREADYEQUIPPED		= $0C
	MSG_JAREMPTIED			= $0D
	MSG_JARALREADYEMPTY		= $0E
	MSG_EMPTY				= $0F
	MSG_WATER				= $10
	MSG_MADEBOILFIRE		= $11
	MSG_CANTMAKEFIRE		= $12
	MSG_DRANKCLEANWATER		= $13
	MSG_JARISEMPTY			= $14
	MSG_ATERAWMEAT			= $15
	MSG_MADECOOKFIRE		= $16
	MSG_ATECOOKEDMEAT		= $17
	MSG_NOMEAT				= $18
	MSG_BADMEAT				= $19
	MSG_GUNEQUIPPED			= $1A
	MSG_CANBECUT			= $1B
	MSG_MACHETEFOUND		= $1C
	MSG_MACHETEEQUIPPED		= $1D
	MSG_STICKFOUND			= $1E
	MSG_STICKEQUIPPED		= $1F
	MSG_NOSTICKS			= $20
	MSG_STONEFOUND			= $21
	MSG_FLINTFOUND			= $22
	MSG_CANTMAKESPEAR		= $23
	MSG_CRAFTEDSPEAR		= $24
	MSG_CANTMAKETORCH		= $25
	MSG_CRAFTEDTORCH		= $26
	MSG_SPEAREQUIPPED		= $27
	MSG_OUTOFWEAPON			= $28
	MSG_CAVEPITCHBLACK		= $29
	MSG_CUT					= $2A
	MSG_INFECTED			= $2B
	MSG_CLOTHFOUND			= $2C
	MSG_NOCLOTH				= $2D
	MSG_NOTCUT				= $2E
	MSG_MADEBANDAGE			= $2F
	MSG_RECOVERED			= $30
	MSG_POISONED			= $31
	
	EXPLOSION_TIME		= 12			;how many frames an explosion should last
	
	;player status IDs
	STATUS_NORMAL		= 0
	STATUS_POISONED		= 1
	STATUS_INFECTED		= 2
	STATUS_SICK			= 3
	STATUS_CUT			= 4
	
	;item IDs
	ITEM_KNIFE			= 0
	ITEM_JAR			= 1
	ITEM_MEAT			= 2
	ITEM_FLINT			= 3
	ITEM_COCONUT		= 4
	ITEM_STICK			= 5
	ITEM_ALOE			= 6
	ITEM_SPEAR			= 7
	ITEM_BIGBONE		= 8
	ITEM_MACHETE		= 9
	ITEM_STONE			= 10
	ITEM_TORCH			= 11
	ITEM_CLOTH			= 12
	ITEM_TOURNIQUET		= 13
	ITEM_GUN			= 14
	
	;weapon IDs
	WEAPON_KNIFE		= 0
	WEAPON_STICK		= 1
	WEAPON_SPEAR		= 2
	WEAPON_BIGBONE		= 3
	WEAPON_MACHETE		= 4
	WEAPON_BULLET		= 5
	
	;ent IDs
	ENT_PLAYER			= 0
	ENT_KNIFE			= 1
	ENT_SNAKE			= 2
	ENT_JAR				= 3
	ENT_HEART			= 4
	ENT_MEAT			= 5
	ENT_BEEHIVE			= 6
	ENT_BEE				= 7
	ENT_GUN				= 8
	ENT_BULLET			= 9
	ENT_DOOR			= 10
	ENT_CRAB			= 11
	ENT_MACHETECOL		= 12	;collectable machete
	ENT_MACHETE			= 13
	ENT_STICKCOL		= 14
	ENT_STICK			= 15
	ENT_STONE			= 16
	ENT_FLINT			= 17
	ENT_SPEAR			= 18
	ENT_CLOTH			= 19
	ENT_BAT				= 20
	ENT_POISONSNAKE		= 21
	
	;ent tyes
	ENT_TYPE_PLAYER		= 0
	ENT_TYPE_WEAPON		= 1		;this refers to the player's weapons
	ENT_TYPE_POWERUP	= 2		;things the player can collect / things that are dropped by an enemy after its killed
	ENT_TYPE_ENEMY		= 3		;basically anything that can hurt the player
	ENT_TYPE_MISC		= 4		;Miscellaneous. These ents don't really do anything. Can be used for particles and other things that don't interact with other ents
	ENT_TYPE_DOOR		= 5
	
	
	;event sprite palette IDs
	SP_SNAKE			= 0
	SP_BEE				= 1
	SP_CRAB				= 2
	SP_STONE			= 3
	SP_FLINT			= 3
	SP_CLOTH			= 4
	SP_BAT				= 5
	SP_POISONSNAKE		= 6
	
	;Background collision type IDs
	BGCOL_NORMAL		= 0
	BGCOL_SOLID			= 1
	BGCOL_SALTWATER		= 2
	BGCOL_FRESHWATER	= 3
	BGCOL_CAVEENTRANCE	= 4
	
	;IDs of what can be in jar
	JAR_CONTENTS_EMPTY	= 0
	JAR_CONTENTS_UNBOILEDWATER	= 1
	JAR_CONTENTS_BOILEDWATER	= 2
	JAR_CONTENTS_MILK	= 3
	
	;Where on the screen messagebox text should start
	MBOX_START			= $2041
	
	DAY_LENGTH_REAL_TIME	= 0120		;currently 2 minutes real-time is one day in the game (2 * 60 = 120 seconds)
	
	;labels for letters and a few other characters
	lA	= 10
	B	= 11
	C	= 12
	D	= 13
	E	= 14
	F	= 15
	G	= 16
	H	= 17
	I	= 18
	J	= 19
	K	= 20
	L	= 21
	M	= 22
	N	= 23
	O	= 24
	P	= 25
	Q	= 26
	R	= 27
	S	= 28
	T	= 29
	U	= 30
	V	= 31
	W	= 32
	lX	= 33
	lY	= 34
	Z	= 35
	SPA	= 36
	
	;Sound engine stuff
	MUSIC_SQ1		= 0
	MUSIC_SQ2		= 1
	MUSIC_TRI		= 2
	MUSIC_NOI		= 3
	MUSIC_DMC		= 4
	SFX_1			= 5
	SFX_2			= 6
	NUM_STREAMS		= 7
	
	SQUARE_1		= 0
	SQUARE_2		= 1
	TRIANGLE		= 2
	NOISE			= 3
	DMC				= 4
	
	;song/sfx indices
	SONG_SHORE			= 0
	SFX_HEARTCOLLECTED	= 1
	SFX_PAUSE			= 2
	SFX_STAB			= 3
	SFX_SAVE			= 4
	SFX_FILESELECT		= 5
	SFX_SELECTION		= 6
	SFX_PLAYERHURT		= 7
	SFX_NEWITEMACQUISITION	= 8
	SFX_PLAYERNEARDEATH	= 9
	SILENCE				= 10
	SFX_ENEMYHURT		= 11
	SFX_GUNSHOT			= 12
	SFX_EMPTYCLIP		= 13
	SONG_TITLE			= 14
	SONG_JUNGLE			= 15
	SONG_CAVES			= 16
	SFX_THROW			= 17
	SFX_RECOVERY		= 18
	SFX_OHSHIT			= 19
	
	;note lengths
	THIRTYSECOND		= $80
	SIXTEENTH			= $81
	EIGHTH				= $82
	QUARTER				= $83
	HALF				= $84
	WHOLE				= $85
	DOTTED_SIXTEENTH	= $86
	DOTTED_EIGHTH		= $87
	DOTTED_QUARTER		= $88
	DOTTED_HALF			= $89
	DOTTED_WHOLE		= $8A
	FIVE_SIXTEENTH		= $8B
	FIVE_EIGHTH			= $8C
	SEVEN_EIGHTH		= $8D
	TWO_WHOLE			= $8E
	LONG_NOTE			= $8F
	LONG_REST			= $90
	WAVE_FADE_IN0		= $91
	FOUR_WHOLE			= $91
	WAVE_FADE_IN1		= $92
	SEVEN_SIXTEENTH		= $93
	
	;opcodes
	ENDSOUND			= $A0
	LOOP				= $A1
	CHANGEVE			= $A2
	CHANGEDUTY			= $A3
	SETLOOP0COUNT		= $A4
	LOOP0				= $A5
	SETLOOP1COUNT		= $A6
	LOOP1				= $A7
	VIBON				= $A8
	VIBOFF				= $A9
	PORTAON				= $AA
	PORTAOFF			= $AB
	CHANGEPSPEED		= $AC
	
	;volume envelopes
	VE0					= 0
	VE1					= 1
	VE2					= 2
	VE3					= 3
	VE4					= 4
	VE5					= 5
	VE6					= 6
	VE7					= 7
	VE8					= 8
	VE9					= 9
	VE10				= 10
	VE11				= 11
	VE12				= 12
	VE13				= 13
	VE14				= 14
	VE15				= 15
	VE16				= 16
	VE17				= 17
	VE18				= 18
	VE19				= 19
	VE20				= 20
	VE21				= 21
	VE22				= 22
	
	;Corresponding note names for each frequency
	;Note: octaves in music traditionally start at C, not A    
	A1 = $00    ;the "1" means Octave 1
	As1 = $01   ;the "s" means "sharp"
	Bb1 = $01   ;the "b" means "flat"  A# == Bb, so same value
	B1 = $02
	C2 = $03
	Cs2 = $04
	Db2 = $04
	D2 = $05
	Ds2 = $06
	Eb2 = $06
	E2 = $07
	F2 = $08
	Fs2 = $09
	Gb2 = $09
	G2 = $0A
	Gs2 = $0B
	Ab2 = $0B
	A2 = $0C
	As2 = $0D
	Bb2 = $0D
	B2 = $0E

	C3 = $0F
	Cs3 = $10
	Db3 = $10
	D3 = $11
	Ds3 = $12
	Eb3 = $12
	E3 = $13
	F3 = $14
	Fs3 = $15
	Gb3 = $15
	G3 = $16
	Gs3 = $17
	Ab3 = $17
	A3 = $18
	As3 = $19
	Bb3 = $19
	B3 = $1a

	C4 = $1b
	Cs4 = $1c
	Db4 = $1c
	D4 = $1d
	Ds4 = $1e
	Eb4 = $1e
	E4 = $1f
	F4 = $20
	Fs4 = $21
	Gb4 = $21
	G4 = $22
	Gs4 = $23
	Ab4 = $23
	A4 = $24
	As4 = $25
	Bb4 = $25
	B4 = $26

	C5 = $27
	Cs5 = $28
	Db5 = $28
	D5 = $29
	Ds5 = $2a
	Eb5 = $2a
	E5 = $2b
	F5 = $2c
	Fs5 = $2d
	Gb5 = $2d
	G5 = $2e
	Gs5 = $2f
	Ab5 = $2f
	A5 = $30
	As5 = $31
	Bb5 = $31
	B5 = $32

	C6 = $33
	Cs6 = $34
	Db6 = $34
	D6 = $35
	Ds6 = $36
	Eb6 = $36
	E6 = $37
	F6 = $38
	Fs6 = $39
	Gb6 = $39
	G6 = $3a
	Gs6 = $3b
	Ab6 = $3b
	A6 = $3c
	As6 = $3d
	Bb6 = $3d
	B6 = $3e

	C7 = $3f
	Cs7 = $40
	Db7 = $40
	D7 = $41
	Ds7 = $42
	Eb7 = $42
	E7 = $43
	F7 = $44
	Fs7 = $45
	Gb7 = $45
	G7 = $46
	Gs7 = $47
	Ab7 = $47
	A7 = $48
	As7 = $49
	Bb7 = $49
	B7 = $4a

	C8 = $4b
	Cs8 = $4c
	Db8 = $4c
	D8 = $4d
	Ds8 = $4e
	Eb8 = $4e
	E8 = $4f
	F8 = $50
	Fs8 = $51
	Gb8 = $51
	G8 = $52
	Gs8 = $53
	Ab8 = $53
	A8 = $54
	As8 = $55
	Bb8 = $55
	B8 = $56

	C9 = $57
	Cs9 = $58
	Db9 = $58
	D9 = $59
	Ds9 = $5a
	Eb9 = $5a
	E9 = $5b
	F9 = $5c
	Fs9 = $5d
	Gb9 = $5d
	rest = $5e