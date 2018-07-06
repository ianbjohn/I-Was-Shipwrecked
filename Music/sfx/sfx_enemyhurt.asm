SFXEnemyHurt:
	.db 1

	.db SFX_1
	.db 1
	.db SQUARE_1
	.db %10110000
	.db VE9
	.dw SFXEnemyHurtSquare1
	.db 220

SFXEnemyHurtSquare1:
	.db SIXTEENTH
	.db F3,E3,Cs3,C3
	.db ENDSOUND