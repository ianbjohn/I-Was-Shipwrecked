;Make sure when editing a section of this file that everything else that corresponds to the ent is accounted for
;(i.e when editing hitbox data, make sure the metasprite x/y data isn't off)
	
	;Metasprites
EntMetaSprites:
	;sorted by ent ID
	.dw PlayerMetaSprites, PlayerWeapon0MetaSprites, SnakeMetaSprites, JarMetaSprites, HeartMetaSprites, MeatMetaSprites, BeehiveMetaSprites, BeeMetaSprites
	.dw GunMetaSprites, BulletMetaSprites, DoorMetaSprites, CrabMetaSprites, MacheteColMetaSpites, MacheteMetaSprites, StickColMetaSprites, StickMetaSprites
	.dw StoneMetaSprites, FlintMetaSprites, SpearMetaSprites, ClothMetaSprites, BatMetaSprites, SnakeMetaSprites, HoneycombMetaSprites

	
	;Player
PlayerMetaSprites:
	;sorted by state
	.dw PlayerMetaSpritesStanding, PlayerMetaSpritesWalking, PlayerMetaSpritesAttacking
	
PlayerMetaSpritesStanding:
	;sorted by Direction
	.dw PlayerMetaSpritesStandingU, PlayerMetaSpritesStandingD, PlayerMetaSpritesStandingL, PlayerMetaSpritesStandingR
PlayerMetaSpritesWalking:
	.dw PlayerMetaSpritesWalkingU, PlayerMetaSpritesWalkingD, PlayerMetaSpritesWalkingL, PlayerMetaSpritesWalkingR
PlayerMetaSpritesAttacking:
	.dw PlayerMetaSpritesAttackingU, PlayerMetaSpritesAttackingD, PlayerMetaSpritesAttackingL, PlayerMetaSpritesAttackingR
	
	;Player - Standing
PlayerMetaSpritesStandingU:
	;sorted by animation frame
	.dw PlayerMetaSpriteStandingU_0
PlayerMetaSpritesStandingD:
	.dw PlayerMetaSpriteStandingD_0
PlayerMetaSpritesStandingL:
	.dw PlayerMetaSpriteStandingL_0
PlayerMetaSpritesStandingR:
	.dw PlayerMetaSpriteStandingR_0
	
	;Player - Walking
PlayerMetaSpritesWalkingU:
	.dw PlayerMetaSpriteWalkingU_0, PlayerMetaSpriteStandingU_0, PlayerMetaSpriteWalkingU_1, PlayerMetaSpriteStandingU_0
PlayerMetaSpritesWalkingD:
	.dw PlayerMetaSpriteWalkingD_0, PlayerMetaSpriteStandingD_0, PlayerMetaSpriteWalkingD_1, PlayerMetaSpriteStandingD_0
PlayerMetaSpritesWalkingL:
	.dw PlayerMetaSpriteWalkingL_0, PlayerMetaSpriteStandingL_0, PlayerMetaSpriteWalkingL_1, PlayerMetaSpriteStandingL_0
PlayerMetaSpritesWalkingR:
	.dw PlayerMetaSpriteWalkingR_0, PlayerMetaSpriteStandingR_0, PlayerMetaSpriteWalkingR_1, PlayerMetaSpriteStandingR_0
	
	;Player - Attacking
PlayerMetaSpritesAttackingU:
	.dw PlayerMetaSpriteAttackingU_0
PlayerMetaSpritesAttackingD:
	.dw PlayerMetaSpriteAttackingD_0
PlayerMetaSpritesAttackingL:
	.dw PlayerMetaSpriteAttackingL_0
PlayerMetaSpritesAttackingR:
	.dw PlayerMetaSpriteAttackingR_0
	
	;(Other Player States)
	
PlayerMetaSpriteStandingU_0:
	.db 20			;5 sprites * 4 = 20
	.db 1,$14,%00000000,-1		;Xoffs,Tile,Attribs,Yoffs-1
	.db -3,$15,%00000000,7
	.db 5,$15,%01000000,7
	.db -3,$26,%00000000,15
	.db 5,$26,%01000000,15
PlayerMetaSpriteStandingD_0:
	.db 24
	.db -3,$05,%00000000,-1
	.db 5,$06,%00000000,-1
	.db -3,$15,%00000000,7
	.db 5,$15,%01000000,7
	.db -3,$25,%00000000,15
	.db 5,$25,%01000000,15
PlayerMetaSpriteStandingL_0:
	.db 16
	.db -3,$00,%00000000,-1
	.db 5,$01,%00000000,-1
	.db 1,$02,%00000000,7
	.db 1,$12,%00000000,15
PlayerMetaSpriteStandingR_0:
	.db 16
	.db -3,$01,%01000000,-1
	.db 5,$00,%01000000,-1
	.db 1,$02,%01000000,7
	.db 1,$12,%01000000,15
PlayerMetaSpriteWalkingU_0:
	.db 20
	.db 1,$14,%00000000,-1
	.db -3,$24,%00000000,7
	.db 5,$13,%00000000,7
	.db -3,$26,%00000000,15
	.db 5,$27,%01000000,15
PlayerMetaSpriteWalkingU_1:
	.db 20
	.db 1,$14,%00000000,-1
	.db -3,$13,%01000000,7
	.db 5,$24,%01000000,7
	.db -3,$27,%00000000,15
	.db 5,$26,%01000000,15
PlayerMetaSpriteWalkingD_0:
	.db 24
	.db -3,$05,%00000000,-1
	.db 5,$06,%00000000,-1
	.db -3,$24,%00000000,7
	.db 5,$13,%00000000,7
	.db -3,$16,%01000000,15
	.db 5,$25,%01000000,15
PlayerMetaSpriteWalkingD_1:
	.db 24
	.db -3,$05,%00000000,-1
	.db 5,$06,%00000000,-1
	.db -3,$13,%01000000,7
	.db 5,$24,%01000000,7
	.db -3,$25,%00000000,15
	.db 5,$16,%00000000,15
PlayerMetaSpriteWalkingL_0:
	.db 24
	.db -3,$00,%00000000,-1
	.db 5,$01,%00000000,-1
	.db -3,$10,%00000000,7
	.db 5,$11,%00000000,7
	.db -3,$20,%00000000,15
	.db 5,$21,%00000000,15
PlayerMetaSpriteWalkingL_1:
	.db 24
	.db -3,$00,%00000000,-1
	.db 5,$01,%00000000,-1
	.db -3,$22,%00000000,7
	.db 5,$23,%00000000,7
	.db -3,$20,%00000000,15
	.db 5,$04,%00000000,15
PlayerMetaSpriteWalkingR_0:
	.db 24
	.db -3,$01,%01000000,-1
	.db 5,$00,%01000000,-1
	.db -3,$11,%01000000,7
	.db 5,$10,%01000000,7
	.db -3,$21,%01000000,15
	.db 5,$20,%01000000,15
PlayerMetaSpriteWalkingR_1:
	.db 24
	.db -3,$01,%01000000,-1
	.db 5,$00,%01000000,-1
	.db -3,$23,%01000000,7
	.db 5,$22,%01000000,7
	.db -3,$04,%01000000,15
	.db 5,$20,%01000000,15
PlayerMetaSpriteAttackingU_0:
	.db 24
	.db -3,$17,%00000000,-1
	.db 1,$14,%00000000,-1
	.db -3,$19,%00000000,7
	.db 5,$13,%00000000,7
	.db -3,$27,%00000000,15
	.db 5,$26,%01000000,15
PlayerMetaSpriteAttackingD_0:
	.db 24
	.db -3,$05,%00000000,-1
	.db 5,$06,%00000000,-1
	.db -3,$24,%00000000,7
	.db 5,$18,%00000000,7
	.db -3,$25,%00000000,15
	.db 5,$07,%01000000,15
PlayerMetaSpriteAttackingL_0:
	.db 24
	.db -3,$00,%00000000,-1
	.db 5,$01,%00000000,-1
	.db -3,$08,%00000000,7
	.db 5,$09,%00000000,7
	.db -3,$20,%00000000,15
	.db 5,$21,%00000000,15
PlayerMetaSpriteAttackingR_0:
	.db 24
	.db -3,$01,%01000000,-1
	.db 5,$00,%01000000,-1
	.db -3,$09,%01000000,7
	.db 5,$08,%01000000,7
	.db -3,$21,%01000000,15
	.db 5,$20,%01000000,15
	
	
	;Player Weapon 0 - Knife
PlayerWeapon0MetaSprites:
	.dw PlayerWeapon0MetaSpritesNormal
	
PlayerWeapon0MetaSpritesNormal:
	.dw PlayerWeapon0MetaSpritesNormalU, PlayerWeapon0MetaSpritesNormalD, PlayerWeapon0MetaSpritesNormalL, PlayerWeapon0MetaSpritesNormalR
	
	;Player Weapon 0 - Normal
PlayerWeapon0MetaSpritesNormalU:
	.dw PlayerWeapon0MetaSpriteNormalU_0
PlayerWeapon0MetaSpritesNormalD:
	.dw PlayerWeapon0MetaSpriteNormalD_0
PlayerWeapon0MetaSpritesNormalL:
	.dw PlayerWeapon0MetaSpriteNormalL_0
PlayerWeapon0MetaSpritesNormalR:
	.dw PlayerWeapon0MetaSpriteNormalR_0
	
PlayerWeapon0MetaSpriteNormalU_0:
	.db 4
	.db 0,$35,%00000001,-1
PlayerWeapon0MetaSpriteNormalD_0:
	.db 4
	.db 0,$35,%11000001,-1
PlayerWeapon0MetaSpriteNormalL_0:
	.db 4
	.db 0,$32,%00000001,-1
PlayerWeapon0MetaSpriteNormalR_0:
	.db 4
	.db 0,$32,%01000001,-1
	
	
	;Enemy Snake
SnakeMetaSprites:
	.dw SnakeMetaSpritesSlithering, SnakeMetaSpritesSlithering, SnakeMetaSpritesSlithering, ExplosionMetaSprites
	
SnakeMetaSpritesSlithering:
	.dw SnakeMetaSpritesSlitheringU, SnakeMetaSpritesSlitheringD, SnakeMetaSpritesSlitheringL, SnakeMetaSpritesSlitheringR
	
SnakeMetaSpritesSlitheringU:
	.dw SnakeMetaSpritesSlitheringU_0, SnakeMetaSpritesSlitheringU_1, SnakeMetaSpritesSlitheringU_2, SnakeMetaSpritesSlitheringU_3
	.dw SnakeMetaSpritesSlitheringU_4, SnakeMetaSpritesSlitheringU_5, SnakeMetaSpritesSlitheringU_6, SnakeMetaSpritesSlitheringU_7
SnakeMetaSpritesSlitheringD:
	.dw SnakeMetaSpritesSlitheringD_0, SnakeMetaSpritesSlitheringD_1, SnakeMetaSpritesSlitheringD_2, SnakeMetaSpritesSlitheringD_3
	.dw SnakeMetaSpritesSlitheringD_4, SnakeMetaSpritesSlitheringD_5, SnakeMetaSpritesSlitheringD_6, SnakeMetaSpritesSlitheringD_7
SnakeMetaSpritesSlitheringL:
	.dw SnakeMetaSpritesSlitheringL_0, SnakeMetaSpritesSlitheringL_1, SnakeMetaSpritesSlitheringL_2, SnakeMetaSpritesSlitheringL_3
	.dw SnakeMetaSpritesSlitheringL_4, SnakeMetaSpritesSlitheringL_5, SnakeMetaSpritesSlitheringL_6, SnakeMetaSpritesSlitheringL_7
SnakeMetaSpritesSlitheringR:
	.dw SnakeMetaSpritesSlitheringR_0, SnakeMetaSpritesSlitheringR_1, SnakeMetaSpritesSlitheringR_2, SnakeMetaSpritesSlitheringR_3
	.dw SnakeMetaSpritesSlitheringR_4, SnakeMetaSpritesSlitheringR_5, SnakeMetaSpritesSlitheringR_6, SnakeMetaSpritesSlitheringR_7
	
SnakeMetaSpritesSlitheringU_0:
	.db 16
	.db 0,$81,%01000010,-1
	.db 8,$90,%11000010,-1
	.db 0,$81,%11000010,7
	.db 8,$80,%11000010,7
SnakeMetaSpritesSlitheringU_1:
	.db 16
	.db 0,$93,%11000010,-1
	.db 8,$92,%11000010,-1
	.db 0,$83,%11000010,7
	.db 8,$82,%11000010,7
SnakeMetaSpritesSlitheringU_2:
	.db 16
	.db 0,$95,%11000010,-1
	.db 8,$85,%00000010,-1
	.db 0,$85,%11000010,7
	.db 8,$84,%11000010,7
SnakeMetaSpritesSlitheringU_3:
	.db 16
	.db 0,$94,%11000010,-1
	.db 8,$83,%00000010,-1
	.db 0,$91,%11000010,7
	.db 8,$93,%00000010,7
SnakeMetaSpritesSlitheringU_4:
	.db 16
	.db 0,$90,%10000010,-1
	.db 8,$81,%00000010,-1
	.db 0,$80,%10000010,7
	.db 8,$81,%10000010,7
SnakeMetaSpritesSlitheringU_5:
	.db 16
	.db 0,$92,%10000010,-1
	.db 8,$93,%10000010,-1
	.db 0,$82,%10000010,7
	.db 8,$83,%10000010,7
SnakeMetaSpritesSlitheringU_6:
	.db 16
	.db 0,$85,%01000010,-1
	.db 8,$95,%10000010,-1
	.db 0,$84,%10000010,7
	.db 8,$85,%10000010,7
SnakeMetaSpritesSlitheringU_7:
	.db 16
	.db 0,$83,%01000010,-1
	.db 8,$94,%10000010,-1
	.db 0,$93,%01000010,7
	.db 8,$91,%10000010,7
SnakeMetaSpritesSlitheringD_0:
	.db 16
	.db 0,$80,%00000010,-1
	.db 8,$81,%00000010,-1
	.db 0,$90,%00000010,7
	.db 8,$81,%10000010,7
SnakeMetaSpritesSlitheringD_1:
	.db 16
	.db 0,$82,%00000010,-1
	.db 8,$83,%00000010,-1
	.db 0,$92,%00000010,7
	.db 8,$93,%00000010,7
SnakeMetaSpritesSlitheringD_2:
	.db 16
	.db 0,$84,%00000010,-1
	.db 8,$85,%00000010,-1
	.db 0,$85,%11000010,7
	.db 8,$95,%00000010,7
SnakeMetaSpritesSlitheringD_3:
	.db 16
	.db 0,$93,%11000010,-1
	.db 8,$91,%00000010,-1
	.db 0,$83,%11000010,7
	.db 8,$94,%00000010,7
SnakeMetaSpritesSlitheringD_4:
	.db 16
	.db 0,$81,%01000010,-1
	.db 8,$80,%01000010,-1
	.db 0,$81,%11000010,7
	.db 8,$90,%01000010,7
SnakeMetaSpritesSlitheringD_5:
	.db 16
	.db 0,$83,%01000010,-1
	.db 8,$82,%01000010,-1
	.db 0,$93,%01000010,7
	.db 8,$92,%01000010,7
SnakeMetaSpritesSlitheringD_6:
	.db 16
	.db 0,$85,%01000010,-1
	.db 8,$84,%01000010,-1
	.db 0,$95,%01000010,7
	.db 8,$85,%10000010,7
SnakeMetaSpritesSlitheringD_7:
	.db 16
	.db 0,$91,%01000010,-1
	.db 8,$93,%10000010,-1
	.db 0,$94,%01000010,7
	.db 8,$83,%10000010,7
SnakeMetaSpritesSlitheringL_0:
	.db 16
	.db 0,$97,%11000010,-1
	.db 8,$96,%11000010,-1
	.db 0,$86,%10000010,7
	.db 8,$86,%11000010,7
SnakeMetaSpritesSlitheringL_1:
	.db 16
	.db 0,$99,%11000010,-1
	.db 8,$98,%11000010,-1
	.db 0,$89,%11000010,7
	.db 8,$88,%11000010,7
SnakeMetaSpritesSlitheringL_2:
	.db 16
	.db 0,$8A,%00000010,-1
	.db 8,$9A,%11000010,-1
	.db 0,$8B,%11000010,7
	.db 8,$8A,%11000010,7
SnakeMetaSpritesSlitheringL_3:
	.db 16
	.db 0,$88,%00000010,-1
	.db 8,$89,%00000010,-1
	.db 0,$9B,%11000010,7
	.db 8,$87,%11000010,7
SnakeMetaSpritesSlitheringL_4:
	.db 16
	.db 0,$86,%00000010,-1
	.db 8,$86,%01000010,-1
	.db 0,$97,%01000010,7
	.db 8,$96,%01000010,7
SnakeMetaSpritesSlitheringL_5:
	.db 16
	.db 0,$89,%01000010,-1
	.db 8,$88,%01000010,-1
	.db 0,$99,%01000010,7
	.db 8,$98,%01000010,7
SnakeMetaSpritesSlitheringL_6:
	.db 16
	.db 0,$8B,%01000010,-1
	.db 8,$8A,%01000010,-1
	.db 0,$8A,%10000010,7
	.db 8,$9A,%01000010,7
SnakeMetaSpritesSlitheringL_7:
	.db 16
	.db 0,$9B,%01000010,-1
	.db 8,$87,%01000010,-1
	.db 0,$88,%10000010,7
	.db 8,$89,%10000010,7
SnakeMetaSpritesSlitheringR_0:
	.db 16
	.db 0,$86,%00000010,-1
	.db 8,$86,%01000010,-1
	.db 0,$96,%00000010,7
	.db 8,$97,%00000010,7
SnakeMetaSpritesSlitheringR_1:
	.db 16
	.db 0,$88,%00000010,-1
	.db 8,$89,%00000010,-1
	.db 0,$98,%00000010,7
	.db 8,$99,%00000010,7
SnakeMetaSpritesSlitheringR_2:
	.db 16
	.db 0,$8A,%00000010,-1
	.db 8,$8B,%00000010,-1
	.db 0,$9A,%00000010,7
	.db 8,$8A,%11000010,7
SnakeMetaSpritesSlitheringR_3:
	.db 16
	.db 0,$87,%00000010,-1
	.db 8,$9B,%00000010,-1
	.db 0,$89,%11000010,7
	.db 8,$88,%11000010,7
SnakeMetaSpritesSlitheringR_4:
	.db 16
	.db 0,$96,%10000010,-1
	.db 8,$97,%10000010,-1
	.db 0,$86,%10000010,7
	.db 8,$86,%11000010,7
SnakeMetaSpritesSlitheringR_5:
	.db 16
	.db 0,$98,%10000010,-1
	.db 8,$99,%10000010,-1
	.db 0,$88,%10000010,7
	.db 8,$89,%10000010,7
SnakeMetaSpritesSlitheringR_6:
	.db 16
	.db 0,$9A,%10000010,-1
	.db 8,$8A,%01000010,-1
	.db 0,$8A,%10000010,7
	.db 8,$8B,%10000010,7
SnakeMetaSpritesSlitheringR_7:
	.db 16
	.db 0,$89,%01000010,-1
	.db 8,$88,%01000010,-1
	.db 0,$87,%10000010,7
	.db 8,$9B,%10000010,7

ExplosionMetaSprites:
	.dw ExplosionMetaSprite, ExplosionMetaSprite, ExplosionMetaSprite, ExplosionMetaSprite

ExplosionMetaSprite:
	.dw ExplosionMetaSprite_0
	
ExplosionMetaSprite_0:
	.db 16
	.db 0,$43,%00000011,-1
	.db 8,$43,%01000011,-1
	.db 0,$43,%10000011,7
	.db 8,$43,%11000011,7
	
	
	;Jar
JarMetaSprites:
	.dw JarMetaSpritesNormal, JarMetaSpritesCollected

JarMetaSpritesNormal:
JarMetaSpritesCollected:
	.dw JarMetaSpritesNormalU
	
JarMetaSpritesNormalU:
	.dw JarMetaSpritesNormalU_0
	
JarMetaSpritesNormalU_0:
	.db 4
	.db 0,$50,%00000010,-1
	
	
	;Heart
HeartMetaSprites:
	.dw HeartMetaSpritesNormal, HeartMetaSpritesCollected
	
HeartMetaSpritesNormal:
HeartMetaSpritesCollected:
	.dw HeartMetaSpritesNormalU, HeartMetaSpritesNormalU, HeartMetaSpritesNormalU, HeartMetaSpritesNormalU
	
HeartMetaSpritesNormalU:
	.dw HeartMetaSpritesNormalU_0
	
HeartMetaSpritesNormalU_0:
	.db 4
	.db 0,$54,%00000011,-1
	
	
	;Meat
MeatMetaSprites:
	.dw MeatMetaSpritesNormal, MeatMetaSpritesCollected
	
MeatMetaSpritesNormal:
MeatMetaSpritesCollected:
	.dw MeatMetaSpritesNormalU, MeatMetaSpritesNormalU, MeatMetaSpritesNormalU, MeatMetaSpritesNormalU
	
MeatMetaSpritesNormalU:
	.dw MeatMetaSpritesNormalU_0
	
MeatMetaSpritesNormalU_0:
	.db 4
	.db 0,$41,%00000011,-1
	
	
	;beehive
BeehiveMetaSprites:
	.dw BeehiveMetaSpritesNormal, ExplosionMetaSprites
	
BeehiveMetaSpritesNormal:
	.dw BeehiveMetaSpritesNormalU, BeehiveMetaSpritesNormalU, BeehiveMetaSpritesNormalU, BeehiveMetaSpritesNormalU
BeehiveMetaSpritesNormalU:
	.dw BeehiveMetaSpritesNormalU_0
	
BeehiveMetaSpritesNormalU_0:
	.db 16
	.db 0,$70,%00000010,-1
	.db 8,$71,%00000010,-1
	.db 0,$72,%00000010,7
	.db 8,$73,%00000010,7
	
	
	;bee
BeeMetaSprites:
	;foraging, returning, guarding hive, swarming, on player attacking, on flower, hit
	.dw BeeMetaSpritesFlying, BeeMetaSpritesFlying, BeeMetaSpritesNormal, BeeMetaSpritesFlying, BeeMetaSpritesFlying, BeeMetaSpritesFlying, ExplosionMetaSprites
	
BeeMetaSpritesNormal:
	.dw BeeMetaSpritesNormalU,BeeMetaSpritesNormalD,BeeMetaSpritesNormalL,BeeMetaSpritesNormalR
BeeMetaSpritesFlying:
	.dw BeeMetaSpritesFlyingU,BeeMetaSpritesFlyingD,BeeMetaSpritesFlyingL,BeeMetaSpritesFlyingR
	
BeeMetaSpritesNormalU:
	.dw BeeMetaSpritesFlyingU_0
BeeMetaSpritesNormalD:
	.dw BeeMetaSpritesFlyingD_0
BeeMetaSpritesNormalL:
	.dw BeeMetaSpritesFlyingL_0
BeeMetaSpritesNormalR:
	.dw BeeMetaSpritesFlyingR_0

BeeMetaSpritesFlyingU:
	.dw BeeMetaSpritesFlyingU_0,BeeMetaSpritesFlyingU_1
BeeMetaSpritesFlyingD:
	.dw BeeMetaSpritesFlyingD_0,BeeMetaSpritesFlyingD_1
BeeMetaSpritesFlyingL:
	.dw BeeMetaSpritesFlyingL_0,BeeMetaSpritesFlyingL_1
BeeMetaSpritesFlyingR:
	.dw BeeMetaSpritesFlyingR_0,BeeMetaSpritesFlyingR_1
	
BeeMetaSpritesFlyingU_0:
	.db 4
	.db 0,$60,%00000010,-1
BeeMetaSpritesFlyingU_1:
	.db 4
	.db 0,$61,%00000010,-1
BeeMetaSpritesFlyingD_0:
	.db 4
	.db 0,$60,%10000010,-1
BeeMetaSpritesFlyingD_1:
	.db 4
	.db 0,$61,%10000010,-1
BeeMetaSpritesFlyingL_0:
	.db 4
	.db 0,$62,%01000010,-1
BeeMetaSpritesFlyingL_1:
	.db 4
	.db 0,$63,%01000010,-1
BeeMetaSpritesFlyingR_0:
	.db 4
	.db 0,$62,%00000010,-1
BeeMetaSpritesFlyingR_1:
	.db 4
	.db 0,$63,%00000010,-1
	
	
	;player weapon 1 - bullets
BulletMetaSprites:
	.dw BulletMetaSpritesNormal
	
BulletMetaSpritesNormal:
	.dw BulletMetaSpritesNormalU, BulletMetaSpritesNormalD, BulletMetaSpritesNormalL, BulletMetaSpritesNormalR
	
BulletMetaSpritesNormalU:
	.dw BulletMetaSpritesNormalU_0
BulletMetaSpritesNormalD:
	.dw BulletMetaSpritesNormalD_0
BulletMetaSpritesNormalL:
	.dw BulletMetaSpritesNormalL_0
BulletMetaSpritesNormalR:
	.dw BulletMetaSpritesNormalR_0
	
BulletMetaSpritesNormalU_0:
	.db 4
	.db -3,$3A,%00000001,-4
BulletMetaSpritesNormalD_0:
	.db 4
	.db  -3,$3A,%10000001,-3
BulletMetaSpritesNormalL_0:
	.db 4
	.db -3,$3B,%00000001,-4
BulletMetaSpritesNormalR_0:
	.db 4
	.db -2,$3B,%01000001,-4
	
	
	;player weapon 1a - gun
GunMetaSprites:
	.dw GunMetaSpritesFiring, GunMetaSpritesNormal
	
GunMetaSpritesFiring:
	.dw GunMetaSpritesFiringU, GunMetaSpritesFiringD, GunMetaSpritesFiringL, GunMetaSpritesFiringR
GunMetaSpritesNormal:
	.dw GunMetaSpritesNormalU, GunMetaSpritesNormalD, GunMetaSpritesNormalL, GunMetaSpritesNormalR
	
GunMetaSpritesFiringU:
	.dw GunMetaSpritesFiringU_0
GunMetaSpritesFiringD:
	.dw GunMetaSpritesFiringD_0
GunMetaSpritesFiringL:
	.dw GunMetaSpritesFiringL_0
GunMetaSpritesFiringR:
	.dw GunMetaSpritesFiringR_0
	
GunMetaSpritesNormalU:
	.dw GunMetaSpritesNormalU_0
GunMetaSpritesNormalD:
	.dw GunMetaSpritesNormalD_0
GunMetaSpritesNormalL:
	.dw GunMetaSpritesNormalL_0
GunMetaSpritesNormalR:
	.dw GunMetaSpritesNormalR_0
	
GunMetaSpritesFiringU_0:
	.db 20
	.db 0,$3F,%00000001,-1
	.db 8,$3F,%01000001,-1
	.db 0,$3E,%00000001,7
	.db 8,$3E,%01000001,7
	.db 4,$49,%00000001,15
GunMetaSpritesFiringD_0:
	.db 20
	.db 4,$49,%10000001,-1
	.db 0,$3E,%10000001,7
	.db 8,$3E,%11000001,7
	.db 0,$3F,%10000001,15
	.db 8,$3F,%11000001,15
GunMetaSpritesFiringL_0:
	.db 20
	.db 0,$3D,%01000001,-1
	.db 8,$3C,%01000001,-1
	.db 16,$48,%00000001,5
	.db 0,$3D,%11000001,7
	.db 8,$3C,%11000001,7
GunMetaSpritesFiringR_0:
	.db 20
	.db 0,$48,%01000001,5
	.db 8,$3C,%00000001,-1
	.db 16,$3D,%00000001,-1
	.db 8,$3C,%10000001,7
	.db 16,$3D,%10000001,7
GunMetaSpritesNormalU_0:
	.db 4
	.db 4,$49,%00000001,15
GunMetaSpritesNormalD_0:
	.db 4
	.db 4,$49,%10000001,-1
GunMetaSpritesNormalL_0:
	.db 4
	.db 16,$48,%00000001,5
GunMetaSpritesNormalR_0:
	.db 4
	.db 0,$48,%01000001,5
	
	
	;door
DoorMetaSprites:
	.dw DoorMetaSpritesNormal
	
DoorMetaSpritesNormal:
	.dw DoorMetaSpritesNormalU, DoorMetaSpritesNormalU, DoorMetaSpritesNormalU, DoorMetaSpritesNormalU
	
DoorMetaSpritesNormalU:
	.dw DoorMetaSpritesNormalU_0
	
DoorMetaSpritesNormalU_0:
	.db 0						;Don't draw any sprites for this ent
	
	
	;crab
CrabMetaSprites:
	;walking, still, grabbing, flying, hit
	.dw CrabMetaSpritesWalking, CrabMetaSpritesWalking, CrabMetaSpritesWalking, CrabMetaSpritesWalking, ExplosionMetaSprites
	
CrabMetaSpritesWalking:
	.dw CrabMetaSpritesWalkingU, CrabMetaSpritesWalkingU, CrabMetaSpritesWalkingU, CrabMetaSpritesWalkingU
	
CrabMetaSpritesWalkingU:
	.dw CrabMetaSpritesWalkingU_0, CrabMetaSpritesWalkingU_1, CrabMetaSpritesWalkingU_2, CrabMetaSpritesWalkingU_3
	
CrabMetaSpritesWalkingU_0:
	.db 16
	.db 0,$64,%00000010,-1
	.db 8,$64,%01000010,-1
	.db 0,$74,%00000010,7
	.db 8,$74,%01000010,7
CrabMetaSpritesWalkingU_1:
	.db 16
	.db 0,$64,%00000010,-1
	.db 8,$65,%00000010,-1
	.db 0,$75,%00000010,7
	.db 8,$76,%00000010,7
CrabMetaSpritesWalkingU_2:
	.db 16
	.db 0,$64,%00000010,-1
	.db 8,$64,%01000010,-1
	.db 0,$66,%00000010,7
	.db 8,$66,%01000010,7
CrabMetaSpritesWalkingU_3:
	.db 16
	.db 0,$65,%01000010,-1
	.db 8,$64,%01000010,-1
	.db 0,$76,%01000010,7
	.db 8,$75,%01000010,7
	
	
	;machete (Both collectable and weapon)
MacheteColMetaSpites:
	.dw MacheteColMetaSpritesNormal

MacheteColMetaSpritesNormal:
	.dw MacheteColMetaSpritesNormalU
	
MacheteColMetaSpritesNormalU:
	.dw MacheteColMetaSpritesNormalU_0
	
MacheteColMetaSpritesNormalU_0:
	.db 12
	.db 0,$36,%00000010,3
	.db 8,$37,%00000010,3
	.db 16,$4A,%00000010,3
	
MacheteMetaSprites:
	.dw MacheteMetaSpritesNormal
	
MacheteMetaSpritesNormal:
	.dw MacheteMetaSpritesNormalU,MacheteMetaSpritesNormalD,MacheteMetaSpritesNormalL,MacheteMetaSpritesNormalR
	
MacheteMetaSpritesNormalU:
	.dw MacheteMetaSpritesNormalU_0
MacheteMetaSpritesNormalD:
	.dw MacheteMetaSpritesNormalD_0
MacheteMetaSpritesNormalL:
	.dw MacheteMetaSpritesNormalL_0
MacheteMetaSpritesNormalR:
	.dw MacheteMetaSpritesNormalR_0
	
MacheteMetaSpritesNormalU_0:
	.db 8
	.db 0,$38,%00000001,-1
	.db 0,$39,%00000001,7
MacheteMetaSpritesNormalD_0:
	.db 8
	.db 0,$39,%11000001,-1
	.db 0,$38,%11000001,7
MacheteMetaSpritesNormalL_0:
	.db 8
	.db 0,$36,%00000001,-1
	.db 8,$37,%00000001,-1
MacheteMetaSpritesNormalR_0:
	.db 8
	.db 0,$37,%01000001,-1
	.db 8,$36,%01000001,-1
	
	
	;stick (collectible and weapon)
StickColMetaSprites:
	.dw StickColMetaSpritesNormal,StickColMetaSpritesCollected

StickColMetaSpritesNormal:
StickColMetaSpritesCollected:
	.dw StickColMetaSpritesNormalU
	
StickColMetaSpritesNormalU:
	.dw StickColMetaSpritesNormalU_0

StickColMetaSpritesNormalU_0:
	.db 12
	.db 0,$55,%00000000,-1
	.db 0,$56,%00000000,7
	.db 8,$57,%00000000,7
	
StickMetaSprites:
	.dw StickMetaSpritesNormal
	
StickMetaSpritesNormal:
	.dw StickMetaSpritesNormalU,StickMetaSpritesNormalD,StickMetaSpritesNormalL,StickMetaSpritesNormalR
	
StickMetaSpritesNormalU:
	.dw StickMetaSpritesNormalU_0
StickMetaSpritesNormalD:
	.dw StickMetaSpritesNormalD_0
StickMetaSpritesNormalL:
	.dw StickMetaSpritesNormalL_0
StickMetaSpritesNormalR:
	.dw StickMetaSpritesNormalR_0
	
StickMetaSpritesNormalU_0:
StickMetaSpritesNormalD_0:
	.db 16
	.db 0,$34,%00000000,-1
	.db 0,$34,%00000000,7
	.db 0,$34,%00000000,15
	.db 0,$34,%00000000,23
StickMetaSpritesNormalL_0:
StickMetaSpritesNormalR_0:
	.db 16
	.db 0,$31,%00000000,-1
	.db 8,$31,%00000000,-1
	.db 16,$31,%00000000,-1
	.db 24,$31,%00000000,-1
	
	
	;stone
StoneMetaSprites:
	.dw StoneMetaSpritesNormal,StoneMetaSpritesCollected
	
StoneMetaSpritesNormal:
StoneMetaSpritesCollected:
	.dw StoneMetaSpritesNormalU
	
StoneMetaSpritesNormalU:
	.dw StoneMetaSpritesNormalU_0
	
StoneMetaSpritesNormalU_0:
	.db 4
	.db 0,$59,%00000010,-1
	
	
	;flint
FlintMetaSprites:
	.dw FlintMetaSpritesNormal,FlintMetaSpritesCollected
	
FlintMetaSpritesNormal:
FlintMetaSpritesCollected:
	.dw FlintMetaSpritesNormalU
	
FlintMetaSpritesNormalU:
	.dw FlintMetaSpritesNormalU_0
	
FlintMetaSpritesNormalU_0:
	.db 4
	.db 0,$58,%00000010,-1
	
	
	;spear
SpearMetaSprites:
	.dw SpearMetaSpritesNormal
	
SpearMetaSpritesNormal:
	.dw SpearMetaSpritesNormalU,SpearMetaSpritesNormalD,SpearMetaSpritesNormalL,SpearMetaSpritesNormalR
	
SpearMetaSpritesNormalU:
	.dw SpearMetaSpritesNormalU_0
SpearMetaSpritesNormalD:
	.dw SpearMetaSpritesNormalD_0
SpearMetaSpritesNormalL:
	.dw SpearMetaSpritesNormalL_0
SpearMetaSpritesNormalR:
	.dw SpearMetaSpritesNormalR_0
	
SpearMetaSpritesNormalU_0:
	.db 20
	.db 0,$33,%00000001,-1
	.db 0,$34,%00000000,7
	.db 0,$34,%00000000,15
	.db 0,$34,%00000000,23
	.db 0,$34,%00000001,31
SpearMetaSpritesNormalD_0:
	.db 20
	.db 0,$34,%00000000,-1
	.db 0,$34,%00000000,7
	.db 0,$34,%00000000,15
	.db 0,$34,%00000000,23
	.db 0,$33,%10000001,31
SpearMetaSpritesNormalL_0:
	.db 20
	.db 0,$30,%00000001,-1
	.db 8,$31,%00000000,-1
	.db 16,$31,%00000000,-1
	.db 24,$31,%00000000,-1
	.db 32,$31,%00000000,-1
SpearMetaSpritesNormalR_0:
	.db 20
	.db 0,$31,%00000000,-1
	.db 8,$31,%00000000,-1
	.db 16,$31,%00000000,-1
	.db 24,$31,%00000000,-1
	.db 32,$30,%01000001,-1
	
	
	;cloth
ClothMetaSprites:
	.dw ClothMetaSpritesNormal,ClothMetaSpritesCollected
	
ClothMetaSpritesNormal:
ClothMetaSpritesCollected:
	.dw ClothMetaSpritesNormalU
	
ClothMetaSpritesNormalU:
	.dw ClothMetaSpritesNormalU_0
	
ClothMetaSpritesNormalU_0:
	.db 4
	.db 0,$40,%00000010,-1
	
	
	;bat
BatMetaSprites:
	.dw BatMetaSpritesPerched,BatMetaSpritesFlying,BatMetaSpritesGliding,ExplosionMetaSprites
	
BatMetaSpritesPerched:
	.dw BatMetaSpritesPerchedU
BatMetaSpritesFlying:
	.dw BatMetaSpritesFlyingL,BatMetaSpritesFlyingR
BatMetaSpritesGliding:
	.dw BatMetaSpritesGlidingL,BatMetaSpritesGlidingR
	
BatMetaSpritesPerchedU:
	.dw BatMetaSpritesPerchedU_0
	
BatMetaSpritesFlyingL:
	.dw BatMetaSpritesFlyingL_0,BatMetaSpritesFlyingL_1
BatMetaSpritesFlyingR:
	.dw BatMetaSpritesFlyingR_0,BatMetaSpritesFlyingR_1
	
BatMetaSpritesGlidingL:
	.dw BatMetaSpritesFlyingL_0
BatMetaSpritesGlidingR:
	.dw BatMetaSpritesFlyingR_0
	
BatMetaSpritesPerchedU_0:
	.db 4
	.db 0,$B0,%00000010,-1
BatMetaSpritesFlyingL_0:
	.db 4
	.db 0,$B1,%01000010,-1
BatMetaSpritesFlyingL_1:
	.db 4
	.db 0,$B2,%01000010,-1
BatMetaSpritesFlyingR_0:
	.db 4
	.db 0,$B1,%00000010,-1
BatMetaSpritesFlyingR_1:
	.db 4
	.db 0,$B2,%00000010,-1
	
	
	;honeycomb
HoneycombMetaSprites:
	.dw HoneycombMetaSpritesNormal,HoneycombMetaSpritesCollected
	
HoneycombMetaSpritesNormal:
HoneycombMetaSpritesCollected:
	.dw HoneycombMetaSpritesNormalU
	
HoneycombMetaSpritesNormalU:
	.dw HoneycombMetaSpritesNormalU_0
	
HoneycombMetaSpritesNormalU_0:
	.db 4
	.db 0,$76,%00000010,-1
	
	
	;(other ents)
	
	
	;Animation Lengths
EntAnimationLengths:
	.dw PlayerAnimationLengths, PlayerWeapon0AnimationLengths, SnakeAnimationLengths, JarAnimationLengths, HeartAnimationLengths, MeatAnimationLengths, BeehiveAnimationLengths, BeeAnimationLengths
	.dw GunAnimationLengths, BulletAnimationLengths, DoorAnimationLengths, CrabAnimationLengths, MacheteColAnimationLengths, MacheteAnimationLengths, StickColAnimationLengths, StickAnimationLengths
	.dw StoneAnimationLengths, FlintAnimationLengths, SpearAnimationLengths, ClothAnimationLengths, BatAnimationLengths, SnakeAnimationLengths, HoneycombAnimationLengths
	
	
	;Player
PlayerAnimationLengths:
	;sorted by state
	.db 1,16,1
	
	;Player Weapon 0 - Knife
	;Jar
PlayerWeapon0AnimationLengths:
JarAnimationLengths:
HeartAnimationLengths:
MeatAnimationLengths:
BeehiveAnimationLengths:
GunAnimationLengths:
BulletAnimationLengths:
DoorAnimationLengths:
MacheteColAnimationLengths:
MacheteAnimationLengths:
StickColAnimationLengths:
StickAnimationLengths:
StoneAnimationLengths:
FlintAnimationLengths:
SpearAnimationLengths:
ClothAnimationLengths:
HoneycombAnimationLengths:
	.db 1,1
SnakeAnimationLengths:
	.db 8,4,8
BeeAnimationLengths:
	.db 4,4,1,4,4,1,1
CrabAnimationLengths:
	.db 4,4,4,4,1
BatAnimationLengths:
	.db 4,6,6,1
	
	;(other ents)
	
	
	;Animation Frames
EntAnimationFrames:
	.dw PlayerAnimationFrames, PlayerWeapon0AnimationFrames, SnakeAnimationFrames, JarAnimationFrames, HeartAnimationFrames, MeatAnimationFrames, BeehiveAnimationFrames, BeeAnimationFrames
	.dw GunAnimationFrames, BulletAnimationFrames, DoorAnimationFrames, CrabAnimationFrames, MacheteColAnimationFrames, MacheteAnimationFrames, StickColAnimationFrames, StickAnimationFrames
	.dw StoneAnimationFrames, FlintAnimationFrames, SpearAnimationFrames, ClothAnimationFrames, BatAnimationFrames, SnakeAnimationFrames, HoneycombAnimationFrames
	

PlayerAnimationFrames:
	;sorted by state
	.db 1,4,1
PlayerWeapon0AnimationFrames:
JarAnimationFrames:
HeartAnimationFrames:
MeatAnimationFrames:
GunAnimationFrames:
BulletAnimationFrames:
DoorAnimationFrames:
MacheteColAnimationFrames:
MacheteAnimationFrames:
StickColAnimationFrames:
StickAnimationFrames:
StoneAnimationFrames:
FlintAnimationFrames:
SpearAnimationFrames:
ClothAnimationFrames:
HoneycombAnimationFrames:
	.db 1,1
BeehiveAnimationFrames
SnakeAnimationFrames:
	.db 8,8,8,1
BeeAnimationFrames:
	.db 2,2,1,2,2,1,1
CrabAnimationFrames:
	.db 4,4,4,4,1
BatAnimationFrames:
	.db 1,2,1,1
	
	
	;Hitbox sizes (width and height, respectively)
	;As of 6/20/17 I've decided that hitbox sizes will only be dependent upon ent ID, state and direction. Individual animation frames for each state must have the same hitbox sizes
EntHitboxSizes:
	.dw PlayerHitboxSizes, PlayerWeapon0HitboxSizes, SnakeHitboxSizes, JarHitboxSizes, HeartHitboxSizes, MeatHitboxSizes, BeehiveHitboxSizes, BeeHitboxSizes
	.dw GunHitboxSizes, BulletHitboxSizes, DoorHitboxSizes, CrabHitboxSizes, MacheteColHitboxSizes, MacheteHitboxSizes, StickColHitboxSizes, StickHitboxSizes
	.dw StoneHitboxSizes, FlintHitboxSizes, SpearHitboxSizes, ClothHitboxSizes, BatHitboxSizes, SnakeHitboxSizes, HoneycombHitboxSizes
	
	
;Lots of ents use 7x7 and 15x15 for all their states, so these are here to avoid a lot of repeated data
HitboxSize7x7:
	.db 7,7, 7,7, 7,7, 7,7
HitboxSize15x15:
	.db 15,15, 15,15, 15,15, 15,15
	
	
	;Player
PlayerHitboxSizes:
	.dw PlayerHitboxSizesStanding, PlayerHitboxSizesWalking, PlayerHitboxSizesAttacking
	
PlayerHitboxSizesStanding:
PlayerHitboxSizesWalking:
	;sorted by direction
	.db 9,23, 9,23, 9,23, 9,23
PlayerHitboxSizesAttacking:
	.db 9,23, 9,15, 9,23, 9,23
	

PlayerWeapon0HitboxSizes:
	.dw PlayerWeapon0HitboxSizesNormal
PlayerWeapon0HitboxSizesNormal:
	.db 7,7, 7,15, 7,7, 7,7				;since the knife is so small, it's fair that its hitbox is technically longer when facing down so that you can actually attack while facing down
	
	
SnakeHitboxSizes:
CrabHitboxSizes:
	.dw HitboxSize15x15, HitboxSize15x15, HitboxSize15x15, HitboxSize15x15, HitboxSize15x15
	
	
JarHitboxSizes:
HeartHitboxSizes:
MeatHitboxSizes:
StoneHitboxSizes:
FlintHitboxSizes:
ClothHitboxSizes:
HoneycombHitboxSizes:
	.dw HitboxSize7x7, HitboxSize7x7
BeehiveHitboxSizes:
DoorHitboxSizes:
MacheteColHitboxSizes:
StickColHitboxSizes:
	.dw HitboxSize15x15
BeeHitboxSizes:
	.dw HitboxSize7x7, HitboxSize7x7, HitboxSize7x7, HitboxSize7x7, HitboxSize7x7, HitboxSize7x7, HitboxSize7x7, HitboxSize15x15
BatHitboxSizes:
	.dw HitboxSize7x7, HitboxSize7x7, HitboxSize7x7, HitboxSize15x15
	
	
BulletHitboxSizes:
	.dw BulletHitboxSizesNormal
BulletHitboxSizesNormal:
	.dw 2,15, 2,15, 15,2, 15,2
	
	
GunHitboxSizes:
	.dw GunHitboxSizesFiring, GunHitboxSizesNormal
GunHitboxSizesFiring:
GunHitboxSizesNormal:
	.db 15,23, 15,23, 23,15, 23,15
	
MacheteHitboxSizes:
	.dw MacheteHitboxSizesNormal
MacheteHitboxSizesNormal:
	.db 7,15, 7,15, 15,7, 15,7
	
StickHitboxSizes:
	.dw StickHitboxSizesNormal
StickHitboxSizesNormal:
	.db 7,31, 7,31, 31,7, 31,7
	
SpearHitboxSizes:
	.dw SpearHitboxSizesNormal
SpearHitboxSizesNormal:
	.db 7,39, 7,39, 39,7, 39,7
	

	;(Other ents here)