depth = -9999;

// Control Setup
controls_setup();

// Item Construsctor
function create_item(_name, _desc, _icon, _effect) constructor
{
	item_name = _name;
	description = _desc;
	icon = _icon;
	effect = _effect;
	quantity = 1;
}

// Create the items
global.item_list =
{
	// Accessories
	blue_ring : new create_item
	(
		"A Blue Ring",
		"It's a Blue Ring! It must have some use, right?",
		spr_blue_ring,
		function(){}
	),
	
	red_ring : new create_item
	(
		"A Red Ring",
		"It's a Red Ring! It must have some use, right?",
		spr_red_ring,
		function(){}
	),
	
	key : new create_item
	(
		"A Key",
		"It's a Key! It must have some use, right?",
		spr_key,
		function(){}
	),
}

// Create the inventory
inv = array_create(0);
inv_max = 5;
selected_item = 0;
item_name_alpha = 0;
item_name_timer = 0;
show_name_duration = 180;
fade_duration = 60;