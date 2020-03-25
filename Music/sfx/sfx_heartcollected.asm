SFXHeartCollected:
	.db 1
	
	.db SFX_1
	.db 1
	.db SQUARE_2
	.db #%00110000
	.db VE9
	.dw SFXHeartCollectedSquare2
	.db 140
	
	
SFXHeartCollectedSquare2:
	.db SIXTEENTH
	.db Bb5,C6,D6,F6,G6,A6,Bb6,C7,D7
	.db ENDSOUND