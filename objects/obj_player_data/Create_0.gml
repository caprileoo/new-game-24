depth = -9999;

// Create the items
global.item_list =
{
	// Accessories
	blue_ring :
	{
		item_name : "A Blue Ring",
		description : "It's a Blue Ring! It must have some use, right?",
		icon : spr_blue_ring,
	},
	
	red_ring :
	{
		item_name : "A Red Ring",
		description : "It's a Red Ring! It must have some use, right?",
		icon : spr_red_ring,
	},
	
	key :
	{
		item_name : "A Key",
		description : "It's a Key! It must have some use, right?",
		icon : spr_key,
	},
	
	// Boosters
	energy :
	{
		item_name : "Energy",
		description : "This energy... I can feel it inside my body",
		icon : spr_energy,
	},
}

// Create the inventory
inv = array_create(0);

array_push(inv, global.item_list.energy);

// For drawing and mouse positions
sep = 16;
screen_bord = 16;