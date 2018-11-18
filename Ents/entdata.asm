	;This data gets loaded into an Ent's RAM when it gets initialized.
EntData:
	;sorted by ent ID
	.dw PlayerData, PlayerWeapon0Data, SnakeData, JarData, HeartData, MeatData, BeehiveData, BeeData
	.dw GunData, BulletData, DoorData, CrabData, MacheteColData, MacheteData, StickColData, StickData
	.dw StoneData, FlintData, SpearData, ClothData, BatData, PoisonSnakeData, HoneycombData
	
	
PlayerData:
	;nothing here yet. I feel like this should just be hard-coded.
	;After all, it only needs to happen once, as the player will
		;always be active in the play state
PlayerWeapon0Data:
	;Type, damage (health), post-hit invincibility time
	.db ENT_TYPE_WEAPON, 2, 120
JarData:
HeartData:
MeatData:
MacheteColData:
StickColData:
StoneData:
FlintData:
ClothData:
HoneycombData:
	.db ENT_TYPE_POWERUP, 0, 0
SnakeData:
PoisonSnakeData:
	.db ENT_TYPE_ENEMY, 8, 30
BeehiveData:
BeeData:
	.db ENT_TYPE_ENEMY, 1, 0
GunData:
	.db ENT_TYPE_MISC, 0, 4	;here, the PHI time is used to count down to switch states (i.e when the explosion should disappear)
BulletData:
	.db ENT_TYPE_WEAPON, 25, 0
DoorData:
	.db ENT_TYPE_DOOR, 0, 0
CrabData:
	.db ENT_TYPE_ENEMY, 4, 30
MacheteData:
	.db ENT_TYPE_WEAPON, 4, 120
StickData:
	.db ENT_TYPE_WEAPON, 1, 120
SpearData:
	.db ENT_TYPE_WEAPON, 10, 120
BatData:
	.db ENT_TYPE_ENEMY, 6, 30