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

// Sprites
mask_sprite = spr_player_idle; // Choosen Sprite to be the Collision Mask
idle_sprite = spr_player_idle; // Idle Sprite
walk_sprite = spr_player_walk; // Walk Sprite
run_sprite = spr_player_run; // Run Sprite
jump_sprite = spr_player_jump; // Jump Sprite
crouch_sprite = spr_player_crouch; // Crouch Sprite

// Moving
face = 1; // Don't touch
move_dir = 0; // Don't touch
run_type = 0; // Don't touch
move_speed[0] = 2; // Normal Movement Speed
move_speed[1] = 3.5; // Movement Speed when sprint (or walk)
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