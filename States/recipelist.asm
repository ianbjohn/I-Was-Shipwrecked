CraftItemsMap:
	;sorted by craftable item ID
	;maps craftable items to their regular item counterparts
	.db ITEM_SPEAR,ITEM_TORCH,ITEM_TOURNIQUET
	
ItemRecipes:
	.dw SpearRecipe,TorchRecipe,TourniquetRecipe
	
SpearRecipe:
	.db S,T,I,C,K, SPA, $2E, SPA, S,T,O,N,E,$FF
TorchRecipe:
	.db S,T,I,C,K, SPA, $2E, SPA, F,L,I,N,T,$FF
Tourniquet:
	.db S,T,I,C,K, SPA, $2E, SPA, C,L,O,T,H,$FF


RecipeListInit:
	;Clear screen completely
	;For however many craftable items have been discovered
		;Draw the item string, and then under it (Or after a colon or something)
RecipeListMain:
	;If B is pressed
		;Redraw status board
		;Go back to inventory state
	rts