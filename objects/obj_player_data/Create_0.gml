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
	
	// Boosters
	energy : new create_item
	(
		"Energy",
		"I feel POWERFUL!!!",
		spr_energy,
		function()
		{
			obj_player.run_type = 1;
			obj_player.run_timer = 0;
			
			global.item_list.energy.quantity -= 1;
			
			// Remove the item
			for ( var _i = 0 ; _i < array_length(inv) ; _i++ )
			{
				if (inv[_i].item_name == "Energy" && inv[_i].quantity <= 0)
				{
					array_delete(inv, _i, 1);
				}
				break;
			}
		}
	),
}

// Create the inventory
inv = array_create(0);
inv_max = 3;
selected_item = -1;

// For drawing and mouse positions
sep = 16;
screen_bord = 16;