	;Song 3 - The Caves
	;(c) 2018 Sogona
	;All Rights Reserved
SongCaves:
	.db 5
	
	.db MUSIC_SQ1
	.db 1
	.db SQUARE_1
	.db %01110000
	.db VE19
	.dw SongCavesSquare1
	.db 136
	
	.db MUSIC_SQ2
	.db 1
	.db SQUARE_2
	.db %01110000
	.db VE20
	.dw SongCavesSquare2
	.db 136
	
	.db MUSIC_TRI
	.db 1
	.db TRIANGLE
	.db %10000001
	.db VE0
	.dw SongCavesTri
	.db 136
	
	.db MUSIC_NOI
	.db 1
	.db NOISE
	.db %00110000
	.db VE6
	.dw SongCavesNoise
	.db 136
	
	.db MUSIC_DMC
	.db 0
	
	
SongCavesSquare1:
	.db QUARTER
	.db SETLOOP0COUNT,4
@loop:
	.db SETLOOP1COUNT,2
@loop_0:
	.db E5,E5,E5,E5,E5,E5,Ds5,E5
	.db Ds5,Ds5,Ds5,Ds5,C5,C5,B4,B4
	.db Bb4,Bb4,Bb4,Bb4,Bb4,Bb4,B4,B4
	.db G4,E4,E4,E4,E4,E4,E4,E4
	.db LOOP1
	.dw @loop_0
	.db Ds4,Ds4,Ds4,Ds4,Ds4,Ds4,E4,E4
	.db B3,B3,B3,B3,B3,B3,E4,E4
	.db Ds4,Ds4,Ds4,Ds4,Ds4,Ds4,E4,E4
	.db G4,G4,G4,G4,G4,G4,E4,E4
	.db Ds4,Ds4,Ds4,Ds4,Ds4,Ds4,E4,E4
	.db B3,B3,B3,B3,B3,B3,E4,E4
	.db Ds4,Ds4,Ds4,Ds4,Ds4,Ds4,E4,E4
	.db G4,G4,G4,G4,A4,A4,Bb4,B4
	.db LOOP0
	.dw @loop
	.db LOOP
	.dw SongCavesSquare1
	
	
SongCavesSquare2:
	.db FOUR_WHOLE
	.db SETLOOP0COUNT,16
@restloop:
	.db rest
	.db LOOP0
	.dw @restloop
	.db QUARTER
	.db SETLOOP0COUNT,2
@loop:
	.db SETLOOP1COUNT,2
@loop_0:
	.db B4,B4,B4,B4,B4,B4,Bb4,B4
	.db Bb4,Bb4,Bb4,Bb4,G4,G4,Fs4,Fs4
	.db F4,F4,F4,F4,F4,F4,G4,G4
	.db E4,B3,B3,B3,B3,B3,B3,B3
	.db LOOP1
	.dw @loop_0
	.db Bb3,Bb3,Bb3,Bb3,Bb3,Bb3,B3,B3
	.db G3,G3,G3,G3,G3,G3,B3,B3
	.db Bb3,Bb3,Bb3,Bb3,Bb3,Bb3,B3,B3
	.db E4,E4,E4,E4,E4,E4,B3,B3
	.db Bb3,Bb3,Bb3,Bb3,Bb3,Bb3,B3,B3
	.db G3,G3,G3,G3,G3,G3,B3,B3
	.db Bb3,Bb3,Bb3,Bb3,Bb3,Bb3,B3,B3
	.db E4,E4,E4,E4,E4,E4,Fs4,G4
	.db LOOP0
	.dw @loop
	.db LOOP
	.dw SongCavesSquare2
	
	
SongCavesTri:
	.db FOUR_WHOLE
	.db SETLOOP0COUNT,8
@restloop:
	.db rest
	.db LOOP0
	.dw @restloop
	.db SETLOOP0COUNT,3
@loop:
	.db SETLOOP1COUNT,8
@loop_0:
	.db DOTTED_WHOLE,E3,QUARTER,E3,rest
	.db LOOP1
	.dw @loop_0
	.db SETLOOP1COUNT,4
@loop_1:
	.db DOTTED_HALF,Eb3,Eb4,QUARTER,E4,rest
	.db DOTTED_HALF,E3,E4,QUARTER,E3,rest
	.db LOOP1
	.dw @loop_1
	.db LOOP0
	.dw @loop
	.db LOOP
	.dw SongCavesTri
	
	
SongCavesNoise:
	.db FOUR_WHOLE
	.db SETLOOP0COUNT,16
@restloop:
	.db rest
	.db LOOP0
	.dw @restloop
	.db EIGHTH
	.db SETLOOP0COUNT,8
@loop:
	.db 14,rest,0,rest,0,rest,0,0,7,rest,0,rest,0,rest,0,rest
	.db 14,rest,0,rest,0,rest,0,0,7,0,0,rest,14,rest,0,rest
	.db 14,rest,0,rest,0,rest,0,0,7,rest,0,rest,14,rest,14,rest
	.db 14,rest,0,rest,0,rest,0,0,7,0,0,rest,14,14,14,14
	.db LOOP0
	.dw @loop
	.db LOOP
	.dw SongCavesNoise