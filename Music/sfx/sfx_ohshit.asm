SFXOhShit:
	.db 1
	
	.db SFX_2
	.db 1
	.db SQUARE_1
	.db %00110000
	.db VE9
	.dw SFXOhShitSquare1
	.db 140
	
SFXOhShitSquare1:
	.db EIGHTH
	.db F3,E3,Eb3,D3,Db3
	.db DOTTED_QUARTER
	.db C3
	.db ENDSOUND