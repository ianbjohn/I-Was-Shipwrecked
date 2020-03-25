SFXSave:
	.db 1
	
	.db SFX_1
	.db 1
	.db SQUARE_1
	.db #%01110000
	.db VE9
	.dw SFXSaveSquare1
	.db 140
	
	
SFXSaveSquare1:
	.db SIXTEENTH
	.db G4,C5,G4,C5,D5,E5
	.db CHANGEVE,VE11,QUARTER,E5
	.db ENDSOUND