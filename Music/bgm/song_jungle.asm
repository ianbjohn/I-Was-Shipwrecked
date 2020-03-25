	;Song 2 - The Jungle
	;(c) 2018 Sogona
	;All Rights Reserved
SongJungle:
	.db 5
	
	.db MUSIC_SQ1
	.db 1
	.db SQUARE_1
	.db %01110000
	.db VE0
	.dw SongJungleSquare1
	.db 125
	
	.db MUSIC_SQ2
	.db 1
	.db SQUARE_2
	.db %10110000
	.db VE18
	.dw SongJungleSquare2
	.db 125
	
	.db MUSIC_TRI
	.db 1
	.db TRIANGLE
	.db %10000001
	.db VE0
	.dw SongJungleTri
	.db 125
	
	.db MUSIC_NOI
	.db 1
	.db NOISE
	.db %00110000
	.db VE5
	.dw SongJungleNoise
	.db 125
	
	.db MUSIC_DMC
	.db 1
	.db DMC
	.db 0,0
	.dw SongJungleDMC
	.db 125
	
	
SongJungleSquare1:
	.db CHANGEPSPEED,5
	.db TWO_WHOLE,rest,rest,rest,rest
	.db SETLOOP0COUNT,2
	.db QUARTER
@mainloop1:
	.db A3,B3,C4,HALF,A3,E4,QUARTER,C4
	.db WHOLE,Eb4,SEVEN_EIGHTH,B3,EIGHTH,rest
	.db QUARTER,B3,C4,D4,HALF,B3,F4,QUARTER,C4
	.db WHOLE,E4,CHANGEVE,VE12,VIBON,DOTTED_HALF,E4,VIBOFF,QUARTER,rest
	.db CHANGEVE,VE0
	.db C4,D4,E4,HALF,C4,G4,QUARTER,C4
	.db HALF,F4,E4,D4,F4
	.db EIGHTH,E4,rest,C4,rest,D4,rest,B3,rest,C4,rest,A3,rest,B3,rest,E3,rest
	.db WHOLE,A3,CHANGEVE,VE12,VIBON,DOTTED_HALF,A3,VIBOFF,QUARTER,rest
	.db CHANGEVE,VE0
	.db LOOP0
	.dw @mainloop1
	
	.db SETLOOP0COUNT,2
@mainloop2:
	.db DOTTED_WHOLE,A3,QUARTER,G3,F3
	.db TWO_WHOLE,G3
	.db WHOLE,Gs3,HALF,B3,D4
	.db EIGHTH,D4,SEVEN_EIGHTH,E4,CHANGEVE,VE12,WHOLE,E4
	.db CHANGEVE,VE0
	.db HALF,D4,QUARTER,C4,HALF,A3,DOTTED_HALF,D4
	.db HALF,E4,QUARTER,D4,DOTTED_HALF,E4,HALF,G4
	.db EIGHTH,G4,SEVEN_EIGHTH,A4,WHOLE,E5,G5,A5
	.db LOOP0
	.dw @mainloop2
	
	.db CHANGEVE,VE12
	.db WHOLE,A5,HALF,PORTAON,A4,A5,PORTAOFF,rest
	.db TWO_WHOLE,rest,rest,rest
	.db CHANGEVE,VE0
	.db LOOP
	.dw SongJungleSquare1
	
	
SongJungleSquare2:
	.db CHANGEPSPEED,10
	.db FOUR_WHOLE,rest,rest
	.db QUARTER
	.db SETLOOP0COUNT,2
@mainloop1:
	.db C6,rest,B5,A5,rest,E5,rest,E5
	.db B5,rest,A5,Gs5,rest,E5,rest,E5
	.db B5,rest,A5,Gs5,rest,D6,rest,E5
	.db C6,rest,B5,A5,rest,E5,rest,E5
	.db E6,rest,D6,C6,rest,G5,rest,G5
	.db F5,rest,A5,D6,rest,F6,rest,F6
	.db E6,rest,D6,B5,rest,E6,rest,Gs5
	.db A5,rest,E5,A5,rest,A4,rest,A4
	.db LOOP0
	.dw @mainloop1
	
	.db SETLOOP0COUNT,2
	.db CHANGEVE,VE0,CHANGEDUTY,%01110000
@mainloop2:
	.db TWO_WHOLE,F3,DOTTED_WHOLE,E3,HALF,C4
	.db FOUR_WHOLE,E3
	.db TWO_WHOLE,F3,G3
	.db FOUR_WHOLE,A3
	.db LOOP0
	.dw @mainloop2
	
	.db CHANGEVE,VE12
	.db TWO_WHOLE,A3
	.db WHOLE,A3,HALF,PORTAON,A2,A3,PORTAOFF,rest
	.db FOUR_WHOLE,rest
	.db CHANGEVE,VE18,CHANGEDUTY,%10110000
	.db LOOP
	.dw SongJungleSquare2
	
	
SongJungleTri:
	.db CHANGEPSPEED,10
	.db EIGHTH
	.db SETLOOP0COUNT,14
@introloop:
	.db E4,rest,A3,rest
	.db LOOP0
	.dw @introloop
	.db PORTAON,A4,A5,PORTAOFF,PORTAON,A4,A5,PORTAOFF,QUARTER,PORTAON,A4,A5,PORTAOFF
	.db EIGHTH,PORTAON,E4,E5,PORTAOFF,PORTAON,E4,E5,PORTAOFF,QUARTER,PORTAON,E3,E5,PORTAOFF
	
	.db SETLOOP0COUNT,2
@mainloop1:
	.db HALF,E4,QUARTER,A3,HALF,E4,QUARTER,A3,rest,A3
	.db HALF,B3,QUARTER,Fs3,HALF,B3,QUARTER,Fs3,rest,Fs3
	.db HALF,B3,QUARTER,F3,HALF,B3,QUARTER,F3,rest,F3
	.db HALF,A3,QUARTER,E4,A3,rest,A3,rest,A3
	.db HALF,C4,QUARTER,G3,HALF,C4,QUARTER,G3,rest,G3
	.db HALF,F3,QUARTER,C4,HALF,F3,QUARTER,C4,rest,F3
	.db HALF,E3,QUARTER,Gs3,HALF,E3,QUARTER,B3,rest,E3
	.db HALF,A3,QUARTER,E4,HALF,A3,QUARTER,E4,rest,A3
	.db LOOP0
	.dw @mainloop1
	
	.db SETLOOP0COUNT,2
@mainloop2:
	.db HALF,F3,QUARTER,C4,F3,F4,HALF,F3,QUARTER,C4
	.db E4,E3,G3,HALF,C4,QUARTER,G3,HALF,C4
	.db QUARTER,E4,D4,E4,B3,E4,D4,E4,B3
	.db E4,D4,B3,HALF,D4,DOTTED_HALF,E4
	.db QUARTER,C4,Bb3,C4,HALF,F3,G3,QUARTER,A3
	.db G3,B3,G3,HALF,D4,G4,EIGHTH,G3,Gs3
	.db SETLOOP1COUNT,2
@mainloop2_1:
	.db A2,rest,A2,rest,A3,A2,rest,G2,A2,rest,A2,rest,HALF,A3,EIGHTH
	.db LOOP1
	.dw @mainloop2_1
	.db LOOP0
	.dw @mainloop2
	.db TWO_WHOLE,A2,A2,A2,WHOLE,A2,rest
	.db LOOP
	.dw SongJungleTri
	
	
SongJungleNoise:
	.db TWO_WHOLE,rest,rest,rest,rest
	.db EIGHTH
	.db SETLOOP0COUNT,8
@loop:
	.db 0,rest,0,rest,0,rest,0,0,0,rest,0,rest,0,rest,0,rest
	.db 0,rest,0,0,0,rest,0,rest,0,rest,0,rest,0,0,0,rest
	.db 0,rest,0,rest,0,rest,0,0,0,rest,0,rest,0,rest,0,rest
	.db 0,0,0,rest,0,0,0,rest,0,0,0,rest,0,0,0,0
	.db LOOP0
	.dw @loop
	.db TWO_WHOLE,rest,rest,rest,rest
	.db LOOP
	.dw SongJungleNoise
	
	
SongJungleDMC:
	.db TWO_WHOLE,rest,rest,rest,WHOLE,rest
	.db EIGHTH,3,rest,3,3,3,rest,3,rest
	
	.db SETLOOP0COUNT,4
@loop:
	.db SETLOOP1COUNT,3
@loop_1
	.db rest,rest,rest,rest,3,rest,rest,rest
	.db LOOP1
	.dw @loop_1
	.db rest,rest,rest,rest,3,rest,3,rest
	.db SETLOOP1COUNT,3
@loop_2:
	.db rest,rest,rest,rest,3,rest,rest,rest
	.db LOOP1
	.dw @loop_2
	.db rest,rest,rest,rest,3,3,3,rest
	.db SETLOOP1COUNT,3
@loop_3:
	.db rest,rest,rest,rest,3,rest,rest,rest
	.db LOOP1
	.dw @loop_3
	.db rest,rest,rest,rest,3,rest,3,3
	.db SETLOOP1COUNT,2
@loop_4:
	.db rest,rest,rest,rest,3,rest,rest,rest
	.db LOOP1
	.dw @loop_4
	.db rest,rest,rest,rest,3,rest,3,rest
	.db rest,rest,rest,rest,3,3,3,3
	.db LOOP0
	.dw @loop
	.db FOUR_WHOLE,rest,rest
	.db LOOP
	.dw SongJungleDMC