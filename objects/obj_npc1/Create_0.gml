// Sprites
mask_sprite = spr_npc_idle; // Chosen Sprite to be the Collision Mask
idle_sprite = spr_npc_idle; // Idle Sprite
walk_sprite = spr_npc_walk; // Walk Sprite

// Moving
face = 1; // Don't touch
move_dir = 1; // 1 for right, -1 for left
move_speed = 1; // NPC's movement speed
x_speed = 0; // Don't touch
y_speed = 0; // Don't touch

// Jumping
grav = .275; // Gravity
terminal_vel = 4; // Don't touch

// Get start position and setup limits
start_x = x;
radius = 40;
left_limit = start_x - radius;
right_limit = start_x + radius;

// Movement and timer variables
move_timer = 0;
rest_timer = 180; // 3 seconds at 60 FPS