SFXThrow:
	.db 1
	
	.db SFX_2
	.db 1
	.db NOISE
	.db %00110000
	.db VE21
	.dw SFXThrowNoise
	.db 120
	
	
SFXThrowNoise:
	.db QUARTER
	.db $07
	.db ENDSOUND