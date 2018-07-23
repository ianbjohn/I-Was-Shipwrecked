	;Song 1 - The Shore
	;(c) 2017 Sogona
	;All Rights Reserved
SongShore:
	;header
	.db 5		;how many channels to use
	
	.db MUSIC_SQ1
	.db 1		;enabled
	.db SQUARE_1
	.db %01110000	;initial duty (7th bit set for triangle)
	.db VE1		;initial volume envelope
	.dw SongShoreSquare1
	.db 117			;initial tempo
	
	.db MUSIC_SQ2
	.db 1
	.db SQUARE_2
	.db #%01110000
	.db VE1
	.dw SongShoreSquare2
	.db 117
	
	.db MUSIC_TRI
	.db 1
	.db TRIANGLE
	.db %10000001
	.db VE0
	.dw SongShoreTri
	.db 117
	
	.db MUSIC_NOI
	.db 1
	.db NOISE
	.db #%00110000
	.db VE3
	.dw SongShoreNoise
	.db 117
	
	.db MUSIC_DMC
	.db 0
	
	
SongShoreSquare1:
	.db CHANGEPSPEED,5
	.db TWO_WHOLE,rest,rest,rest,rest
	.db A5,LONG_NOTE,E5
	.db LONG_REST,rest
	.db CHANGEDUTY,%00110000,CHANGEVE,VE0
	.db EIGHTH
	.db SETLOOP0COUNT,4
	
@introloop0:
	.db SETLOOP1COUNT,8
@introloop0_0:
	.db B3,E3
	.db LOOP1
	.dw @introloop0_0
	.db SETLOOP1COUNT,8
@introloop0_1:
	.db A3,E3
	.db LOOP1
	.dw @introloop0_1
	.db SETLOOP1COUNT,8
@introloop0_2:
	.db G3,D3
	.db LOOP1
	.dw @introloop0_2
	.db SETLOOP1COUNT,8
@introloop0_3:
	.db Fs3,D3
	.db LOOP1
	.dw @introloop0_3
	.db LOOP0
	.dw @introloop0
	
	.db SETLOOP0COUNT,2
@mainloop0:
	.db DOTTED_QUARTER,Gs4,EIGHTH,rest,Gs4,A4,rest,DOTTED_QUARTER,B4,QUARTER,E4,EIGHTH,E5,rest,E5,rest
	.db DOTTED_QUARTER,E5,EIGHTH,rest,D5,Cs5,rest,DOTTED_QUARTER,D5,EIGHTH,Cs5,rest,Cs5,rest,A4,rest
	.db DOTTED_QUARTER,G4,EIGHTH,rest,G4,A4,rest,DOTTED_QUARTER,B4,QUARTER,E4,EIGHTH,D5,rest,D5,rest
	.db DOTTED_QUARTER,D5,Cs5,A4,EIGHTH,D5,Cs5,A4,D5,Cs5,A4,Cs5
	.db LOOP0
	.dw @mainloop0
	.db SETLOOP0COUNT,2
	
	.db HALF,Gs4,EIGHTH,rest,Gs4,A4,FIVE_EIGHTH,B4,EIGHTH,rest,DOTTED_QUARTER,Cs5
	.db HALF,D5,EIGHTH,rest,D5,E5,FIVE_EIGHTH,Fs5,EIGHTH,rest,DOTTED_QUARTER,A5
	.db EIGHTH,Gs5,rest,Fs5,E5,rest,DOTTED_QUARTER,Gs5,EIGHTH,Fs5,rest,E5,D5,rest,Fs5,rest,Gs5
	.db rest,SEVEN_EIGHTH,E5,VIBON,CHANGEVE,VE12,WHOLE,E5,VIBOFF,CHANGEVE,VE0
	.db HALF,Gs4,EIGHTH,rest,Gs4,A4,FIVE_EIGHTH,B4,EIGHTH,rest,DOTTED_QUARTER,Cs5
	.db HALF,D5,EIGHTH,rest,D5,E5,FIVE_EIGHTH,Fs5,EIGHTH,rest,DOTTED_QUARTER,A5
	.db EIGHTH,Gs5,rest,Fs5,E5,rest,DOTTED_QUARTER,Gs5,EIGHTH,Fs5,rest,E5,D5,rest,Fs5,rest,Gs5
	.db rest,SEVEN_EIGHTH,E5,CHANGEVE,VE12,HALF,E5,PORTAON,E4,E5
	.db CHANGEVE,VE0,PORTAOFF
	
	.db FIVE_EIGHTH,E4,EIGHTH,rest,B3,rest,E4,Fs4,rest,Gs4,rest,E4,rest,DOTTED_HALF,Fs4
	.db EIGHTH,rest,A3,rest,D4,E4,rest,Fs4,rest,D4,rest,DOTTED_QUARTER,E4
	.db QUARTER,G3,EIGHTH,C4,D4,E4,DOTTED_QUARTER,Eb4
	.db QUARTER,Fs3,EIGHTH,B3,Cs4,Eb4,DOTTED_QUARTER,Cs4
	.db QUARTER,E3,EIGHTH,A3,B3,Cs4,DOTTED_QUARTER,B3
	.db QUARTER,D3,EIGHTH,G3,A3,B3,DOTTED_QUARTER,A3
	.db QUARTER,C3,EIGHTH,F3,G3,A3,DOTTED_QUARTER,Gs3
	.db QUARTER,B2,EIGHTH,E3,Fs3,Gs3,DOTTED_QUARTER,Fs3
	.db QUARTER,A2,EIGHTH,D3,E3,Fs3,DOTTED_QUARTER,E3
	.db QUARTER,G2,EIGHTH,C3,D3,E3,DOTTED_QUARTER,D3
	.db QUARTER,F2,EIGHTH,Bb2,C3,D3,DOTTED_QUARTER,Cs3
	.db QUARTER,E2,EIGHTH,A2,B2,Cs3,DOTTED_QUARTER,B2
	.db QUARTER,D2,EIGHTH,G2,A2,B2,QUARTER,A2
	.db EIGHTH,rest,A2,rest,G2,DOTTED_QUARTER,Fs2
	.db TWO_WHOLE,E2
	.db rest,rest,rest
	.db CHANGEVE,VE1,CHANGEDUTY,%01110000
	.db LOOP
	.dw SongShoreSquare1
	
	
SongShoreSquare2:
	.db TWO_WHOLE,rest,rest,rest,rest
	.db WHOLE,rest,TWO_WHOLE,Gs5
	.db LONG_REST,B4,rest
	.db QUARTER,CHANGEVE,VE2,CHANGEDUTY,%00110000
	.db SETLOOP0COUNT,4
	
@introloop0:
	.db rest,Gs4,A4,Gs4,rest,E4,rest,rest
	.db rest,Fs4,Gs4,Fs4,rest,E4,rest,rest
	.db rest,E4,Fs4,E4,rest,D4,rest,rest
	.db rest,D4,E4,D4,rest,Cs4,rest,D4
	.db LOOP0
	.dw @introloop0
	
	.db CHANGEDUTY,%10110000,CHANGEVE,VE7
	.db EIGHTH
	.db SETLOOP0COUNT,2
@mainloop0:
	.db SETLOOP1COUNT,2
@mainloop0_0:
	.db E6,rest,Gs5,B5,rest,E6,rest,Gs5,B5,rest,E6,rest,Gs4,rest,B5,rest
	.db LOOP1
	.dw @mainloop0_0:
	.db SETLOOP1COUNT,2
@mainloop0_1:
	.db D6,rest,Fs5,A5,rest,D6,rest,Fs5,A5,rest,D6,rest,Fs5,A5,rest,rest
	.db LOOP1
	.dw @mainloop0_1
	.db LOOP0
	.dw @mainloop0
	
	.db SIXTEENTH
	.db SETLOOP0COUNT,2
@mainloop1:
	.db SETLOOP1COUNT,8
@mainloop1_0:
	.db Gs5,B5,E6,Gs6
	.db LOOP1
	.dw @mainloop1_0
	.db SETLOOP1COUNT,8
@mainloop1_1:
	.db Fs5,A5,D6,Fs6
	.db LOOP1
	.dw @mainloop1_1
	.db SETLOOP1COUNT,4
@mainloop1_2:
	.db Gs5,B5,E6,Gs6
	.db LOOP1
	.dw @mainloop1_2
	.db SETLOOP1COUNT,4
@mainloop1_3:
	.db Fs5,A5,D6,Fs6
	.db LOOP1
	.dw @mainloop1_3
	.db SETLOOP1COUNT,8
@mainloop1_4:
	.db Gs5,B5,E6,Gs6
	.db LOOP1
	.dw @mainloop1_4
	.db LOOP0
	.dw @mainloop1
	
	.db SETLOOP0COUNT,8
@outroloop0:
	.db Gs5,B5,E6,Gs6
	.db LOOP0
	.dw @outroloop0
	.db SETLOOP0COUNT,8
@outroloop1:
	.db Fs5,A5,D6,Fs6
	.db LOOP0
	.dw @outroloop1
	.db SETLOOP0COUNT,4
@outroloop2:
	.db E5,G5,C6,E6
	.db LOOP0
	.dw @outroloop2
	.db SETLOOP0COUNT,4
@outroloop3:
	.db Eb5,Fs5,B5,Eb6
	.db LOOP0
	.dw @outroloop3
	.db SETLOOP0COUNT,4
@outroloop4:
	.db Cs5,E5,A5,Cs6
	.db LOOP0
	.dw @outroloop4
	.db SETLOOP0COUNT,4
@outroloop5:
	.db B4,D5,G5,B5
	.db LOOP0
	.dw @outroloop5
	.db SETLOOP0COUNT,4
@outroloop6:
	.db A4,C5,F5,A5
	.db LOOP0
	.dw @outroloop6
	.db SETLOOP0COUNT,4
@outroloop7:
	.db Gs4,B4,E5,Gs5
	.db LOOP0
	.dw @outroloop7
	.db SETLOOP0COUNT,4
@outroloop8:
	.db Fs4,A4,D5,Fs5
	.db LOOP0
	.dw @outroloop8
	.db SETLOOP0COUNT,4
@outroloop9:
	.db E4,G4,C5,E5
	.db LOOP0
	.dw @outroloop9
	.db SETLOOP0COUNT,4
@outroloop10:
	.db D4,F4,Bb4,D5
	.db LOOP0
	.dw @outroloop10
	.db SETLOOP0COUNT,4
@outroloop11:
	.db Cs4,E4,A4,Cs5
	.db LOOP0
	.dw @outroloop11
	.db SETLOOP0COUNT,4
@outroloop12:
	.db B3,D4,G4,B4
	.db LOOP0
	.dw @outroloop12
	.db SETLOOP0COUNT,8
@outroloop13:
	.db A3,Cs4
	.db LOOP0
	.dw @outroloop13
	
	.db FOUR_WHOLE,rest,rest
	.db CHANGEDUTY,%01110000,CHANGEVE,VE1
	.db LOOP
	.dw SongShoreSquare2
	
	
SongShoreTri:
	.db FOUR_WHOLE,rest,rest,rest,TWO_WHOLE,rest
	.db Cs3,FOUR_WHOLE,Cs3,Cs3
	
	.db SETLOOP0COUNT,2
@introloop0:
	.db DOTTED_WHOLE,E3,HALF,B3
	.db DOTTED_WHOLE,E4,HALF,A3
	.db WHOLE,G3,DOTTED_QUARTER,G3,FIVE_EIGHTH,A3
	.db TWO_WHOLE,D3
	.db DOTTED_WHOLE,E3,HALF,B3
	.db DOTTED_WHOLE,E4,HALF,A3
	.db WHOLE,G3,DOTTED_QUARTER,G3,FIVE_EIGHTH,A3
	.db WHOLE,D3,HALF,A3,D3
	.db LOOP0
	.dw @introloop0
	
	.db SETLOOP0COUNT,2
@mainloop0:
	.db HALF
	.db E3,QUARTER,B2,DOTTED_HALF,E3,HALF,B3
	.db E4,QUARTER,B3,DOTTED_HALF,E4,HALF,A3
	.db G3,QUARTER,D3,FIVE_EIGHTH,G3,A3,WHOLE
	.db D3,HALF,A3,D3
	.db LOOP0
	.dw @mainloop0
	
	.db SETLOOP0COUNT,2
@mainloop1:
	.db HALF
	.db E3,QUARTER,B3,DOTTED_HALF,E3,EIGHTH,B3,DOTTED_QUARTER,E3,HALF
	.db D3,QUARTER,A3,DOTTED_HALF,D3,EIGHTH,A3,DOTTED_QUARTER,D3,QUARTER
	.db E3,EIGHTH,B3,QUARTER,E3,B3,EIGHTH,E3,QUARTER,D3,EIGHTH,A3,QUARTER,D3,A3,EIGHTH,D3,HALF
	.db E3,QUARTER,B3,E3,WHOLE,E3
	.db LOOP0
	.dw @mainloop1
	
	.db HALF,E4,QUARTER,B3,HALF,E4,B3,QUARTER,E4
	.db HALF,D4,QUARTER,A3,HALF,D4,A3,QUARTER,D4
	.db QUARTER,C4,EIGHTH,G3,QUARTER,C4,DOTTED_QUARTER,G3
	.db QUARTER,B3,EIGHTH,Fs3,QUARTER,B3,DOTTED_QUARTER,Fs3
	.db QUARTER,A3,EIGHTH,E3,QUARTER,A3,DOTTED_QUARTER,E3
	.db QUARTER,G3,EIGHTH,D3,QUARTER,G3,DOTTED_QUARTER,D3
	.db QUARTER,F3,EIGHTH,C3,QUARTER,F3,DOTTED_QUARTER,C3
	.db QUARTER,E3,EIGHTH,B2,QUARTER,E3,DOTTED_QUARTER,B2
	.db QUARTER,D3,EIGHTH,A2,QUARTER,D3,DOTTED_QUARTER,A2
	.db QUARTER,C3,EIGHTH,G2,QUARTER,C3,DOTTED_QUARTER,G2
	.db QUARTER,Bb2,EIGHTH,F2,QUARTER,Bb2,DOTTED_QUARTER,F2
	.db QUARTER,A2,EIGHTH,E2,QUARTER,A2,DOTTED_QUARTER,E2
	.db HALF,G2,A2,G2,Fs2
	.db FOUR_WHOLE,E2,TWO_WHOLE,E2,rest
	.db LOOP
	.dw SongShoreTri
	
	
SongShoreNoise:
	.db SETLOOP0COUNT,5
@waves:
	.db WAVE_FADE_IN0,$02,EIGHTH,CHANGEVE,VE4,$02
	.db CHANGEVE,VE3,WAVE_FADE_IN1,$06,DOTTED_QUARTER,CHANGEVE,VE4,$06
	.db CHANGEVE,VE3
	.db LOOP0
	.dw @waves
	
	.db EIGHTH,CHANGEVE,VE5
	.db SETLOOP0COUNT,8
@mainloop:
	.db SETLOOP1COUNT,3
@mainloop_0:
	.db $00,$00,$00,$00,CHANGEVE,VE6,$09,CHANGEVE,VE5,$00,$00,$00
	.db $00,$00,$00,$00,CHANGEVE,VE6,$09,CHANGEVE,VE5,$00,CHANGEVE,VE6,$09,CHANGEVE,VE5,$00
	.db LOOP1
	.dw @mainloop_0
	.db $00,$00,$00,$00,CHANGEVE,VE6,$09,CHANGEVE,VE5,$00,$00,$00
	.db $00,$00,$00,$00,CHANGEVE,VE6,$09,$09,$09,CHANGEVE,VE5,$00
	.db LOOP0
	.dw @mainloop
	
	.db $00,$00,$00,$00,CHANGEVE,VE6,$09,CHANGEVE,VE5,$00,$00,$00
	.db $00,$00,$00,$00,CHANGEVE,VE6,$09,CHANGEVE,VE5,$00,CHANGEVE,VE6,$09,CHANGEVE,VE5,$00
	
	.db CHANGEVE,VE3
	.db TWO_WHOLE,$02,EIGHTH,CHANGEVE,VE4,$02
	.db CHANGEVE,VE3,WAVE_FADE_IN1,$06,DOTTED_QUARTER,CHANGEVE,VE4,$06
	.db CHANGEVE,VE3
	.db LOOP
	.dw SongShoreNoise