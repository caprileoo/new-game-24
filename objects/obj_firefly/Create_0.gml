depth = -9999;

// Light Custom
size = 256; // Light Size
color = #FFFDA3; // Light Color
str = 0.5; // Light Strength
dir = 69; // Light Direction
fov = 360; // Light Radius (360 is full circle, 180 is half circle)

// Breathing Effect
str_min = -1;
str_max = 0.5;
breathing_speed = 0.08; // Adjust this to control speed
breathing_time = 0;

// Variables for following the player
target = obj_player;
follow_speed = 10;
hover_amplitude = 5;
hover_speed = 0.1;
hover_offset = 0;

// Variable to keep track of the facing direction
target_direction = 1;

// Variables for customizing position relative to player's head
horizontal_offset = 25; // Distance behind the player's head
vertical_offset = 30; // Height behind the player's head