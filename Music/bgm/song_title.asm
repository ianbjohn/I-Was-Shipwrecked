	;Song 0 - Title
	;(c) 2018 Sogona
	;All Rights Reserved
SongTitle:
	.db 4
	
	.db MUSIC_SQ1
	.db 1
	.db SQUARE_1
	.db %01110000
	.db VE13
	.dw SongTitleSquare1
	.db 105
	.db MUSIC_SQ2
	.db 1
	.db SQUARE_2
	.db %01110000
	.db VE14
	.dw SongTitleSquare2
	.db 105
	
	.db MUSIC_TRI
	.db 1
	.db TRIANGLE
	.db %10000001
	.db VE0
	.dw SongTitleTri
	.db 105
	
	.db MUSIC_NOI
	.db 1
	.db NOISE
	.db %00110000
	.db VE15
	.dw SongTitleNoise
	.db 105
	
SongTitleSquare1:
	.db SETLOOP0COUNT,8		;cut in half to 4
@loop:
	.db SETLOOP1COUNT,4
@loop_a:
	.db SIXTEENTH,G3,SEVEN_SIXTEENTH,A3,HALF,G3
	.db LOOP1
	.dw @loop_a
	.db SETLOOP1COUNT,4
@loop_b
	.db SIXTEENTH,F3,SEVEN_SIXTEENTH,G3,HALF,F3
	.db LOOP1
	.dw @loop_b
	.db LOOP0
	.dw @loop
	
	;mid-high-pitched square, quick fade in fade out volume, semi staccatoey
	;A,G,F,D, x4
	;F,E,C,Bb x4
	;(maybe)
	
	.db CHANGEVE,VE17,FOUR_WHOLE,F3,F3,F3,TWO_WHOLE,F3,DOTTED_WHOLE,F3,HALF,rest
	.db ENDSOUND
	
	
SongTitleSquare2:
	.db CHANGEPSPEED,8
	.db WHOLE
	.db SETLOOP0COUNT,4
@loop:
	.db D3,D3,D3,D3,Bb2,Bb2,Bb2,Bb2
	.db LOOP0
	.dw @loop
	
	.db CHANGEDUTY,%00110000,VIBON
	.db SETLOOP0COUNT,2
@loop1:
	.db CHANGEVE,VE0
	.db HALF,rest,G4,PORTAON,A4,G4,PORTAON,D5,A4,TWO_WHOLE,PORTAON,A4,D5
	.db HALF,rest,F4,PORTAON,G4,F4,PORTAON,C5,G4,WHOLE,PORTAON,G4,C5,PORTAON,F4,G4
	.db HALF,rest,D4,PORTAON,E4,D4,PORTAON,A4,E4,TWO_WHOLE,PORTAON,E4,A4
	.db HALF,rest,C4,PORTAON,D4,C4,PORTAON,G4,D4,WHOLE,PORTAON,D4,G4,PORTAON,C4,D4
	.db LOOP0
	.dw @loop1
	
	.db CHANGEVE,VE12,FOUR_WHOLE,C4,C4,C4,TWO_WHOLE,C4,DOTTED_WHOLE,C4,HALF,rest
	.db ENDSOUND


SongTitleTri:
	.db SETLOOP0COUNT,8
@loop:
	.db WHOLE,D3,D3,D3,HALF,D3,C3
	.db WHOLE,Bb2,Bb2,Bb2,HALF,Bb2,C3
	.db LOOP0
	.dw @loop
	
	.db TWO_WHOLE,Bb3,C4,FOUR_WHOLE,D3
	.db TWO_WHOLE,Bb3,C4,TWO_WHOLE,D3,DOTTED_WHOLE,D3,HALF,rest
	.db ENDSOUND


SongTitleNoise:
	.db FOUR_WHOLE,rest,rest,rest,rest
	.db SETLOOP0COUNT,4
@loop0:
	.db DOTTED_HALF,$07,QUARTER,rest,DOTTED_HALF,$07,QUARTER,rest,DOTTED_HALF,$07,QUARTER,rest,HALF,CHANGEVE,VE16,$07,$07,CHANGEVE,VE15
	.db LOOP0
	.dw @loop0
	
	.db SETLOOP0COUNT,4
@loop1:
	.db QUARTER,$07,$07,$07,$07,CHANGEVE,VE6,$09,CHANGEVE,VE15,$07,$07,$07
	.db $07,$07,HALF,$07,QUARTER,CHANGEVE,VE6,$09,CHANGEVE,VE15,$07,HALF,$07
	.db QUARTER,$07,$07,$07,$07,CHANGEVE,VE6,$09,CHANGEVE,VE15,$07,$07,$07
	.db $07,CHANGEVE,VE6,$09,HALF,CHANGEVE,VE15,$07,CHANGEVE,VE6,$09,CHANGEVE,VE15,$07
	.db LOOP0
	.dw @loop1
	
	.db SETLOOP0COUNT,3
@loop2:
	.db DOTTED_HALF,$07,QUARTER,rest,DOTTED_HALF,$07,QUARTER,rest,DOTTED_HALF,$07,QUARTER,rest,HALF,CHANGEVE,VE16,$07,$07,CHANGEVE,VE15
	.db LOOP0
	.dw @loop2
	.db DOTTED_HALF,$07,QUARTER,rest,DOTTED_HALF,$07,QUARTER,rest,DOTTED_WHOLE,$07,HALF,rest
	.db ENDSOUND