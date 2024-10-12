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

if place_meeting( x + x_speed, y, obj_wall ){
	// Pixel Perfect
	var _pixel_check = _sub_pixels * sign(x_speed);
	while !place_meeting( x + _pixel_check, y, obj_wall ){
		x += _pixel_check;
	}
	
	// Set xspd to zero to "collide"
	x_speed = 0;
}

// Move
x += x_speed;
#endregion

#region Y Movement
// Gravity
if ( coyote_hang_timer > 0 ){
	// Count the timer down
	coyote_hang_timer--;
} else {
	// Apply gravity to the player
	y_speed += grav;
	// No longer on ground
	setOnGround(false);
}

// Reset/Prepare jumping variables
if (on_ground){
	jump_count = 0;
	coyote_jump_timer = coyote_jump_frames;
} else {
	// If the player is in the air, make sure they can't do extra jump
	coyote_jump_timer--;
	if ( jump_count == 0 && coyote_jump_timer <= 0 ) { jump_count = 1; }
}

// Initiate the Jump
if ( jump_key_buffered && jump_count < jump_max ){
	// Reset the buffer
	jump_key_buffered = false;
	jump_key_buffer_timer = 0;
	
	// Increase the number of performed jumps
	jump_count++;
	
	// Set the jump hold timer
	jump_hold_timer = jump_hold_frames;
	
	// Alert that i'm no longer on ground
	setOnGround(false);
	
	// Reset the timer
	coyote_jump_timer = 0;
}

// Jump based on the timer/holding the button
if ( jump_hold_timer > 0 ){
	// Constantly set the y_speed to be jumping speed
	y_speed = jump_speed;
	// Count down the timer
	jump_hold_timer--;
}

// Cut off the jump by releasing the jump button
if ( !jump_key ){
	jump_hold_timer = 0;
}

// Y Collision and movement
// Cap falling speed
if ( y_speed > terminal_vel ) {
	y_speed = terminal_vel;
}

// Y Collision
var _sub_pixels = .5;
if( place_meeting( x, y + y_speed, obj_wall) ){
	// Pixel Perfect
	var _pixel_check = _sub_pixels * sign(y_speed);
	while !place_meeting( x, y + _pixel_check, obj_wall ){
		y += _pixel_check;
	}
	
	// Bonk code
	if ( y_speed < 0 ){
		jump_hold_timer = 0
	}
	
	// Set y_speed to 0 to collide
	y_speed = 0;
}

// Set if i'm on the ground
if ( y_speed >= 0 && place_meeting( x, y + 1, obj_wall) ){
	setOnGround(true);
}

// Move
y += y_speed;
#endregion

#region Sprite control
// Walking
if ( abs(x_speed) > 0 ) { sprite_index = walk_sprite; }
// Running
if ( abs(x_speed) >= move_speed[1] ) { sprite_index = run_sprite; }
// Idle
if ( x_speed == 0 ) { sprite_index = idle_sprite; }
// Jump
if ( !on_ground ) { sprite_index = jump_sprite; }
// Set the collision mask
mask_index = mask_sprite;
#endregion