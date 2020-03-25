BCD_8:
	;8-bit BCD conversion
	;(Not my code - Celius's)
	;A shouldn't have to worry about being clobbered since it gets stored in bcd_value before the routine gets called
	;X clobbered
	lda #0
	sta bcd_ones
	sta bcd_tens
	sta bcd_hundreds
	
	lda bcd_value+0
	and #$0F
	tax
	lda HexDigit00Table,x
	sta bcd_ones
	lda HexDigit01Table,x
	sta bcd_tens
	
	lda bcd_value+0
	lsr
	lsr
	lsr
	lsr
	tax
	lda HexDigit10Table,x
	clc
	adc bcd_ones
	sta bcd_ones
	lda HexDigit11Table,x
	adc bcd_tens
	sta bcd_tens
	lda HexDigit12Table,x
	sta bcd_hundreds
	
	clc
	ldx bcd_ones
	lda DecimalSumsLow,x
	sta bcd_ones
	
	lda DecimalSumsHigh,x
	adc bcd_tens
	tax
	lda DecimalSumsLow,x
	sta bcd_tens
	
	lda DecimalSumsHigh,x
	adc bcd_hundreds
	tax
	lda DecimalSumsLow,x
	sta bcd_hundreds
	rts
	
	
HexDigit00Table:
DecimalSumsLow:
	.db 0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5
	.db 6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1
	.db 2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7
	.db 8,9,0,1,2,3,4
HexDigit01Table:
DecimalSumsHigh:
	.db 0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1
	.db 1,1,1,1,2,2,2,2,2,2,2,2,2,2,3,3
	.db 3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4
	.db 4,4,5,5,5,5,5,5,5,5,5,5
HexDigit10Table:
	.db 0,6,2,8,4,0,6,2,8,4,0,6,2,8,4,0
HexDigit11Table:
	.db 0,1,3,4,6,8,9,1,2,4,6,7,9,0,2,4
HexDigit12Table:
	.db 0,0,0,0,0,0,0,1,1,1,1,1,1,2,2,2
	
	
BCD_16:
	;16-bit BCD conversion
	;(Also not my code - Tokumaru's)
	;X and Y get clobbered
	lda #0
	sta bcd_ones
	sta bcd_tens
	sta bcd_hundreds
	sta bcd_thousands
	sta bcd_tenthousands
	ldx #16
@bitloop:
	asl bcd_value+0
	rol bcd_value+1
	
	ldy bcd_ones
	lda BCD_16_Table,y
	rol
	sta bcd_ones
	
	ldy bcd_tens
	lda BCD_16_Table,y
	rol
	sta bcd_tens
	
	ldy bcd_hundreds
	lda BCD_16_Table,y
	rol
	sta bcd_hundreds
	
	ldy bcd_thousands
	lda BCD_16_Table,y
	rol
	sta bcd_thousands
	
	rol bcd_tenthousands
	
	dex
	bne @bitloop
	rts
	

BCD_16_Table:
   .db $00,$01,$02,$03,$04, $80,$81,$82,$83,$84