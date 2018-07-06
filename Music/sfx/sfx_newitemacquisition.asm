SFXNewItemAcquisition:
	.db 1
	
	.db SFX_1
	.db 1
	.db SQUARE_1
	.db #%10110000
	.db VE9
	.dw SFXNewItemAcquisitionSquare1
	.db 140
	
	
SFXNewItemAcquisitionSquare1:
	.db SIXTEENTH
	.db D4,G4,D4,G4,B4,D4,G4,B4,D5,G4,B4,D5,G5
	.db ENDSOUND