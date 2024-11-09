// Custom function for player
function setOnGround(_val = true)
{
	if ( _val == true )
	{
		on_ground = true;
		coyote_hang_timer = coyote_hang_frames;
	} else {
		on_ground = false;
		my_floor_plat = noone;
		coyote_hang_timer = 0;
	}
}

function checkForSemiSolidPlatform(_x, _y)
{
	// Create a return variable
	var _return = noone;
	// We must not be moving upwards, and then we check for a normal collision
	if y_speed >= 0 && place_meeting(_x, _y, obj_semi_solid_wall)
	{
		// Create a ds list to store all colliding instances of obj_semi_solid_wall
		var _list = ds_list_create();
		var _list_size = instance_place_list(_x, _y, obj_semi_solid_wall, _list, false);
		
		// Loop through the colliding instances and only return one of it's top is below the player
		for( var i = 0; i < _list_size; i++ )
		{
			var _list_inst = _list[| i];
			if _list_inst != forget_semi_solid && floor(bbox_bottom) <= ceil( _list_inst.bbox_top - _list_inst.y_speed )
			{
				// Return the id of a semisolid platform
				_return = _list_inst;
				// Exit the loop early
				i = _list_size;
			}
		}
		
		// Destroy ds list to free memory
		ds_list_destroy(_list);
	}
	// Return our variable
	return _return;
}

depth = -30;

// Control Setup
controlsSetup();

// Sprites
mask_sprite = spr_player_idle; // Choosen Sprite to be the Collision Mask
idle_sprite = spr_player_idle; // Idle Sprite
walk_sprite = spr_player_walk; // Walk Sprite
run_sprite = spr_player_run; // Run Sprite
jump_sprite = spr_player_jump; // Jump Sprite
fall_sprite = spr_player_fall; // Fall Sprite
crouch_sprite = spr_player_crouch; // Crouch Sprite
roll_sprite = spr_player_roll; // Roll Sprite
//ledge_idle_sprite = spr_player_ledge_grab_idle; // Idle while grabbing ledge Sprite
//ledge_land_sprite = spr_player_ledge_grab_land; // Land on ledge Sprite

// Moving
face = 1; // Don't touch
move_dir = 0; // Don't touch
run_type = 0; // Don't touch
move_speed[0] = 2; // Normal Movement Speed
move_speed[1] = 3; // Movement Speed when sprint (or walk)
crouch_move_speed = 1.2; // Crouch movement speed
x_speed = 0; // Don't touch
y_speed = 0; // Don't touch

// State variables
crouching = false;

// Jumping
grav = .275; // Gravity
terminal_vel = 4; // Don't touch
jump_speed = -2.75; // Decrease for higher jump height
jump_max = 1; // Change this value for double, triple,... jumps!
jump_count = 0; // Don't touch
jump_hold_timer = 0; // Don't touch
jump_hold_frames = 18; // Don't touch
on_ground = true; // Don't touch

// Coyote Time
// Hang Time
coyote_hang_frames = 2;
coyote_hang_timer = 0; // Don't touch
// Jump Buffer Time
coyote_jump_frames = 6;
coyote_jump_timer = 0; // Don't touch

// Moving Platforms
my_floor_plat = noone;
early_move_plat_x_speed = false;
down_slop_semi_solid = noone;
forget_semi_solid = noone;
move_plat_x_speed = 0;
//crush_timer = 0;
//crush_death_time = 3;