SFXEmptyClip:
	.db 1
	
	.db SFX_1
	.db 1
	.db DMC
	.db 0,0
	.dw SFXEmptyClipDMC
	.db 100
	
SFXEmptyClipDMC:
	.db EIGHTH
	.db 2
	.db ENDSOUND