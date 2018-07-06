SFXGunshot:
	.db 1
	
	.db SFX_1
	.db 1
	.db DMC
	.db 0,0
	.dw SFXGunshotDMC
	.db 100
	
SFXGunshotDMC:
	.db EIGHTH
	.db 1
	.db ENDSOUND