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