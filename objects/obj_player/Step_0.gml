// Step Event
// Load Controls
getControls();

if hp <= 0 { state = states.DEAD; }

switch(state) {
    case states.FREE: {
		
		#region Behavior against moving wall
		// Get out of solid move_plats that have positioned themselves into the player in the begin step
		var _right_wall = noone;
		var _left_wall = noone;
		var _bottom_wall = noone;
		var _top_wall = noone;
		var _list = ds_list_create();
		var _list_size = instance_place_list( x, y, obj_moving_plat, _list, false );
		// Loop through all colliding move plats
		for( var i = 0; i < _list_size; i++ )
		{
			var _list_inst = _list[| i];
	
			// Find closest walls in each direction
			// Right walls
			if _list_inst.bbox_left - _list_inst.x_speed >= bbox_right - 1
			{
				if !instance_exists(_right_wall) || _list_inst.bbox_left < _right_wall.bbox_left
				{
					_right_wall = _list_inst;
				}
			}
			// Left walls
			if _list_inst.bbox_right - _list_inst.x_speed <= bbox_left + 1
			{
				if !instance_exists(_left_wall) || _list_inst.bbox_right > _left_wall.bbox_right
				{
					_left_wall = _list_inst;
				}
			}
			// Bottom walls
			if _list_inst.bbox_top - _list_inst.y_speed >= bbox_bottom - 1
			{
				if !_bottom_wall || _list_inst.bbox_top < _bottom_wall.bbox_top
				{
					_bottom_wall = _list_inst;
				}
			}
			// Top walls
			if _list_inst.bbox_bottom - _list_inst.y_speed <= bbox_top + 1
			{
				if !_top_wall || _list_inst.bbox_bottom > _top_wall
				{
					_top_wall = _list_inst;
				}
			}
		}

		// Destroy the ds list to free memory
		ds_list_destroy(_list);

		// Get out of the walls
		// Right wall
		if instance_exists(_right_wall)
		{
			var _right_dist = bbox_right - x;
			x = _right_wall.bbox_left - _right_dist;
		}
		// Left wall
		if instance_exists(_left_wall)
		{
			var _left_dist = x - bbox_left;
			x = _left_wall.bbox_right + _left_dist;
		}
		// Bottom wall
		if instance_exists(_bottom_wall)
		{
			var _bottom_dist = bbox_bottom - y;
			y = _bottom_wall.bbox_top - _bottom_dist;
		}
		// Top wall
		if instance_exists(_top_wall)
		{
			var _up_dist = y - bbox_top;
			var _target_y = _top_wall.bbox_bottom + _up_dist;
			// Check if there isn't a wall in the way
			if !place_meeting( x, _target_y, obj_wall )
			{
				y = _target_y;
			}
		}

		// Don't get left behind by my move_plat!!!
		early_move_plat_x_speed = false;
		if instance_exists(my_floor_plat) && my_floor_plat.x_speed != 0 && !place_meeting( x, y + terminal_vel + 1, my_floor_plat )
		{
			var _x_check = my_floor_plat.x_speed;
			// Go ahead and move our_selves back onto that platform if there is no wall in the way
			if !place_meeting( x + _x_check, y, obj_wall )
			{
				x += _x_check;
				early_move_plat_x_speed = true;
			}
		}
		#endregion

		#region Crouching
		// Transition to crouch
		// Manual
		if down_key && instance_exists(my_floor_plat)
		{
			crouching = true;
		}
		// Change collision mask
		if crouching { mask_index = crouch_sprite; };
		// Transition out of crouching
		// Manual
		if crouching && !down_key
		{
			// Check if i can uncrouch
			mask_index = idle_sprite;
			// Uncrouch if no solid wall in the way
			if !place_meeting(x, y, obj_wall)
			{
				crouching = false;
			}
			// Go back to crouching mask index if we can't uncrouch
			else
			{
				mask_index = crouch_sprite;
			}
		}
		#endregion

		#region X Movement
		// Direction
		move_dir = right_key - left_key;

		// Get my face
		if move_dir != 0 { face = move_dir; }

		// Get x_speed
		run_type = run_key;
		x_speed = move_dir * move_speed[run_type];

		// Crouch and move
		if crouching { x_speed = move_dir * crouch_move_speed; };

		// X Collision
		var _sub_pixels = .5; // How close we can get close to the wall

		if place_meeting(x + x_speed, y, obj_wall)
		{
		    // First check if there is a slope to go up
		    var _is_slope = false;
		    var _check_inst = instance_place(x + x_speed, y, obj_wall);
    
		    if (_check_inst != noone) {
		        // Only allow slope behavior if we're actually colliding with a slope object
		        _is_slope = (_check_inst.object_index == obj_slope || object_is_ancestor(_check_inst.object_index, obj_slope));
		    }
    
		    if (_is_slope && !place_meeting(x + x_speed, y - abs(x_speed) - 1, obj_wall))
		    {
		        while place_meeting(x + x_speed, y, obj_wall) 
		        {
		            y -= _sub_pixels;
		        }
		    } 
		    else 
		    { 
		        // Check for ceiling slope
		        if (!place_meeting(x + x_speed, y + abs(x_speed) + 1, obj_wall))
		        {
		            while place_meeting(x + x_speed, y, obj_wall) 
		            {
		                y += _sub_pixels;
		            }
		        } 
		        else 
		        {
		            // Regular wall collision - Pixel Perfect
		            var _pixel_check = _sub_pixels * sign(x_speed);
		            while !place_meeting(x + _pixel_check, y, obj_wall)
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
		if jump_key_buffered && !down_key && jump_count < jump_max && !crouching
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
			if ( y_speed < 0 )
			{
				jump_hold_timer = 0;
			}
	
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
		if !place_meeting( x, y + y_speed, obj_wall ){ y += y_speed; };

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
		if !early_move_plat_x_speed
		{
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
		}

		// Y - Snap myself to my floor platform
		if instance_exists(my_floor_plat) // Add other kind of moving object into this as you update
		&& ( my_floor_plat.y_speed != 0
		|| my_floor_plat.object_index == obj_moving_plat
		|| object_is_ancestor(my_floor_plat.object_index, obj_moving_plat)
		|| my_floor_plat.object_index == obj_moving_semi_solid_wall
		|| object_is_ancestor(my_floor_plat.object_index, obj_moving_semi_solid_wall)
		)
		{
			// Snap to the top of the floor platform (un-floor our y variable so it's not choppy)
			if !place_meeting( x, my_floor_plat.bbox_top, obj_wall )
			&& my_floor_plat.bbox_top >= bbox_bottom - terminal_vel
			{
				y = my_floor_plat.bbox_top;
			}
		}

		// Get pushed down through a semisolid by a moving solid platform
		if instance_exists(my_floor_plat)
		&& ( my_floor_plat.object_index == obj_semi_solid_wall || object_is_ancestor(my_floor_plat.object_index, obj_semi_solid_wall) )
		&& place_meeting( x, y, obj_wall )
		{
			// If i'm already stuck in a wall at this point, try and move me down to get below a semisolid
			// If i'm still stuck afterwards, that just means i've been properly "crushed"
	
			// Also, don't check too far, we don't want to warp below walls
			var _max_push_dist = 10;
			var _pushed_dist = 0;
			var  _start_y = y;
			while place_meeting( x, y, obj_wall ) && _pushed_dist <= _max_push_dist
			{
				y++;
				_pushed_dist++;
			}
			setOnGround(false);
	
			// If i'm still in a wall at this point, i've been crushed regardless, take me back to my start y to avoid the funk
			if _pushed_dist > _max_push_dist { y = _start_y; };
		}

		// Death trigger by "Being crushed"
		if place_meeting(x, y, obj_wall)
		{
			crush_timer++;
			if crush_timer > crush_death_time
			{
				hp -= 999;
			}
		} else{
			crush_timer = 0;
		}
		checkForLedgeGrab();
		#endregion
        
        break;
    }
    
	case states.LEDGE: {
	    // Reset speeds while in ledge state
	    x_speed = 0;
	    y_speed = 0;
    
	    // Jump off ledge
	    if (jump_key_pressed)
	    {
	        state = states.FREE;
	        can_ledge_grab = false; // Prevent immediate re-grab
	        y_speed = jump_speed;
	        jump_hold_timer = jump_hold_frames;
        
	        // Add a small boost in the facing direction
	        x_speed = face * move_speed[0];
        
	        // Reset after a brief delay
	        alarm[0] = 15;
	    }
    
	    // Drop from ledge
	    if (down_key)
	    {
	        state = states.FREE;
	        can_ledge_grab = false;
        
	        // Reset after a brief delay
	        alarm[0] = 15;
	    }
    
	    break;
	}
}

switch(state) {
    case states.FREE: {
        // Walking
        if (abs(x_speed) > 0) { sprite_index = walk_sprite; }
        // Running
        if (abs(x_speed) >= move_speed[1]) { sprite_index = run_sprite; }
        // Idle
        if (x_speed == 0) { sprite_index = idle_sprite; }
        // Jumping and Falling 
        if (!on_ground) {
            if (y_speed < 0) { sprite_index = jump_sprite; } 
            else { sprite_index = fall_sprite; }
        }
        // Crouching
        if (crouching) {
            if (abs(x_speed) > 0) {
                sprite_index = roll_sprite;
            } else {
                sprite_index = crouch_sprite;
            }
        }
		// Reset ledge animation flags when not in ledge state
        ledge_landing = false;
        ledge_landing_finished = false;
        break;
    }
    
    case states.LEDGE: {
        // When first entering ledge state
        if (!ledge_landing && !ledge_landing_finished) {
            ledge_landing = true;
            sprite_index = ledge_land_sprite;
            image_index = 0;  // Start animation from beginning
        }
        
        // Check if landing animation has finished
        if (ledge_landing && sprite_index == ledge_land_sprite) 
		{
            if (image_index >= image_number - animationInterval()) // If we've reached the last frame
			{
                ledge_landing = false;
                ledge_landing_finished = true;
                sprite_index = ledge_idle_sprite;
                image_index = 0;  // Start idle animation from beginning
            }
        }
        
        // Stay in idle animation after landing is complete
        if (ledge_landing_finished) 
		{
            sprite_index = ledge_idle_sprite;
        }
        break;
    }
	
	case states.DEAD: {
		sprite_index = dead_sprite;
		
		// Check if dead animation has finished to destroy the player
		if sprite_index == dead_sprite
		{
			if (image_index >= image_number - animationInterval())
			{
				instance_destroy();
			}
		}
	}
}

// Set the collision mask
mask_index = mask_sprite;
if (crouching) { mask_index = crouch_sprite; }