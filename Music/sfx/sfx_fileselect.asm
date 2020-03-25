SFXFileSelect:
	.db 1
	
	.db SFX_1
	.db 1
	.db SQUARE_1
	.db #%01110000
	.db VE9
	.dw SFXFileSelectSquare1
	.db 140
	
	
SFXFileSelectSquare1:
	.db SIXTEENTH
	.db G5,B5,Eb5
	.db ENDSOUND