// Custom function for player
function setOnGround(_val = true){
	if ( _val == true ){
		on_ground = true;
		coyote_hang_timer = coyote_hang_frames;
	} else {
		on_ground = false;
		coyote_hang_timer = 0;
	}
}

// Control Setup
controlsSetup();

// Moving
move_dir = 0; // Don't touch
move_speed = 2; // Movement speed
x_speed = 0; // Don't touch
y_speed = 0; // Don't touch

// Jumping
grav = .275; // Gravity
terminal_vel = 4; // Don't touch
jump_speed = -3; // Decrease for higher jump height
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