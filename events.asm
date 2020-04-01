;Events can also spawn items like cloth and sticks and rope and whatnot (Really only on the shore tho), and eventually items should also be saved by the prev screen ent system. So Just a heads up on that as well (Make sure this works with the screen structure loading system and the prev screen ent system.)

EventCounts:
	;how many different events there are (minus 1)
	;rows of area, columns of difficulty
	;(must be a power of 2)
	.db 15,0,0
	.db 7,7,0
	.db 1,0,0
	.db 1,0,0
	.db 1,0,0
	

Events:
	;sorted by area
	.dw ShoreEvents, JungleEvents, ClearingEvents, MountainEvents, CaveEvents
	
	
ShoreEvents:
	;sorted by difficulty
	.dw ShoreEventsEasy, ShoreEventsModerate, ShoreEventsHard
JungleEvents:
	.dw JungleEventsEasy, JungleEventsModerate, JungleEventsHard
ClearingEvents:
	.dw ClearingEventsEasy, ClearingEventsModerate, ClearingEventsHard
MountainEvents:
	.dw MountainEventsEasy, MountainEventsModerate, MountainEventsHard
CaveEvents:
	.dw CaveEventsEasy, CaveEventsModerate, CaveEventsHard
	
	
ShoreEventsEasy:
	.dw EmptyEvent,ShoreEventEasy0,ShoreEventEasy1,ShoreEventEasy2,ShoreEventEasy3,ShoreEventEasy1,ShoreEventEasy2,ShoreEventEasy3
	.dw ShoreEventEasy1,ShoreEventEasy1,ShoreEventEasy2,ShoreEventEasy7,ShoreEventEasy3,ShoreEventEasy4,ShoreEventEasy5,ShoreEventEasy6

ShoreEventsModerate:

ShoreEventsHard:


JungleEventsEasy:
	.dw EmptyEvent,JungleEventEasy0,JungleEventEasy1,JungleEventEasy2,JungleEventEasy3,JungleEventEasy4,JungleEventEasy0,JungleEventEasy1

JungleEventsModerate:
	.dw EmptyEvent,JungleEventModerate0,JungleEventModerate1,JungleEventModerate2,JungleEventModerate0,JungleEventModerate1,JungleEventModerate0,JungleEventModerate1

JungleEventsHard:


ClearingEventsEasy:

ClearingEventsModerate:

ClearingEventsHard:


MountainEventsEasy:

MountainEventsModerate:

MountainEventsHard:
	.dw EmptyEvent


CaveEventsEasy:
	.dw CaveEventsEasy0

CaveEventsModerate:

CaveEventsHard:
	.dw EmptyEvent
	
	
	;the actual event data is just the index of the enemy sprite palette, followed by a list of ent IDs, with $FF as the terminator
	;kinda wasteful, but I think we'll be ok since we have this entire 16Kb bank dedicated to just this
ShoreEventEasy7:
	.db SP_CLOTH, ENT_CLOTH, $FF
ShoreEventEasy6:
	.db SP_FLINT, ENT_FLINT, $FF
ShoreEventEasy5:
	.db SP_STONE, ENT_STONE, $FF
ShoreEventEasy4:
	.db 0, ENT_STICKCOL, $FF
ShoreEventEasy3:
	.db SP_CRAB, ENT_CRAB,ENT_CRAB,ENT_CRAB,ENT_CRAB, $FF		;4 snakes
ShoreEventEasy2:
	.db SP_CRAB, ENT_CRAB,ENT_CRAB,ENT_CRAB, $FF		;3 snakes
ShoreEventEasy1:
	.db SP_CRAB, ENT_CRAB,ENT_CRAB, $FF		;2 snakes
ShoreEventEasy0:
	.db SP_CRAB, ENT_CRAB, $FF		;1 snake
EmptyEvent:
	.db 0, $FF


JungleEventEasy0:
	.db SP_SNAKE, ENT_SNAKE, $FF
JungleEventEasy1:
	.db SP_SNAKE, ENT_SNAKE,ENT_SNAKE, $FF
JungleEventEasy2:
	.db SP_SNAKE, ENT_SNAKE,ENT_SNAKE,ENT_SNAKE, $FF
JungleEventEasy3:
	.db SP_SNAKE, ENT_SNAKE,ENT_SNAKE,ENT_SNAKE,ENT_SNAKE, $FF
JungleEventEasy4:
	.db SP_BEE, ENT_BEEHIVE, $FF
	
	
JungleEventModerate0:
	.db SP_POISONSNAKE, ENT_POISONSNAKE, $FF
JungleEventModerate1:
	.db SP_POISONSNAKE, ENT_POISONSNAKE,ENT_POISONSNAKE, $FF
JungleEventModerate2:
	.db SP_POISONSNAKE, ENT_POISONSNAKE,ENT_POISONSNAKE,ENT_POISONSNAKE, $FF
	
	
CaveEventsEasy0:
	.db SP_BAT, ENT_BAT, ENT_BAT, ENT_BAT, $FF

	
	
	;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	
	
	;special events happen on a few given screens, which are determined by the header data of each screen
	;special events are also 1-based, so in the screen data, 0 means there's no special event. 1 means special event 0, etc
SpecialEvents:
	.dw SpecialEvent0,SpecialEvent1
	
SpecialEvent0:
	;item ID, x, y, palette
	.db ITEM_JAR, 160,144, $20,$10,$00
SpecialEvent1:
	.db ITEM_MACHETE, 224,208, $20,$10,$00