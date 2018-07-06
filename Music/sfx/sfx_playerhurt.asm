SFXPlayerHurt:
	.db 1
	
	.db SFX_1
	.db 1
	.db SQUARE_1
	.db #%10110000
	.db VE9
	.dw SFXPlayerHurtSquare1
	.db 220
	
	
SFXPlayerHurtSquare1:
	.db SIXTEENTH
	.db G4,Fs4,F4,E4,Eb4,D4,Cs4,C4,B3,Bb3,A3
	.db ENDSOUND