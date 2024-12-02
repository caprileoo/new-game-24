// Main NPC movement
if ( move_timer > 0 ) {
	x_speed = 0;
    //x_speed = move_dir * move_speed;

    // Get NPC face direction
    if ( move_dir != 0 ) {
        face = move_dir;
    }

    // X Collision
    var _sub_pixels = .5; // How close we can get close to the wall
    if place_meeting( x + x_speed, y, obj_wall ) {
        // First check if there is a slope to go up
        if ( !place_meeting( x + x_speed, y - abs(x_speed) - 1, obj_wall ) ) {
            while place_meeting( x + x_speed, y, obj_wall ) {
                y -= _sub_pixels;
            }
        } else { // Next, check for ceiling slope, otherwise, do a regular collision
            // Ceiling Slopes
            if !place_meeting( x + x_speed, y + abs(x_speed) + 1, obj_wall ) {
                while place_meeting( x + x_speed, y, obj_wall ) {
                    y += _sub_pixels;
                }
            } else {
                // Pixel Perfect
                var _pixel_check = _sub_pixels * sign(x_speed);
                while !place_meeting( x + _pixel_check, y, obj_wall ) {
                    x += _pixel_check;
                }
                // Set xspd to zero to "collide"
                x_speed = 0;
            }
        }
    }

    // Go Down Slopes
    if ( y_speed >= 0 && !place_meeting( x + x_speed, y + 1, obj_wall ) && place_meeting( x + x_speed, y + abs(x_speed) + 1, obj_wall ) ) {
        while !place_meeting( x + x_speed, y + _sub_pixels, obj_wall ) {
            y += _sub_pixels;
        }
    }

    // Move
    x += x_speed;

    // Y Movement
    y_speed += grav;

    // Y Collision and movement
    // Cap falling speed
    if ( y_speed > terminal_vel ) { y_speed = terminal_vel; }
	
    var _sub_pixels = .5;
    if ( place_meeting( x, y + y_speed, obj_wall ) ) {
        // Pixel Perfect
        var _pixel_check = _sub_pixels * sign(y_speed);
        while !place_meeting( x, y + _pixel_check, obj_wall ) {
            y += _pixel_check;
        }
        // Set y_speed to 0 to collide
        y_speed = 0;
    }

    // Move
    y += y_speed;

    // Sprite control
    // Walking
    if ( abs(x_speed) > 0 ) { sprite_index = walk_sprite; }

    // Reduce move timer
    move_timer -= 1;

    // Reached the limit, change direction
    if ( x <= left_limit ) { move_dir = 1; }
    if ( x >= right_limit ) { move_dir = -1; }
} else {
    // Resting phase
    // Gravity and y movement during rest
    y_speed += grav;
    if ( y_speed > terminal_vel ) { y_speed = terminal_vel; }
	
    var _sub_pixels = .5;
    if ( place_meeting( x, y + y_speed, obj_wall ) ) {
        var _pixel_check = _sub_pixels * sign(y_speed);
        while !place_meeting( x, y + _pixel_check, obj_wall ) {
            y += _pixel_check;
        }
        y_speed = 0;
    }
    y += y_speed;

    // Set sprite to idle during rest
    sprite_index = idle_sprite;
    rest_timer -= 1;

    // Start moving after rest period
    if ( rest_timer <= 0 ) {
        move_timer = 180; // Move for 3 seconds
        rest_timer = 180; // Rest for 3 seconds
    }
}

// Set the collision mask
mask_index = mask_sprite;
