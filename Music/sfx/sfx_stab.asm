SFXStab:
	.db 1
	
	.db SFX_2
	.db 1
	.db NOISE
	.db %00110000
	.db VE10
	.dw SFXStabNoise
	.db 90
	
	
SFXStabNoise:
	.db EIGHTH
	.db $04
	.db ENDSOUND