// Load Controls
getControls();

#region X Movement
// Direction
move_dir = right_key - left_key;

// Get my face
if move_dir != 0 { face = move_dir; }

// Get x_speed
run_type = run_key;
x_speed = move_dir * move_speed[run_type];

// X Collision
var _sub_pixels = .5; // How close we can get close to the wall

if place_meeting( x + x_speed, y, obj_wall )
{
	
	// First check if there is a slope to go up
	if ( !place_meeting( x + x_speed, y - abs(x_speed) - 1, obj_wall ) )
	{
		while place_meeting( x + x_speed, y, obj_wall ) 
		{
			y -= _sub_pixels;
		}
	} else { // Next, check for ceiling slope, otherwise, do a regular collision
		// Ceiling Slopes
		if !place_meeting( x + x_speed, y + abs(x_speed) + 1, obj_wall )
		{
			while place_meeting( x + x_speed, y, obj_wall ) 
			{
				y += _sub_pixels;
			}
		} else {
			// Pixel Perfect
			var _pixel_check = _sub_pixels * sign(x_speed);
			while !place_meeting( x + _pixel_check, y, obj_wall )
			{
				x += _pixel_check;
			}
	
			// Set xspd to zero to "collide"
			x_speed = 0;
		}
	}
}

// Go Down Slopes

down_slop_semi_solid = noone;
if y_speed >= 0 && !place_meeting( x + x_speed, y + 1, obj_wall ) && place_meeting( x + x_speed, y + abs(x_speed) + 1, obj_wall )
{
	// Check for a semisolid in the way
	down_slop_semi_solid = checkForSemiSolidPlatform( x + x_speed, y + abs(x_speed) + 1 );
	// Precisely move down slope if there is not a semisolid in the way
	if !instance_exists(down_slop_semi_solid)
	{
		while !place_meeting( x + x_speed, y + _sub_pixels, obj_wall ) { y += _sub_pixels; };
	}
}

// Move
x += x_speed;
#endregion

#region Y Movement
// Gravity
if coyote_hang_timer > 0
{
	// Count the timer down
	coyote_hang_timer--;
} else {
	// Apply gravity to the player
	y_speed += grav;
	// No longer on ground
	setOnGround(false);
}

// Reset/Prepare jumping variables
if on_ground
{
	jump_count = 0;
	coyote_jump_timer = coyote_jump_frames;
	jump_hold_timer = 0;
} else {
	// If the player is in the air, make sure they can't do extra jump
	coyote_jump_timer--;
	if ( jump_count == 0 && coyote_jump_timer <= 0 ) { jump_count = 1; };
}

// Initiate the Jump
if jump_key_buffered && !down_key && jump_count < jump_max 
{
	// Reset the buffer
	jump_key_buffered = false;
	jump_key_buffer_timer = 0;
	
	// Increase the number of performed jumps
	jump_count++;
	
	// Set the jump hold timer
	jump_hold_timer = jump_hold_frames;
	
	// Alert that i'm no longer on ground
	setOnGround(false);
}

// Jump based on the timer/holding the button
if jump_hold_timer > 0
{
	// Constantly set the y_speed to be jumping speed
	y_speed = jump_speed;
	// Count down the timer
	jump_hold_timer--;
}

// Cut off the jump by releasing the jump button
if !jump_key 
{
	jump_hold_timer = 0;
}

// Y Collision and movement
// Cap falling speed
if y_speed > terminal_vel { y_speed = terminal_vel; };

// Y Collision
var _sub_pixels = .5;
// Upward Y Collision
if y_speed < 0 && place_meeting( x, y + y_speed, obj_wall )
{
	// Pixel Perfect
	var _pixel_check = _sub_pixels * sign(y_speed);
	while !place_meeting( x, y + _pixel_check, obj_wall )
	{
		y += _pixel_check;
	}
	
	// Bonk code (OPTIONAL)
	//if ( y_speed < 0 )
	//{
	//	jump_hold_timer = 0;
	//}
	
	// Set y_speed to 0 to collide
	y_speed = 0;
}

// Floor Y Collision

// Check for solid and semisolid platforms under me
var _clamp_y_speed = max( 0, y_speed );
var _list = ds_list_create(); // Create a DS list to store all of the objects we run into
var _array = array_create(0);
array_push( _array, obj_wall, obj_semi_solid_wall );

// Do the actual check and add objects to list
var _list_size = instance_place_list( x, y + 1 + _clamp_y_speed + terminal_vel, _array, _list, false );

// For high resolution/high speed (Check for a semisolid plat below the player)
var _y_check = y + 1 + _clamp_y_speed;
if instance_exists(my_floor_plat) { _y_check += max(0, my_floor_plat.y_speed); };
var _semi_solid = checkForSemiSolidPlatform(x, _y_check);

// Loop through the colliding instance and only return on if it's top is bellow the player
for ( var i = 0; i < _list_size; i++ )
{
	// Get an instance of obj_wall or obj_semi_solid_wall from the list
	var _list_inst = _list[| i];
	
	// Avoid magnetism
	if (_list_inst != forget_semi_solid
	&& ( _list_inst.y_speed <= y_speed || instance_exists(my_floor_plat) )
	&& ( _list_inst.y_speed > 0 || place_meeting( x, y + 1 + _clamp_y_speed, _list_inst ) ))
	|| (_list_inst == _semi_solid) // For high resolution/high speed
	{
		// Return a solid wall or any semisolid walls that are below the player
		if _list_inst.object_index == obj_wall 
		|| object_is_ancestor( _list_inst.object_index, obj_wall ) 
		|| floor(bbox_bottom) <= ceil( _list_inst.bbox_top - _list_inst.y_speed ) 
		{
			// Return the "highest wall object"
			if !instance_exists(my_floor_plat) 
			|| _list_inst.bbox_top + _list_inst.y_speed <= my_floor_plat.bbox_top + my_floor_plat.y_speed
			|| _list_inst.bbox_top + _list_inst.y_speed <= bbox_bottom
			{
				my_floor_plat = _list_inst;
			}
		}
	}
}
// Destory the DS list to avoid mem leak
ds_list_destroy(_list);

// Downslope semisolid for making sure we don't miss semisolid's while going down slopes
if instance_exists(down_slop_semi_solid) { my_floor_plat = down_slop_semi_solid; };

// One last check to make sure the floor platform is actually below us
if instance_exists(my_floor_plat) && !place_meeting( x, y + terminal_vel, my_floor_plat )
{
	my_floor_plat = noone;
}

// Land on the ground platform if there is one
if instance_exists(my_floor_plat)
{
	// Scoot up to our wall precisely
	var _sub_pixels = .5;
	while !place_meeting( x, y + _sub_pixels, my_floor_plat ) && !place_meeting( x, y, obj_wall ) { y += _sub_pixels; };
	// Make sure we don't end up below the top of a semisolid
	if my_floor_plat.object_index == obj_semi_solid_wall
	|| object_is_ancestor(my_floor_plat.object_index, obj_semi_solid_wall)
	{
		while place_meeting( x, y, my_floor_plat ){ y -= _sub_pixels; };
	}
	// Floor the y variable
	y = floor(y);
	
	// Collision with the ground
	y_speed = 0;
	setOnGround(true);
}

// Manualy fall through a semisolid platform
if down_key && jump_key_pressed
{
	// Make sure we have a floor platform thats a semisolid
	if instance_exists(my_floor_plat)
	&& ( my_floor_plat.object_index == obj_semi_solid_wall || object_is_ancestor(my_floor_plat.object_index, obj_semi_solid_wall) )
	{
		// Check if we can go below the semisolid
		var _y_check = max( 1, my_floor_plat.y_speed + 1 )
		if !place_meeting( x, y + _y_check, obj_wall )
		{
			// Move below the platform
			y += 1;
			
			// Inherit any downward speed from my floor platform so it doesn't catch me
			y_speed = _y_check - 1;
			
			// Forget this platform fro a brief time so we don't get caught again
			forget_semi_solid = my_floor_plat;
			
			// Reset the buffer
			jump_key_buffered = false;
			
			// No more floor platform
			setOnGround(false);
		}
	}
}

// Move
y += y_speed;

// Reset forget_semi_solid variable
if instance_exists(forget_semi_solid) && !place_meeting(x, y, forget_semi_solid)
{
	forget_semi_solid = noone;
}

// Final moving platform and collisions and movement
// X - move_plat_x_speed and collision
// Get the move_plat_x_speed
move_plat_x_speed = 0;
if instance_exists(my_floor_plat) { move_plat_x_speed = my_floor_plat.x_speed; };

// Move with move_plat_x_speed
if place_meeting( x + move_plat_x_speed, y, obj_wall )
{
	// Scoot up to wall precisely
	var _sub_pixels = .5;
	var _pixel_check = _sub_pixels * sign(move_plat_x_speed);
	while !place_meeting( x + _pixel_check, y, obj_wall )
	{
		x += _pixel_check;
	}
	// Set move_plat_x_speed to 0 to finish collision
	move_plat_x_speed = 0;
}
// Move
x += move_plat_x_speed;

// Y - Snap myself to my floor platform
if instance_exists(my_floor_plat) // Add other kind of moving object into this as you update
&& ( my_floor_plat.y_speed != 0
|| my_floor_plat.object_index == obj_moving_semi_solid_wall
|| object_is_ancestor(my_floor_plat.object_index, obj_moving_semi_solid_wall) )
{
	// Snap to the top of the floor platform (un-floor our y variable so it's not choppy)
	if !place_meeting( x, my_floor_plat.bbox_top, obj_wall )
	&& my_floor_plat.bbox_top >= bbox_bottom - terminal_vel
	{
		y = my_floor_plat.bbox_top;
	}
	
	// Going up into a solid wall while on a semisolid platform
	if my_floor_plat.y_speed < 0 && place_meeting( x, y + my_floor_plat.y_speed, obj_wall )
	{
		// Get pushed down through the semisolid floor platform
		if my_floor_plat.object_index == obj_semi_solid_wall || object_is_ancestor(my_floor_plat.object_index, obj_semi_solid_wall)
		{
			// Get pushed down through the semisolid
			var _sub_pixels = .25;
			while place_meeting( x, y + my_floor_plat.y_speed, obj_wall ) { y += _sub_pixels; };
			// If we got pushed into a solid wall while going downwards, push ourselves back out
			while place_meeting( x, y, obj_wall ){ y -= _sub_pixels; };
			y = round(y);
		}
		
		// Cancel the my_floor_plat variable
		setOnGround(false);
	}
}
#endregion

#region Sprite control
// Walking
if abs(x_speed) > 0 { sprite_index = walk_sprite; };
// Running
if abs(x_speed) >= move_speed[1] { sprite_index = run_sprite; };
// Idle
if x_speed == 0 { sprite_index = idle_sprite; };
// Jump
if !on_ground { sprite_index = jump_sprite; };
// Set the collision mask
mask_index = mask_sprite;
#endregion