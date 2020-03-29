	;This data gets loaded into an Ent's RAM when it gets initialized.
EntData:
	;sorted by ent ID
	.dw PlayerData, PlayerWeapon0Data, SnakeData, JarData, HeartData, MeatData, BeehiveData, BeeData
	.dw BulletData, DoorData, CrabData, MacheteColData, MacheteData, StickColData, StickData, StoneData
	.dw FlintData, SpearData, ClothData, BatData, PoisonSnakeData, HoneycombData
	
	
PlayerData:
	;nothing here yet. I feel like this should just be hard-coded.
	;After all, it only needs to happen once, as the player will
		;always be active in the play state
PlayerWeapon0Data:
	;Type, damage (health)
	.db ENT_TYPE_WEAPON, 2
JarData:
HeartData:
MeatData:
MacheteColData:
StickColData:
StoneData:
FlintData:
ClothData:
HoneycombData:
	.db ENT_TYPE_POWERUP, 0
SnakeData:
PoisonSnakeData:
	.db ENT_TYPE_ENEMY, 8
BeehiveData:
BeeData:
	.db ENT_TYPE_ENEMY, 1
BulletData:
	.db ENT_TYPE_WEAPON, 25
DoorData:
	.db ENT_TYPE_DOOR, 0
CrabData:
	.db ENT_TYPE_ENEMY, 4
MacheteData:
	.db ENT_TYPE_WEAPON, 4
StickData:
	.db ENT_TYPE_WEAPON, 1
SpearData:
	.db ENT_TYPE_WEAPON, 10
BatData:
	.db ENT_TYPE_ENEMY, 6