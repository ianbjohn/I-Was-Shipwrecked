MetaTileBanks:
	.dw MetaTileBank0,MetaTileBank1
	
	
MetaTileBank0:
	.dw MetaTile0_00,MetaTile0_01,MetaTile0_02,MetaTile0_03,MetaTile0_04,MetaTile0_05,MetaTile0_06,MetaTile0_07
	.dw MetaTile0_08,MetaTile0_09,MetaTile0_0A,MetaTile0_0B,MetaTile0_0C,MetaTile0_0D,MetaTile0_0E,MetaTile0_0F
	.dw MetaTile0_10,MetaTile0_11,MetaTile0_12,MetaTile0_13,MetaTile0_14,MetaTile0_15,MetaTile0_16,MetaTile0_17
	.dw MetaTile0_18,MetaTile0_19,MetaTile0_1A,MetaTile0_1B,MetaTile0_1C,MetaTile0_1D,MetaTile0_1E,MetaTile0_1F
	.dw MetaTile0_20,MetaTile0_21,MetaTile0_22,MetaTile0_23,MetaTile0_24,MetaTile0_25,MetaTile0_26,MetaTile0_27
	.dw MetaTile0_28,MetaTile0_29,MetaTile0_2A,MetaTile0_2B,MetaTile0_2C,MetaTile0_2D,MetaTile0_2E,MetaTile0_2F
	.dw MetaTile0_30,MetaTile0_31,MetaTile0_32,MetaTile0_33,MetaTile0_34,MetaTile0_35,MetaTile0_36,MetaTile0_37
	.dw MetaTile0_38,MetaTile0_39,MetaTile0_3A,MetaTile0_3B,MetaTile0_3C,MetaTile0_3D,MetaTile0_3E,MetaTile0_3F
	.dw MetaTile0_40
MetaTileBank1:
	.dw MetaTile1_00,MetaTile1_01,MetaTile1_02,MetaTile1_03,MetaTile1_04,MetaTile1_05,MetaTile1_06,MetaTile1_07
	.dw MetaTile1_08,MetaTile1_09,MetaTile1_0A,MetaTile1_0B,MetaTile1_0C,MetaTile1_0D,MetaTile1_0E,MetaTile1_0F
	.dw MetaTile1_10,MetaTile1_11,MetaTile1_12,MetaTile1_13,MetaTile1_14,MetaTile1_15,MetaTile1_16,MetaTile1_17
	.dw MetaTile1_18,MetaTile1_19,MetaTile1_1A,MetaTile1_1B,MetaTile1_1C,MetaTile1_1D,MetaTile1_1E,MetaTile1_1F
	.dw MetaTile1_20,MetaTile1_21,MetaTile1_22,MetaTile1_23,MetaTile1_24,MetaTile1_25,MetaTile1_26,MetaTile1_27
	.dw MetaTile1_28,MetaTile1_29,MetaTile1_2A,MetaTile1_2B,MetaTile1_2C,MetaTile1_2D,MetaTile1_2E,MetaTile1_2F
	.dw MetaTile1_30,MetaTile1_31,MetaTile1_32,MetaTile1_33,MetaTile1_34,MetaTile1_35,MetaTile1_36,MetaTile1_37
	
	;0-non-interactable (not solid), 1-salt water,  2-non-interactable (solid), 3-fresh water, 4 - Solid that can be destroyed by machete, 5 - Harms player and can be destroyed by machete, 6 - Solid that can be destroyed by regular knife
MetaTile0_00:
	;regular sand
	;4 Tile0_s, collision type
	.db $4C,$4C,$4C,$4C, $00
MetaTile0_01:
	.db $44,$4A,$48,$4C, $00
MetaTile0_02:
	.db $4A,$4A,$4C,$4C, $00
MetaTile0_03:
	.db $4A,$45,$4C,$49, $00
MetaTile0_04:
	.db $48,$4C,$48,$4C, $00
MetaTile0_05:
	.db $4C,$49,$4C,$49, $00
MetaTile0_06:
	.db $48,$4C,$46,$4B, $00
MetaTile0_07:
	.db $4C,$4C,$4B,$4B, $00
MetaTile0_08:
	.db $4C,$49,$4B,$47, $00
	
MetaTile0_09:
	;sea
	.db $40,$40,$40,$40, $01
	
MetaTile0_0A:
	;palm trees
	.db $50,$51,$60,$61, $02
MetaTile0_0B:
	.db $52,$53,$62,$63, $02
MetaTile0_0C:
	.db $54,$55,$64,$65, $02
	
MetaTile0_0D:
	;jungle front
	.db $43,$43,$56,$57, $02
MetaTile0_0E:
	.db $66,$67,$58,$59, $02
MetaTile0_0F:
	.db $68,$69,$5A,$5B, $02
MetaTile0_10:
	.db $43,$43,$43,$43, $02

MetaTile0_11:
	;fresh water
	.db $43,$43,$43,$43, $03
	
MetaTile0_12:
	;more jungle
	.db $5C,$6B,$6C,$43, $02
MetaTile0_13:
	.db $6A,$6B,$43,$43, $02
MetaTile0_14:
	.db $6A,$5D,$43,$6E, $02
MetaTile0_15:
	.db $6D,$43,$6C,$43, $02
MetaTile0_16:
	.db $43,$6F,$43,$6E, $02
MetaTile0_17:
	.db $6D,$43,$5E,$57, $02
MetaTile0_18:
	.db $43,$6F,$56,$5F, $02
MetaTile0_19:
	.db $5C,$6B,$5C,$57, $02
MetaTile0_1A:
	.db $6A,$6B,$56,$57, $02
MetaTile0_1B:
	.db $6A,$5D,$56,$5F, $02
	
MetaTile0_1C:
	;mountains and rocks
	.db $82,$83,$72,$73, $02
MetaTile0_1D:
	.db $74,$74,$43,$43, $02
MetaTile0_1E:
	.db $84,$75,$78,$79, $02
MetaTile0_1F:
	.db $72,$73,$72,$73, $02
MetaTile0_20:
	.db $43,$43,$43,$43, $00
MetaTile0_21:
	.db $78,$79,$88,$89, $02
MetaTile0_22:
	.db $70,$71,$80,$81, $02
MetaTile0_23:
	.db $76,$77,$86,$87, $02
MetaTile0_24:
	.db $7A,$7B,$86,$85, $02
MetaTile0_25:
	.db $7C,$77,$88,$7D, $02
MetaTile0_26:
	.db $76,$8D,$8C,$73, $02
MetaTile0_27:
	.db $43,$43,$8A,$43, $00
MetaTile0_28:
	.db $43,$8B,$8B,$43, $00
	
MetaTile0_29:
	;jungle floor
	.db $A9,$A9,$A9,$A9, $00
MetaTile0_2A:
	.db $AC,$B1,$A9,$AB, $00
MetaTile0_2B:
	.db $B0,$AC,$AA,$A9, $00
MetaTile0_2C:
	.db $A9,$AB,$AD,$AF, $00
MetaTile0_2D:
	.db $AA,$A9,$AE,$AD, $00
MetaTile0_2E:
	.db $A9,$AB,$A9,$AB, $00
MetaTile0_2F:
	.db $AA,$A9,$AA,$A9, $00
MetaTile0_30:
	.db $AC,$AC,$A9,$A9, $00
MetaTile0_31:
	.db $A9,$A9,$AD,$AD, $00
	
MetaTile0_32:
	;forest tree trunks
	.db $C0,$C1,$C2,$C3, $02
MetaTile0_33:
	.db $C0,$C1,$C0,$C1, $02
	
MetaTile0_34:
	;more rocks and mountain; cave entrances
	.db $7E,$7F,$8E,$8F, $02
MetaTile0_35:
	.db $93,$94,$95,$96, $00
MetaTile0_36:
	.db $9F,$A0,$43,$43, $00
MetaTile0_37:
	.db $97,$98,$99,$9A, $00
MetaTile0_38:
	.db $A1,$43,$A2,$43, $00
MetaTile0_39:
	.db $43,$A3,$43,$A4, $00
MetaTile0_3A:
	.db $9B,$9C,$9D,$9E, $00
MetaTile0_3B:
	.db $90,$92,$43,$43, $02
MetaTile0_3C:
	.db $92,$91,$43,$43, $02
	
MetaTile0_3D:
	;More jungle brush
	.db $B2,$B3,$B4,$B5, $06
MetaTile0_3E:
	.db $B6,$B7,$B4,$B5, $06
MetaTile0_3F:
	.db $B8,$B9,$BA,$BB, $04
MetaTile0_40:
	.db $BC,$BD,$BE,$BF, $05
	
	
	;~~~~~~~~~~~ BANK 1 ~~~~~~~~~~~~~~~~~
	
	
MetaTile1_00:
	;Inside the caves
	.db $50,$51,$60,$61, $02
MetaTile1_01:
	.db $58,$59,$68,$69, $02
MetaTile1_02:
	.db $52,$53,$62,$63, $02
MetaTile1_03:
	.db $5A,$5B,$6A,$6B, $02
MetaTile1_04:
	.db $54,$51,$64,$61, $02
MetaTile1_05:
	.db $5C,$59,$6C,$69, $02
MetaTile1_06:
	.db $52,$57,$62,$67, $02
MetaTile1_07:
	.db $5A,$5F,$6A,$6F, $02
MetaTile1_08:
	.db $50,$55,$60,$65, $02
MetaTile1_09:
	.db $58,$5D,$68,$6D, $02
MetaTile1_0A:
	.db $56,$53,$66,$63, $02
MetaTile1_0B:
	.db $5E,$5B,$6E,$6B, $02
MetaTile1_0C:
	.db $54,$55,$64,$65, $02
MetaTile1_0D:
	.db $5C,$5D,$6C,$6D, $02
MetaTile1_0E:
	.db $56,$57,$66,$67, $02
MetaTile1_0F:
	.db $5E,$5F,$6E,$6F, $02
MetaTile1_10:
	.db $76,$77,$86,$87, $02
MetaTile1_11:
	.db $76,$8B,$7A,$41, $02
MetaTile1_12:
	.db $8B,$8B,$41,$41, $02
MetaTile1_13:
	.db $8B,$77,$41,$7B, $02
MetaTile1_14:
	.db $7A,$41,$7A,$41, $02
MetaTile1_15:
	.db $41,$41,$41,$41, $00
MetaTile1_16:
	.db $41,$7B,$41,$7B, $02
MetaTile1_17:
	.db $7A,$41,$86,$8A, $02
MetaTile1_18:
	.db $41,$41,$8A,$8A, $02
MetaTile1_19:
	.db $41,$7B,$8A,$87, $02
MetaTile1_1A:
	.db $76,$8B,$86,$8A, $02
MetaTile1_1B:
	.db $8B,$8B,$8A,$8A, $02
MetaTile1_1C:
	.db $8B,$77,$8A,$87, $02
MetaTile1_1D:
	.db $76,$77,$7A,$7B, $02
MetaTile1_1E:
	.db $7A,$7B,$7A,$7B, $02
MetaTile1_1F:
	.db $7A,$7B,$86,$87, $02
MetaTile1_20:
	.db $78,$79,$88,$89, $00
MetaTile1_21:
	.db $74,$75,$84,$85, $00
MetaTile1_22:
	.db $70,$71,$80,$81, $00
MetaTile1_23:
	.db $7E,$7F,$90,$83, $00
MetaTile1_24:
	.db $8E,$7F,$82,$83, $00
MetaTile1_25:
	.db $8E,$8F,$82,$83, $00
MetaTile1_26:
	.db $82,$73,$90,$83, $00
MetaTile1_27:
	.db $72,$73,$82,$83, $00
MetaTile1_28:
	.db $72,$93,$82,$91, $00
MetaTile1_29:
	.db $92,$73,$94,$95, $00
MetaTile1_2A:
	.db $72,$73,$96,$95, $00
MetaTile1_2B:
	.db $72,$73,$96,$97, $00
MetaTile1_2C:
	.db $7E,$8F,$82,$83, $00
MetaTile1_2D:
	.db $92,$93,$90,$91, $00
MetaTile1_2E:
	.db $92,$93,$94,$97, $00
MetaTile1_2F:
	.db $7E,$7F,$94,$95, $00
MetaTile1_30:
	.db $8E,$7F,$96,$95, $00
MetaTile1_31:
	.db $8E,$8F,$96,$97, $00
MetaTile1_32:
	.db $7E,$8F,$94,$97, $00
MetaTile1_33:
	.db $7C,$7D,$8C,$8D, $02
MetaTile1_34:
	.db $43,$43,$98,$43, $00
MetaTile1_35:
	.db $43,$99,$99,$43, $00
MetaTile1_36:
	;cliff
	.db $9A,$9B,$9C,$9D, $00
MetaTile1_37:
	.db $43,$43,$43,$43, $03