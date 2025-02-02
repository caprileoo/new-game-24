// obj_player
// Create Event
function set_on_ground(_val = true)
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

function check_for_semi_solid_platform(_x, _y)
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
		for( var _i = 0; _i < _list_size; _i++ )
		{
			var _list_inst = _list[| _i];
			if _list_inst != forget_semi_solid && floor(bbox_bottom) <= ceil( _list_inst.bbox_top - _list_inst.y_speed )
			{
				// Return the id of a semisolid platform
				_return = _list_inst;
				// Exit the loop early
				_i = _list_size;
			}
		}
		
		// Destroy ds list to free memory
		ds_list_destroy(_list);
	}
	// Return our variable
	return _return;
}

function check_for_ledge_grab()
{
    // Only check for ledge grab if we're in the air and can grab ledges
    if (!on_ground && can_ledge_grab && state == STATES.FREE)
    {
        // Create a list to store possible ledge objects
        var _list = ds_list_create();
        
        // Get the intended movement direction (either from actual movement or input)
        var _intended_direction = (x_speed != 0) ? sign(x_speed) : move_dir;
        
        // Only proceed if we have an intended direction
        if (_intended_direction != 0)
        {
            // Check for walls at grab position
            var _list_size = instance_place_list(x + _intended_direction, y, obj_wall, _list, false);
            
            // Loop through potential ledge objects
            for (var _i = 0; _i < _list_size; _i++)
            {
                var _inst = _list[| _i];
                
                if (!_inst.grabbable)
                {
                    continue;
                }
                
                // Determine which corner to check based on intended direction
                var _player_check_x = (_intended_direction > 0) ? bbox_right : bbox_left;
                var _wall_check_x = (_intended_direction > 0) ? _inst.bbox_left : _inst.bbox_right;
                
                // Check if we're near the wall's edge horizontally
                var _proximity_threshold = 2;
                if (abs(_player_check_x - _wall_check_x) <= _proximity_threshold)
                {
                    // Check if there's no wall above the ledge
                    if (!position_meeting(_wall_check_x, _inst.bbox_top - 1, obj_wall))
                    {
                        // Calculate how far we are vertically from the ideal grab position
                        var _vertical_distance = _inst.bbox_top - bbox_top;
                        
                        // Different conditions based on whether we're above or below the ledge
                        var _can_grab = false;
                        
                        if (_vertical_distance >= 0) {
                            // We're below the ledge
                            // Allow grab if we're moving up and close enough
                            _can_grab = (_vertical_distance <= 4);
                        } else {
                            // We're above the ledge
                            // Only allow grab if we're falling and very close
                            _can_grab = (y_speed >= 0 && abs(_vertical_distance) <= 4);
                        }
                        
                        if (_can_grab)
                        {
                            // Enter ledge state
                            state = STATES.LEDGE;
                            
                            // Reset ledge animation flags when grabbing new ledge
                            ledge_landing = false;
                            ledge_landing_finished = false;
                            
                            // Align exactly with the wall edge
                            if (_intended_direction > 0)
                            {
                                x = _inst.bbox_left - (bbox_right - x);
                            }
                            else
                            {
                                x = _inst.bbox_right - (bbox_left - x);
                            }
                            
                            // Align exactly with the top edge
                            y = _inst.bbox_top - (bbox_top - y);
                            
                            // Reset speeds
                            x_speed = 0;
                            y_speed = 0;
                            
                            // Update face direction
                            face = _intended_direction;
                            
                            // Break the loop
                            _i = _list_size;
                        }
                    }
                }
            }
        }
        
        // Clean up
        ds_list_destroy(_list);
    }
}

// State variable
enum STATES {
    FREE,
    LEDGE,
	DEAD
}
state = STATES.FREE; // Don't touch
crouching = false; // Don't touch
can_ledge_grab = true; // Don't touch
ledge_landing = false;  // Track if we're currently in landing animation
ledge_landing_finished = false;  // Track if landing animation has completed

// Control Setup
controls_setup();

// Sprites
mask_sprite = spr_spacecat_idle; // Choosen Sprite to be the Collision Mask
idle_sprite = spr_spacecat_idle; // Idle Sprite
walk_sprite = spr_spacecat_walk; // Walk Sprite
run_sprite = spr_spacecat_walk; // Run Sprite
jump_sprite = spr_spacecat_jump; // Jump Sprite
fall_sprite = spr_spacecat_fall; // Fall Sprite
crouch_sprite = spr_player_crouch; // Crouch Sprite
roll_sprite = spr_player_roll; // Roll Sprite
ledge_idle_sprite = spr_player_ledge_grab_idle; // Idle while grabbing ledge Sprite
ledge_land_sprite = spr_player_ledge_grab_land; // Land on ledge Sprite
dead_sprite = spr_spacecat_dead; // Dead sprite
//push_sprite = spr_player_push; // Pushing Sprite
//pull_sprite = spr_player_pull; // Pulling Sprite

// Stats
hp = 100;
energy = 0;

// Moving
face = 1; // Don't touch
move_dir = 0; // Don't touch
run_type = 0; // Don't touch
run_timer = 0; // Don't touch
target_time = 3; // Booster deplete time
move_speed[0] = 2; // Normal Movement Speed
move_speed[1] = 3; // Movement Speed Second Type
crouch_move_speed = 1.2; // Crouch movement speed
x_speed = 0; // Don't touch
y_speed = 0; // Don't touch

// Jumping (Only Change the first 4 value for jumping feel)
grav = .3; // Gravity
jump_speed = -2.5; // Upward Force
jump_hold_frames = 16; // How long the player can hold jump
jump_max = 1; // Change this value for double, triple,... jumps!
terminal_vel = 4; // Don't touch
jump_count = 0; // Don't touch
jump_hold_timer = 0; // Don't touch
on_ground = true; // Don't touch

// Coyote Time
// Hang Time
coyote_hang_frames = 2; // How long does the player hang on edge before falling
coyote_hang_timer = 0; // Don't touch
// Jump Buffer Time
coyote_jump_frames = 6; // How long the player can still jump when already off edge
coyote_jump_timer = 0; // Don't touch

// Moving Platforms
my_floor_plat = noone; // Don't touch
early_move_plat_x_speed = false; // Don't touch
down_slop_semi_solid = noone; // Don't touch
forget_semi_solid = noone; // Don't touch
move_plat_x_speed = 0; // Don't touch
crush_timer = 0; // Don't touch
crush_death_time = 3; // Don't touch

// Transition Values
target_rm = rm_devroom; // Don't touch
target_x = 32; // Don't touch
target_y = 176; // Don't touch
target_face = 1; // Don't touch
animation_speed = 0.01; // Don't touch
delay = 0; // Don't touch