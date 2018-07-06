SFXPause:
	.db 1
	
	.db SFX_1
	.db 1
	.db SQUARE_1
	.db %00110000
	.db VE9
	.dw SFXPauseSquare1
	.db 90
	
	
SFXPauseSquare1:
	.db SIXTEENTH
	.db F4,C4,F4
	.db ENDSOUND