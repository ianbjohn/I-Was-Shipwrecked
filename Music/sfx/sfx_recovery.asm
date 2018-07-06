SFXRecovery:
	.db 2
	
	.db SFX_1
	.db 1
	.db SQUARE_1
	.db %00110000
	.db VE22
	.dw SFXRecoverySquare1
	.db 140
	
	.db SFX_2
	.db 1
	.db SQUARE_2
	.db %00110000
	.db VE22
	.dw SFXRecoverySquare2
	.db 140
	
	
SFXRecoverySquare1:
	.db TWO_WHOLE
	.db G2
	.db ENDSOUND
	
SFXRecoverySquare2:
	.db TWO_WHOLE
	.db E3
	.db ENDSOUND