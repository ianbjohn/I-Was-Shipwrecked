	;Song 4 - The Mountains
	;(c) 2020 Sogona
	;All Rights Reserved
SongMountains:
	.db 5

	.db MUSIC_SQ1
	.db 1
	.db SQUARE_1
	.db %01110000
	.db VE24
	.dw SongMountainsSquare1
	.db 114			;probably not the tempo we want but we can keep messing with it

	.db MUSIC_SQ2
	.db 1
	.db SQUARE_2
	.db %01110000
	.db VE24
	.dw SongMountainsSquare2
	.db 114

	.db MUSIC_TRI
	.db 1
	.db TRIANGLE
	.db %10000001
	.db VE0
	.dw SongMountainsTri
	.db 114

	.db MUSIC_NOI
	.db 1
	.db NOISE
	.db %00110000
	.db VE5
	.dw SongMountainsNoise
	.db 114

	.db MUSIC_DMC
	.db 0


SongMountainsSquare1:
	.db FOUR_WHOLE,rest,rest
	.db VIBON
	.db SETLOOP0COUNT,2
@introLoop:
	.db CHANGEVE,VE23
	.db SIXTEENTH
	.db C4,D4,Eb4,F4,FIVE_EIGHTH,G4
	.db EIGHTH,F4,FIVE_EIGHTH,G4
	.db EIGHTH,F4,WHOLE,G4,CHANGEVE,VE14,DOTTED_HALF,G4
	.db HALF,rest
	.db CHANGEVE,VE23
	.db SIXTEENTH
	.db Bb3,C4,Db4,Eb4,FIVE_EIGHTH,F4
	.db EIGHTH,Eb4,FIVE_EIGHTH,F4
	.db EIGHTH,Eb4,WHOLE,F4,CHANGEVE,VE14,DOTTED_HALF,F4
	.db HALF,rest
	.db CHANGEVE,VE23
	.db SIXTEENTH
	.db Ab3,Bb3,C4,D4,FIVE_EIGHTH,Eb4
	.db EIGHTH,D4,FIVE_EIGHTH,Eb4
	.db EIGHTH,D4,WHOLE,Eb4,CHANGEVE,VE14,DOTTED_HALF,Eb4
	.db HALF,rest
	.db CHANGEVE,VE23
	.db SIXTEENTH
	.db G3,A3,B3,C4,FIVE_EIGHTH,D4
	.db EIGHTH,C4,FIVE_EIGHTH,D4
	.db EIGHTH,C4,WHOLE,D4,CHANGEVE,VE14,DOTTED_HALF,D4
	.db HALF,rest
	.db LOOP0
	.dw @introLoop
@main1:
	.db VIBOFF
	.db CHANGEDUTY,%00110000
	.db CHANGEVE,VE24
	.db EIGHTH
	.db C4,D4,Eb4,F4,G4,C5,rest,Eb5
	.db rest,D5,rest,Bb4,C5,rest,G4,rest
	.db C4,D4,Eb4,F4,G4,C5,rest,Eb5
	.db rest,D5,rest,Bb4,C5,rest,G4,rest
	.db Bb3,C4,Db4,rest,CHANGEVE,VE25,QUARTER,Db4,EIGHTH,F4,CHANGEVE,VE24,Ab4
	.db rest,CHANGEVE,VE25,QUARTER,Ab4,CHANGEVE,VE24,EIGHTH,F4,Ab4,rest,Db4,rest
	.db Bb3,C4,Db4,rest,CHANGEVE,VE25,QUARTER,Db4,EIGHTH,F4,CHANGEVE,VE24,Ab4
	.db rest,CHANGEVE,VE25,QUARTER,Ab4,CHANGEVE,VE24,EIGHTH,F4,Ab4,rest,Bb3,rest
	.db C4,D4,Eb4,F4,G4,C5,rest,Eb5
	.db rest,Eb5,rest,C5,D5,rest,Bb4,rest
	.db C4,D4,Eb4,F4,G4,C5,rest,Eb5
	.db rest,Eb5,rest,C5,D5,rest,Bb4,rest
	.db Bb3,C4,Db4,rest,CHANGEVE,VE25,QUARTER,Db4,EIGHTH,F4,CHANGEVE,VE24,Ab4
	.db rest,CHANGEVE,VE25,QUARTER,Ab4,CHANGEVE,VE24,EIGHTH,F4,Ab4,rest,Db4,rest
	.db Bb3,C4,Db4,rest,CHANGEVE,VE25,QUARTER,Db4,EIGHTH,F4,CHANGEVE,VE24,Ab4
	.db rest,CHANGEVE,VE25,QUARTER,Ab4,CHANGEVE,VE24,EIGHTH,F4,Ab4,rest,Bb3,rest
	.db LOOP
	.dw SongMountainsSquare1


SongMountainsSquare2:
	.db FOUR_WHOLE,rest,rest
	.db SETLOOP0COUNT,2
@introLoop:
	.db CHANGEVE,VE23
	.db HALF,rest,EIGHTH,F4,FIVE_EIGHTH,G4
	.db EIGHTH,F4,TWO_WHOLE,G4,CHANGEVE,VE14,EIGHTH,G4
	.db HALF,rest
	.db CHANGEVE,VE23
	.db HALF,rest,EIGHTH,Eb4,FIVE_EIGHTH,F4
	.db EIGHTH,Eb4,TWO_WHOLE,F4,CHANGEVE,VE14,EIGHTH,F4
	.db HALF,rest
	.db CHANGEVE,VE23
	.db HALF,rest,EIGHTH,D4,FIVE_EIGHTH,Eb4
	.db EIGHTH,D4,TWO_WHOLE,Eb4,CHANGEVE,VE14,EIGHTH,Eb4
	.db HALF,rest
	.db CHANGEVE,VE23
	.db HALF,rest,EIGHTH,C4,FIVE_EIGHTH,D4
	.db EIGHTH,C4,TWO_WHOLE,D4,CHANGEVE,VE14,EIGHTH,D4
	.db HALF,rest
	.db LOOP0
	.dw @introLoop
@main1:
	.db VIBOFF
	.db SIXTEENTH
	.db CHANGEDUTY,%10110000
	.db CHANGEVE,VE26
	.db SETLOOP0COUNT,2
@main1_loop1:
	.db SETLOOP1COUNT,2
@main1_loop1_0:
	.db G3,C4,Eb4,G4,C5,Eb5,G5,C6,Eb6,C6,G5,Eb5,C5,G4,Eb4,C4
	.db Eb3,G3,C4,Eb4,G4,C5,Eb5,G5,C6,G5,Eb5,C5,G4,Eb4,C4,G3
	.db LOOP1
	.dw @main1_loop1_0
	.db SETLOOP1COUNT,2
@main1_loop1_1:
	.db Bb5,F5,Bb4,F4,Bb4,Db5,F5,Bb5,F5,Bb4,F4,Bb4,Db5,F5
	.db Bb5,F5,Bb4,F4,Bb4,Db5,F5,Bb5,F5,Bb4,F4,Bb4,Db5,F5
	.db Bb5,F5,Db5,F5
	.db LOOP1
	.dw @main1_loop1_1
	.db LOOP0
	.dw @main1_loop1
	.db LOOP
	.dw SongMountainsSquare2


SongMountainsTri:
	.db SIXTEENTH
	.db SETLOOP0COUNT,20
@introLoop:
	.db Eb4,rest,D4,rest,Eb4,rest,D4,rest,Eb4,rest,F4,rest,rest,rest,Eb4,rest
	.db rest,rest,D4,rest,rest,rest,Bb3,rest,C4,rest,rest,rest,G3,rest,rest,rest
	.db LOOP0
	.dw @introLoop 
	.db QUARTER
	.db SETLOOP0COUNT,2
@main1:
	.db C4,rest,G3,HALF,C4,QUARTER,rest,EIGHTH,G4,F4,Eb4,F4
	.db C4,G4,rest,G4,rest,F4,G4,rest,Bb3,C4,rest,FIVE_EIGHTH,C4
	.db HALF,Bb3,EIGHTH,Db4,rest,HALF,Db4,EIGHTH,Ab3,SIXTEENTH,Bb3,rest,QUARTER,Bb3,rest
	.db DOTTED_QUARTER,Bb3,QUARTER,Db4,EIGHTH,rest,QUARTER,Db4,Ab3,SIXTEENTH,Bb3,rest,DOTTED_QUARTER,Bb3,QUARTER,B3
	.db LOOP0
	.dw @main1
	.db LOOP
	.dw SongMountainsTri


SongMountainsNoise:
	.db EIGHTH
	.db $02,$02,$02,$02,$07,$02,$02,$02
	.db $0F,$02,$02,$02,$07,$02,$02,$0F
	.db LOOP
	.dw SongMountainsNoise